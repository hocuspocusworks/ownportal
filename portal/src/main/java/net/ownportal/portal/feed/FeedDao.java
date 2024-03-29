package net.ownportal.portal.feed;

import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Document(collection = "feeds")
@Getter
@Setter
@ToString
class FeedDao {
    @Id
    private String id;
    @Indexed(unique=true)
    private String username;
    private boolean paidUser;
    private List<GroupDao> groups;
}
