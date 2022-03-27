package net.ownportal.portal.developer;

import java.time.Instant;

import org.springframework.data.annotation.Id;
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

    @Id
    private String id;
    @NonNull
    private String username;
    @NonNull
    private String password;
    @NonNull
    private String email;
    private boolean paidSubscription;
    private long qouta;
    private long lastUsed;
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
        dao.setLastUsed(detail.getLastUsed());
        return dao;
    }

    public static DeveloperDao newDao() {
        final var dao = new DeveloperDao();
        dao.setPaidSubscription(false);
        dao.setQouta(100L);
        dao.setLastUsed(Instant.now().getEpochSecond());
        return dao;
    }
}
