package net.ownportal;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class RssResolverTest {
    private ByteArrayOutputStream rssBaos;
    private ByteArrayOutputStream atomBaos;

    @BeforeEach
    void setUp() throws Exception {
        URL rssUrl = App.class.getClassLoader().getResource("rss.xml");
        File rssFile = new File(rssUrl.toURI().getPath());
        InputStream rssIs = new FileInputStream(rssFile);
        rssBaos = new ByteArrayOutputStream();
        rssIs.transferTo(rssBaos);
        rssIs.close();

        URL atomUrl = App.class.getClassLoader().getResource("atom.xml");
        File atomFile = new File(atomUrl.toURI().getPath());
        InputStream atomIs = new FileInputStream(atomFile);
        atomBaos = new ByteArrayOutputStream();
        atomIs.transferTo(atomBaos);
        atomIs.close();
    }

    @Test
    void rssToJson() {
        var page = RssResolver.rssToJson(rssBaos.toByteArray());
        assertEquals("Zimbabwe | The Guardian", page.getSource());
    }

    @Test
    void atomToJson() {
        var page = RssResolver.rssToJson(atomBaos.toByteArray());
        assertEquals("Atom Feed", page.getSource());
    }

    @Test
    void bothToJson() {
        var page = RssResolver.rssToJson(rssBaos.toByteArray());
        assertEquals("Zimbabwe | The Guardian", page.getSource());

        page = RssResolver.rssToJson(atomBaos.toByteArray());
        assertEquals("Atom Feed", page.getSource());
    }
}
