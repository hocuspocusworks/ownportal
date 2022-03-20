package net.ownportal.portal.feed;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeedRepository extends MongoRepository<FeedDao, String> {

    Optional<FeedDao> findOneByUsername(String username);
}
