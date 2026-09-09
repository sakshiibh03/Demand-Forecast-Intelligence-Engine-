# Nexora Operations Demand Capacity Intelligence Engine

## Project Overview

Nexora Operations is a fictional company created for this business analytics case study. 
The project focuses on understanding whether operational capacity is sufficient to handle changing demand across different locations.

The project analyses two years of operational data to identify demand patterns, capacity pressure, 
operational risks and the relationship between capacity constraints and service performance. 
It also uses demand forecasting to estimate future requirements and support capacity planning for 2026.

The analysis was built across Excel, SQL, Python and Power BI to create an end to end analytical workflow from raw operational data to business recommendations.

## Business Problem

When demand increases faster than available capacity, businesses can experience delays, cancellations and service issues.
On the other hand, excess capacity can result in underutilised resources and higher operating costs.

The key business question was:

**Can Nexora identify capacity pressure early enough to take action before it affects operational performance?**

## Objectives

• Analyse historical demand and capacity trends  
• Identify locations and periods experiencing capacity pressure  
• Measure the operational impact of capacity constraints  
• Analyse the effect of promotions on demand and capacity  
• Classify operational periods by risk level  
• Forecast demand for January to June 2026  
• Estimate additional capacity required for future demand  
• Develop dashboards that support operational decision making  

## Tools Used

• **Excel** for data preparation, analysis, forecasting inputs and scenario planning  
• **PostgreSQL** for data validation, aggregation, relational analysis and business queries  
• **Python** for forecasting, model comparison and analytical visualisation  
• **Power BI** for interactive dashboards and business intelligence  
• **AI** as a supporting analytical layer for interpretation and insight development  

## Data

The project contains 4,386 daily operational records covering:

**January 2024 to December 2025**

The data covers six operational locations:

• Mumbai  
• Pune  
• Bengaluru  
• Delhi NCR  
• Hyderabad  
• Chennai  

The analysis combines operational performance, calendar information, promotions, workforce capacity and capacity planning data.

## Key Analysis

### Executive Overview

The first Power BI page provides a high level view of Nexora's operational position.

It focuses on:

• Total demand and available capacity  
• Overall capacity gap  
• Fulfilment and cancellation performance  
• Daily demand versus capacity  
• Monthly demand and capacity trends  
• Management level business takeaways  

### Capacity and Risk Intelligence

The second page focuses on identifying where operational pressure occurs and what impact it has.

It analyses:

• Critical day frequency by location  
• Operational risk levels  
• Capacity utilisation versus delay rate  
• Promotion driven demand and capacity pressure  
• Operational impact of being over capacity  

### 2026 Forecast and Capacity Planning

The third page focuses on future planning.

A three month moving average was selected as the primary forecasting method after comparing it with exponential smoothing.

The forecast covers January to June 2026 and evaluates:

• Forecast demand  
• Planning capacity  
• Forecast capacity gaps  
• Risk levels  
• Additional capacity requirements  

## Dashboard Preview

### Executive Overview

Provides a management level view of demand, capacity, fulfilment, cancellations and monthly capacity trends.

![Executive Overview](Executive%20Overview%20dashboard.png)

### Capacity and Risk Intelligence

Identifies capacity pressure by location, operational risk levels, promotion impact and the relationship between capacity utilisation and service delays.

![Capacity and Risk Intelligence](Capacity%20%26%20Risk%20Intelligence%20Dashboard.png)

### 2026 Forecast and Capacity Planning

Shows forecast demand, planning capacity, projected capacity gaps, risk levels and additional capacity requirements for January to June 2026.

![2026 Forecast and Capacity Planning](2026%20Forecast%20%26%20Capacity%20Planning%20Dashboard.png)

## Key Findings

• Total demand across the two year period was approximately **3.21 million**, compared with approximately **3.57 million** units of available capacity.

• Overall capacity was sufficient, but the aggregate position masked significant peak period pressure.

• Capacity utilisation increased from **87.9% in 2024 to 92.0% in 2025**, showing that demand was growing faster than available capacity.

• **November 2025** was the most constrained month, with demand exceeding capacity by approximately **12.9K units**.

• **Delhi NCR** experienced the highest frequency of capacity breaches, followed by Mumbai and Bengaluru.

• Promotion periods generated approximately **21% higher average daily demand** than non promotion days.

• **Festive promotions** created the highest capacity pressure among promotion types.

• Delay rate increased from **1.33% within capacity to 6.76% when over capacity**.

• The 2026 forecast indicates average utilisation of approximately **103.5%**, suggesting continued capacity pressure.

• Approximately **31.8K additional capacity** is required across the January to June 2026 forecast period under the current planning assumption.

## Business Recommendation

Nexora should move from reactive capacity management towards proactive planning.

Forecasted demand should be monitored alongside available capacity, with additional resources planned ahead of high pressure periods.
Particular attention should be given to locations and promotional periods where demand is more likely to exceed available capacity.

The analysis suggests that monitoring capacity gaps as an early warning indicator can help reduce delays and cancellations while improving operational planning.

## Project Workflow

**Raw Data → Excel Analysis → SQL Analysis → Python Forecasting → Power BI Dashboard → Business Recommendations**

## Project Files

## Project Files

| File | Purpose |
|---|---|
| `Nexora Operations Demand Capacity Intelligence Engine.xlsx` | Excel analysis, calculations, forecasting inputs and scenario planning |
| `Nexora Monthly Demand Forecast.sql` | PostgreSQL data validation, KPI analysis, demand and capacity analysis, risk identification and business queries |
| `Nexora Demand Capacity Intelligence Engine.ipynb` | Python forecasting, model comparison and analytical visualisation |
| `Nexora Forecast 2026(in).csv` | 2026 forecast and capacity planning outputs used for the Power BI analysis |
| `Nexora Operations Demand Capacity Intelligence Engine.pbix` | Complete interactive Power BI dashboard |
| `Executive Overview dashboard.png` | Executive Overview dashboard screenshot |
| `Capacity & Risk Intelligence Dashboard.png` | Capacity and Risk Intelligence dashboard screenshot |
| `2026 Forecast & Capacity Planning Dashboard.png` | 2026 Forecast and Capacity Planning dashboard screenshot |

## Outcome

This project demonstrates how operational data can be transformed into actionable business intelligence by combining data analysis, forecasting, risk identification and visual reporting.

The final outcome is a decision support framework that helps management understand current capacity pressure, identify operational risk and prepare for future demand.
