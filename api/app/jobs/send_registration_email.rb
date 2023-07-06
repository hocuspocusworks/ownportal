class SendRegistrationEmail < ApplicationJob
  def perform(user_id)
    @user = User.find(user_id)

    RegistrationMailer.with(user: @user, link:).registration_email.deliver
  end

  private

  def link
    "https://ownportal.net/confirm?user=#{@user.id}&token=#{@user.registration_token}"
  end
end
