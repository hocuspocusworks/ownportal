package net.ownportal.portal.developer;

import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import lombok.ToString;

@Document(collection = "developers")
@ToString
@Getter
@Setter
class DeveloperDao {
    private static final DeveloperDao dao = new DeveloperDao();

    @NonNull
    private String username;
    @NonNull
    private String password;
    @NonNull
    private String email;
    private String apiToken;

    private DeveloperDao() {}

    public static DeveloperDao empty() {
        return dao;
    }

    public static DeveloperDao newDao() {
        return new DeveloperDao();
    }
}
