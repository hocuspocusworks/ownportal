class NotificationArticleHighligherJob < ApplicationJob
  def perform
    User.where(deactivated_at: nil).each do |user|
      highlights = Highlight.where(user: user)

      articles = Article.joins(:source)
                        .joins(source: [:streams])
                        .where(created_at: 1.hour.ago..Time.now)
                        .where(streams: { user: user })

      [].tap do |items|
        articles.each do |article|
          match_highlights = title_with_description(article) & (highlights.pluck(:keyword))

          next unless match_highlights.present?

          items << {
            article_id: article.id,
            highlight_id: highlights.find { |item| item.keyword == match_highlights.first }&.id,
            user_id: user.id
          }
        end

        Notification.upsert_all(items) unless items.blank?
      end
    end
  end

  private

  def title_with_description(article)
    "#{article.title} #{article.description}"
      .downcase
      .gsub(/[^0-9A-Za-z ]/, '')
      .split
  end
end
