SELECT
  COUNT(*) AS total_count,
  SUM(CASE WHEN sysadmin = FALSE then 1 else 0 end) AS user_count,
  SUM(CASE WHEN updated_at > (SELECT TIMESTAMP 'yesterday') then 1 else 0 end) AS active_count
FROM
  users
