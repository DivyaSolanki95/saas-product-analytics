# Problem Statement — Smart Task Automation Feature Analysis

## Company Context
PulseCRM is a B2B SaaS CRM platform. Three months ago, the Product team launched
**Smart Task Automation**, a feature that auto-generates follow-up tasks for sales
reps. It was rolled out to 50% of new signups as a controlled A/B test (treatment
vs control) to measure impact before a full rollout decision.

## Business Problem
The VP of Product needs a data-backed go/no-go recommendation on whether to invest
further engineering resources into Smart Task Automation, or deprioritize it.
Right now, the team only has anecdotal feedback from a handful of customer calls —
no rigorous analysis has been done.

## Stakeholders
| Stakeholder | What they need |
|---|---|
| VP of Product | Go/no-go recommendation backed by statistically sound evidence |
| Growth/Marketing Lead | Which user segments (channel, company size, plan) adopt fastest, to target onboarding campaigns |
| Engineering Lead | Whether the retention/activation lift justifies further investment |

## Key Business Questions
1. What % of eligible (treatment group) users actually adopted the feature?
2. How long does it take users to try the feature after signup?
3. Does using the feature improve Day-30 retention compared to non-users?
4. Is the difference between treatment and control statistically significant, or could it be random noise?
5. Which acquisition channels / company sizes / plans show the highest adoption?

## KPIs
- **Activation Rate** — % of new users completing a core action (task_created) within 7 days of signup
- **Feature Adoption Rate** — % of treatment-group users who triggered `smart_task_used` at least once
- **Time-to-First-Use** — median days between signup and first `smart_task_used` event
- **D30 Retention Lift** — retention rate of feature adopters vs non-adopters
- **Statistical Significance** — p-value of retention difference between treatment and control groups

## Deliverable
A recommendation memo (Executive Summary) answering: **Should PulseCRM invest
further in Smart Task Automation, and which segments should Growth prioritize
in onboarding?** — backed by SQL analysis, statistical testing, and a Power BI
dashboard stakeholders can self-serve from.

## Findings Log (updated as analysis progresses)
- **Adoption Rate:** 55.6% of users in the treatment group (550 of 990) used
  Smart Task Automation at least once.
- **Time-to-First-Use (median):** Among users who adopted the feature, the
  typical (median) time between signup and first use was ~10 days. This
  suggests users are not discovering the feature organically right away —
  an onboarding nudge (in-app tip or email) in the first week could
  accelerate adoption.
- **Retention Lift (headline finding):** Comparing treatment vs control groups
  (not adopters vs non-adopters, to avoid selection bias), users with access
  to Smart Task Automation had 78.8% retention vs 72.7% for control — a 6.1
  percentage point lift. This was confirmed statistically significant via a
  chi-square test (p = 0.00143, well below the 0.05 threshold), meaning the
  effect is very unlikely to be due to random chance.
  **Recommendation: invest further in this feature.**
