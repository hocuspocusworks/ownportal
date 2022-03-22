package net.ownportal.fetcher;

import java.net.URL;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.extern.slf4j.Slf4j;
import net.ownportal.RssResolver;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@RestController
@CrossOrigin
@RequestMapping("/rss")
@Slf4j
class FetchController {
    private final WebClient webClient;

    FetchController(WebClient.Builder builder) {
        this.webClient = builder.build();
    }

    @PostMapping("/validate")
    public Mono<ServiceResponse<?>> validateRss(final String url) {
        try {
            URL page = new URL(url);
            return webClient.get()
                .uri(page.toURI())
                .retrieve()
                .bodyToMono(byte[].class)
                .onErrorResume(e -> Mono.just(new byte[]{0}))
                .publishOn(Schedulers.boundedElastic())
                .map(RssResolver::isValid)
                .map(Response::ok);
        } catch (Exception e) {
            log.debug("unexpected error {}", e);
        }
        return Mono.just(Response.fail("unexpected error"));
    }

    @GetMapping("/fetch")
    public Mono<ServiceResponse<?>> fetchRss(final String url) throws Exception {
        URL page = new URL(url);
        return webClient.get()
            .uri(page.toURI())
            .retrieve()
            .bodyToMono(byte[].class)
            .publishOn(Schedulers.boundedElastic())
            .map(RssResolver::rssToJson)
            .map(Response::ok);
    }
}
