package net.ownportal.fetcher;

import java.util.UUID;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@ToString
@Getter
@RequiredArgsConstructor
@Builder
public class ServiceResponse<T> {
    private final int code;
    private final UUID requestId;
    private final long timestamp;
    private final T data;
}
