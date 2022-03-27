package net.ownportal.portal.developer;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
interface DeveloperRepository extends MongoRepository<DeveloperDao, String> {
    
    Optional<DeveloperDao> findOneByUsername(String username);
    Optional<DeveloperDao> findOneByUsernameAndPassword(String username, String password);
}
