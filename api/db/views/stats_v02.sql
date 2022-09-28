SELECT
  (
    SELECT COUNT(*) FROM users
  ) AS users_total,
  (
    SELECT COUNT(*) FROM users WHERE sysadmin = false
  ) AS user_count,
  (
    SELECT COUNT(*) FROM users WHERE sysadmin = false and updated_at > (SELECT TIMESTAMP 'yesterday')
  ) AS user_active,
  (
    SELECT COUNT(*) FROM sources
  ) AS sources_total,
  (
    SELECT COUNT(*) FROM sources WHERE restricted = true
  ) AS sources_restricted,
  (
    SELECT COUNT(*) FROM sources WHERE published = true
  ) AS sources_published
