package net.ownportal.fetcher;

import java.util.List;

import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;

@Getter
@Setter
class FetchAllRequest {
    @NonNull
    private List<String> urls;
    private String sort = "random";
}
