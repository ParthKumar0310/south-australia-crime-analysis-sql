# 🚔 South Australia Crime Analysis using SQL

## 📌 Project Overview
This project aims to perform an analysis of crime patterns and trends in South Australia through the use of SQL data modelling and query analysis techniques.

The data includes about **140,000+ records** of crimes committed in South Australia, consisting of various types of offences, suburb locations, postcodes, and dates.

The objective of this project is to analyze the provided crime dataset by creating a relational database model, performing normalization of data, and running advanced SQL queries.

---

# 🎯 Project Objectives

- Analyze crime distribution across suburbs in South Australia
- Identify the most common offence categories
- Perform year-wise and month-wise crime trend analysis
- Measure contribution of top suburbs to total crime volume
- Explore hierarchical offence category patterns
- Develop a structured relational database for analytical reporting

---

# 🗂️ Dataset Information

The dataset includes:

- Reported crime dates
- Suburbs and postcodes
- Offence hierarchy levels
- Crime occurrence counts

---

# 🏗️ Database Design & Data Modelling

The project was designed using a relational database structure with normalization concepts.

## 📌 Dimension Tables

### `suburbs`
Contains:
- suburb_id
- suburb
- postcode

### `offences`
Contains:
- offence_id
- offence_level_1
- offence_level_2
- offence_level_3

## 📌 Fact Table

### `crime_fact`
Contains:
- crime_id
- suburb_id
- offence_id
- reported_date
- offence_count

---

# 🧠 SQL Concepts & Techniques Used

This project demonstrates multiple SQL concepts including:

## 🔹 Data Definition & Administration
- CREATE TABLE
- INSERT INTO
- Primary Keys
- Foreign Keys
- Relational Data Modelling
- Database Normalization

## 🔹 Analytical SQL Concepts
- GROUP BY
- ORDER BY
- Aggregate Functions
- CASE Statements
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- Ranking Functions
- Percentage Contribution Analysis
- Year-over-Year Analysis
- Time-Series Analysis

## 🔹 Advanced SQL Techniques
- Joins
- Multi-table Analysis
- Subqueries
- Hierarchical Crime Analysis
- Rolling & Trend-Based Analysis

---

# 📈 Key Analysis Performed

## ✅ Crime Contribution Analysis
- Percentage contribution of top suburbs to total crimes in South Australia

## ✅ Time-Series Analysis
- Monthly and yearly crime trend analysis

## ✅ Category Analysis
- Most common offence categories by suburb

## ✅ Top Crime Analysis
- Top Level-2 offence categories by suburb

## ✅ Hierarchical Crime Analysis
- Offence hierarchy analysis using offence levels

## ✅ Trend & Growth Analysis
- Year-wise crime growth analysis
  
---

# 📌 Conclusion

This project helped strengthen practical skills in:

- SQL analytics
- Database design
- Data modelling
- Business-focused analytical thinking
- Relational schema development
- Real-world data analysis

The project demonstrates how SQL can be used to transform raw public datasets into actionable analytical insights for reporting and decision-making.
