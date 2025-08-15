# SQL Data Cleaning and Analysis

This directory contains the SQL script responsible for the entire data transformation and analysis pipeline. The script was executed using MySQL Workbench on macOS and is designed to take the raw layoff data, clean and standardize it, and then run a series of queries to uncover key insights.

## Script Workflow

The SQL script is divided into two main parts:
1.  **Data Cleaning and Preparation**: This section focuses on transforming the raw data (using various techniques like window functions, CTEs, string manipulation, etc.) into a clean, standardized, and analysis-ready format.
2.  **Exploratory Data Analysis (EDA)**: This section uses the cleaned data to answer specific questions about layoff trends.

### Data Cleaning and Preparation

The data cleaning process follows a structured pipeline to ensure data integrity and usability. The key steps are outlined in the table below:
### Exploratory Data Analysis (EDA)

After cleaning the data, a series of analytical queries were run to extract meaningful insights. The key questions addressed were:

1.  **Largest Single Layoff Event**: Identified the company with the highest number of layoffs in a single event.
    *   **Finding**: Intel, with 22,000 employees laid off in April 2025.
2.  **Companies Shutting Down**: Counted the number of companies that laid off 100% of their workforce.
    *   **Finding**: 327 companies went out of business between 2020 and 2025.
3.  **Top Companies by Total Layoffs**: Aggregated total layoffs by company over the five-year period.
    *   **Top 5**: Intel, Microsoft, Amazon, Meta, and Tesla.
4.  **Hardest-Hit Industries**: Calculated total layoffs for each industry.
    *   **Top 5**: Hardware, Other, Consumer, Retail, and Transportation.
5.  **Most-Affected Countries**: Aggregated layoffs by country.
    *   **Top 5**: USA, India, Germany, UK, and Netherlands.
6.  **Year with the Most Layoffs**: Grouped total layoffs by year.
    *   **Finding**: 2023 was the worst year, with over 264,000 layoffs.
7.  **Company Stage and Layoffs**: Analyzed layoff numbers based on the funding stage of the company.
    *   **Finding**: Post-IPO companies were the most affected.
8.  **Monthly Layoff Progression**: Created a rolling total of layoffs to track the trend over time.
9.  **Top 5 Layoff Companies by Year**: Identified the top five companies with the most layoffs for each year in the dataset.

The data generated from the final two queries (`Rolling_Total` and `Company_Year_Rank`) was exported to CSV files to be used as a data source for the visualizations in Tableau.