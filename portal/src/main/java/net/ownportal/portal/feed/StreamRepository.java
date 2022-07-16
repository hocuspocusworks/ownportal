package net.ownportal.portal.feed;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
interface StreamRepository extends JpaRepository<Stream, Long> {
}
