class AddToHistoryJob < ApplicationJob
  def perform(article_id, user_id)
    user = User.find(user_id)

    return unless user && user.history?

    begin
      History.create(article_id: article_id, user_id: user.id)
    rescue ActiveRecord::RecordNotUnique => exception
      # do not care
      return
    end
  end
end
