Global Layoffs Data Cleaning & Exploratory Analysis (SQL)

## Overview

This SQL script (`Query_Scripts.sql`) provides a comprehensive, end-to-end workflow for cleaning, transforming, and analyzing a raw dataset of global company layoffs, extracted from an automated pipeline, making use of a dynamic web scraper in python. Executed within a MySQL environment, this script serves as the foundational data analysis step, preparing the data for in-depth exploratory analysis and subsequent visualization in tools like Tableau or Power BI.

The script demonstrates a robust data cleaning pipeline, handling everything from duplicate removal to complex data standardization, and culminates in a series of analytical queries designed to uncover key trends in the global workforce landscape since 2020.

## Key Features & Advanced Techniques

This script showcases a range of standard and advanced SQL techniques to ensure data quality and derive meaningful insights.

#### 1.  **Robust Data Staging & Integrity**
*   A staging table (`layoffs_staging`) is created as a duplicate of the raw data. This is a critical best practice that preserves the original dataset, allowing for safe, repeatable, and non-destructive transformations.

#### 2.  **Advanced Duplicate Detection and Removal**
*   **Window Functions:** A `ROW_NUMBER()` window function is partitioned over all relevant columns (`Company`, `Location`, `Industry`, etc.) to assign a unique index to each group of identical rows. This is a sophisticated method for accurately identifying duplicates where no primary key exists.
*   **CTE for Deletion:** The duplicates identified by the window function are then isolated using a Common Table Expression (CTE) and removed, ensuring each unique layoff event is represented only once.

#### 3.  **Complex Data Standardization and Cleaning**
*   **String Manipulation:**
    *   `TRIM()` is used to remove leading/trailing whitespace from company names.
    *   `REPLACE()` is used to clean up location data by removing artifacts like ",Non-U.S."
*   **Conditional Logic with `CASE` Statements:** Foreign city names with character encoding issues are anglicized using a `CASE` statement, showcasing conditional data cleaning.
*   **Manual Data Imputation:** Incomplete or ambiguous data points are manually corrected or split into new rows. For example, records with multiple cities are split into distinct entries, and missing `Country` or `Stage` information is programmatically filled based on known company details.

#### 4.  **Data Type Conversion and Formatting**
*   **Date Transformation:** The `STR_TO_DATE()` function is used to convert the date column from a `TEXT` format (`%m/%d/%Y`) to a proper `DATE` type, enabling accurate time-series analysis.
*   **Numeric Conversion:** Text-based numeric columns (`Number_laid_off`, `Percentage_laid_off`, etc.) are cleaned of non-numeric characters (e.g., '%' and '$') and then converted to `INT` types for mathematical operations.

#### 5.  **In-Depth Exploratory Data Analysis (EDA)**
The script concludes with a powerful set of analytical queries designed to answer key business questions:
*   **Time-Series Analysis with Rolling Totals:** A CTE is used to calculate the monthly sum of layoffs and then a `SUM() OVER()` window function computes a rolling total, perfect for visualizing the progression of layoffs over time.
*   **Ranked Analysis:** A multi-level CTE structure first aggregates layoffs by company and year, then uses `DENSE_RANK()` to identify the top 5 companies with the most layoffs for each year, demonstrating a complex and insightful ranking query.
*   **Aggregations & Subqueries:** A variety of `GROUP BY`, `ORDER BY`, and subqueries are used to find the single largest layoff event, companies that went out of business (100% layoff), and the hardest-hit industries, countries, and company stages.

## How to Use This Script

1.  **Database Setup:** Ensure a MySQL server is running.
2.  **Data Loading:** Load the raw layoffs dataset into a table named `layoffs`.
3.  **Script Execution:** Run this SQL script in its entirety. It will perform all cleaning and transformation steps, resulting in a final, analysis-ready table named `layoffs_staging2`.
4.  **Analysis:** Execute the individual `SELECT` queries in the "EXPLORATORY DATA ANALYSIS" section to replicate the findings or export the results for visualization.

## Requirements

*   MySQL Server (Note, one may use Postgres of SQL Server, but proceed with caution, as some syntax may have to be changed slightly)
*   User permissions to `CREATE TABLE`, `ALTER TABLE`, `INSERT`, `UPDATE`, and `DELETE`.
*   A raw data table named `layoffs` structured similarly to the one processed in the script.
