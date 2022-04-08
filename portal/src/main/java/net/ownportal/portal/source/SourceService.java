package net.ownportal.portal.source;

import java.time.Instant;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SourceService {
    private final SourceRepository repository;
    private final CategoryRepository category;

    public SourceDao saveSource(SourceDao dao) {
        final var result = repository.findByName(dao.getName());
        if (result.isEmpty()) {
            return repository.save(dao);
        }
        result.get().setCategories(dao.getCategories());
        result.get().setTimestamp(Instant.now().toEpochMilli());
        return repository.save(result.get());
    }

    public CategoryDao getCategories() {
        return category.findAll().get(0);
    }
}
