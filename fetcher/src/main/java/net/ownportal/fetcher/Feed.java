package net.ownportal.fetcher;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import net.ownportal.RssPage;

@ToString
@Getter
@Setter
@Slf4j
public class Feed {
    private long size;
    private List<FeedItem> nodes = new ArrayList<>();

    public Feed(List<RssPage> pages, String sort) {
        for (var page : pages) {
            size += page.getSize();
            for (var item : page.getNodes()) {
                var feedItem = new FeedItem.Builder()
                    .source(page.getSource())
                    .title(item.getTitle())
                    .description(item.getDescription())
                    .link(item.getLink())
                    .publishedDate(item.getPublishedDate())
                    .build();
                nodes.add(feedItem);
            }
        }
        if (sort.equals("asc")) {
            Collections.sort(nodes, this::dateComparator);
        } else {
            Collections.shuffle(nodes);
        }
    }

    @ToString
    @Getter
    @Setter
    static class FeedItem {
        private String source;
        private String title;
        private String description;
        private String link;
        private String publishedDate;

        public static class Builder {
            private String source;
            private String title;
            private String description;
            private String link;
            private String publishedDate;

            public Builder source(String source) {
                this.source = source;
                return this;
            }

            public Builder title(String title) {
                this.title = title;
                return this;
            }

            public Builder description(String description) {
                this.description = description;
                return this;
            }

            public Builder link(String link) {
                this.link = link;
                return this;
            }

            public Builder publishedDate(String publishedDate) {
                this.publishedDate = publishedDate;
                return this;
            }

            public FeedItem build() {
                return new FeedItem(this);
            }
        }

        private FeedItem(Builder b) {
            source = b.source;
            title = b.title;
            description = b.description;
            link = b.link;
            publishedDate = b.publishedDate;
        }
    }

    private int dateComparator(FeedItem i1, FeedItem i2) {
        try {
            var d1 = new SimpleDateFormat("EEEE, dd MMMM yyyy HH:mm:ss Z").parse(i1.getPublishedDate());
            var d2 = new SimpleDateFormat("EEEE, dd MMMM yyyy HH:mm:ss Z").parse(i2.getPublishedDate());
            return d2.compareTo(d1);
        } catch (ParseException ex) {
            log.debug("cannot parse {} or {}", i1.getPublishedDate(), i2.getPublishedDate());
        }
        return 0;
    }
}
