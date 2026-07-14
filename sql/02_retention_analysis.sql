-- 02_retention_analysis.sql
-- Day 3 analysis: adoption rate, time-to-first-use, and treatment vs control retention

-- Query 1: Feature Adoption Rate
SELECT
    (SELECT COUNT(*) FROM raw_ab_test_assignment WHERE test_group = 'treatment') AS users_who_got_feature,
    (SELECT COUNT(DISTINCT user_id) FROM clean_feature_events WHERE event_name = 'smart_task_used') AS users_who_used_feature,
    ROUND(
        (SELECT COUNT(DISTINCT user_id) FROM clean_feature_events WHERE event_name = 'smart_task_used')
        /
        (SELECT COUNT(*) FROM raw_ab_test_assignment WHERE test_group = 'treatment')
        * 100, 1
    ) AS adoption_rate_percent;
-- Result: 55.6% adoption rate (550 of 990 treatment users)

-- Query 2: Median Time-to-First-Use
SELECT AVG(days_to_first_use) AS median_days_to_first_use
FROM (
    SELECT
        DATEDIFF(fe.first_use, cu.signup_date) AS days_to_first_use,
        ROW_NUMBER() OVER (ORDER BY DATEDIFF(fe.first_use, cu.signup_date)) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM clean_users cu
    JOIN (
        SELECT user_id, MIN(event_timestamp) AS first_use
        FROM clean_feature_events
        WHERE event_name = 'smart_task_used'
        GROUP BY user_id
    ) fe ON cu.user_id = fe.user_id
) ranked
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));
-- Result: ~10 days median time-to-first-use

-- Query 3 (IMPORTANT - correct comparison): Treatment vs Control Retention
-- Note: We compare treatment vs control (randomized groups), NOT adopters vs
-- non-adopters, to avoid selection bias -- see docs/day3_recap.md for why.
SELECT
    ab.test_group,
    s.subscription_status,
    COUNT(*) AS user_count
FROM raw_ab_test_assignment ab
JOIN raw_subscriptions s ON ab.user_id = s.user_id
GROUP BY ab.test_group, s.subscription_status;
-- Result: control 72.7% retention (734/1010), treatment 78.8% retention (780/990)
-- -> 6.1 percentage point lift, confirmed statistically significant via
--    python/ab_test_significance.py (chi-square test, p = 0.00143)
