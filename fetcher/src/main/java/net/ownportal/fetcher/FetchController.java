package net.ownportal.fetcher;

import java.net.URL;

import org.apache.commons.io.IOUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import net.ownportal.RssPage;
import net.ownportal.RssResolver;

@RestController
@RequestMapping("/rss")
class FetchController {
    @GetMapping("/fetch")
    public RssPage fetchRss(final String url) throws Exception {
        URL page = new URL(url);
        byte[] data = IOUtils.toByteArray(page);
        RssResolver rss = new RssResolver();
        RssPage json = rss.rssToJson(data);
        return json;
    }
}
