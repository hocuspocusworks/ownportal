package net.ownportal.fetcher;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import net.ownportal.RssPage;

@ToString
@Getter
@Setter
public class Feed {
    private long size;
    private List<FeedItem> nodes = new ArrayList<>();

    public Feed(List<RssPage> pages) {
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
}
