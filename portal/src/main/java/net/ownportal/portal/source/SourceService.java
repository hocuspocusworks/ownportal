package net.ownportal.portal.source;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SourceService {
    private final SourceRepository repository;

    public SourceDao saveSource(SourceDao dao) {
        final var result = repository.findByName(dao.getName());
        if (result.isEmpty()) {
            return repository.save(dao);
        }
        return result.get();
    }
}
