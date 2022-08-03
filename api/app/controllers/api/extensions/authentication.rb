module Api
  module Extensions
    module Authentication
      private

      def current_user
        token = request.headers['Authorization']
        User.find_by(token: token)
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
