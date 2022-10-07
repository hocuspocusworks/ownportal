module Api
  module Services
    class RssFinder
      def initialize(url, user)
        @url = url
        @user = user
      end

      def call
        source = Source.with_url(@url)

        return count(source.first) unless source.empty?

        response = RestClient.get Rails.configuration.x.fetcher_url + "/rss/fetch?url=#{@url}"

        return unless response.code == 200

        @body = JSON.parse(response.body.as_json)
        saved_source = Source.create(
          description: source_description,
          language: source_language,
          name: source_name,
          url: @url,
          timestamp: source_timestamp,
          creator: @user,
          counter: 0
        )

        return saved_source if saved_source.errors.empty?

        raise StandardError.new, saved_source.errors.full_messages[0]
      end

      private

      def count(source)
        source.counter = 0 if source.counter.nil?
        source.counter += 1
        source.save
        source
      end

      def random_name
        "NO_TEXT_#{(0...8).map { ('A'..'Z').to_a[rand(26)] }.join}"
      end

      def source_name
        @body['data']['source'].nil? || @body['data']['source'].empty? ? random_name : @body['data']['source']
      end

      def source_description
        @body['data']['description'].nil? ? random_name : @body['data']['description'][0..511]
      end

      def source_language
        @body['data']['language']
      end

      def source_timestamp
        @body['data']['lastBuildDate']
      end 
    end
  end
end
