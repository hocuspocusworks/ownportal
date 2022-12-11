package net.ownportal;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
public class RssPage {
    private long size;
    private String source;
    private String link;
    private String description;
    private String language;
    private String lastBuildDate;
    private String rssUrl;
    private List<RssNode> nodes = new ArrayList<>();

    public void addNode(RssNode node) {
        nodes.add(node);
    }

    @ToString
    @Getter
    @Setter
    public static class RssNode {
        private String title;
        private String description;
        private String link;
        private String publishedDate;
        private List<String> rawCategories = new ArrayList<>();
        private List<String> categories = new ArrayList<>();
        private String mediaUrl;
    }
}
