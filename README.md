# PulseCRM: Smart Task Automation — Feature Adoption & Activation Analysis

**Type:** End-to-end product analytics case study
**Tools:** SQL · Python (pandas, scipy) · Power BI · Excel
**Status:** 🚧 In progress

---

## 📌 Business Problem
PulseCRM (B2B SaaS CRM) launched a new **Smart Task Automation** feature via a
controlled A/B test to 50% of new signups. Leadership needs a data-backed
recommendation: **invest further in this feature, or deprioritize it?**

Full problem statement: [`docs/problem_statement.md`](docs/problem_statement.md)

## 🎯 Key Business Questions
1. What % of eligible users adopted the feature?
2. Does adoption improve Day-30 retention?
3. Is the effect statistically significant?
4. Which user segments adopt fastest?

## 🗂️ Repository Structure
```
saas-product-analytics/
├── data/
│   ├── raw/          # Original, messy exported data
│   └── cleaned/       # Cleaned datasets ready for analysis
├── sql/               # SQL scripts: cleaning, funnel, cohort, adoption analysis
├── python/            # Dataset generation + statistical testing (A/B significance)
├── excel/              # Executive workbook with pivot-based funnel view
├── powerbi/            # Power BI dashboard (.pbix)
├── docs/
│   ├── problem_statement.md
│   ├── data_dictionary.md
│   └── erd.png
├── screenshots/        # Dashboard & query screenshots
└── executive_summary.pdf
```

## 🧱 Data Model
5 tables: `users`, `sessions`, `feature_events`, `subscriptions`, `ab_test_assignment`.
Full schema and known data quality issues: [`docs/data_dictionary.md`](docs/data_dictionary.md)

This dataset was deliberately generated with realistic data quality issues
(inconsistent date formats, nulls, duplicates, orphan records) to mirror a real
production export — not a clean Kaggle CSV.

## 🔧 Methodology
1. **Data Cleaning (SQL/Python):** standardized date formats, deduplicated
   sessions, handled nulls, resolved orphan records
2. **SQL Analysis:** activation funnel, feature adoption rate by segment, D30
   cohort retention
3. **Statistical Testing (Python):** two-proportion z-test / chi-square test to
   determine if the treatment vs control retention difference is significant
4. **Power BI Dashboard:** interactive, stakeholder-facing view of adoption,
   retention, and segment performance
5. **Excel Workbook:** finance/ops-friendly pivot summary

## 📊 Key Findings
*(To be filled in after analysis is complete)*

## 💡 Business Recommendation
*(To be filled in after analysis is complete)*

## 🔭 Future Scope
*(To be filled in after analysis is complete)*

---
## Author
Built as part of a structured Data Analyst portfolio project.
