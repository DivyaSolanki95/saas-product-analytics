# PulseCRM: Smart Task Automation — Feature Adoption & Retention Analysis

**A/B test analysis answering: should this SaaS company invest further in a new product feature?**

![SQL](https://img.shields.io/badge/SQL-MySQL-blue) ![Python](https://img.shields.io/badge/Python-Statistical%20Testing-yellow) ![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-purple) ![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

---

## TL;DR

Users given access to a new feature retained at **78.8% vs 72.7%** for those
without it — a statistically significant 6.1-point lift (p = 0.0014). But the
more interesting finding was methodological: the *obvious* comparison
(feature adopters vs non-adopters) was actively misleading due to selection
bias, and the correct comparison (randomized treatment vs control) told a
different, more trustworthy story. **Recommendation: invest further.**

## Dashboard

![Dashboard Screenshot](screenshots/dashboard_overview.png)
*(Screenshot to be added — see screenshots/ folder)*

## The Business Problem

PulseCRM (fictional B2B SaaS CRM) launched **Smart Task Automation** via a
controlled A/B test to 50% of new signups. Three months in, the VP of
Product needed a data-backed decision: keep investing engineering resources
in this feature, or deprioritize it? No rigorous analysis had been done —
only anecdotal customer feedback.

Full write-up: [`docs/problem_statement.md`](docs/problem_statement.md)

## The Finding That Matters Most: Avoiding a Misleading Comparison

The naive approach — compare people who *used* the feature against people
who *didn't* — showed feature users retaining *worse* (77.8%) than
non-users (80.0%). Taken at face value, that would have killed the feature.

**But that comparison is broken.** Users self-select into trying new
features — the kind of person who tries something new isn't a random
sample, so any difference could reflect *who tried it*, not *what the
feature did*.

Because this was a proper randomized A/B test, the correct comparison is
**treatment vs control** (everyone *given access*, regardless of whether
they used it, vs everyone who wasn't). That comparison showed the opposite
result: a real, statistically significant **positive** effect.

This distinction — recognizing when a comparison is contaminated by
selection bias, and knowing how randomization fixes it — is the core
skill this project demonstrates.

## Methodology

| Stage | Tool | What was done |
|---|---|---|
| Data generation | Python (Faker) | Synthetic 5-table SaaS dataset (~50K rows) with realistic messiness: mixed date formats, duplicates, nulls, orphan records |
| Data cleaning | SQL (MySQL) | Standardized date formats, deduplicated records, handled nulls, resolved referential integrity issues |
| Analysis | SQL | Adoption rate, time-to-first-use, treatment vs control retention |
| Statistical testing | Python (SciPy) | Chi-square test of independence to validate the retention lift wasn't random noise |
| Visualization | Power BI | Interactive dashboard for stakeholder self-service |
| Reporting | Markdown | Executive summary translating findings into business recommendations |

## Key Findings

- **Adoption Rate:** 55.6% of users given access used the feature at least once
- **Time-to-First-Use:** Median 10 days — users aren't discovering it quickly, pointing to an onboarding opportunity
- **Retention Lift:** +6.1 percentage points (78.8% vs 72.7%), treatment vs control
- **Statistical Significance:** p = 0.0014 (chi-square test) — the lift is very unlikely to be due to chance

Full findings log: [`docs/problem_statement.md`](docs/problem_statement.md#findings-log-updated-as-analysis-progresses)

## Business Recommendation

1. Continue investing in Smart Task Automation — the retention impact is real
2. Prioritize onboarding nudges (in-app tip or email) in the first week to close the 10-day discovery gap
3. Proceed toward full rollout beyond the current 50% test group

Full memo: [`executive_summary.md`](executive_summary.md)

## Repository Structure
```
saas-product-analytics/
├── data/
│   ├── raw/              # Original messy synthetic data
│   └── cleaned/           # Exported clean tables (for Power BI)
├── sql/                    # Cleaning + analysis scripts
├── python/                 # Dataset generation + statistical testing
├── powerbi/                 # Dashboard file + custom theme
├── docs/                     # Problem statement, data dictionary
├── screenshots/                # Dashboard visuals
└── executive_summary.md         # Business-facing recommendation memo
```

## Future Scope
- Segment retention lift by acquisition channel and plan type to prioritize onboarding investment
- Track D60/D90 retention once more data is available
- A/B test a specific onboarding nudge to directly test whether it reduces the 10-day median time-to-first-use

---
*Built as a full-cycle analytics project: business problem → data cleaning →
SQL analysis → statistical validation → dashboard → executive recommendation.*
