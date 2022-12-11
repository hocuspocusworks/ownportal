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
import net.ownportal.RssPage.RssNode;

@ToString
@Getter
@Setter
@Slf4j
public class Feed {
    private long size = 0;
    private List<FeedItem> nodes = new ArrayList<>();

    public Feed(List<RssPage> pages, String sort) {
        for (var page : pages) {
            for (var item : page.getNodes()) {
                if (!validItem(item)) continue;

                setValidPublishedDate(item);

                var feedItem = new FeedItem.Builder()
                    .source(page.getSource())
                    .title(item.getTitle())
                    .description(item.getDescription())
                    .link(item.getLink())
                    .publishedDate(item.getPublishedDate())
                    .rssUrl(page.getRssUrl())
                    .mediaUrl(item.getMediaUrl())
                    .build();
                nodes.add(feedItem);
                size++;
            }
        }
        if (sort.equals("asc")) {
            Collections.sort(nodes, this::dateComparator);
        } else {
            Collections.shuffle(nodes);
        }
    }

    private void setValidPublishedDate(RssNode item) {
        if (item.getPublishedDate() == null) {
            item.setPublishedDate("Thu, 1 Jan 1970 00:00:00 GMT");
        }
    }

    private boolean validItem(RssNode item) {
        if (item.getDescription() == null ||
            item.getTitle() == null ||
            item.getLink() == null) {
            return false;
        }
        return true;
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
        private String rssUrl;
        private String mediaUrl;

        public static class Builder {
            private String source;
            private String title;
            private String description;
            private String link;
            private String publishedDate;
            private String rssUrl;
            private String mediaUrl;

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

            public Builder rssUrl(String rssUrl) {
                this.rssUrl = rssUrl;
                return this;
            }

            public Builder mediaUrl(String mediaUrl) {
                this.mediaUrl = mediaUrl;
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
            rssUrl = b.rssUrl;
            mediaUrl = b.mediaUrl;
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
