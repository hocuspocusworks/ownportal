package net.ownportal.portal.feed;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeedRepository extends MongoRepository<FeedDao, String> {

    List<FeedDao> findByUsername(String username);
}
