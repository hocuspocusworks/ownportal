module Api
  module Extensions
    module Authentication
      private

      def current_user
        User.where(token: authorisation_token).first
      end

      def authorisation_token
        request.headers['Authorization']
      end

      def authenticate
        return unless current_user.nil?

        request_invalid
      end

      def request_invalid
        render json: { 'errors': { 'token': ['is invalid'] } }, status: :unauthorized
      end
    end
  end
end
