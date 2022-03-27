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
    private boolean paidSubscription;
    private long qouta;
    private String apiToken;

    private DeveloperDao() {}

    public static DeveloperDao empty() {
        return dao;
    }

    public static DeveloperDao from(final DeveloperDetail detail) {
        final var dao = newDao();
        dao.setUsername(detail.getUsername());
        dao.setEmail(detail.getEmail());
        dao.setPaidSubscription(detail.isPaidSubscription());
        dao.setQouta(detail.getQouta());
        return dao;
    }

    public static DeveloperDao newDao() {
        final var dao = new DeveloperDao();
        dao.setPaidSubscription(false);
        dao.setQouta(100L);
        return dao;
    }
}
