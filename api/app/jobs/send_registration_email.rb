class SendRegistrationEmail < ApplicationJob
  def perform(user_id)
    @user = User.find(user_id)

    call
  end

  private

  def call
    url = 'https://mailer.petricomp.com/api/v1/send_mail'

    HTTParty.post(url, body: json_body, headers: json_headers)
  end

  def json_body
    {
      Sender: 'admin@ownportal.net',
      Recipient: @user.email,
      Subject: 'Registration confirmation',
      HtmlBody: '<h1>Welcome to ownportal!</h1>',
      TextBody: 'This is your code.',
      Charset: 'UTF-8'
    }.to_json
  end

  def json_headers
    {
      Authorization: '781zsyxDyhSOSH58/3UqnfhKaSMGhJkFtIt58DlLBKo=',
      'X-User': 'petricomp@gmail.com'
    }
  end

  def effective_ownportal_link
    'https://space.ownportal.net/ownportal-s-blog/how-to-effectively-use-ownportal.html'
  end

  def notifications_link
    'https://space.ownportal.net/ownportal-s-blog/say-hello-to-notifications.html'
  end

  def podcasts_link
    'https://space.ownportal.net/ownportal-s-blog/play-podcasts-and-more-on-ownportal.html'
  end

  def history_link
    'https://space.ownportal.net/ownportal-s-blog/keep-history-new-feature.html'
  end
end
