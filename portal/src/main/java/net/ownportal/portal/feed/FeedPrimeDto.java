package net.ownportal.portal.feed;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
class FeedPrimeDto {
    private String key;
    private String label;
    private String data;
    private String icon;
    private List<FeedPrimeDto> children;
}
