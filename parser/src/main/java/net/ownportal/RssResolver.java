package net.ownportal;

public class RssResolver {
    public static boolean isValid(final byte[] rss) {
        return (new RssReader(rss).isValid() == true) || (new AtomReader(rss).isValid() == true);
    }

    public static RssPage rssToJson(final byte[] rssBytes) {
        var rssReader = new RssReader(rssBytes);
        if (rssReader.isValid()) {
            return rssReader.rssToJson();
        }

        var atomReader = new AtomReader(rssBytes);
        if (atomReader.isValid()) {
            return atomReader.rssToJson();
        }

        return new RssPage();
    }

    public static RssPage rssToJson(final byte[] rssBytes, String url) {
        var rssReader = new RssReader(rssBytes, url);
        if (rssReader.isValid()) {
            return rssReader.rssToJson();
        }

        var atomReader = new AtomReader(rssBytes, url);
        if (atomReader.isValid()) {
            return atomReader.rssToJson();
        }

        return new RssPage();
    }
}
