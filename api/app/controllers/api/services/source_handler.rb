module Api
  module Services
    class SourceHandler
      def initialize(sources, params)
        @sources = sources
        @params = params
      end

      def results
        @scope = @sources
        @scope = kind_scope

        status_scope
      end

      private

      def kind_scope
        case @params[:kind]&.to_sym
        when :admin
          @scope.with_admin
        when :contributor
          @scope.with_non_admin
        else
          @scope
        end
      end

      def status_scope
        case @params[:status]&.to_sym
        when :new
          @scope.with_non_processed
        else
          @scope
        end
      end
    end
  end
end
