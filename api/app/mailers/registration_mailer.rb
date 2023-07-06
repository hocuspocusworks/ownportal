class RegistrationMailer < ApplicationMailer
  def registration_email
    @user = params[:user]
    @link = params[:link]

    return unless @user.present?

    mail(to: @user.email,
         subject: 'Verify your email for new ownportal account',
         template_path: 'mailers/registration_mailer')
  end
end
