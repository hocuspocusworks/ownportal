package net.ownportal;

import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import net.ownportal.rssjax.Rss;
import net.ownportal.rssjax.RssChannel;
import net.ownportal.rssjax.RssItem;

class AppTest {
    private ByteArrayOutputStream baos;

    @BeforeEach
    void setUp() throws Exception {
        URL url = App.class.getClassLoader().getResource("rss.xml");
        File rssFile = new File(url.toURI().getPath());
        InputStream is = new FileInputStream(rssFile);
        baos = new ByteArrayOutputStream();
        is.transferTo(baos);
        is.close();
    }

    @Test
    void testParsingValidXml() {
        Rss rss = RssResolver.rssFromBytes(baos.toByteArray()).get();
        RssChannel channel = rss.getChannel();
        List<RssItem> items = channel.getItem();
        assertTrue(items.size() > 0);
    }

    @Test
    void rssToJson() {
        final var result = RssResolver.rssToJson(baos.toByteArray());
        System.out.println(result.toString());
    }
}
