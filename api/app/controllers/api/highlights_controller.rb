module Api
  class HighlightsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @highlights
    end

    def create
      save_form
    end

    def update
      save_form
    end

    def destroy
      @highlight.destroy

      head :no_content
    end

    private

    def load_resource
      @highlight ||= policy_scope(Highlight).find(params[:id])
    end

    def load_collection
      @highlights ||= policy_scope(Highlight)
    end
  end
end
