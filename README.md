# 🌍 Global Tech Layoffs Data Analysis

## 📌 Project Overview
This project analyzes **global layoffs in the tech and startup sectors**, compiled from publicly available reports. It demonstrates a full data science workflow, with an emphasis on:

- Data **cleaning** and **standardization**
- **Exploratory data analysis (EDA)** to identify trends and patterns
- Deduplication and data integrity validation
- Analytical storytelling through **SQL** and **Python**

The ultimate goal is to uncover **market volatility**, **geographic impact**, and **investment stages most affected** by job cuts, offering a snapshot of trends in the post-pandemic tech economy.

---

## 🛠️ Key Goals & Skills Demonstrated
- **Exploratory Data Analysis (EDA):**  
  Understand distributions, identify outliers, and detect relationships between variables like `industry`, `percentage_laid_off`, and `funds_raised`.

- **Data Cleaning & Standardization (MySQL):**  
  Fix character encoding issues (e.g., `'MalmÃ¶'` → `'Malmö'`), standardize country names, and handle missing values.

- **Deduplication & Data Integrity:**  
  Write efficient SQL logic to remove duplicates while retaining one clean record per unique layoff event.

- **Trend Analysis & Ranking:**  
  Use SQL window functions to identify top companies and industries affected per year, and calculate rolling totals over time.

---

## 🧪 Exploratory Data Analysis (EDA)
**Guiding questions:**
- What is the distribution of `total_laid_off` and `percentage_laid_off`?
- Which industries and countries experienced the largest layoffs?
- How does company **stage** (e.g., Post-IPO vs. Series A) relate to severity of layoffs?
- Which columns have the most missing values, and how are they handled (e.g., `funds_raised`)?

**Key Techniques:**
- Summary statistics (MAX, MIN, AVG)
- Grouping & ranking (`GROUP BY`, `DENSE_RANK()`)
- Rolling totals using window functions
- Identifying outliers through distribution analysis

---

## 🧰 Tools & Technologies
| Category                    | Tools Used                                              |
|-----------------------------|---------------------------------------------------------|
| Data Storage & Cleaning     | 🐬 MySQL / SQL                                          |
| Data Analysis               | 🐬 MySQL / SQL                                          |                               
---

## 📂 Repository Structure
| File/Folder                     | Description                                                                 |
|----------------------------------|------------------------------------------------------------------------------|
| `data/layoffs.csv`              | 📄 Raw dataset (uncleaned).                                                 |
| `sql/SQL_Cleaning_Script.sql`   | 🧼 MySQL script to clean, standardize, and deduplicate data.                |
| `sql/EDA on layoffs.sql` | 📊 Structured SQL script for exploratory analysis and rolling trends.       |
| `reports/Analysis_Report.md`    | 📝 Summary of key findings and insights.                                   |
| `README.md`                     | 🏠 Project overview (this file).                                            |

---

