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
      htmlContent: '<h1>Welcome to ownportal!</h1>' \
                   '<p>ownportal is a free, simple and fast RSS feed reader.</p>' \
                   '<p>To get started, we suggest you to read the following articles:<p>' \
                   '<ul>' \
                   "<li><a href='#{effective_ownportal_link}'>Effective use of ownportal</a></li>" \
                   "<li><a href='#{notifications_link}'>Use of notifications</a></li>" \
                   "<li><a href='#{podcasts_link}'>Use built-in podcast player</a></li>" \
                   "<li><a href='#{history_link}'>Keep your browsing history</a></li>" \
                   '</ul>' \
                   '<br>' \
                   '<p>We hope you will enjoy using ownportal. For any questions email us at admin@ownportal.net.</p>' \
                   '<p>Also, for all news follow our ownportal RSS blog which is added to your groups by default.</p>' \
                   '<p>Happy reading!</p>' \
                   '<br>' \
                   '<h5>The ownportal team.</h5>' \
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
