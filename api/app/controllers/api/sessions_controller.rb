module Api
  class SessionsController < ApplicationController
    include Api::Extensions::Respondable
    include Api::Extensions::Resourceful

    skip_before_action :authenticate, only: [:create]
    skip_before_action :authorise_resource, only: [:create]
    skip_before_action :resource_from_attributes, only: [:create]
    skip_after_action :verify_authorized, only: [:create]

    def create
      @session = User.find_by(email: params[:session][:email])

      if user_valid?
        user_token = { 'session': { 'token': encode_jwt(@session), 'sysadmin': @session.sysadmin, 'id': @session.id } }
        set_last_logged_in
        render_json user_token, status: 201
      else
        render json: { errors: { credentials: ['are invalid'] } },
               status: :unauthorized
      end
    end

    def destroy
      @session&.regenerate_token
    end

    private

    def load_resource
      @session ||= current_user
    end

    def policy_class
      SessionPolicy
    end

    def user_valid?
      @session.present? && @session.deactivated_at.nil? && @session.authenticate(params[:session][:password])
    end

    def set_last_logged_in
      @session.last_logged_in = Time.current
      @session.save
    end
  end
end
