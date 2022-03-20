package net.ownportal.portal.feed;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
class GroupDto {
    private String name;
    private List<StreamDto> streams;
}
