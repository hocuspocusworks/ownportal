package net.ownportal.portal.story;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
interface StoryRepository extends MongoRepository<FavouriteDao, String> {
    List<FavouriteDao> findAllByUsername(String username);
}
