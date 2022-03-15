package net.ownportal.portal.filter;

import org.springframework.stereotype.Component;
import org.springframework.web.context.annotation.RequestScope;

import lombok.Data;

@Component
@RequestScope
@Data
class UserDetail {
    private String username;
    private boolean paidUser;
    private int qouta;
    private int numberOfGroups;
    private int numberOfSources;
}
