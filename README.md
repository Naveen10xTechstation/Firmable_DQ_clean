📘 Business Data Quality preprocessing & Power BI Analytics Pipeline
📌 Project Overview

This project demonstrates a complete local data processing pipeline that starts with a raw .zip file and ends with a fully interactive Power BI dashboard.
The workflow includes:

Parsing and extracting raw data

Profiling, EDA, and data quality checks

Cleaning and standardizing business data

Loading into a SQLite database

Connecting to Power BI via ODBC

Building interactive dashboards and deriving insights

🏗️ End-to-End Workflow Diagram
               ┌───────────────┐
               │    ZIP File    │
               └───────┬────────┘
                       ↓
        ┌─────────────────────────────────┐
        │ parsing.py  (VS Code - Python)  │
        │  • Extracts & parses raw files  │
        └───────┬─────────────────────────┘
                ↓
         parsed_output.csv
                ↓
   ┌──────────────────────────────────────┐
   │ VS Code (Jupyter Notebook)           │
   │ Profiling + EDA + Data Quality Checks│
   └───────┬──────────────────────────────┘
           ↓
   cleaned_business_data.csv
           ↓
   ┌──────────────────────────────────┐
   │        SQLite (database.db)      │
   │  • Tables Created:               │
   │      - cleaned_business_data     │
   │      - dq_metric                 │
   └─────────┬────────────────────────┘
             ↓
 cleaned_business_data.sql  
 dq_metric.sql
             ↓
   ┌──────────────────────────────────┐
   │  Power BI Dashboard (via ODBC)   │
   │  • Visuals, KPIs & Insights      │
   │  • Driven by dq_metric + data    │
   └──────────────────────────────────┘

📂 Project Structure
project/
│
├── scripts/
│   └── parsing.py
│
├── notebooks/
│   └── data_exploration_profiling.ipynb
│
├── data/
│   ├── parsed_output.csv
│   ├── cleaned_business_data.csv
│   └── dq_metric.csv
│
├── sqlite/
│   ├── database.db
│   ├── cleaned_business_data.sql
│   └── dq_metric.sql
│
├── powerbi/
│   └── dashboard.pbix
│
└── README.md

🧪 Detailed Steps Followed
1️⃣ Parsing the ZIP File

A raw .zip file was received as input.

parsing.py was executed in VS Code (Python) to:

Extract contents

Parse raw files

Convert them into a structured format

Output: parsed_output.csv

2️⃣ Data Profiling & Cleaning (Jupyter Notebook)

Performed in VS Code Notebook:

Data profiling (missing values, duplicates, type checks)

Exploratory Data Analysis (EDA)

Business rule validation

Standardization and cleaning of invalid records

Data quality metric generation (duplicate counts, final row counts, low-confidence rows)

Outputs:

cleaned_business_data.csv

dq_metric.csv

3️⃣ SQLite Database Development

Created database.db using Python’s sqlite3

Designed schema for business data and DQ metrics

Loaded cleaned data and metrics into separate tables:

cleaned_business_data

dq_metric

Exported .sql dumps:

cleaned_business_data.sql

dq_metric.sql

4️⃣ Power BI Dashboard

Established ODBC connection between SQLite → Power BI Desktop

Imported:

cleaned_business_data

dq_metric

Built visuals for:

Duplicate analysis

Row count validation

Low-confidence row insights

Company-level metrics

Trend & distribution patterns

📊 Final Deliverables

✔️ Cleaned business dataset
✔️ Data quality metric dataset
✔️ SQLite local database
✔️ Power BI dashboard with insights
✔️ End-to-end reproducible workflow

🧰 Tools & Technologies Used
Tool	Purpose
Python	Parsing & data cleaning
Pandas	Profiling, EDA, transformations
Jupyter Notebook	Interactive analysis
SQLite3	Lightweight local database
ODBC	Connection layer for Power BI
Power BI	Dashboard development
VS Code	Development environment
📄 Recommended .gitignore
.venv/
*.db
*.zip
__pycache__/
*.pyc

🚀 How to Reproduce This Project

Place input ZIP file in the project directory

Run

python scripts/parsing.py


Open data_exploration_profiling.ipynb and execute all cells

Generate:

cleaned_business_data.csv

dq_metric.csv

Load data into SQLite (database.db)

Connect Power BI using SQLite ODBC driver

Build visuals & insights