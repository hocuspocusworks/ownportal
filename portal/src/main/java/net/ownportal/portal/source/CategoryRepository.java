package net.ownportal.portal.source;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
interface CategoryRepository extends MongoRepository<CategoryDao, String> {
}
