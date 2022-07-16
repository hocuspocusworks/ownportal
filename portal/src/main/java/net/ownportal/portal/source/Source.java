package net.ownportal.portal.source;

import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "sources")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Source {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String name;
    private String description;
    private String language;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "source_category",
        joinColumns = @JoinColumn(name = "source_id"),
        inverseJoinColumns = @JoinColumn(name = "category_id"))
    private Set<Category> categories;
    private String icon;
    @Column(unique=true)
    private String url;
    private long timestamp;
}
