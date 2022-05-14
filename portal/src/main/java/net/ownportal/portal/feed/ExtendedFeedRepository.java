package net.ownportal.portal.feed;

import com.mongodb.BasicDBObject;

import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
class ExtendedFeedRepository {
    private final MongoOperations mongo;

    //db.feeds.update({"username": "jean"}, {$pull: {"groups": {"name": "test"}}})
    void deleteGroupByName(String user, String group) {
        Query match = Query.query(Criteria.where("username").is(user));
        Update update = new Update().pull("groups", new BasicDBObject("name", group));
        mongo.updateFirst(match, update, FeedDao.class);
    }

    //db.getCollection('feeds').update({"username": "jean"},{ $pull: {"groups.$[].streams": {"name": "Biz & IT – Ars Technica"}}});
    public void deleteStreamByName(String user, String name) {
        Query match = Query.query(Criteria.where("username").is(user));
        Update update = new Update().pull("groups.$[].streams", new BasicDBObject("name", name));
        mongo.updateFirst(match, update, "feeds");
    }
}
