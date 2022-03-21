package net.ownportal.fetcher;

import java.io.IOException;
import java.net.URL;

import org.apache.commons.io.IOUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import net.ownportal.RssPage;
import net.ownportal.RssResolver;

@RestController
@RequestMapping("/rss")
class FetchController {
    @PostMapping("/validate")
    public boolean validateRss(final String url) throws IOException {
        URL page = new URL(url);
        byte[] data = IOUtils.toByteArray(page);
        RssResolver rss = new RssResolver();
        return rss.isValid(data);
    }

    @GetMapping("/fetch")
    public RssPage fetchRss(final String url) throws IOException {
        URL page = new URL(url);
        byte[] data = IOUtils.toByteArray(page);
        RssResolver rss = new RssResolver();
        return rss.rssToJson(data);
    }
}
