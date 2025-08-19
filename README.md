# Global Layoffs Analysis and Prediction

## Project Overview

This project provides a comprehensive analysis of global layoff trends. The workflow begins with scraping publicly available layoff data, creating an automated pipeline into a MySQL DB, followed by cleaning and querying the data in MySQL. The processed data is then visualized using Tableau to uncover insights and create a data story. Finally, a predictive model using Python's Prophet library forecasts future layoff trends for 2026, broken down by month, company, and industry.

## Live Dashboard

An interactive Tableau dashboard has been developed to allow for dynamic filtering and exploration of the layoffs data. The dashboard allows for an in-depth analysis across different dimensions of the dataset for a deeper understanding of layoff trends.

![Dashboard Preview](Tableau/images/dashboard.gif)

## Tech Stack & Tools

*   **Data Extraction:** Python (Selenium)
*   **Database:** MySQL
*   **Data Cleaning, Transformation, EDA:** SQL
*   **Time Series Forecasting:** Prophet
*   **Data Visualization & Dashboarding:** Tableau
*   **Version Control:** Git & GitHub

## Project Pipeline

This project follows a structured, multi-stage data pipeline:

1.  **Data Scraping**: A Python script dynamically scrapes the global layoffs table from the source website.
2.  **Data Cleaning and SQL Analysis**: The raw data is cleaned and loaded into a MySQL database. SQL queries are then used to generate tables and extract key insights.
3.  **Data Export**: The analyzed data is exported from MySQL into CSV files.
4.  **Tableau Visualization**: The CSV files are loaded into Tableau to create interactive visualizations and dashboards.
5.  **Data Storytelling**: A narrative is built around the Tableau visualizations to communicate the findings effectively.
6.  **Predictive Modeling**: A time-series forecasting model is developed in Python using Prophet library to predict layoff trends for 2026.

## Data Source

The dataset used for this analysis was dynamically scraped from layoffs.fyi, containing layoffs data since 2020 to date, with details on Company name, date of layoff, industry, stage, country, location HQ, etc.

## Setup & Installation

To replicate this project locally, please follow these steps:

**Clone the repository:**
    ```
    git clone https://github.com/tanmaykumar99/Portfolio.Global-Layoffs.git
    ```

1.  **Scrape Data**: Run the Python scraping scripts located in the `python` directory called 'Layoffsfyi_Data_Pull' to gather the initial dataset.
2.  **Database and ETL**: Use the SQL scripts in `sql/queries/` to set up your MySQL database, clean the data, and perform initial analysis.
3.  **Visualize**: Open the Tableau workbooks in `tableau/workbooks/` to explore the interactive visualizations of the layoff data.
4.  **Predict**: Execute the Python scripts in `python` dir called 'Prediction_Model_2026' to generate layoff forecasts for 2026.

## Future Enhancements

*   **Bug Fixes:** Continue fixing the Prophet model to make the prediction more accurate over time, as more data flows in to train the model.