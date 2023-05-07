module Articles
  class SourceLoader
    def initialize(source_id)
      raise 'Invalid source_id param' unless source_id.to_i.positive?

      @source_id = source_id
    end

    def call
      Rails.cache.fetch(source) do
        Article.where(source_id: @source_id)
               .order(published_date: :desc)
               .limit(50)
               .pluck(:id)
      end
    end

    private

    def source
      @source ||= Source.find(@source_id)
    end
  end
end
