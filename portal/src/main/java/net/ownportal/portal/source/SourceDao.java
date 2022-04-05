package net.ownportal.portal.source;

import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Document(collection = "sources")
@Getter
@Setter
@ToString
@Builder
public class SourceDao {
    @Id
    private String id;
    private String name;
    private String description;
    private String language;
    private List<String> categories;
    private String icon;
    private String url;
}
