class SendRegistrationEmail < ApplicationJob
  def perform(user_id, registration_key)
    @user = User.find(user_id)
    @registration_key = registration_key

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
      HtmlBody: body_content,
      TextBody: '',
      Charset: 'UTF-8'
    }.to_json
  end

  def body_content
    <<~TEXT
      <h2>#{@user.email}, welcome to ownportal!</h2>
      <p>Your registration key is #{@registration_key}.</p>
      <p>Please click on the following link: <a href='https://ownportal.net/activate?key=#{@registration_key}'>activation link</a>.</p>
      <p>Otherwise, copy and paste the following link in your browser: https://ownportal.net/activate?key=#{@registration_key}</p>
      <p>If you need any help with using ownportal.net, check our help pages.</p>
      <p>If you have any questions, write to us on admin@ownportal.net</p>
      <p>We truly hope you enjoy using ownportal.net.</p>
    TEXT
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
