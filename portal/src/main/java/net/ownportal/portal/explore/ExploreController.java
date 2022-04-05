package net.ownportal.portal.explore;

import java.util.Collections;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpMethod;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import lombok.Getter;
import lombok.Setter;
import net.ownportal.portal.source.SourceDao;
import net.ownportal.portal.source.SourceService;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/explore")
class ExploreController {
    private final WebClient client;
    private final SourceService service;

    public ExploreController(WebClient.Builder builder,
        SourceService service) {
        client = builder.baseUrl("http://fetcher:8070").build();
        this.service = service;
    }

    @GetMapping("/rss")
    public SourceDao findRssPage(final String url) {
        final var result = getRssFeed(url);
        
        if (result == null) {
            return SourceDao.builder().build();
        }

        final var source = SourceDao.builder()
            .name(result.getData().getSource())
            .description("")
            .icon("")
            .categories(Collections.emptyList())
            .url(url)
            .build();
        return service.saveSource(source);
    }

    private RssFetchResponse getRssFeed(final String url) {
        return client.method(HttpMethod.GET)
            .uri(uriBuilder -> uriBuilder
                    .path("/rss/fetch")
                    .queryParam("url", url).build())
            .retrieve()
            .bodyToMono(RssFetchResponse.class)
            .onErrorResume(WebClientResponseException.class, ex -> Mono.empty())
            .block();
    }

    @Getter @Setter
    private static class RssFetchResponse {
        private int code;
        private UUID requestId;
        private long timestamp;
        private Data data;

        @Getter @Setter
        private static class Data {
            private long size;
            private String source;
            private List<RssNode> nodes;

            @Getter @Setter
            private static class RssNode {
                private String title;
                private String description;
                private String link;
                private String publishedDate;
            }
        }
    }
}
