package net.ownportal.fetcher;

import java.time.Instant;
import java.util.Random;
import java.util.UUID;

public class Response {
    private final static Random rand = new Random();
    public static <T> ServiceResponse<T> ok(T data) {
        return ServiceResponse.<T>builder()
            .code(0)
            .data(data)
            .timestamp(Instant.now().toEpochMilli())
            .requestId(new UUID(rand.nextLong(), rand.nextLong()))
            .build();
    }

    public static <T> ServiceResponse<T> fail(T reason) {
        return ServiceResponse.<T>builder()
            .code(-1)
            .data(reason)
            .timestamp(Instant.now().toEpochMilli())
            .requestId(new UUID(rand.nextLong(), rand.nextLong()))
            .build();
    }
}
