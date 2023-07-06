class RegistrationMailerPreview < ActionMailer::Preview
  def registration_email
    RegistrationMailer.with(user: User.first, link:).registration_email
  end

  private

  def link
    "http://localhost:3000/registrations?action=confirm&user_id=#{User.first.id}&registration_token=#{User.first.registration_token}"
  end
end
