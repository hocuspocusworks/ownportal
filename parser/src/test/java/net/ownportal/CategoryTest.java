package net.ownportal;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;

public class CategoryTest {
    @Test
    public void testLevenshteinDistance() {
        var opt = Category.keywordToCategory("weight");
        assertNotNull(opt.get());
        System.out.println(opt.get());
    }
}
