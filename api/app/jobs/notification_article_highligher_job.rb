class NotificationArticleHighligherJob < ApplicationJob
  def perform
    User.where(deactivated_at: nil).each do |user|
      highlights = Highlight.where(user: user)

      articles = Article.where(created_at: 1.hour.ago..Time.now)

      [].tap do |items|
        articles.each do |article|
          match_highlights = title_with_description(article) & (highlights.pluck(:keyword))

          next unless match_highlights.present?

          items << {
            article_id: article.id,
            highlight_id: nil,
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
