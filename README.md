## 📺 BrightTV Viewership Analytics – Case Study
📌 Project Overview
This repository contains a data analytics case study conducted for BrightTV, focused on understanding user behaviour, content consumption patterns, and churn risk.
The goal of the analysis is to support Customer Value Management (CVM) initiatives aimed at growing the subscription base.
The solution uses Databricks SQL for data analysis and dashboarding, with insights presented in an executive‑ready format.

This case study uses user profile data and viewership session data to generate insights that support the Customer Value Management (CVM) team in driving:
Increased content consumption
Reduced churn
Sustainable user growth

The analysis was performed using Databricks SQL, with dashboards designed for executive decision‑making.

## 🎯 Business Objectives
BrightTV’s CEO aims to grow the platform’s subscriber base for the current financial year.

This case study addresses the following key questions:

What are the current user and usage trends?
Which factors influence content consumption?
What content should be promoted on low‑consumption days?
Which initiatives can grow and retain users effectively?


## 📂 Dataset Description
1️⃣ User Profiles (user_profiles)
Contains demographic and user metadata:

- user_id
- age
- gender
- province
- race
- social_media_handle

2️⃣ Viewership Sessions (viewing_sessions)
Session‑level consumption data:

- user_id
- session_start (UTC timestamp)
- duration_minutes
- channel_name
- content_category

## ⚠️ Data Notes

All timestamps are provided in UTC and converted to South African time (Africa/Johannesburg) during analysis.

Consumption is recorded per session.

Some demographic fields contain missing or null values.


## 🧠 Analytical Approach
The analysis followed a structured analytics lifecycle:

- Business Understanding
- Data Preparation
- Exploratory Data Analysis
- Visuals and Dashboard Development
- Insight Generation
- Business Recommendations

A MIRO board was used for analytics storytelling, and results were surfaced through Databricks.

## 📈 Key Insights Summary
### User & Usage Trends

- Core users fall within the 20–40 age group
- Highest engagement comes from Gauteng, Western Cape, and KwaZulu‑Natal
- Consumption is event‑driven, with strong spikes during live sports and premium events

### Drivers of Consumption

- Live sports and premium content drive the longest sessions
- Usage peaks during evenings and weekends
- Urban provinces exhibit higher engagement

### Low‑Consumption Days

- Mondays and Tuesdays show consistently lower usage
- Non‑event days underperform compared to live‑event days

## 🚀 Business Recommendations
### Increase Consumption

- Personalised content recommendations
- Highlight reels on low‑usage days
- Kids programming for weekday afternoons

### Reduce Churn

- Win‑back campaigns for inactive users
- Loyalty rewards based on watch time
- Province‑specific engagement strategies

### Grow User Base

- Referral incentives
- Youth & student subscription bundles
- Social‑media driven acquisition campaigns


## 🛠️ Technology Stack

- Databricks SQL
- Excel for visualization
- Google Looker Dashboards
- MIRO (analytics storytelling & planning)
- PowerPoint (executive presentation)

## ✅ Outcome
This case study delivers actionable, data‑driven insights that support BrightTV’s strategic goals by enabling:

- Better content planning
- Targeted CVM initiatives
- Improved user retention and engagement
- Scalable analytics capability

📬 Contact
For questions regarding this analysis or implementation details, please contact me at bkramogayane@gmail.com.
