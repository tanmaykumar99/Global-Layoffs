# The Great Reshuffle: An In-Depth Analysis of the Global Layoff Landscape (2020–2025)

![Dashboard 1](../Tableau/images/screenshot_1.png)
![Dashboard 2](../Tableau/images/screenshot_2.png)

The years following 2020 marked a period of volatility in the global job market. What began as a reaction to the pandemic soon evolved into a complex "Great Reshuffle," driven by economic shifts, technological advancements, organizational restructuring, and changing consumer behaviors. This analysis provides a data-driven narrative of this turbulent period, uncovering key trends, identifying the most affected industries, sectors, companies, etc., and forecasting what may lie ahead.

The entire project—from data acquisition to final visualization—is built on a robust, automated pipeline. Data was continuously scraped from *layoffs.fyi*, cleaned and processed using SQL, and analyzed with Python, culminating in an interactive Tableau dashboard that brings the story to life.

### Key Findings at a Glance

*   **Total Impact:** Since 2020, over **750,000** layoffs have been recorded across more than **1,900** companies globally.
*   **The Peak of the Storm:** The layoff crisis reached its zenith in early 2023, with a single month seeing over **80,000** job cuts!
*   **Geographic Concentration:** The United States was disproportionately affected, accounting for over **70%** of total layoffs! However, tech/IT hubs in India and Germany also faced significant cuts.
*   **Industry Hotspots:** The **Hardware, Software, and Retail** sectors bore the brunt of the downturn, while surprisingly, **AI** remained one of the most resilient industries, possibly due to its recent arrival in the industry scene.

---

## The Narrative Unfolded: A Three-Act Story

This story can be understood in three distinct acts: the initial shock, the widespread correction, and the emerging new reality.

### Act I: The Initial Shock and the Dominance of Titans (2020–2022)

The early phase of this trend was defined by massive, single-event layoffs from established tech giants. **Intel** and **Microsoft** led this wave, with Intel executing the single largest layoff event by cutting **22,000** jobs in one day. The "Top 10 Companies by Layoffs" chart clearly shows that legacy hardware and software companies initiated this trend.

Interestingly, the yearly analysis reveals that the top companies driving layoffs changed over time. While giants like **Meta** and **Amazon** were consistent players, companies like **Uber** and **Booking.com** dominated the early pandemic phase in 2020, reflecting the immediate impact on the travel and transportation sectors due to the lockdown.

### Act II: The Great Correction—A Ripple Effect Across Industries (2023–2024)

2023 marked a turning point. As the "Layoff Trends" area chart shows, this year saw the highest volume of layoffs, but the nature of these cuts shifted. The problem was no longer confined to a few large corporations but had become an industry-wide phenomenon.

*   **Industry Impact:** The "Top 10 Industries" chart highlights that **Hardware, Consumer, and Retail** were the most impacted. The high number in the 'Other' category is significant, as the underlying SQL script reveals it includes many software and tech companies, indicating a broad-based tech downturn.
*   **Company Stage:** The "In-Depth Stage Heatmap" provides a crucial insight: **Post-IPO** companies accounted for the vast majority of layoffs. This suggests that mature, public companies were under immense pressure to correct their post-pandemic hiring sprees and demonstrate profitability to investors. In contrast, early-stage startups (Seed, Series A/B) were far more resilient, likely due to leaner operations and different funding pressures.

### Act III: The New Reality and a Look to the Future (2025 and Beyond)

As we moved into 2025, the trend began to stabilize but did not disappear. The monthly layoff numbers, while lower than the 2023 peak, remained elevated, suggesting a new, more cautious equilibrium in the job market.

To understand what lies ahead, a predictive model was built using Python and the Prophet forecasting library. Based on historical data, the model projects the layoff trends for 2026. While the overall numbers are expected to be lower than the 2023 peak, the forecast indicates that layoffs will continue to be a significant factor, with certain months predicted to see tens of thousands of job cuts. This suggests that the "Great Reshuffle" is not over, but is transitioning into a new phase of continuous, strategic workforce adjustments rather than massive, reactive cuts.

---

## Methodology

This project demonstrates a full-stack data analysis workflow, designed for accuracy, scalability, and impact:

### 1. Automated Data Scraping
A Python script using **Selenium** was developed to scrape real-time data from `layoffs.fyi`. To ensure data integrity and avoid redundant processing, a hashing mechanism was implemented to detect changes on the website, triggering the script only when new data was available.

### 2. Robust Data Cleaning with SQL
The raw data was often inconsistent. A comprehensive **SQL script** was executed to perform critical data cleaning and transformation tasks, including:
*   Creating a staging table to preserve the raw data.
*   Removing duplicates using window functions (`ROW_NUMBER`).
*   Standardizing company names, locations, and industry labels.
*   Handling `NULL` values and converting data types appropriately for further analysis.

### 3. Advanced Analytics and Predictive Modeling
Exploratory Data Analysis (EDA) was first conducted in SQL to answer key business questions. For predictive insights, a **Jupyter Notebook** was used to:
*   Build a time-series forecasting model using Facebook's **Prophet** to predict future layoff trends.
*   Analyze data by different segments (industry, company stage) to provide a granular forecast.
*   Generate visualizations with **Matplotlib** to validate the model's performance.

### 4. Data Visualisation with Tableau
The final, cleaned datasets were exported out of SQL into **Tableau** to create an interactive and intuitive dashboard. Each visualization was carefully designed to answer a specific question, guiding the user through the data story in a logical and compelling manner.

## Conclusion

The global layoff trend of 2020–2025 is more than just a series of numbers; it's a story about economic transformation, corporate strategy, and the changing face of work, spearheaded by automation processes like AI. By leveraging a powerful combination of data engineering, statistical analysis, and visualization, this project not only tells that story but also provides a framework for understanding the forces that will shape the job market for years to come. More importantly, it is essential for us to go beyond the tech-stacks and the techniques, and really grasp the sombre reality of hundreds of thousands of people losing their jobs - People with bills to pay, responsibilities to manage, and an ever-competitive job market to go up against. 
