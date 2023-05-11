module Articles
  class GroupLoader
    def initialize(group_id)
      raise 'Invalid group_id param' unless group_id.to_i.positive?

      @group_id = group_id
    end

    def call
      Rails.cache.fetch(group) do
        Article.where(source_id: source_ids)
               .order(published_date: :desc)
               .limit(50)
               .pluck(:id)
      end
    end

    private

    def group
      @group ||= Group.where(id: @group_id).includes(:sources)&.first
    end

    def source_ids
      @source_ids ||= group.sources.pluck(:id)
    end
  end
end
