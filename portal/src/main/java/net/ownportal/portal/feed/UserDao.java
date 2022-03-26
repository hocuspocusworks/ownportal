package net.ownportal.portal.feed;

import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import lombok.ToString;

@Document(collection = "users")
@ToString
@Getter
@Setter
public class UserDao {
    @NonNull
    private String username;
    @NonNull
    private String password;
}
