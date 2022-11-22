package net.ownportal;

import java.io.ByteArrayInputStream;
import java.util.Optional;

import org.jsoup.Jsoup;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBElement;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.UnmarshalException;
import net.ownportal.RssPage.RssNode;
import net.ownportal.atomjax.ContentType;
import net.ownportal.atomjax.DateTimeType;
import net.ownportal.atomjax.EntryType;
import net.ownportal.atomjax.FeedType;
import net.ownportal.atomjax.LinkType;
import net.ownportal.atomjax.TextType;

public class AtomReader {
    private JAXBElement<FeedType> feed;
    private String url;
    private int feedEntries = 0;

    public AtomReader(final byte[] rss) {
        feed = load(rss).orElse(null);
    }

    public AtomReader(final byte[] rss, final String url) {
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
        rssPage.setRssUrl(url);
        for (var item : feed.getValue().getAuthorOrCategoryOrContributor()) {
            if (item instanceof JAXBElement) {
                JAXBElement element = (JAXBElement) item;
                setTitle(element, rssPage);
                setLastBuildDate(element, rssPage);
                setEntries(element, rssPage);
            } else {
                // e.g. creativeCommons:license
                System.out.println();
            }
        }
        rssPage.setSize(feedEntries);
        return rssPage;
    }

    private void setEntries(JAXBElement element, RssPage rssPage) {
        if (element.getName().getLocalPart().equals("entry")) {
            EntryType entry = (EntryType) element.getValue();
            final var rssNode = new RssPage.RssNode();
            rssPage.addNode(rssNode);
            feedEntries++;
            for (var item : entry.getAuthorOrCategoryOrContent()) {
                if (item instanceof JAXBElement) {
                    JAXBElement subitem = (JAXBElement) item;
                    setEntryTitle(subitem, rssNode);
                    setEntryDescription(subitem, rssNode);
                    setEntryLink(subitem, rssNode);
                    setEntryPublishedDate(subitem, rssNode);
                } else {
                    // e.g. media:thumbnail
                    System.out.println();
                }
            }
        }
    }

    private void setEntryPublishedDate(JAXBElement element, RssNode rssNode) {
        if (element.getName().getLocalPart().equals("updated")) {
            DateTimeType item = (DateTimeType) element.getValue();
            rssNode.setPublishedDate((item.getValue().toString()));
        }
    }

    private void setEntryLink(JAXBElement element, RssNode rssNode) {
        if (element.getName().getLocalPart().equals("link")) {
            LinkType item = (LinkType) element.getValue();
            rssNode.setLink(item.getHref());
        }
    }

    private void setEntryDescription(JAXBElement element, RssNode rssNode) {
        if (element.getName().getLocalPart().equals("content")) {
            ContentType item = (ContentType) element.getValue(); // TODO: check content type and convert
            rssNode.setDescription(processedText(item.getContent().get(0).toString()));
        }
        if (element.getName().getLocalPart().equals("summary")) {
            TextType item = (TextType) element.getValue();
            rssNode.setDescription(processedText(item.getContent().get(0).toString()));
        }
    }

    private void setEntryTitle(JAXBElement element, RssNode rssNode) {
        if (element.getName().getLocalPart().equals("title")) {
            TextType item = (TextType) element.getValue();
            rssNode.setTitle(item.getContent().get(0).toString());
        }
    }

    private void setLastBuildDate(JAXBElement element, RssPage rssPage) {
        if (element.getName().getLocalPart().equals("updated")) {
            DateTimeType item = (DateTimeType) element.getValue();
            rssPage.setLastBuildDate(item.getValue().toString());
        }
    }

    private void setTitle(JAXBElement element, RssPage rssPage) {
        if (element.getName().getLocalPart().equals("title")) {
            TextType item = (TextType) element.getValue();
            rssPage.setSource(item.getContent().get(0).toString());
        }
    }

    private Optional<JAXBElement<FeedType>> load(byte[] rss) {
        try {
            var context = JAXBContext.newInstance(FeedType.class);
            var unmarshaller = context.createUnmarshaller();
            feed = (JAXBElement<FeedType>) unmarshaller.unmarshal(new ByteArrayInputStream(rss));
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

    private String processedText(String html) {
        return htmlToText(html).trim();
    }

    private String htmlToText(String html) {
        return Jsoup.parse(html).text();
    }
}
