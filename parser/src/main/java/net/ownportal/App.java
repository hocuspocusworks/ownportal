package net.ownportal;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.List;

import jakarta.xml.bind.JAXBElement;
import net.ownportal.rssjax.Rss;
import net.ownportal.rssjax.RssChannel;
import net.ownportal.rssjax.RssItem;

// use JAXB https://mkyong.com/java/jaxb-hello-world-example/
// and annotations!
// API:
// RssFeed convert(InputStream xml);
// Json rssToJson(RssFeed);
// Html rssToHtml(RssFeed);
public final class App {
    private App() {
    }

    public static void main(String[] args) throws Exception {
        URL url = App.class.getClassLoader().getResource("rss.xml");
        File rssFile = new File(url.toURI().getPath());
        InputStream is = new FileInputStream(rssFile);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        is.transferTo(baos);
        is.close();

        RssResolver resolver = new RssResolver();
        Rss rss = resolver.rssFromBytes(baos.toByteArray()).get();
        RssChannel channel = rss.getChannel();
        List<RssItem> items = channel.getItem();
        for (RssItem item : items) {
            for (var element : item.getTitleOrDescriptionOrLink()) {
                if (element instanceof JAXBElement) {
                    JAXBElement el = (JAXBElement) element;
                    var type = el.getName().toString();
                    if (type.equals("title")) {
                        System.out.println(el.getValue().toString());
                    }
                    if (type.equals("link")) {
                        System.out.println(el.getValue().toString());
                    }
                    if (type.equals("description")) {
                        System.out.println(el.getValue().toString());
                    }
                }
            }
        }
        System.out.println();
    }
}
