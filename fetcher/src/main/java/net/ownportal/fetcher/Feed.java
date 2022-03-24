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
    private List<RssPage.RssNode> nodes = new ArrayList<>();

    public Feed(List<RssPage> pages) {
        for (var p : pages) {
            size += p.getSize();
            nodes.addAll(p.getNodes());
        }
    }
}
