package net.ownportal.fetcher;

import java.net.URL;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.extern.slf4j.Slf4j;
import net.ownportal.RssResolver;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@RestController
@RequestMapping("/rss")
@Slf4j
class FetchController {
    private final WebClient webClient;

    FetchController(WebClient.Builder builder) {
        this.webClient = builder.build();
    }

    @PostMapping("/validate")
    public Mono<ServiceResponse<?>> validateRss(final String url) {
        log.info("rss validating {}", url);
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

    @PostMapping("/fetchAll")
    public Mono<ServiceResponse<?>> fetchAllRss(@RequestBody FetchAllRequest request) throws Exception {
        final var urls = request.getUrls();
        final var sort = request.getSort().equals("asc") ? "asc" : "random";
        return Flux.fromIterable(urls)
            .flatMap(this::get)
            .publishOn(Schedulers.boundedElastic())
            .map(RssResolver::rssToJson)
            .collectList()
            .map(f -> new Feed(f, sort))
            .map(Response::ok);
    }

    private Mono<byte[]> get(final String url) {
        try {
            URL page = new URL(url);
            return webClient.get()
                .uri(page.toURI())
                .retrieve()
                .bodyToMono(byte[].class);
        } catch (Exception e) {
            log.debug(e.getMessage());
        }
        return Mono.empty();
    }
}
