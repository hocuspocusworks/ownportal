package net.ownportal.fetcher;

import java.net.URL;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;

import net.ownportal.RssPage;
import net.ownportal.RssResolver;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@RestController
@RequestMapping("/rss")
class FetchController {
    private final WebClient webClient;

    FetchController(WebClient.Builder builder) {
        this.webClient = builder.build();
    }

    @PostMapping("/validate")
    public Mono<Boolean> validateRss(final String url) throws Exception {
        URL page = new URL(url);
        return webClient.get()
            .uri(page.toURI())
            .retrieve()
            .bodyToMono(byte[].class)
            .publishOn(Schedulers.boundedElastic())
            .map(RssResolver::isValid);
    }

    @GetMapping("/fetch")
    public Mono<RssPage> fetchRss(final String url) throws Exception {
        URL page = new URL(url);
        return webClient.get()
            .uri(page.toURI())
            .retrieve()
            .bodyToMono(byte[].class)
            .publishOn(Schedulers.boundedElastic())
            .map(RssResolver::rssToJson);
    }
}
