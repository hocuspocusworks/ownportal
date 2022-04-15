package net.ownportal.portal.story;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.Setter;

@Document(collection = "favourites")
@Getter
@Setter
class FavouriteDao {
    @Id
    private String id;
    private String username;
    private String title;
    private String description;
    private String publishedDate;
    private String publisher;
    private String link;
}
