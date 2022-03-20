package net.ownportal.portal.feed;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
class StreamDto {
    private String group;
    private String stream;
    private String url;
}
