-- 00_create_raw_tables_mysql.sql
-- Run this first in MySQL Workbench (creates the schema + raw staging tables)

CREATE DATABASE IF NOT EXISTS saas_analytics;
USE saas_analytics;

DROP TABLE IF EXISTS raw_users;
CREATE TABLE raw_users (
    user_id VARCHAR(20),
    signup_date VARCHAR(20),
    plan_type VARCHAR(30),
    company_size VARCHAR(20),
    acquisition_channel VARCHAR(50),
    country VARCHAR(50)
);

DROP TABLE IF EXISTS raw_sessions;
CREATE TABLE raw_sessions (
    session_id VARCHAR(20),
    user_id VARCHAR(20),
    session_date_raw VARCHAR(30),   -- mixed formats: 'YYYY-MM-DD HH:MM:SS', 'MM/DD/YYYY HH:MM', 'DD-Mon-YYYY HH:MM:SS'
    session_duration_min VARCHAR(20)
);

DROP TABLE IF EXISTS raw_feature_events;
CREATE TABLE raw_feature_events (
    event_id VARCHAR(20),
    user_id VARCHAR(20),
    event_name VARCHAR(50),
    event_timestamp VARCHAR(30)
);

DROP TABLE IF EXISTS raw_subscriptions;
CREATE TABLE raw_subscriptions (
    user_id VARCHAR(20),
    plan_type VARCHAR(30),
    mrr VARCHAR(20),
    subscription_status VARCHAR(20),
    churn_date VARCHAR(20)
);

DROP TABLE IF EXISTS raw_ab_test_assignment;
CREATE TABLE raw_ab_test_assignment (
    user_id VARCHAR(20),
    test_group VARCHAR(20),
    assignment_date VARCHAR(20)
);
