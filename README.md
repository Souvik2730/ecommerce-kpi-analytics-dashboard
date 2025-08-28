# 📊 E-Commerce KPI Analytics Dashboard

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Souvik2730/ecommerce-kpi-analytics-dashboard/blob/main/E_commerce_KPI.ipynb)

---

## 📌 Project Overview

This project is a complete end-to-end **E-Commerce KPI Analytics** solution that helps businesses track, analyze, and act on their key performance indicators using real-time data. It integrates data from multiple sources to uncover deep insights into customer behavior, product performance, marketing channels, and revenue trends — all visualized in an interactive **Power BI dashboard**.

---

## 🖼️ Screenshots – Power BI Dashboard
 ![Dashboard Screenshot](https://github.com/Souvik2730/ecommerce-kpi-analytics-dashboard/blob/main/Screenshot%202025-08-28%20122344.png)

## 🚀 Key Features

- 📦 **Product Performance Analysis** (Category & SKU level)
- 🧑‍💼 **Customer Insights** (Repeat rate, new vs returning)
- 📈 **Revenue, Orders, AOV Trends**
- 💹 **Channel-wise Revenue Contribution**
- 🛍️ **Conversion Funnel** (Views → Cart → Purchase)
- 📊 **Gross Margin & Net Sales KPIs**
- 🔁 **Repeat Purchase Tracking**
- 📅 **Monthly Growth Trends**
- 📉 **Discounts, Shipping Fee, Tax Breakdown**
- 🧠 **Cohort Analysis** *(SQL View created)*
- 🎯 **RFM Segmentation** *(SQL View created)*

---

## 🧠 Problem Statement

E-commerce businesses generate huge volumes of data, but without proper structuring and visualization, it becomes nearly impossible to:
- Track key business metrics efficiently.
- Identify which products, customers, or channels are driving revenue.
- Understand customer retention patterns and behavior.
- Make strategic decisions based on real insights.

---

## 🌟 Solution Using STAR Method

### ✅ **S – Situation**
The business lacked a consolidated system to track its KPIs. The available data was scattered across CSVs and required cleaning, modeling, and insightful visualization. There was no clarity on repeat customers, top-selling categories, or marketing performance.

---

### ✅ **T – Task**
Build an end-to-end data analytics pipeline and an interactive dashboard that:
- Cleans and formats raw datasets.
- Stores the data using a normalized SQL schema.
- Extracts advanced insights (e.g., RFM, Cohorts, Funnel).
- Visualizes key metrics in a Power BI report.

---

### ✅ **A – Action**
1. 🧹 **Data Cleaning with Python (Pandas):**
   - Rounded off financial metrics (unit price, cost, tax, discount, etc.).
   - Saved cleaned data back to CSV files.
   - [View Python Data Cleaning Code](https://colab.research.google.com/github.com/Souvik2730/ecommerce-kpi-analytics-dashboard/blob/main/E_commerce_KPI.ipynb)

2. 🗃️ **SQL Database & Modeling:**
   - Created tables: `orders`, `order_items`, `products`, `customers`, `web_events`.
   - Built views: `v_monthly_sales`, `v_cohort_retention`, `v_customer_rfm`, `v_monthly_funnel`.

3. 📊 **Power BI Dashboard:**
   - Built interactive visuals for revenue, orders, gross margin, customer funnel, etc.
   - Integrated filters (category, channel, date).
   - Used SQL views to back advanced visuals.

---

### ✅ **R – Result**
The final solution delivered:

- 🔍 **Real-time business insights** across orders, channels, and customers.
- 🧠 **Deep customer intelligence** using cohort retention and RFM segmentation.
- 📈 **Data-driven decision making** for marketing, product, and finance teams.
- 💰 **Revenue optimization** through performance tracking and behavioral analysis.

---

## 🧰 Tools & Technologies Used

| Tool/Language | Purpose                          |
|---------------|----------------------------------|
| **Python (Pandas)** | Data cleaning and preprocessing |
| **MySQL / PostgreSQL** | Data modeling and SQL views       |
| **Power BI**   | Interactive dashboard creation   |
| **Google Colab** | Python execution environment    |
| **VS Code**   | Development environment           |

---

## 🙋‍♂️ Author
**Souvik Ghorui**  
📧 Email: ghoruisouvik7@gmail.com  
🔗 LinkedIn: (https://www.linkedin.com/in/souvik-ghorui273/)  
💻 GitHub: (https://github.com/Souvik2730)  

---

## ⭐ How to Support
If you found this project helpful, please **star this repository** on GitHub.  
Your support motivates me to create more projects!




