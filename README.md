# TheLook E-Commerce: Customer Retention Analysis
### Why Do 78% of Customers Never Return?

---

## Executive Summary

This project investigates why the majority of TheLook's customers make only one purchase and never return. Starting from a broad revenue health check, the analysis narrowed to a single critical finding: the platform has a severe retention problem, not an acquisition problem.

Four hypotheses were tested systematically — demographics, product category, first order value, and delivery time. None explained the return gap. This leads to an honest conclusion: the driver of retention lies in post-purchase experience data that does not currently exist in the dataset.

---

## Tools

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

---

## Business Context

The starting question was not about retention at all.  
The goal was to understand what drives revenue using the fundamental e-commerce equation:

**Revenue = Visitors × Conversion Rate × Average Order Value**

Q4 showed a consistent ~59% revenue premium over Q1 — driven almost entirely by order volume, not higher prices or larger baskets. This led to the next question: if volume drives revenue, what drives volume?

The answer pointed directly to acquisition. But this uncovered a deeper structural problem.

---

## The Discovery: A Leaky Bucket

| Metric | Value |
|---|---|
| Repeat Purchase Rate | 22% |
| Customers Who Never Return | 78% |
| Median Days to Second Purchase | 204 days |
| Industry Benchmark | 60–90 days |

The platform is effective at acquisition but loses 78% of customers after the first order — a classic "leaky bucket." Retaining even a fraction of these customers would generate revenue at near-zero acquisition cost, making this the highest-leverage problem in the business.

---

## Hypothesis Testing

Four hypotheses were tested to understand *why* customers don't return.  
Each was falsifiable and grounded in business logic.

---

### H1: Demographics Drive Return Behavior

**Logic:** Women aged 25–35 face recurring social pressure to refresh their wardrobe — making them structurally more likely to return.

**Evidence from Notebook:**

| Segment | Count | Avg Age | Female % |
|---|---|---|---|
| Early Returner | 4,192 | 40.95 | 51.7% |
| Mid Returner | 4,366 | 41.07 | 52.2% |
| Late Returner | 8,245 | 41.21 | 51.8% |
| Never Returner | 38,270 | 40.91 | 51.5% |

Age and gender are virtually identical across all segments.  
**Hypothesis rejected.**

---

### H2: First Product Category Predicts Return

**Logic:** Certain categories create higher engagement, acting as "entry products" that build loyalty.

**Evidence from Notebook:**

Category distribution (Accessories, Active, Blazers & Jackets) showed no meaningful difference across segments — all hovered around the same percentages.  
**Hypothesis rejected.**

---

### H3: First Order Value Signals Customer Intent

**Logic:** Higher spending in the first order reflects stronger purchase intent and predicts higher likelihood of return.

**Evidence from Notebook:**

| Segment | Count | Mean Value | Median Value |
|---|---|---|---|
| Early Returner | 4,192 | $88.46 | $55.00 |
| Mid Returner | 4,366 | $89.68 | $55.00 |
| Late Returner | 8,245 | $87.06 | $55.66 |
| Never Returner | 38,270 | $87.23 | $56.00 |

Median first order value is nearly identical across all segments.  
**Hypothesis rejected.**

---

### H4: Delivery Time Affects Return Decision

**Logic:** A poor first delivery experience damages trust and suppresses the likelihood of a second purchase.

**Evidence from PostgreSQL:**

| Metric | Value |
|---|---|
| Min Delivery Time | 16 minutes |
| Avg Delivery Time | 3 days 23 hours |
| Max Delivery Time | 7 days 22 hours |

The entire delivery range falls within industry-standard expectations. There is no variance significant enough to explain a 78% churn rate.  
**Hypothesis rejected.**

---

## What the Data Cannot Tell Us

The systematic rejection of four hypotheses is not a failure — it is a finding.  
It tells us precisely where the explanation does *not* live.

The TheLook dataset covers pre-purchase behavior and the transaction itself. What it does not contain is any record of the **post-purchase journey** — the phase between delivery and the decision to return or disappear.

To answer the retention question fully, the business would need:
- Customer satisfaction scores after delivery
- Email engagement rates post-purchase
- Post-delivery browsing behavior
- Returns and complaint records

---

## Recommendations

**Short term:** Begin collecting post-purchase behavioral data. Even a simple post-delivery survey would provide more explanatory power than the entire current dataset for this question.

**Medium term:** Investigate the post-purchase communication strategy. Since no demographic or product variable explains the return decision, the most likely lever is what happens between delivery and the next purchase opportunity.

**Long term:** Build a retention KPI dashboard tracking repeat purchase rate and time-to-second-purchase monthly — making retention a first-class metric alongside revenue.

---

## Dataset & Reproduction

**Dataset:** TheLook E-Commerce (PostgreSQL — Google BigQuery Public Dataset)  
**Download:** [TheLook E-Commerce Dataset on Kaggle](https://www.kaggle.com/datasets/chiraggivan82/ecommerce-bigquery)  
**Tables used:** `orders` · `order_items` · `users` · `events` · `inventory_items` · `distribution_centers`

To reproduce:
1. Connect to a TheLook PostgreSQL instance
2. Run SQL scripts in `/queries` in order
3. Execute `/notebooks/analysis.ipynb`

