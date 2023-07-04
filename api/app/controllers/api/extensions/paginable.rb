module Api
  module Extensions
    module Paginable
      extend ActiveSupport::Concern

      def paginate(records)
        records.merge(model.offset(start_item).limit(end_item))
      end

      private

      def model
        controller_name.classify.constantize
      end

      def start_item
        (page - 1) * offset
      end

      def end_item
        page * offset
      end

      def default_page
        1
      end

      def max_offset
        30
      end

      def page
        a_number?(params[:page]) ? to_int(params[:page]) : default_page
      end

      def offset
        if a_number?(params[:offset]) && to_int(params[:offset]) <= max_offset
          to_int(params[:offset])
        else
          max_offset
        end
      end

      def to_int(param)
        param.to_i
      end

      def a_number?(param)
        param.present? && to_int(param).positive?
      end
    end
  end
end
