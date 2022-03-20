package net.ownportal.portal.feed;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import net.ownportal.portal.filter.UserService;

public class FeedServiceTest {
    private UserService userServiceMock;
    private FeedRepository feedRepositoryMock;

    @BeforeEach
    void setUp() {
        userServiceMock = mock(UserService.class);
        feedRepositoryMock = mock(FeedRepository.class);
    }

    @Test
    void whenNoGroupsExist_thenAddNewGroupToFeed() {
        var groupMock = mock(GroupDto.class);
        var feedMock = mock(FeedDao.class);
        when(groupMock.getName()).thenReturn("mockGroup");
        when(userServiceMock.hasFeed()).thenReturn(true);
        when(userServiceMock.getUsername()).thenReturn("user");
        when(feedRepositoryMock.findOneByUsername("user")).thenReturn(Optional.of(feedMock));

        var feedService = new FeedService(userServiceMock, feedRepositoryMock);
        feedService.newGroup(groupMock);

        verify(feedRepositoryMock, times(1)).save(feedMock);
    }

    @Test
    void whenSomeGroupsExist_thenAddNewGroupToFeed() {
        var groupMock = mock(GroupDto.class);
        var feedMock = mock(FeedDao.class);
        when(groupMock.getName()).thenReturn("mockGroup");
        when(userServiceMock.hasFeed()).thenReturn(true);
        when(userServiceMock.getUsername()).thenReturn("user");
        when(feedRepositoryMock.findOneByUsername("user")).thenReturn(Optional.of(feedMock));

        var existingGroup = mock(GroupDto.class);
        when(existingGroup.getName()).thenReturn("mockGroup2");
        when(feedMock.getGroups()).thenReturn(List.of(existingGroup));

        var feedService = new FeedService(userServiceMock, feedRepositoryMock);
        feedService.newGroup(groupMock);

        verify(feedRepositoryMock, times(1)).save(feedMock);
    }

    @Test
    void whenGroupExists_thenDoNotOverwriteFeed() {
        var groupMock = mock(GroupDto.class);
        var feedMock = mock(FeedDao.class);
        when(groupMock.getName()).thenReturn("mockGroup");
        when(userServiceMock.hasFeed()).thenReturn(true);
        when(userServiceMock.getUsername()).thenReturn("user");
        when(feedRepositoryMock.findOneByUsername("user")).thenReturn(Optional.of(feedMock));

        var existingGroup = mock(GroupDto.class);
        when(existingGroup.getName()).thenReturn("mockGroup");
        when(feedMock.getGroups()).thenReturn(List.of(existingGroup));

        var feedService = new FeedService(userServiceMock, feedRepositoryMock);
        feedService.newGroup(groupMock);

        verify(feedRepositoryMock, times(0)).save(feedMock);
    }
}
