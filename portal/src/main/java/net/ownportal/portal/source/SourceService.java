package net.ownportal.portal.source;

import java.time.Instant;
import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SourceService {
    private final SourceRepository repository;
    private final CategoryRepository category;

    public Source saveSource(Source dao) {
        final var result = repository.findByName(dao.getName());
        if (result.isEmpty()) {
            return repository.save(dao);
        }
        result.get().setCategories(dao.getCategories());
        result.get().setTimestamp(Instant.now().toEpochMilli());
        return repository.save(result.get());
    }

    public Category getCategories() {
        return category.findAll().get(0);
    }

    public List<Source> getByKeyword(String keyword) {
        return repository.findByDescriptionContainingIgnoreCase(keyword);
    }
}
