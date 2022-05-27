package net.ownportal.portal.story;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import net.ownportal.portal.user.User;

@Entity
@Table(name = "favourites")
@Getter
@Setter
public class Favourite {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @ManyToOne
    private User user;
    private String title;
    private String description;
    private String publishedDate;
    private String publisher;
    private String link;
}
