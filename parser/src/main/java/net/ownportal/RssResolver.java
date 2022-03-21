package net.ownportal;

import java.io.ByteArrayInputStream;
import java.util.Optional;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBElement;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.UnmarshalException;
import net.ownportal.rssjax.Rss;

public class RssResolver {
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
                        rssNode.setDescription(el.getValue().toString());
                    }
                    if (type.equals("pubDate")) {
                        rssNode.setPublishedDate(el.getValue().toString());
                    }
                }
            }
            rssPage.addNode(rssNode);
            i++;
        }
        rssPage.setSize(i);
        return rssPage;
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
