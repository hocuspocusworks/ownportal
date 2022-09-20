module Api
  module Extensions
    module Authentication
      private

      def current_user
        raise_error_on_invalid_header
        User.find_by(token: authorisation_token)
      end

      def raise_error_on_invalid_header
        raise 'Authorization header not set' if authorisation_token.nil?
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
