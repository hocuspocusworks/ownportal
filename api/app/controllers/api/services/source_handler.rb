module Api
  module Services
    class SourceHandler
      def initialize(sources, params)
        @sources = sources
        @params = params
      end

      def results
        scope = @sources
        case @params[:kind]&.to_sym
        when :admin
          scope.with_admin
        when :contributor
          scope.with_non_admin
        else
          scope
        end
      end
    end
  end
end
