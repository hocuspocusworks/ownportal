package net.ownportal.portal.user;

import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import net.ownportal.portal.feed.Group;
import net.ownportal.portal.story.Favourite;

@Entity
@Table(name = "users")
@Getter
@Setter
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String email;
    private String password;
    private String salt;
    private boolean enabled;
    @Column(nullable = true)
    private boolean premium;
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<Group> groups;
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<Favourite> favourites;
}
