module Api
  module Services
    class RssFinder
      def self.call(url)
        source = Source.with_url(url)

        return source unless source.empty?

        response = RestClient.get Rails.configuration.x.fetcher_url + "/rss/fetch?url=#{url}"

        return unless response.code == 200

        body = JSON.parse(response.body.as_json)
        description = body['data']['description']
        language = body['data']['language']
        name = body['data']['source']
        timestamp = body['data']['lastBuildDate']
        Source.create(description: description, language: language, name: name, url: url, timestamp: timestamp)
      end
    end
  end
end
