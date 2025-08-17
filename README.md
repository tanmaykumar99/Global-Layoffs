# Global Layoffs Analysis and Prediction

## Overview

This project provides a comprehensive analysis of global layoff trends. The workflow begins with scraping publicly available layoff data, creating an automated pipeline into a MySQL DB, followed by cleaning and querying the data in MySQL. The processed data is then visualized using Tableau to uncover insights and create a data story. Finally, a predictive model using Python's Prophet library forecasts future layoff trends for 2026, broken down by month, company, and industry.

## Prerequisites

To run this project, you will need the following installed:

*   **Python 3.8+**
*   **Tableau for Desktop
*   **MySQL Server 8.0+**: A running instance of MySQL is required to store and query the data.
*   All Python packages listed in the `requirements.txt` file. You can install them by running:
    ```
    pip install -r requirements.txt
    ```

## Project Stages

1.  **Data Scraping**: A Python script dynamically scrapes the global layoffs table from the source website.
2.  **Data Cleaning and SQL Analysis**: The raw data is cleaned and loaded into a MySQL database. SQL queries are then used to generate tables and extract key insights.
3.  **Data Export**: The analyzed data is exported from MySQL into CSV files.
4.  **Tableau Visualization**: The CSV files are loaded into Tableau to create interactive visualizations and dashboards.
5.  **Data Storytelling**: A narrative is built around the Tableau visualizations to communicate the findings effectively.
6.  **Predictive Modeling**: A time-series forecasting model is developed in Python using Prophet library to predict layoff trends for 2026.

## Folder Structure

The project is organized into the following folder structure to maintain clarity and separation of concerns:

Project_Root/
├── .gitignore
├── README.md
├── LICENSE
├── requirements.txt
├── Datasets/
│ ├── cleaned_data/
│ └── raw_data/
├── Data_Story/
|  ├── insights/
├── python/
| ├── modeling/
│ ├── images/
│ ├── scraping/
│ └── README.md/
├── SQL/
│ ├── README.md
│ ├── exports/
│ └── queries/
│ └── images/
│ └── Query_doc/
└── Tableau/
  └── twb_workbook/
  └── sample_screenshot/

## How to Use This Project

**Clone the repository:**
    ```
    git clone https://github.com/tanmaykumar99/amazon-sales-analysis.git
    ```

1.  **Scrape Data**: Run the Python scraping scripts located in the `python` directory called 'Layoffsfyi_Data_Pull' to gather the initial dataset.
2.  **Database and ETL**: Use the SQL scripts in `sql/queries/` to set up your MySQL database, clean the data, and perform initial analysis.
3.  **Visualize**: Open the Tableau workbooks in `tableau/workbooks/` to explore the interactive visualizations of the layoff data.
4.  **Predict**: Execute the Python scripts in `python` dir called 'Prediction_Model_2026' to generate layoff forecasts for 2026.

## Future Enhancements

*   **Bug Fixes:** Continue fixing the Prophet model to make the prediction more accurate over time, as more data flows in to train the model.