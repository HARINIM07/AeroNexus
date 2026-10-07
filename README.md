<img width="960" height="540" alt="image" src="https://github.com/user-attachments/assets/664108fd-6e42-49d9-810f-d3b82435a50f" />

# ✈️ AeroNexus – Airline Operations & Passenger Satisfaction Analytics

> **A Power BI-based end-to-end airline analytics project** that combines flight operations, airline performance, airport intelligence, route analysis and passenger satisfaction to identify patterns that can support better operational and customer-experience decisions.

<div align="center">

[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?logo=powerbi&logoColor=white)](https://www.microsoft.com/power-platform/products/power-bi)
[![Data%20Modelling](https://img.shields.io/badge/Data%20Modelling-7B61FF?logoColor=white)](https://learn.microsoft.com/power-bi/transform-model/desktop-relationships-understand)
[![DAX](https://img.shields.io/badge/DAX-D94F4F?logo=powerbi&logoColor=white)](https://learn.microsoft.com/dax/)
[![Excel](https://img.shields.io/badge/Excel-217346?logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/microsoft-365/excel)
[![Power Query](https://img.shields.io/badge/Power%20Query-0078D4?logo=microsoftpowerbi&logoColor=white)](https://learn.microsoft.com/power-query/)
[![MySQL](https://img.shields.io/badge/MySQL-00897B?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Python](https://img.shields.io/badge/Python-E67E22?logo=python&logoColor=white)](https://www.python.org/)
[![GitHub](https://img.shields.io/badge/GitHub-24292F?logo=github&logoColor=white)](https://github.com/)

</div>

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

**20,080 rows × 58 columns**

**Reference Source:** U.S. Bureau of Transportation Statistics (BTS) — Airline On-Time Performance data.

🔗 [BTS – Search for On-Time Flight Data](https://www.transtats.bts.gov/ONTIME/)

### 👥 Passenger Satisfaction Dataset

**11,640 rows × 25 columns**

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
```

---

## 🔬 Methodology

### 🧹 Data Preparation

Data was inspected, cleaned and transformed using **Excel and Power Query** to improve consistency, usability and analytical quality.

### 🗄️ Relational Data Management

The cleaned data was loaded into **MySQL**, where tables, relationships, keys and normalisation were implemented to organise the data efficiently and reduce redundancy.

### 🔍 Data Validation

Data quality checks were performed across Excel, SQL and Python to identify duplicates, NULL values, inconsistent values, invalid ranges and business-rule issues.

### 📊 Exploratory & Descriptive Analysis

Python was used to explore the datasets and understand distributions, operational patterns, passenger satisfaction and important numerical characteristics.

### 🚨 Outlier Detection

Potential outliers were analysed using both **IQR and Z-score methods** to identify unusual operational and passenger-related values.

### 🧪 Statistical Validation

Two main statistical approaches were conducted:

- 📈 **Spearman Correlation Analysis** – used to measure the strength and direction of monotonic relationships between selected numerical variables.
- 🧪 **Chi-square Test of Independence** – used to determine whether selected categorical factors are statistically associated with passenger satisfaction.

**Cramér's V** was additionally used to measure the strength of categorical associations identified through the Chi-square analysis.

### 📊 Power BI Analysis

The validated data will be modelled in **Power BI**, where DAX measures and interactive visualisations will be developed to support business analysis and decision-making.

---

## 🧹 Data Preparation & Cleaning

- 🔎 Inspect dataset structure, column names and data types
- ✂️ Remove unwanted spaces using **Trim**
- 🔄 Reorder columns
- 🔢 Round off decimal columns where required
- ✏️ Rename columns for consistency and readability
- 🗑️ Remove unwanted columns
- ♻️ Remove duplicate records
- 🔍 Review and correct inconsistent values and formatting
- ✅ Validate numerical fields against expected ranges
- 🎯 Check whether the actual satisfaction value matches the expected satisfaction
- 🧩 Replace NULL values where required
- ⏱️ Create a new custom column using logic to convert values into the required time format

---

## 🗄️ SQL Data Analysis & Validation

- 🏗️ Database schema design and table creation
- 🔢 Data type optimisation
- 🧩 Data normalisation and dimensional table design
- 🔑 Primary Key and Foreign Key implementation
- 🔗 Table relationships and referential integrity validation
- ♻️ Duplicate and uniqueness checks
- 🚫 NULL, data consistency and quality validation
- ✅ Business-rule validation using SQL queries
- 🔀 SQL joins to verify table relationships
- ✈️ Flight operations analysis
- ⏱️ Delay, cancellation and diversion analysis
- 👥 Passenger satisfaction and service-quality analysis
- 📊 Aggregations and percentage-based analysis
- 📈 Preparing integrated and validated data for Power BI data modelling

---

## 🐍 Python Data Analysis & Statistical Validation

- 🔌 MySQL database connectivity and data extraction
- 🔎 Exploratory Data Analysis (EDA)
- ✈️ Flight operations summary and descriptive analysis
- ❌ Cancellation and diversion rate analysis
- 👥 Passenger satisfaction distribution and percentage analysis
- 🚨 Outlier detection using IQR and Z-score methods
- 🔍 Operational anomaly and data-quality checks
- ✅ Business-rule validation for flight operations
- 📏 Rating and ticket-price range validation
- 🛠️ Feature engineering for route, age group and delay categories
- 📈 Spearman correlation analysis
- 🧪 Chi-square tests for categorical factors
- 📊 Cramér's V for association strength
- ⏱️ Passenger satisfaction analysis by arrival-delay groups
- 📤 Automated export of analysis results to CSV files

---

## 💡 Key Insights & Project Outcomes

The analysis provides a structured understanding of:

- ✈️ Flight operational performance
- 🏢 Airline-level performance patterns
- 🛫 Airport-level operational behaviour
- 🗺️ Route-level performance
- ⏱️ Delay patterns and operational disruptions
- ❌ Cancellation and diversion behaviour
- 👥 Passenger characteristics and travel patterns
- ⭐ Passenger service and experience ratings
- 💳 Ticket-price patterns
- 😊 Passenger satisfaction distribution
- 🔎 Relationships between operational factors, passenger characteristics and satisfaction

The statistical analysis also helps distinguish between **observable patterns and statistically supported associations**, providing additional validation for the analytical findings.

The project identifies **factors and areas that can help the airline make decisions to improve satisfaction** by highlighting operational problem areas, passenger experience patterns and areas that may require further attention.

---

## 🚀 How to Run / Use the Project

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/HARINIM07/AeroNexus.git
```

### 2️⃣ Explore the Datasets

The project datasets are available under:

```text
Dataset/
├── raw_data/
└── cleaned_data/
```

### 3️⃣ Run the SQL Analysis

Open the SQL scripts available under:

```text
MySQL/
```

The scripts cover passenger satisfaction analysis, flight operations analysis and the project data model.

### 4️⃣ Set Up the Python Environment

Navigate to the Python directory:

```bash
cd Python
```

Create a virtual environment:

```bash
python -m venv venv
```

Activate the environment on Windows:

```bash
venv\Scripts\activate
```

Install the required Python packages according to the project requirements.

### 5️⃣ Run the Python Analysis

Python scripts are available under:

```text
Python/scripts/
```

The generated analysis results are organised under:

```text
Python/outputs/
```

### 6️⃣ Power BI

The validated data will be used in **Power BI** for data modelling, DAX calculations and interactive dashboard development.

---

## 🗂️ Repository Structure

```text
AeroNexus/
│
├── 📂 Dataset/
│   ├── 📁 raw_data/
│   │   ├── Flight_Operations_Raw.xlsx
│   │   └── Passenger_Satisfaction_Raw.xlsx
│   │
│   └── 📁 cleaned_data/
│       ├── Flight_Operations_Cleaned.csv
│       └── Passenger_Satisfaction_Cleaned.csv
│
├── 🗄️ MySQL/
│   ├── 01_passenger_satisfaction_analysis.sql
│   ├── 02_flight_operations_analysis.sql
│   └── 03_five_table_data_model.sql
│
├── 🐍 Python/
│   ├── README.md
│   │
│   ├── 📁 scripts/
│   │   ├── README.md
│   │   ├── aeronexus_eda.py
│   │   ├── aeronexus_outlier_analysis.py
│   │   └── aeronexus_statistical_analysis.py
│   │
│   └── 📁 outputs/
│       ├── README.md
│       ├── 📁 eda/
│       ├── 📁 outlier_analysis/
│       ├── 📁 data_quality/
│       └── 📁 statistical_analysis/
│
├── .gitignore
└── README.md
```

---

## 🧠 Skills Developed & Key Learnings

### 📊 Data Analytics

- Exploratory Data Analysis
- Descriptive Statistics
- Outlier Detection
- Statistical Validation
- Data Quality Analysis
- Business-focused Data Analysis

### 📗 Excel & Power Query

- Data inspection and profiling
- Data cleaning
- Data transformation
- Data validation
- Custom column creation

### 🗄️ SQL & Database Management

- Relational database design
- Table creation
- Data normalisation
- Primary and Foreign Keys
- Joins
- Aggregations
- Data quality validation
- Business-rule validation

### 🐍 Python

- MySQL connectivity
- Pandas-based analysis
- Exploratory Data Analysis
- Statistical analysis
- IQR and Z-score outlier detection
- Feature engineering
- Automated CSV output generation

### 📊 Power BI

- Data modelling
- DAX
- Business intelligence
- Interactive data visualisation
- Dashboard development

### 💼 Business & Analytical Thinking

- Translating business problems into analytical questions
- Identifying operational problem areas
- Analysing passenger experience patterns
- Interpreting relationships between business factors
- Converting analytical results into decision-support insights

---

## 🔮 Future Improvements

- 📊 Complete and enhance the interactive Power BI dashboard
- 🧮 Add advanced DAX measures and calculations
- 🤖 Integrate machine learning for passenger satisfaction prediction
- 📈 Add predictive analytics for operational performance
- 🚨 Develop advanced risk and anomaly detection
- 🗺️ Expand route and airport network analysis
- 🔄 Introduce automated data refresh pipelines
- ☁️ Explore cloud-based deployment and reporting

---

## ✅ Conclusion

AeroNexus is an end-to-end airline analytics project that brings together **flight operations, airline performance, airport intelligence, route performance and passenger experience** to provide a broader understanding of airline performance and customer satisfaction.

The project uses **Excel / Power Query, MySQL, Python and Power BI** as different stages of a single analytical workflow. Data is first prepared and cleaned, then structured and validated through a relational database, followed by exploratory analysis, outlier detection and statistical validation. The validated data is then used for Power BI-based business intelligence and interactive analysis.

By combining operational factors such as **delays, cancellations, diversions, airlines, airports and routes** with passenger-related factors such as **age, gender, passenger type, travel class, travel type, ticket price and service ratings**, AeroNexus helps identify patterns associated with passenger satisfaction.

The project is intended to help an airline move beyond simply measuring operational performance and instead understand **how operational disruptions and passenger experience factors are connected to customer satisfaction**.

It **identifies factors and areas that can help the airline make decisions to improve satisfaction** by highlighting operational problem areas, passenger experience patterns and areas where further attention may be required.

Ultimately, AeroNexus provides a **data-driven foundation for airline decision-making**, helping organisations better understand their operations and passenger experience and make more informed decisions aimed at improving service quality, reducing operational issues and supporting higher passenger satisfaction.

---

## 👩‍💻 Author & Contact

**Harini M**

📍 Chennai, India

📧 **Email:** mharini0701@gmail.com

🔗 **GitHub:** [HARINIM07](https://github.com/HARINIM07)

🔗 **LinkedIn:** [linkedin.com/in/harinim07](https://linkedin.com/in/harinim07)
