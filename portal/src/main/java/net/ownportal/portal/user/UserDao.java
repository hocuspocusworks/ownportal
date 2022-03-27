package net.ownportal.portal.user;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import lombok.ToString;

@Document(collection = "users")
@ToString
@Getter
@Setter
class UserDao {
    private static UserDao dao = new UserDao();

    @Id
    private String id;
    @NonNull
    private String username;
    @NonNull
    private String password;
    @NonNull
    private String email;

    static UserDao empty() {
        return dao;
    }
}
