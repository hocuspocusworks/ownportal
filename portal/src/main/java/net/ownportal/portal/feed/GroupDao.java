package net.ownportal.portal.feed;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
class GroupDao {
    private String name;
    private List<StreamDao> streams;
}
