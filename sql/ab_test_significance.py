"""
ab_test_significance.py
-------------------------
Tests whether the retention difference between the treatment group (had access
to Smart Task Automation) and control group (no access) is statistically
significant, or could plausibly be explained by random chance.

Method: Chi-square test of independence on a 2x2 contingency table
(test_group x subscription_status).

Data source: raw_ab_test_assignment + raw_subscriptions (counted via SQL --
see sql/02_retention_analysis.sql for the query that produced these counts)
"""

from scipy.stats import chi2_contingency
import numpy as np

# Contingency table: rows = [control, treatment], columns = [Active, Churned]
# Counts obtained from SQL query joining raw_ab_test_assignment + raw_subscriptions
table = np.array([
    [734, 276],   # control:   734 active, 276 churned (1010 total)
    [780, 210]    # treatment: 780 active, 210 churned (990 total)
])

chi2, p_value, dof, expected = chi2_contingency(table, correction=False)

control_retention = 734 / (734 + 276) * 100
treatment_retention = 780 / (780 + 210) * 100
lift = treatment_retention - control_retention

print("=== A/B Test: Smart Task Automation — Retention Impact ===")
print(f"Control retention:    {control_retention:.1f}%")
print(f"Treatment retention:  {treatment_retention:.1f}%")
print(f"Retention lift:       {lift:.1f} percentage points")
print(f"Chi-square statistic: {chi2:.3f}")
print(f"P-value:              {p_value:.5f}")
print(f"Statistically significant (p < 0.05)? {'YES' if p_value < 0.05 else 'NO'}")

if p_value < 0.05:
    print("\nConclusion: The retention lift is statistically significant.")
    print("Recommendation: Invest further in Smart Task Automation --")
    print("the retention improvement is unlikely to be due to random chance.")
else:
    print("\nConclusion: The retention difference could plausibly be random noise.")
    print("Recommendation: Collect more data before making a rollout decision.")
