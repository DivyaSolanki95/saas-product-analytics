"""
generate_dataset.py
--------------------
Generates a realistic (deliberately messy) synthetic dataset for the
PulseCRM "Smart Task Automation" feature adoption analysis project.

Messiness included on purpose (mirrors real production data):
- Null values in optional fields
- Duplicate session rows
- Inconsistent date formats in raw sessions data
- Inconsistent text casing in categorical fields
- A few orphan records (user_id in child table not in users table)

Run: python generate_dataset.py
Output: CSVs written to ../data/raw/
"""

import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker()
Faker.seed(42)
random.seed(42)
np.random.seed(42)

OUT_DIR = "../data/raw"
import os
os.makedirs(OUT_DIR, exist_ok=True)

N_USERS = 2000
START_DATE = datetime(2026, 1, 1)
END_DATE = datetime(2026, 3, 31)  # 3-month window, matches the feature launch problem statement

PLAN_TYPES = ["Free", "Starter", "Professional", "Enterprise"]
PLAN_WEIGHTS = [0.35, 0.30, 0.25, 0.10]
CHANNELS = ["Organic Search", "Paid Ads", "Referral", "Content Marketing", "Direct", "Partner"]
COUNTRIES = ["United States", "United Kingdom", "India", "Canada", "Germany", "Australia", "Singapore"]
COMPANY_SIZES = ["1-10", "11-50", "51-200", "201-500", "500+"]

def random_date(start, end):
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days), seconds=random.randint(0, 86399))

# ---------------------------------------------------------
# 1. USERS TABLE
# ---------------------------------------------------------
users = []
for i in range(1, N_USERS + 1):
    signup_date = random_date(START_DATE, END_DATE)
    plan = np.random.choice(PLAN_TYPES, p=PLAN_WEIGHTS)
    company_size = random.choice(COMPANY_SIZES)
    channel = random.choice(CHANNELS)
    country = random.choice(COUNTRIES)

    # inject messiness: ~3% missing company_size, ~2% missing channel
    if random.random() < 0.03:
        company_size = None
    if random.random() < 0.02:
        channel = None
    # inject inconsistent casing ~10% of the time (real CRM exports do this)
    if random.random() < 0.10:
        plan = plan.upper()

    users.append({
        "user_id": f"U{i:05d}",
        "signup_date": signup_date.strftime("%Y-%m-%d"),
        "plan_type": plan,
        "company_size": company_size,
        "acquisition_channel": channel,
        "country": country
    })

users_df = pd.DataFrame(users)

# ---------------------------------------------------------
# 2. AB TEST ASSIGNMENT TABLE
# (50% of users randomly assigned into treatment = got Smart Task Automation)
# ---------------------------------------------------------
ab_rows = []
for u in users:
    group = np.random.choice(["control", "treatment"], p=[0.5, 0.5])
    assign_date = (datetime.strptime(u["signup_date"], "%Y-%m-%d") + timedelta(days=random.randint(0, 1)))
    ab_rows.append({
        "user_id": u["user_id"],
        "test_group": group,
        "assignment_date": assign_date.strftime("%Y-%m-%d")
    })
ab_df = pd.DataFrame(ab_rows)

# ---------------------------------------------------------
# 3. SUBSCRIPTIONS TABLE
# Treatment group gets a modest retention boost baked in (this is the "signal"
# your analysis should be able to detect statistically)
# ---------------------------------------------------------
sub_rows = []
mrr_map = {"Free": 0, "Starter": 29, "Professional": 79, "Enterprise": 249}
for u in users:
    ab_group = ab_df.loc[ab_df.user_id == u["user_id"], "test_group"].values[0]
    plan = u["plan_type"].title() if u["plan_type"] else "Free"
    mrr = mrr_map.get(plan, 29)

    # base churn probability, reduced for treatment group (the effect we're testing for)
    base_churn_prob = 0.28
    churn_prob = base_churn_prob - 0.08 if ab_group == "treatment" else base_churn_prob
    is_churned = random.random() < churn_prob

    status = "Churned" if is_churned else "Active"
    churn_date = None
    if is_churned:
        signup = datetime.strptime(u["signup_date"], "%Y-%m-%d")
        churn_dt = signup + timedelta(days=random.randint(10, 85))
        churn_date = churn_dt.strftime("%Y-%m-%d")

    sub_rows.append({
        "user_id": u["user_id"],
        "plan_type": plan,
        "mrr": mrr,
        "subscription_status": status,
        "churn_date": churn_date
    })
subs_df = pd.DataFrame(sub_rows)

# ---------------------------------------------------------
# 4. SESSIONS TABLE (with intentional messiness: mixed date formats + duplicates)
# ---------------------------------------------------------
session_rows = []
session_id_counter = 1
for u in users:
    signup = datetime.strptime(u["signup_date"], "%Y-%m-%d")
    n_sessions = np.random.poisson(12) + 1  # activity varies per user
    for _ in range(n_sessions):
        s_date = random_date(signup, min(signup + timedelta(days=90), END_DATE + timedelta(days=1)))
        duration = round(np.random.exponential(scale=15) + 1, 1)

        # inconsistent date formatting: real exports often mix these
        fmt_choice = random.random()
        if fmt_choice < 0.7:
            date_str = s_date.strftime("%Y-%m-%d %H:%M:%S")
        elif fmt_choice < 0.9:
            date_str = s_date.strftime("%m/%d/%Y %H:%M")
        else:
            date_str = s_date.strftime("%d-%b-%Y %H:%M:%S")

        session_rows.append({
            "session_id": f"S{session_id_counter:06d}",
            "user_id": u["user_id"],
            "session_date_raw": date_str,
            "session_duration_min": duration
        })
        session_id_counter += 1

sessions_df = pd.DataFrame(session_rows)

# inject ~1.5% exact duplicate rows (common real-world logging bug)
dupes = sessions_df.sample(frac=0.015, random_state=1)
sessions_df = pd.concat([sessions_df, dupes], ignore_index=True)

# ---------------------------------------------------------
# 5. FEATURE_EVENTS TABLE
# Includes 'smart_task_used' events -- treatment group has higher & earlier adoption
# ---------------------------------------------------------
event_rows = []
event_id_counter = 1
EVENT_NAMES = ["login", "task_created", "report_viewed", "team_invite_sent"]

for u in users:
    ab_group = ab_df.loc[ab_df.user_id == u["user_id"], "test_group"].values[0]
    signup = datetime.strptime(u["signup_date"], "%Y-%m-%d")

    # generic activity events
    n_events = np.random.poisson(8) + 1
    for _ in range(n_events):
        e_date = random_date(signup, min(signup + timedelta(days=90), END_DATE + timedelta(days=1)))
        event_rows.append({
            "event_id": f"E{event_id_counter:06d}",
            "user_id": u["user_id"],
            "event_name": random.choice(EVENT_NAMES),
            "event_timestamp": e_date.strftime("%Y-%m-%d %H:%M:%S")
        })
        event_id_counter += 1

    # smart_task_used -- only possible for treatment group, with an adoption probability
    if ab_group == "treatment":
        adopts = random.random() < 0.62  # 62% adoption rate among those with access
        if adopts:
            n_uses = np.random.poisson(4) + 1
            first_use_delay = random.randint(1, 21)  # time-to-first-use
            for k in range(n_uses):
                e_date = signup + timedelta(days=first_use_delay + k * random.randint(1, 10))
                if e_date > END_DATE:
                    break
                event_rows.append({
                    "event_id": f"E{event_id_counter:06d}",
                    "user_id": u["user_id"],
                    "event_name": "smart_task_used",
                    "event_timestamp": e_date.strftime("%Y-%m-%d %H:%M:%S")
                })
                event_id_counter += 1

events_df = pd.DataFrame(event_rows)

# inject a handful of orphan records (user_id not present in users table) -- realistic data quality issue
orphan_events = pd.DataFrame([{
    "event_id": f"E{event_id_counter + i:06d}",
    "user_id": f"U9{9000+i}",
    "event_name": random.choice(EVENT_NAMES),
    "event_timestamp": random_date(START_DATE, END_DATE).strftime("%Y-%m-%d %H:%M:%S")
} for i in range(5)])
events_df = pd.concat([events_df, orphan_events], ignore_index=True)

# ---------------------------------------------------------
# WRITE ALL FILES
# ---------------------------------------------------------
users_df.to_csv(f"{OUT_DIR}/users.csv", index=False)
ab_df.to_csv(f"{OUT_DIR}/ab_test_assignment.csv", index=False)
subs_df.to_csv(f"{OUT_DIR}/subscriptions.csv", index=False)
sessions_df.to_csv(f"{OUT_DIR}/sessions.csv", index=False)
events_df.to_csv(f"{OUT_DIR}/feature_events.csv", index=False)

print("Dataset generated successfully:")
print(f"  users.csv               -> {len(users_df)} rows")
print(f"  ab_test_assignment.csv  -> {len(ab_df)} rows")
print(f"  subscriptions.csv       -> {len(subs_df)} rows")
print(f"  sessions.csv            -> {len(sessions_df)} rows (includes ~1.5% intentional duplicates)")
print(f"  feature_events.csv      -> {len(events_df)} rows (includes 5 intentional orphan records)")
