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
      sender: { name: 'ownportal', email: 'admin@ownportal.net' },
      to: [{ email: @user.email, name: @user.email }],
      subject: 'Registration confirmation',
      htmlContent: '<h1>Welcome to ownportal!</h1>'
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
