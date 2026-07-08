-- 01_clean_data_mysql.sql
-- YOUR MISSION: Fill in every blank marked -- TODO
-- Run each section, check the verify query underneath it, then move to the next.

USE saas_analytics;

-- ============================================================
-- TASK 1: Clean raw_users
-- Issue: inconsistent casing in plan_type (e.g. "STARTER" vs "Starter")
-- ============================================================

DROP TABLE IF EXISTS clean_users;
CREATE TABLE clean_users AS
SELECT
    user_id,
    STR_TO_DATE(signup_date, '%Y-%m-%d') AS signup_date,
    -- TODO: standardize plan_type so "STARTER" and "Starter" become identical.
    -- MySQL has no INITCAP(). Build it yourself with CONCAT + UPPER + LOWER + SUBSTRING:
    -- CONCAT(UPPER(LEFT(plan_type,1)), LOWER(SUBSTRING(plan_type,2)))
    ______________ AS plan_type,
    company_size,        -- nulls handled in Task 4
    acquisition_channel,
    country
FROM raw_users;

-- Verify: SELECT DISTINCT plan_type FROM clean_users;
-- You should see exactly 4 values: Free, Starter, Professional, Enterprise


-- ============================================================
-- TASK 2: Clean raw_sessions
-- Issues: (a) three mixed date formats, (b) ~1.5% duplicate rows
-- ============================================================

-- Step 2a: standardize dates using STR_TO_DATE with format codes matching each pattern.
-- Formats present:
--   'YYYY-MM-DD HH:MM:SS'   -> format '%Y-%m-%d %H:%i:%s'
--   'MM/DD/YYYY HH:MM'      -> format '%m/%d/%Y %H:%i'
--   'DD-Mon-YYYY HH:MM:SS'  -> format '%d-%b-%Y %H:%i:%s'
-- Use REGEXP to detect which pattern a row matches, inside a CASE statement.

DROP TABLE IF EXISTS clean_sessions_with_dupes;
CREATE TABLE clean_sessions_with_dupes AS
SELECT
    session_id,
    user_id,
    CASE
        WHEN session_date_raw REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN
            STR_TO_DATE(session_date_raw, '%Y-%m-%d %H:%i:%s')
        WHEN session_date_raw REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}' THEN
            -- TODO: fill in STR_TO_DATE for the MM/DD/YYYY HH:MM format
            ______________
        ELSE
            -- TODO: fill in STR_TO_DATE for the DD-Mon-YYYY HH:MM:SS format
            ______________
    END AS session_date,
    CAST(session_duration_min AS DECIMAL(10,2)) AS session_duration_min
FROM raw_sessions;

-- Verify: SELECT COUNT(*) FROM clean_sessions_with_dupes WHERE session_date IS NULL;
-- Should return 0.

-- Step 2b: remove exact duplicate rows using ROW_NUMBER() (MySQL 8+ supports window functions).
-- TODO: think about which columns define a "duplicate" here, then write a query that
-- keeps only the first occurrence of each duplicate set.
-- Skeleton to guide you:
--
-- DROP TABLE IF EXISTS clean_sessions;
-- CREATE TABLE clean_sessions AS
-- SELECT session_id, user_id, session_date, session_duration_min
-- FROM (
--     SELECT *,
--         ROW_NUMBER() OVER (PARTITION BY ______________ ORDER BY session_id) AS rn
--     FROM clean_sessions_with_dupes
-- ) t
-- WHERE rn = 1;

______________;

-- Verify row counts before/after:
-- SELECT (SELECT COUNT(*) FROM clean_sessions_with_dupes) AS before_count,
--        (SELECT COUNT(*) FROM clean_sessions) AS after_count;


-- ============================================================
-- TASK 3: Clean raw_feature_events
-- Issue: 5 orphan user_id records (no matching row in clean_users)
-- ============================================================

-- Business decision: drop orphan events since they can't be attributed to a real
-- user/segment for this analysis. Be ready to explain this tradeoff in an interview.

DROP TABLE IF EXISTS clean_feature_events;
CREATE TABLE clean_feature_events AS
SELECT
    fe.event_id,
    fe.user_id,
    fe.event_name,
    STR_TO_DATE(fe.event_timestamp, '%Y-%m-%d %H:%i:%s') AS event_timestamp
FROM raw_feature_events fe
-- TODO: add a JOIN or WHERE EXISTS clause that only keeps rows where fe.user_id
-- exists in clean_users
______________;

-- Verify: SELECT COUNT(*) FROM clean_feature_events; -- should be 20,123


-- ============================================================
-- TASK 4: Handle nulls in clean_users
-- Issue: nulls in company_size (~3%) and acquisition_channel (~2%)
-- ============================================================

-- TODO: use UPDATE + COALESCE (or IFNULL) to replace NULLs with 'Unknown'.
-- Example pattern: UPDATE table SET col = IFNULL(col, 'Unknown');

______________;
______________;


-- ============================================================
-- TASK 5 (self-check): one validation query proving the cleaning worked
-- ============================================================
-- TODO: write ONE query returning: total clean users, total clean sessions,
-- total clean feature events, and remaining null count in company_size/acquisition_channel
-- (should be 0). This is the exact kind of query a hiring manager asks you to write live.

______________;
