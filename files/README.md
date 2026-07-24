# E-Commerce Product Analytics: Funnel, Retention & Revenue Analysis

A end-to-end product analytics case study — from raw event data to actionable business recommendations — built to demonstrate the core skill set of a Product Analyst: SQL, funnel analysis, cohort retention analysis, and data storytelling.

## The Business Question

A growing e-commerce app acquires users through 5 channels (Paid Social, Paid Search, Organic, Referral, Email) but has no clear view of:
1. Where users drop off in the signup → purchase funnel
2. Which channels bring high-*quality* users, not just high volume
3. How retention differs across channels and devices

## Key Findings

| Finding | Detail |
|---|---|
| **Biggest funnel leak** | Product-view → cart loses ~50% of engaged users — the highest-leverage stage to fix |
| **Channel quality gap** | Paid Social = highest signup volume, lowest conversion (11%). Referral = lowest volume, highest conversion (47.4%) — a 4x gap |
| **Retention mirrors conversion** | Referral users have both the best week-1 (32.6%) *and* week-4 (15.7%) retention; Paid Social is weakest on both |
| **Platform gap** | iOS converts at 27.9% vs Android's 17.0% — worth a UX audit |

**Recommendation:** reallocate a portion of Paid Social spend toward a Referral incentive program, and prioritize cart-flow UX work over top-of-funnel acquisition.

Full writeup with charts: [`report/Product_Analytics_Case_Study.docx`](report/Product_Analytics_Case_Study.docx)

![Funnel](charts/chart_funnel.png)
![Channel Conversion](charts/chart_channel_conversion.png)

## Tech Stack

- **SQL (SQLite)** — CTEs, multi-table joins, conditional aggregation, date-based cohort logic
- **Python** — pandas for data generation/wrangling, matplotlib for visualization
- **Analytical frameworks** — funnel analysis, weekly cohort retention, channel/segment comparison

## Repo Structure

```
├── data/                    # Raw dataset (6,000 users, ~19K events over 90 days)
│   ├── users.csv
│   └── events.csv
├── sql/
│   └── queries.sql          # 8 core queries: funnel, cohort retention, revenue, etc.
├── scripts/
│   ├── generate_data.py     # Synthetic data generator
│   ├── load_db.py           # Loads CSVs into SQLite
│   └── analyze.py           # Runs queries, builds charts
├── charts/                  # Output visualizations
├── report/
│   ├── Product_Analytics_Case_Study.docx   # Full case study writeup
│   └── results_*.csv        # Raw query outputs
└── dashboard.html           # Interactive dashboard (open in any browser)
```

## How to Reproduce

```bash
pip install pandas numpy matplotlib
python scripts/generate_data.py   # generates data/users.csv, data/events.csv
python scripts/load_db.py         # builds product_analytics.db
python scripts/analyze.py         # runs SQL queries, outputs charts to charts/
```

## Notes on the Data

This uses a **synthetic dataset** (generated with intentional, realistic patterns — e.g. channel-quality differences, device effects, retention decay) rather than a scraped/public dataset, so the full pipeline — from data generation through SQL analysis to business recommendations — is original work.

---
*Built as a portfolio project for Product Analyst roles.*
