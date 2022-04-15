package net.ownportal.portal.source;

import java.util.List;
import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
interface SourceRepository extends MongoRepository<SourceDao, String> {
    Optional<SourceDao> findByName(String name);
    List<SourceDao> findByDescriptionContainingIgnoreCase(String keyword);
}
