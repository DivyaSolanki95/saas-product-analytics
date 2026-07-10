-- 01_clean_data_mysql.sql
-- COMPLETED VERSION -- Day 2

USE saas_analytics;

-- ============================================================
-- TASK 1: Clean raw_users (fix inconsistent casing in plan_type)
-- ============================================================

DROP TABLE IF EXISTS clean_users;
CREATE TABLE clean_users AS
SELECT
    user_id,
    STR_TO_DATE(signup_date, '%Y-%m-%d') AS signup_date,
    CONCAT(UPPER(LEFT(plan_type, 1)), LOWER(SUBSTRING(plan_type, 2))) AS plan_type,
    company_size,
    acquisition_channel,
    country
FROM raw_users;

-- ============================================================
-- TASK 2: Clean raw_sessions (standardize dates + remove duplicates)
-- ============================================================

DROP TABLE IF EXISTS clean_sessions_with_dupes;
CREATE TABLE clean_sessions_with_dupes AS
SELECT
    session_id,
    user_id,
    CASE
        WHEN session_date_raw REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN
            STR_TO_DATE(session_date_raw, '%Y-%m-%d %H:%i:%s')
        WHEN session_date_raw REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}' THEN
            STR_TO_DATE(session_date_raw, '%m/%d/%Y %H:%i')
        ELSE
            STR_TO_DATE(session_date_raw, '%d-%b-%Y %H:%i:%s')
    END AS session_date,
    CAST(session_duration_min AS DECIMAL(10,2)) AS session_duration_min
FROM raw_sessions;

DROP TABLE IF EXISTS clean_sessions;
CREATE TABLE clean_sessions AS
SELECT session_id, user_id, session_date, session_duration_min
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY session_id) AS rn
    FROM clean_sessions_with_dupes
) t
WHERE rn = 1;

-- ============================================================
-- TASK 3: Clean raw_feature_events (drop orphan user_id records)
-- ============================================================

DROP TABLE IF EXISTS clean_feature_events;
CREATE TABLE clean_feature_events AS
SELECT
    fe.event_id,
    fe.user_id,
    fe.event_name,
    STR_TO_DATE(fe.event_timestamp, '%Y-%m-%d %H:%i:%s') AS event_timestamp
FROM raw_feature_events fe
WHERE EXISTS (
    SELECT 1 FROM clean_users cu WHERE cu.user_id = fe.user_id
);

-- ============================================================
-- TASK 4: Handle nulls in clean_users
-- ============================================================

UPDATE clean_users
SET company_size = 'Unknown'
WHERE company_size IS NULL;

UPDATE clean_users
SET acquisition_channel = 'Unknown'
WHERE acquisition_channel IS NULL;

-- ============================================================
-- TASK 5: Validation query
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM clean_users) AS total_users,
    (SELECT COUNT(*) FROM clean_sessions) AS total_sessions,
    (SELECT COUNT(*) FROM clean_feature_events) AS total_feature_events,
    (SELECT SUM(CASE WHEN company_size IS NULL OR acquisition_channel IS NULL THEN 1 ELSE 0 END) FROM clean_users) AS remaining_nulls;

-- Expected result: total_users=2000, total_sessions=26046,
-- total_feature_events=20123, remaining_nulls=0
