package net.ownportal.portal;

import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
public class UserDetail {
    @NonNull
    private String username;
    @NonNull
    private String password;
    private String token;
}
