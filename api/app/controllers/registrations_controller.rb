class RegistrationsController < ApplicationController
  skip_before_action :authenticate
  skip_after_action :verify_authorized

  def confirm
    @user = User.find(params[:user_id])
    @token = params[:registration_token]

    head :no_content and return unless @user.registration_token == @token && @user.registration_confirmed.nil?

    @user.update(registration_confirmed: Time.now)
    redirect_to 'https://ownportal.net', allow_other_host: true
  end
end
