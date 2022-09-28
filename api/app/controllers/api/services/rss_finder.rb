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
        description = body['data']['description']
        language = body['data']['language']
        name = body['data']['source']
        timestamp = body['data']['lastBuildDate']
        Source.create(
          description: description,
          language: language,
          name: name,
          url: @url,
          timestamp: timestamp,
          creator: @user,
          counter: 0
        )
      end

      private

      def count(source)
        source.counter = 0 if source.counter.nil?
        source.counter += 1
        source.save
        source
      end
    end
  end
end
