# ✈️ AeroNexus – Airline Operations & Passenger Satisfaction Analytics

> **A Power BI-based end-to-end airline analytics project** that combines flight operations, airline performance, airport intelligence, route analysis and passenger satisfaction to identify patterns that can support better operational and customer-experience decisions.

---

## 📖 Project Overview

**AeroNexus – Airline Operations & Passenger Satisfaction Analytics** is a **Power BI-based end-to-end airline analytics project** designed to analyse airline performance, airport intelligence, route performance, flight operations and passenger satisfaction.

The project brings together operational and passenger-related information to understand **delays, cancellations, diversions, airline performance, airport and route patterns, passenger characteristics, service ratings and overall passenger satisfaction**.

The analysis also considers passenger experience factors such as **flight experience, cleanliness, staff service and other service ratings**, along with passenger details such as **age, gender, passenger type, travel class, travel type and ticket price**.

The project follows an end-to-end analytical workflow using **Excel / Power Query, MySQL, Python and Power BI**. Data is first prepared and cleaned using Excel and Power Query, then structured and validated using MySQL, followed by exploratory and statistical analysis using Python. The validated data will then be modelled and analysed in Power BI to create the final interactive dashboard.

---

## ❗ Business Problem / Problem Statement

Airlines need a comprehensive view of their performance across **airlines, airports, routes and flight operations**, while also understanding how operational performance and passenger characteristics influence the overall travel experience.

The airline wants to analyse **airline performance, airport intelligence, route performance, flight delays, cancellations and diversions**, along with passenger experience factors such as **flight experience, cleanliness, staff service and other service ratings**.

At the passenger level, factors such as **age, gender, passenger type, travel class, travel type and ticket price** also need to be analysed to understand differences in passenger satisfaction.

The key business problem is to bring these operational, passenger and service-related factors together and understand **how these factors affect or relate to overall passenger satisfaction**.

The analysis aims to help identify operational problem areas, understand passenger experience patterns and provide data-driven insights that can support improvements in airline performance and customer satisfaction.

---

## 🎯 Project Objectives

- ✈️ Analyse overall flight operations and airline performance
- 🛫 Evaluate airport-level operational performance
- 🗺️ Analyse route-level performance and delay patterns
- ⏱️ Analyse flight delays and their patterns
- ❌ Analyse cancellation and diversion patterns
- 👥 Understand passenger characteristics and travel behaviour
- ⭐ Analyse passenger experience and service ratings
- 💳 Analyse ticket-price patterns across passenger groups
- 📊 Analyse passenger satisfaction across operational and passenger-related factors
- 🔎 Identify factors and areas that can help the airline make decisions to improve satisfaction
- 💡 Provide data-driven insights that can support better operational and customer-experience decisions

---

## 🧰 Tools & Technologies

| Tool / Technology | Purpose |
|---|---|
| 📗 **Microsoft Excel** | Initial data inspection and preparation |
| 🔄 **Power Query** | Data cleaning and transformation |
| 🗄️ **MySQL** | Database creation, relational modelling, SQL analysis and validation |
| 🐍 **Python** | EDA, descriptive analysis, outlier detection and statistical validation |
| 📊 **Power BI** | Data modelling, DAX calculations and interactive business intelligence |
| 🧮 **DAX** | Business calculations and analytical measures |
| 🔗 **GitHub** | Version control and project documentation |

---

## 📂 Dataset Overview

AeroNexus uses **synthetic datasets created specifically for this project**. The datasets were structured and prepared using publicly available airline and passenger-satisfaction data as reference sources.

### ✈️ Flight Operations Dataset

**20,080 rows × 41 columns**

**Reference Source:** U.S. Bureau of Transportation Statistics (BTS) — Airline On-Time Performance data.

🔗 [BTS TranStats – Airline On-Time Performance Data](https://www.transtats.bts.gov/DL_SelectFields.aspx?QO_fu146_anzr=%5d&gnoyr_VQ=FGJ)

### 👥 Passenger Satisfaction Dataset

**11,640 rows × 21 columns**

**Reference Source:** Kaggle – Airline Passenger Satisfaction dataset.

🔗 [Kaggle – Airline Passenger Satisfaction](https://www.kaggle.com/datasets/teejmahal20/airline-passenger-satisfaction)

---

## 🔄 Project Workflow

```text
📂 Dataset Collection & Synthetic Dataset Preparation
                    ↓
🔎 Dataset Structure & Column Analysis
                    ↓
🧹 Excel / Power Query Cleaning & Transformation
                    ↓
🗄️ MySQL Database Creation & Data Loading
                    ↓
🔍 SQL Data Quality Checks & Basic Analysis
                    ↓
🔗 PK / FK Relationships & Join Validation
                    ↓
🐍 Python Virtual Environment & MySQL Connectivity
                    ↓
📊 Exploratory & Descriptive Analysis
                    ↓
🚨 Outlier Detection & Data Validation
                    ↓
🧪 Statistical Analysis & Validation
                    ↓
📤 Analysis Results Export
                    ↓
📊 Power BI Data Modelling
                    ↓
🧮 DAX Measures & Calculations
                    ↓
📈 Interactive Dashboard Development
                    ↓
📝 Final Documentation
