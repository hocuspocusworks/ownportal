module Users
  class RegistrationEmail
    def initialize(user)
      @user = user
    end

    def send
      RegistrationMailer.with(user: @user, link:).registration_email.deliver_later
    end

    private

    def link
      "https://ownportal.net/confirmation?user=#{@user.id}&token=#{@user.registration_token}"
    end
  end
end
