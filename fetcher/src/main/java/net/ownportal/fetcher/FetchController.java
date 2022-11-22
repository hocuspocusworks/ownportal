package net.ownportal.fetcher;

import java.net.URL;
import java.time.Duration;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.extern.slf4j.Slf4j;
import net.ownportal.RssResolver;
import reactor.core.Exceptions;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@RestController
@RequestMapping("/rss")
@Slf4j
class FetchController {
    private final WebClient webClient;
    private static final long REQUEST_TIMEOUT = 3L;

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
            .onErrorResume(e -> Flux.just(new RssBodyWithUrl()))
            .publishOn(Schedulers.boundedElastic())
            .map(bodyWithUrl -> RssResolver.rssToJson(bodyWithUrl.body, bodyWithUrl.url))
            .collectList()
            .map(f -> new Feed(f, sort))
            .map(Response::ok);
    }

    private Mono<RssBodyWithUrl> get(final String url) {
        try {
            URL page = new URL(url);
            return webClient.get()
                .uri(page.toURI())
                .retrieve()
                .bodyToMono(byte[].class)
                .flatMap(body -> bodyWithUrl(body, url))
                .timeout(Duration.ofSeconds(REQUEST_TIMEOUT));
        } catch (Exception ex) {
            throw Exceptions.propagate(ex);
        }
    }

    private Mono<RssBodyWithUrl> bodyWithUrl(byte[] body, String url) {
        return Mono.just(new RssBodyWithUrl(body, url));
    }

    private class RssBodyWithUrl {
        public byte[] body;
        public String url;

        public RssBodyWithUrl() {}

        public RssBodyWithUrl(byte[] body, String url) {
            this.body = body;
            this.url = url;
        }
    }
}
