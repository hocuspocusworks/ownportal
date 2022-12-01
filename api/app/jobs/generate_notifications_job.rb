class GenerateNotificationsJob < ApplicationJob
  def perform
    User.active.each do |user|
      highlights = user.highlights.map(&:keyword)
      
      articles = Article.joins(:source)
        .joins(source: :streams)
        .where(articles: { user_id: user })
        .where('articles.published_date >= ?', Date.today)

      articles.each do |article|
        pieces = article.title.split + article.description.split

        match = pieces & highlights

        next if match.empty?

        highlight = Highlight.where(keyword: match.first).where(user_id: user).first

        # check it doesn't exist already!
        Notification.create(
          article_id: article.id,
          highlight_id: highlight.id,
          user_id: user.id,
          stale: false)
      end
    end
  end
end
