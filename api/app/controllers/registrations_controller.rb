class RegistrationsController < ApplicationController
  skip_before_action :authenticate
  skip_after_action :verify_authorized

  def confirm
    @user = User.find(params[:user_id])
    @token = params[:registration_token]

    head :forbidden and return unless @user.registration_token == @token && @user.registration_confirmed.nil?

    @user.update(registration_confirmed: Time.now)
    head :ok
  end
end
