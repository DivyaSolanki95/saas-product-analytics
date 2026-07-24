# Resume Bullets

Use 2-3 of these, adapted to the specific JD (swap in "A/B testing" language if the JD mentions experiments, "dashboard" if it mentions BI tools, etc.)

**Version A (general):**
> Built an end-to-end product analytics case study on a 6,000-user e-commerce dataset using SQL and Python — identified a 4x conversion gap between acquisition channels and a 50% funnel drop-off at cart stage, translating findings into channel-budget and UX recommendations.

**Version B (SQL-focused):**
> Wrote SQL queries (CTEs, conditional aggregation, cohort date logic) to analyze user funnel conversion, weekly retention cohorts, and revenue across 5 acquisition channels; presented findings in a stakeholder-ready case study report.

**Version C (dashboard-focused):**
> Designed and built an interactive analytics dashboard (HTML/JS/Chart.js) visualizing funnel, retention, and revenue metrics, enabling self-serve exploration of channel-level performance.

**Version D (short, for tight resume space):**
> Product analytics project: SQL + Python funnel/retention/revenue analysis on e-commerce data; found referral channel converts 4x better than paid social, informing budget reallocation recommendation.

---

# Interview Q&A Prep

**Q: Walk me through this project.**
> I built a synthetic-but-realistic e-commerce dataset — 6,000 users, ~19K events over 90 days — then used SQL to analyze the signup-to-purchase funnel, weekly retention cohorts, and revenue by channel. The goal was to answer: where do users drop off, which channels bring quality users, and how does retention differ by segment. I found Paid Social brings the most volume but converts worst, while Referral is small but converts 4x better and retains best — so my recommendation was to shift some budget from Paid Social to a referral program, and prioritize fixing the cart-flow drop-off over top-of-funnel growth.

**Q: Why did you generate synthetic data instead of using a public dataset?**
> I wanted full control over the pipeline — from data generation through analysis — so the SQL logic, edge-case handling, and insights were entirely my own work, not just re-running someone else's notebook. I did build in realistic patterns (channel-quality differences, device effects, retention decay) so the analysis reflects real product-analytics scenarios.

**Q: Why did you exclude the most recent cohorts from the retention analysis?**
> Because they hadn't had a full 4-week window to accumulate return visits yet — including them would've shown a misleading near-0% week-4 retention that reflects "not enough time has passed" rather than "users churned." Excluding incomplete cohorts avoids that bias. This is a common real-world cohort analysis pitfall.

**Q: How would you validate that the Paid Social conversion problem is a targeting issue and not something else?**
> I'd want to segment further — check if it's concentrated in specific ad campaigns/audiences, compare new-vs-returning behavior, and ideally run an A/B test on landing page or targeting changes rather than acting on the correlation alone. The current analysis identifies *where* to look, not a fully proven causal story.

**Q: What would you do next with more time/data?**
> Add statistical significance testing to the channel comparisons, build a proper LTV/CAC view by channel (not just short-term conversion), and instrument actual A/B tests on the cart-flow drop-off rather than just recommending it.

**Q: What SQL concepts did you use?**
> CTEs (WITH clauses) for building intermediate cohort tables, conditional aggregation with CASE WHEN inside COUNT/SUM to pivot event types into columns, JULIANDAY-based date math for computing "weeks since signup," and multi-table joins between users and events.

---

# Quick Checklist Before You Apply Today

- [ ] Push `repo/` to a public GitHub repo (see below)
- [ ] Add the GitHub link + dashboard to your resume/portfolio section
- [ ] Re-read the case study doc once so you can speak to it without notes
- [ ] Pick 2-3 resume bullets above matching the JD

## Pushing to GitHub (2 minutes)

```bash
# 1. Create a new empty repo on github.com (no README/gitignore, just create it)
# 2. In the unzipped repo folder:
git remote add origin https://github.com/<your-username>/<repo-name>.git
git branch -M main
git push -u origin main
```
