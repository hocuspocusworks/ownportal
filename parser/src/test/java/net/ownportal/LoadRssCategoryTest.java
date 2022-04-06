package net.ownportal;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.io.File;
import java.nio.file.Files;

import com.google.gson.JsonParser;

import org.junit.jupiter.api.Test;

public class LoadRssCategoryTest {
    @Test
    public void testLoadingRssCategories() throws Exception {
        var resource = App.class.getClassLoader().getResource("rss_categories.json");
        var file = new File(resource.toURI().getPath());
        var parser = JsonParser.parseString(Files.readString(file.toPath()));
        var json = parser.getAsJsonObject();
        assertNotNull(json);
    }
}
