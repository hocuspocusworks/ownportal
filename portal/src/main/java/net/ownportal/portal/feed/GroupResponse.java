package net.ownportal.portal.feed;

import java.util.HashSet;
import java.util.Set;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
class GroupResponse {
    private String name;
    private Set<StreamResponse> streams = new HashSet<>();
}
