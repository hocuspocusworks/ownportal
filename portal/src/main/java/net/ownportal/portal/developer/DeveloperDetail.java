package net.ownportal.portal.developer;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
@Builder
class DeveloperDetail {
    private final String username;
    private final String email;
    private final boolean paidSubscription;
    private final long qouta;
    private final String token;

    public static DeveloperDetail empty() {
        return DeveloperDetail.builder().build();
    }

    public static DeveloperDetail from(final DeveloperDao dao) {
        return DeveloperDetail.builder()
            .username(dao.getUsername())
            .email(dao.getEmail())
            .paidSubscription(dao.isPaidSubscription())
            .qouta(dao.getQouta())
            .token(dao.getApiToken())
            .build();
    }
}
