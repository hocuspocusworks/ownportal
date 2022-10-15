package net.ownportal;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class RssTest {
    private ByteArrayOutputStream baos;

    @BeforeEach
    void setUp() throws Exception {
        URL url = App.class.getClassLoader().getResource("rss.xml");
        File atomFile = new File(url.toURI().getPath());
        InputStream is = new FileInputStream(atomFile);
        baos = new ByteArrayOutputStream();
        is.transferTo(baos);
        is.close();
    }

    @Test
    void testParsingValidXml() {
        var rss = new RssReader(baos.toByteArray());
        var page = rss.rssToJson();
        assertEquals("Zimbabwe | The Guardian", page.getSource());
        assertEquals(20, page.getSize());
    }
}
