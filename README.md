E-Commerce Sales Analytics Project

Python | SQL | Power BI | Gamma Presentation

presentation link : "C:\Users\b aiesha\Downloads\Ecommerce-Sales-Performance-Analysis.pptx"

📌 Project Overview

This project is an end-to-end data analytics solution built on an e-commerce transactional dataset.
The objective is to convert raw sales data into meaningful business insights using industry-standard analytics tools.

The project demonstrates the complete analytics lifecycle:
Data Cleaning → Analysis → Visualization → Business Recommendations

🎯 Business Objectives

Analyze overall sales and revenue performance

Identify top categories, products, and cities

Understand customer purchasing behavior

Evaluate discount impact on revenue

Build an interactive dashboard for stakeholders

📊 Dataset Summary

Total Records: 50,000

Total Features: 24

Data Format: CSV

Time Period Covered: 2023

Granularity: Order-level transactions

🧾 Dataset Structure
Order & Time Details

order_id

order_date

order_year

order_month

order_quarter

month_name

Customer & Product Information

customer_id

product_id

category

city

Pricing & Sales Metrics

price

discount_%

discounted_price

quantity

revenue

Customer Behavior

rating

payment_mode

subscription_status

🧹 Data Cleaning & Preprocessing (Python)
Tools Used

pandas

numpy

matplotlib

Key Cleaning Steps

Converted date column to datetime format

Created derived time features (year, month, quarter)

Calculated discounted price and revenue

Standardized categorical values

Validated numeric columns

Checked and handled missing values

The cleaned dataset was saved and reused for SQL and Power BI analysis.

📊 Exploratory Data Analysis (EDA)

EDA was performed to:

Analyze sales distribution across categories

Identify high-revenue cities

Study impact of discounts on sales

Understand rating vs revenue trends

Observe seasonal sales patterns

Key insights from EDA guided dashboard KPIs and SQL queries.

🗄️ SQL Analysis (MySQL)
Database Used

MySQL

SQL Concepts Applied

SELECT, WHERE, ORDER BY

GROUP BY, HAVING

Aggregate functions (SUM, AVG, COUNT)

Business-driven queries

Business Questions Addressed

Which categories generate the highest revenue?

What are the top-selling cities?

How do discounts affect revenue?

Which payment modes are most used?

Which products receive the highest ratings?

(All SQL queries are available in the sql folder.)

📈 Power BI Dashboard
Dashboard Highlights

KPI cards for Revenue, Quantity Sold, Avg Rating

Category-wise and City-wise revenue analysis

Funnel & Ribbon charts for performance comparison

Monthly and quarterly sales trends

Interactive slicers for dynamic filtering

📸 Dashboard Image: Included in the repository

📌 Key Insights

Electronics and Fashion contribute the highest revenue

Cities like Delhi and Mumbai dominate total sales

Moderate discounts lead to higher sales volume

Subscription customers show higher purchase value

Higher ratings generally align with higher revenue

💡 Business Recommendations

Optimize discount strategies to balance volume and revenue

Increase inventory for high-demand categories

Focus marketing efforts on top-performing cities

Encourage subscriptions to improve customer lifetime value

Use ratings and reviews to boost product visibility

📑 Presentation & Reporting

Gamma Presentation: Executive-level storytelling

Video Walkthrough: Dashboard explanation via screen recording

The presentation summarizes:

Problem statement

Analytical approach

Insights

Business recommendations

📂 Repository Structure
📁 ecommerce-sales-analytics
│
├── 📁 dataset
│   ├── raw_dataset.csv
│   ├── cleaned_dataset.csv
│
├── 📁 python
│   └── data_cleaning_eda.ipynb
│
├── 📁 sql
│   └── ecommerce_analysis.sql
│
├── 📁 powerbi
│   └── ecommerce_dashboard.pbix
│
├── 📁 presentation
│   └── gamma_presentation.pdf
│
├── 📁 images
│   └── dashboard.png
│
└── README.md

🛠️ Tools & Technologies

Python (pandas, numpy, matplotlib)

MySQL

Power BI

Gamma

GitHub

🚀 What This Project Demonstrates

Real-world data cleaning skills

Business-focused SQL querying

Dashboard design and storytelling

End-to-end analytics workflow

Job-ready portfolio project

👩‍💻 Author

B Aiesha
Aspiring Data Analyst
📌 Python | SQL | Power BI
