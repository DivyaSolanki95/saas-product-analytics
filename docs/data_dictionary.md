# Data Dictionary — PulseCRM Smart Task Automation Analysis

## 1. `users.csv`
| Column | Type | Description | Notes |
|---|---|---|---|
| user_id | string | Unique user identifier (e.g. U00001) | Primary key |
| signup_date | date (YYYY-MM-DD) | Date user created account | |
| plan_type | string | Free / Starter / Professional / Enterprise | ⚠️ Contains inconsistent casing (e.g. "STARTER") — needs cleaning |
| company_size | string | Employee band of user's company | ⚠️ Contains nulls (~3%) |
| acquisition_channel | string | Marketing channel that acquired the user | ⚠️ Contains nulls (~2%) |
| country | string | User's country | |

## 2. `ab_test_assignment.csv`
| Column | Type | Description | Notes |
|---|---|---|---|
| user_id | string | Foreign key to users.user_id | |
| test_group | string | 'control' or 'treatment' | Treatment = has access to Smart Task Automation feature |
| assignment_date | date | Date user was assigned to test group | |

## 3. `subscriptions.csv`
| Column | Type | Description | Notes |
|---|---|---|---|
| user_id | string | Foreign key to users.user_id | |
| plan_type | string | Current subscription plan | |
| mrr | integer | Monthly recurring revenue (USD) from this user | |
| subscription_status | string | 'Active' or 'Churned' | |
| churn_date | date, nullable | Date of churn if applicable | Null if still active |

## 4. `sessions.csv`
| Column | Type | Description | Notes |
|---|---|---|---|
| session_id | string | Unique session identifier | Primary key |
| user_id | string | Foreign key to users.user_id | |
| session_date_raw | string | Timestamp of session | ⚠️ **Mixed date formats** (YYYY-MM-DD HH:MM:SS, MM/DD/YYYY HH:MM, DD-Mon-YYYY HH:MM:SS) — must be standardized before analysis |
| session_duration_min | float | Session length in minutes | |

**Known issue:** ~1.5% of rows are exact duplicates (simulates a real logging bug). Must be de-duplicated.

## 5. `feature_events.csv`
| Column | Type | Description | Notes |
|---|---|---|---|
| event_id | string | Unique event identifier | Primary key |
| user_id | string | Foreign key to users.user_id | ⚠️ Contains 5 orphan records with user_id not present in users.csv — simulates real tracking/ETL issue |
| event_name | string | login / task_created / report_viewed / team_invite_sent / smart_task_used | `smart_task_used` is the key adoption event for this analysis |
| event_timestamp | datetime (YYYY-MM-DD HH:MM:SS) | When the event occurred | |

---

## Entity Relationship Summary
```
users (1) ──< sessions (many)
users (1) ──< feature_events (many)
users (1) ── ab_test_assignment (1)
users (1) ── subscriptions (1)
```

## Known Data Quality Issues (intentional — this is your cleaning checklist)
1. Inconsistent casing in `plan_type` (users.csv)
2. Null values in `company_size`, `acquisition_channel`
3. Three different date formats mixed in `sessions.csv`
4. ~1.5% duplicate rows in `sessions.csv`
5. 5 orphan `user_id` values in `feature_events.csv` with no matching user
6. Some `churn_date` values fall after the 90-day analysis window — needs a business decision on how to treat these
