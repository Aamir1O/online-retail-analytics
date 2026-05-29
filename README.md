# Online Retail II — End-to-End Analytics Project

## Project Overview
End-to-end data analytics project analysing 1,067,371 transactions 
from a UK-based online retailer spanning December 2009 to December 2011.
The project covers data cleaning, exploratory data analysis, PostgreSQL 
database design, and business SQL analysis.

## Dataset
**Source:** UCI Machine Learning Repository  
**Link:** https://archive.ics.uci.edu/dataset/502/online+retail+ii  
**Size:** ~1 million rows, 8 columns  
**Period:** December 2009 – December 2011  
**Business type:** UK-based wholesale gift retailer  

> Note: Download the raw dataset from the link above.
> The cleaned CSV is not included in this repository due to file size.

## Business Problems Solved
1. What months drive peak revenue and why?
2. Which countries generate the most revenue and how do they differ?
3. Which products consistently drive the most revenue?
4. Who are the most valuable customers?
5. Are customers retained or mostly one-time buyers?
6. Does revenue growth come from more orders or larger orders?
7. Is the business B2B or B2C — what does the data say?
8. Does the business follow a Pareto revenue distribution?
9. How does revenue grow month over month — is growth accelerating or slowing?
10. How are customers distributed across revenue segments — High, Mid, Low, Micro?

## Tools Used
| Tool | Purpose |
|---|---|
| Python / Pandas | Data loading, cleaning, feature engineering |
| PostgreSQL | Analytics database design and storage |
| SQL | Business queries and insight extraction |
| pgAdmin | Database management and query execution |
| GitHub | Version control and portfolio documentation |

> Power BI dashboard — in progress

## Project Structure

online-retail-analytics/
├── notebooks/
│   ├── 01_data_understanding.ipynb   # Load, clean, feature engineer
│   └── 02_eda_analysis.ipynb         # EDA, charts, business insights
├── sql/
│   ├── 01_setup.sql                  # Table creation and validation
│   └── 02_business_queries.sql       # 10 business SQL queries
├── powerbi/
│   └── screenshots/                  # Dashboard screenshots (coming soon)
└── README.md

## Key Findings

### Revenue & Seasonality
- November is the peak revenue month both years — not December
- September to November consistently drives 35–40% of annual revenue
- Wholesale buying behaviour explains the pre-Christmas peak

### Geography
- United Kingdom generates ~85% of total revenue (£17.4M of £20.5M)
- Netherlands has the highest average order value at £2,429 vs UK's £476
- EIRE, Germany, and France are the only other meaningful markets

### Products
- REGENCY CAKESTAND 3 TIER is the most consistent top revenue product
- Top 10 products are all gift and home décor items — clear niche identity
- One product (PAPER CRAFT LITTLE BIRDIE) shows £168K from a single order — wholesale outlier

### Customers
- Top 10% of customers drive 63.9% of total revenue — super-Pareto distribution
- Top 4.4% of customers (261 accounts) generate 50% of all revenue
- 72.4% of customers purchased more than once — strong retention signal
- 27.6% are one-time buyers worth targeting with re-engagement campaigns

### Business Model
- Saturday generates less than 0.05% of weekly revenue
- Thursday and Tuesday are peak ordering days
- Weekend silence confirms this is a B2B wholesale business, not B2C retail

### Order Behaviour
- Average order value is flat across 24 months (£430–£575 range)
- Revenue peaks are entirely volume-driven, not basket-size driven
- No evidence of successful upsell or cross-sell strategy over the period

## SQL Queries (10 Business Queries)
| # | Query | Technique Used |
|---|---|---|
| 1 | Monthly Revenue Trend | GROUP BY, TO_CHAR, date aggregation |
| 2 | Revenue by Country | GROUP BY, ORDER BY, AOV calculation |
| 3 | Top 10 Products by Revenue | WHERE filter, GROUP BY, ILIKE |
| 4 | Top 10 Customers by Revenue | GROUP BY, NULL filter, AOV calculation |
| 5 | Average Order Value by Month | Date grouping, division aggregation |
| 6 | Repeat vs One-Time Customers | CTE, CASE WHEN, window function |
| 7 | Revenue by Day of Week | EXTRACT, TO_CHAR, DOW grouping |
| 8 | Monthly Revenue Growth Rate | CTE, LAG window function |
| 9 | Customer Revenue Segments | CTE, CASE WHEN tiers |
| 10 | Pareto Customer Decile Analysis | CTE, NTILE window function |


## How to Run

### Notebooks
1. Clone this repository
2. Download the dataset from the UCI link above
3. Install dependencies:
```
   pip install pandas sqlalchemy psycopg2-binary matplotlib
```

4. Run notebooks in order: `01_data_understanding.ipynb` → `02_eda_analysis.ipynb`

### SQL
1. Install PostgreSQL
2. Create a database called `retail_analytics`
3. Run `sql/01_setup.sql` to create the table
4. Load cleaned data using pandas `to_sql()`
5. Run `sql/02_business_queries.sql` for all business queries

## Author
**Aamir**  
[GitHub](https://github.com/Aamir1O)