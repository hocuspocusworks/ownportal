package net.ownportal;

import java.io.ByteArrayInputStream;
import java.util.Optional;
import java.util.stream.Collectors;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBElement;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.UnmarshalException;
import net.ownportal.rssjax.Rss;
import net.ownportal.rssjax.RssChannel;

public class RssReader {
    private Rss feed;
    private String url;

    public RssReader(final byte[] rss) {
        feed = load(rss).orElse(null);
    }

    public RssReader(final byte[] rss, final String url) {
        feed = load(rss).orElse(null);
        this.url = url;
    }

    public boolean isValid() {
        return feed != null ? true : false;
    }

    public RssPage rssToJson() {
        if (!isValid()) {
            return new RssPage();
        }
        final var rssPage = new RssPage();
        final var channel = feed.getChannel();
        final var items = channel.getItem();

        rssPage.setSource(getChannelItemValue(channel, "title"));
        rssPage.setLink(getChannelItemValue(channel, "link"));
        rssPage.setDescription(getChannelItemValue(channel, "description"));
        rssPage.setLanguage(getChannelItemValue(channel, "language"));
        rssPage.setLastBuildDate(getChannelItemValue(channel, "lastBuildDate"));
        rssPage.setRssUrl(url);
        int i = 0;
        for (final var item : items) {
            final var rssNode = new RssPage.RssNode();
            for (final var elem : item.getTitleOrDescriptionOrLink()) {
                if (elem instanceof JAXBElement) {
                    final var el = (JAXBElement) elem;
                    final var type = el.getName().toString();
                    if (type.equals("title")) {
                        rssNode.setTitle(el.getValue().toString());
                    }
                    if (type.equals("link")) {
                        rssNode.setLink(el.getValue().toString());
                    }
                    if (type.equals("description")) {
                        rssNode.setDescription(HtmlParser.parse(el.getValue().toString()));
                    }
                    if (type.equals("pubDate")) {
                        rssNode.setPublishedDate(el.getValue().toString());
                    }
                    if (type.equals("category")) {
                        var cat = ((net.ownportal.rssjax.Category) el.getValue()).getValue();
                        rssNode.getRawCategories().add(cat);
                        var optCategory = Category.keywordToCategory(cat);
                        if (optCategory.isPresent()) {
                            rssNode.getCategories().add(optCategory.get());
                        }
                    }
                }
            }
            rssPage.addNode(rssNode);
            i++;
        }
        rssPage.setSize(i);
        return rssPage;
    }

    private String getChannelItemValue(final RssChannel channel, final String field) {
        final var item = channel
            .getTitleOrLinkOrDescription()
            .stream()
            .filter(el -> isField(el, field))
            .collect(Collectors.toList());
        if (!item.isEmpty()) {
            return ((JAXBElement) item.get(0)).getValue().toString();
        }
        return "";
    }

    private boolean isField(final Object el, final String field) {
        if (el instanceof JAXBElement) {
            return ((JAXBElement) el).getName().toString().toLowerCase().equals(field) ? true : false;
        }
        return false;
    }

    private Optional<Rss> load(byte[] rss) {
        try {
            var context = JAXBContext.newInstance(Rss.class);
            var unmarshaller = context.createUnmarshaller();
            feed = (Rss) unmarshaller.unmarshal(new ByteArrayInputStream(rss));
        } catch (UnmarshalException e) {
            // incorrect format
            // e.printStackTrace();
            return Optional.empty();
        } catch (JAXBException e) {
            // general problem
            // e.printStackTrace();
            return Optional.empty();
        }
        return Optional.of(feed);
    }
}
