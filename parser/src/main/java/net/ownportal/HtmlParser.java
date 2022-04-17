package net.ownportal;

import org.jsoup.Jsoup;

class HtmlParser {
    static String parse(String input) {
        return isHtml(input) ? parseHtml(input) : input;
    }

    private static boolean isHtml(String value) {
        return true;
    }

    private static String parseHtml(String html) {
        final var doc = Jsoup.parse(html);
        if (!doc.hasText()) {
            return html;
        }
        return doc.text();
    }
}
