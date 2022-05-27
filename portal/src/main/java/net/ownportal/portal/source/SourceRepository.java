package net.ownportal.portal.source;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
interface SourceRepository extends JpaRepository<Source, String> {
    Optional<Source> findByName(String name);
    List<Source> findByDescriptionContainingIgnoreCase(String keyword);
}
