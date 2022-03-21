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
    private List<RssNode> nodes = new ArrayList<>();

    public void addNode(RssNode node) {
        nodes.add(node);
    }

    @ToString
    @Getter
    @Setter
    static class RssNode {
        private String title;
        private String description;
        private String link;
        private String publishedDate;
    }
}
