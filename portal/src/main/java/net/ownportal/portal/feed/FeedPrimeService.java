package net.ownportal.portal.feed;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
class FeedPrimeService {
    private final FeedRepository repo;

    public List<FeedPrimeDto> getFeedForUsername(String username) {
        var feedOpt = repo.findOneByUsername(username);
        if (feedOpt.isEmpty()) {
            return List.of(FeedPrimeDto.builder().build());
        }
        var result = new ArrayList<FeedPrimeDto>();
        var feed = feedOpt.get();
        var key = 0;
        for (var group : feed.getGroups()) {
            var dto = FeedPrimeDto.builder();
            dto.key(String.valueOf(key));
            dto.label(group.getName());
            var streams = new ArrayList<FeedPrimeDto>();
            var childKey = 0;
            for (var stream : group.getStreams()) {
                var child = FeedPrimeDto.builder();
                child.label(stream.getName());
                child.data(stream.getUrl());
                child.key(String.valueOf(key + "-" + childKey++));
                streams.add(child.build());
            }
            dto.children(streams);
            result.add(dto.build());
            key++;
        }
        return result;
    }    
}
