class FetchNewArticlesJob < ApplicationJob
  PER_PAGE = 10

  def perform
    user = User.first

    pages = 0..(Source.count / PER_PAGE + 1)

    pages.each do |page|
      response = fetch_content(urls_for_page(page), user)

      next unless response['code']&.zero?

      [].tap do |items|
        response['data']['nodes'].each do |item|
          items << {
            title: item['title'],
            link: item['link'],
            description: item['description'],
            published_date: item['publishedDate'],
            publisher: item['source'],
            user_id: user.id,
            source_id: source_id(item['rssUrl'])
          }
        end

        deduped_items = dedup(items)

        Article.upsert_all(deduped_items) unless deduped_items.blank?
      end
    end
  end

  private

  def dedup(items)
    [].tap do |result|
      items.each do |item|
        next unless newest_article?(item)

        result << item
      end
    end
  end

  def newest_article?(item)
    return true if item[:published_date] > latest_entry_date(item[:source_id])
  end

  def latest_entry_date(source_id)
    latest_articles.select { |item| item.source_id == source_id }.first&.date || Time.now - 1.year
  end

  def latest_articles
    @latest_articles ||= Article.select('source_id, MAX(published_date) AS date').group(:source_id)
  end

  def source_id(url)
    sources.find_by(url: url)&.id
  end

  def sources
    @sources ||= Source.select('id, url').all
  end

  def urls_for_page(page)
    Source.limit(PER_PAGE).offset(page * PER_PAGE).map(&:url)
  end

  def fetch_content(payload, user)
    HTTParty.post(fetch_url, body: formatted_payload(payload), headers: headers(user))
  end

  def fetch_url
    if Rails.env.development?
      'http://localhost:8089/rss/rss/fetchAll'
    else
      'https://gateway.ownportal.net/api/rss/fetchAll'
    end
  end

  def formatted_payload(payload)
    {}.tap do |body|
      body['sort'] = 'asc'
      body['urls'] = payload
    end.to_json
  end

  def headers(user)
    {
      'Authorization': user.token,
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }
  end
end