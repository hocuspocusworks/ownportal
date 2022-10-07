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

        body = JSON.parse(response.body.as_json)
        description = body['data']['description'][0..511]
        language = body['data']['language']
        name = body['data']['source'].empty? ? random_name : body['data']['source']
        timestamp = body['data']['lastBuildDate']
        saved_source = Source.create(
          description: description,
          language: language,
          name: name,
          url: @url,
          timestamp: timestamp,
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
        "FIX_NAME_#{(0...8).map { ('A'..'Z').to_a[rand(26)] }.join}"
      end
    end
  end
end
