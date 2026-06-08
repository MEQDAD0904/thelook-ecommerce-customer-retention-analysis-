# TheLook E-Commerce: Customer Retention Analysis
### Why Do 78% of Customers Never Return?

---

## Executive Summary

This project investigates why the majority of TheLook's customers 
make only one purchase and never return. Starting from a broad 
revenue health check, the analysis naturally narrowed to a single 
critical finding: the platform has a severe retention problem, 
not an acquisition problem. Through systematic hypothesis testing 
across four dimensions — demographics, product category, first 
order value, and delivery time — no variable was found to explain 
the return decision. This leads to a clear and honest conclusion: 
the driver of retention lies in post-purchase experience data 
that does not currently exist in the dataset.

---

## Business Context

The starting question was not about retention at all. 
The goal was to understand what drives revenue on TheLook 
using the fundamental e-commerce equation:

**Revenue = Visitors × Conversion Rate × Average Order Value**

The analysis began by examining Q4's consistent revenue premium 
over other quarters, testing whether it reflected true seasonality 
or natural platform growth. After controlling for year-over-year 
momentum, net seasonality proved small and inconsistent (2–4.5%). 
The real signal came from decomposing the revenue equation itself: 
Q4's ~59% revenue premium over Q1 was driven almost entirely by 
order volume, not by higher prices, larger baskets, or better 
conversion rates.

This led to the next question: if volume drives revenue, 
what drives volume? The answer pointed directly to acquisition — 
the platform was consistently bringing in new customers. 
But this uncovered a deeper structural problem.

---

## The Discovery: A Leaky Bucket

Repeat purchase rate: **22%**  
Median days to second purchase: **204 days**  
Industry benchmark for repeat purchase: **60–90 days**

The platform is effective at acquisition but loses 78% of its 
customers after the first order. At scale, this creates a 
"leaky bucket" dynamic: strong inflow of new customers, 
chronic outflow with no retention mechanism to offset it. 
Retaining even a fraction of these customers would generate 
revenue at zero acquisition cost — making this the highest-ROI 
problem in the business.

---

## Hypothesis Testing: The Search for an Explanation

To understand *why* customers don't return, four hypotheses 
were tested systematically. Each was falsifiable, grounded 
in business logic, and rejected only after the data 
provided clear evidence.

### Hypothesis 1: Demographics Drive Return Behavior
**Logic:** Women aged 25–35 in fashion e-commerce face recurring 
social and professional pressure to refresh their wardrobe, 
making them structurally more likely to return than other segments.  
**Result:** All segments clustered within 3 percentage points 
of the 22% average. Hypothesis rejected.

### Hypothesis 2: First Product Category Predicts Return
**Logic:** Certain product categories create higher engagement 
or satisfaction, acting as "entry products" that build loyalty.  
**Result:** No category showed a meaningful deviation from 
the platform average. Hypothesis rejected.

### Hypothesis 3: First Order Value Signals Customer Intent
**Logic:** Higher spending in the first order reflects stronger 
purchase intent and predicts higher likelihood of return.  
**Result:** All four spending quartiles produced identical 
return rates around 22%. Hypothesis rejected.

### Hypothesis 4: Delivery Time Affects Return Decision
**Logic:** A poor first delivery experience damages trust 
and suppresses the likelihood of a second purchase.  
**Result:** Maximum delivery time across all completed orders 
was 7 days, with a mean of ~3 days. No variance existed 
to explain the return gap. Hypothesis rejected.

---

## What the Data Cannot Tell Us

This is perhaps the most important section of this analysis. 
The systematic rejection of four plausible hypotheses is not 
a failure — it is a finding. It tells us precisely where 
the explanation does *not* live, and therefore where 
the business must look next.

The TheLook dataset covers two phases of the customer journey: 
pre-purchase behavior (browsing, funnel events) and the 
transaction itself (orders, delivery). What it does not contain 
is any record of the post-purchase journey — the phase between 
delivery and the decision to return or disappear.

To answer the retention question fully, the business would need:
- Customer reviews and satisfaction scores
- Email open and click rates after first purchase  
- Post-delivery browsing behavior
- Returns and complaint records

---

## Recommendations

**Short term:** Begin collecting post-purchase behavioral data 
immediately. Even a simple post-delivery survey would provide 
more explanatory power than the entire current dataset 
for the retention question.

**Medium term:** Investigate the post-purchase communication 
strategy. Since no demographic or product variable explains 
the return decision, the most likely lever is what happens 
between delivery and the next purchase opportunity — 
emails, recommendations, re-engagement triggers.

**Long term:** Build a retention KPI dashboard that tracks 
repeat purchase rate and time-to-second-purchase monthly, 
making retention a first-class metric alongside revenue.

---

## Technical Details

**Dataset:** TheLook E-Commerce (PostgreSQL)  
**Tools:** PostgreSQL · Python (Pandas, Matplotlib) · Power BI  
**Tables used:** orders · order_items · users · events · 
inventory_items · distribution_centers  

To reproduce: clone the repo, connect to a TheLook PostgreSQL 
instance, run SQL scripts in /queries in order, 
then execute /notebooks/analysis.ipynb.

---

## Project Structure

├── queries/
│   ├── 01_revenue_decomposition.sql
│   ├── 02_seasonality_analysis.sql
│   ├── 03_retention_baseline.sql
│   └── 04_master_table.sql
├── notebooks/
│   └── analysis.ipynb
├── dashboard/
│   └── thelook_retention.pbix
└── README.md
