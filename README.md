# E-Commerce Data Warehouse & Power BI Analytics Project

## Project Overview

This project demonstrates the end-to-end development of a modern data warehousing and business intelligence solution using the Brazilian Olist E-Commerce dataset.

The solution follows a multi-layered architecture (Bronze → Silver → Gold) to transform raw transactional data into business-ready analytical models. The final Gold layer is connected to Power BI to create interactive dashboards and KPI-driven visualizations for business decision-making.

---

## Tech Stack

* MySQL
* SQL
* Power BI
* DAX (Data Analysis Expressions)
* Star Schema Data Modeling
* Kaggle Olist E-Commerce Dataset

---

## Data Warehouse Architecture

### Bronze Layer (Raw Data)

Raw source tables loaded without transformations.

Tables:

* Orders
* Order Items
* Products
* Customers
* Sellers
* Payments
* Reviews

---

### Silver Layer (Cleaned Data)

Data cleansing and standardization performed:

* Data type conversions
* Null value handling
* Duplicate removal
* Date formatting
* Data validation checks
* Foreign key integrity checks
* Standardized column naming

---

### Gold Layer (Business-Ready Data Model)

Created dimensional and fact tables optimized for reporting and analytics.

#### Fact Table

* `gold_fact_sales`

#### Dimension Tables

* `gold_dim_customers`
* `gold_dim_products`
* `gold_dim_sellers`
* `gold_dim_date`

The Gold layer follows a Star Schema design for efficient Power BI reporting.

---

## Power BI Dashboard

### Executive Dashboard

Key Performance Indicators (KPIs):

* Total Revenue
* Total Orders
* Average Order Value
* Average Delivery Days
* Delayed Deliveries

---

### Sales Trend Dashboard

Visualizations include:

* Revenue Trend by Month and Year
* Order Trend by Month
* Sales Performance Analysis

---

### Delivery analysis dashboard

visualization include:

* Average Delivery days
* Order count by delivery status

  ---
  
## DAX Measures Created

### Total Revenue

```DAX
Total Revenue =
SUM('ecommerce_gold_fact_sales'[price])
```

### Total Orders

```DAX
Total Orders =
DISTINCTCOUNT('ecommerce_gold_fact_sales'[order_id])
```

### Average Order Value

```DAX
Average Order Value =
DIVIDE([Total Revenue],[Total Orders])
```

### Average Delivery Days

```DAX
Average Delivery Days =
AVERAGE('ecommerce_gold_fact_sales'[delivery_days])
```

### Delayed Deliveries

```DAX
Delayed Deliveries =
CALCULATE(
    COUNTROWS('ecommerce_gold_fact_sales'),
    'ecommerce_gold_fact_sales'[delivery_status] = "Delayed"
)
```

---

## Business Questions Answered

### Sales Performance

* What is the total revenue generated?
* How many orders were placed?
* What is the average order value?

### Product Analysis

* Which products generate the most sales?
* Which categories perform best?

### Delivery Performance

* Average delivery duration
* Number of delayed deliveries
* Delivery efficiency trends

---

## Data Quality Checks

The project includes validation checks for:

* Duplicate records
* Missing values
* Invalid dates
* Referential integrity
* Data consistency across tables

---

## Project Outcome

Successfully designed and implemented:

* Multi-layered data warehouse architecture
* Star schema dimensional model
* SQL-based ETL transformations
* Business-ready Gold layer
* Power BI executive dashboard
* KPI and trend analysis reporting

The solution transforms raw e-commerce data into actionable business insights that support data-driven decision-making.

---

## Future Enhancements

* Customer segmentation analysis
* Product profitability analysis
* Regional sales performance dashboard
* Advanced forecasting using Power BI
* Interactive drill-through reporting

---

## Author

**Apshara Parvin**

