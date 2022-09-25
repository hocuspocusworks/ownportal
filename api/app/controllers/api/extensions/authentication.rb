module Api
  module Extensions
    module Authentication
      private

      def current_user
        User.where(token: authorisation_token).first
      end

      def authorisation_token
        decode_jwt[0]['token']
      end

      def authenticate
        return unless current_user.nil?

        request_invalid
      end

      def decode_jwt
        JWT.decode header_token, jwt_secret, true, { algorithm: 'HS512' }
      rescue JWT::VerificationError, JWT::DecodeError
        raise Pundit::NotAuthorizedError
      end

      def encode_jwt(user)
        payload = { token: user.token, iss: 'ownportal' }
        JWT.encode payload, jwt_secret, 'HS512'
      end

      def header_token
        request.headers['Authorization']
      end

      def jwt_secret
        Rails.configuration.x.jwt_secret
      end

      def request_invalid
        render json: { 'errors': { 'token': ['is invalid'] } }, status: :unauthorized
      end
    end
  end
end
