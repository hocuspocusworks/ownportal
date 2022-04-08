package net.ownportal.portal.source;

import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Document(collection = "categories")
@ToString @Getter @Setter
public class CategoryDao {
    @Id
    private String id;
    private List<Category> categories;

    @ToString @Getter @Setter
    private static class Category {
        private String name;
        private List<String> sub;
    }
}
