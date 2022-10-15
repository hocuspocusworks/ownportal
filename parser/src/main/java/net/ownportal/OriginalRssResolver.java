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

public class OriginalRssResolver {
    public static boolean isValid(final byte[] rss) {
        try {
            var context = JAXBContext.newInstance(Rss.class);
            var unmarshaller = context.createUnmarshaller();
            unmarshaller.unmarshal(new ByteArrayInputStream(rss));
        } catch (UnmarshalException e) {
            // incorrect format
            // e.printStackTrace();
            return false;
        } catch (JAXBException e) {
            // general problem
            // e.printStackTrace();
            return false;
        }
        return true;
    }

    public static RssPage rssToJson(final byte[] rssBytes) {
        final var rssOpt = rssFromBytes(rssBytes);
        if (rssOpt.isEmpty()) {
            return new RssPage();
        }
        final var rss = rssOpt.get();
        final var channel = rss.getChannel();
        final var items = channel.getItem();

        final var rssPage = new RssPage();
        rssPage.setSource(getChannelItemValue(channel, "title"));
        rssPage.setLink(getChannelItemValue(channel, "link"));
        rssPage.setDescription(getChannelItemValue(channel, "description"));
        rssPage.setLanguage(getChannelItemValue(channel, "language"));
        rssPage.setLastBuildDate(getChannelItemValue(channel, "lastBuildDate"));
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

    private static String getChannelItemValue(final RssChannel channel, final String field) {
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

    private static boolean isField(final Object el, final String field) {
        if (el instanceof JAXBElement) {
            return ((JAXBElement) el).getName().toString().toLowerCase().equals(field) ? true : false;
        }
        return false;
    }

    static Optional<Rss> rssFromBytes(final byte[] rss) {
        if (!isValid(rss)) {
            return Optional.empty();
        }
        try {
            var context = JAXBContext.newInstance(Rss.class);
            var unmarshaller = context.createUnmarshaller();
            return Optional.of((Rss) unmarshaller.unmarshal(new ByteArrayInputStream(rss)));
        } catch (JAXBException e) {
            return Optional.empty();
        }
    }
}
