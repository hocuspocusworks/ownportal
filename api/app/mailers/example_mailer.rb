class ExampleMailer < ApplicationMailer
  default from: 'admin@ownportal.net'

  def welcome_email
    mail(to: 'petricomp@gmail.com', subject: 'Welcome to My Awesome Site')
  end
end
