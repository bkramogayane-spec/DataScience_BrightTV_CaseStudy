---Data checks 
---Check all column names and data types
SELECT*
FROM workspace.default.bright_tv_userprofile2026;

SELECT*
FROM workspace.default.bright_tv_viewership2026;

---Returns only records with matching UserID in both tables
SELECT v.*, u.*
FROM workspace.default.bright_tv_viewership2026 AS v
INNER JOIN workspace.default.bright_tv_userprofile2026 AS u ON v.UserID0 = u.UserID;

---Returns all records from Viewership, and matched records from UserProfiles.
SELECT v.*, u.*
FROM workspace.default.bright_tv_viewership2026 AS v
LEFT JOIN workspace.default.bright_tv_userprofile2026 AS u ON v.UserID0 = u.UserID;

---Returns all records from UserProfiles, and matched records from Viewership.
SELECT v.channel2,
COUNT(DISTINCT v.UserID0) AS TotalUsers
FROM workspace.default.bright_tv_viewership2026 AS v
INNER JOIN workspace.default.bright_tv_userprofile2026 AS u ON v.UserID0 = u.UserID
GROUP BY v.Channel2;

---User and Usage Trends 
---5375 recorded
SELECT UserID
FROM workspace.default.bright_tv_userprofile2026
UNION
SELECT UserID0
FROM workspace.default.bright_tv_viewership2026;

SELECT 
    v.Channel2,
    COUNT(DISTINCT u.UserID) AS TotalUsers
FROM workspace.default.bright_tv_userprofile2026 u
JOIN workspace.default.bright_tv_viewership2026 v
    ON u.UserID = v.UserID0
GROUP BY v.Channel2
ORDER BY TotalUsers DESC;

---10 000 recorded
SELECT COUNT(*) AS TotalSessions 
FROM workspace.default.bright_tv_viewership2026;

---User demographics
SELECT
  gender,
  COUNT(DISTINCT UserID) AS Users
FROM workspace.default.bright_tv_userprofile2026
WHERE gender IS NOT NULL
GROUP BY gender;

---Factors Influencing Consumption 
---sessions per age group
SELECT AGE, 
COUNT(*) AS Sessions 
FROM workspace.default.bright_tv_userprofile2026 u
JOIN workspace.default.bright_tv_viewership2026 v ON u.UserID = v.UserID0
GROUP BY AGE 
ORDER BY Sessions DESC;

---Group sessions by gender including non-allocated
SELECT Gender, 
COUNT(*) AS Sessions 
FROM workspace.default.bright_tv_userprofile2026 u  
JOIN workspace.default.bright_tv_viewership2026 v ON u.UserID = v.UserID0
GROUP BY Gender 
ORDER BY Sessions DESC;

---Group sessions by provinces including non-allocated
SELECT province, 
COUNT(*) AS Sessions 
FROM workspace.default.bright_tv_userprofile2026 u  
JOIN workspace.default.bright_tv_viewership2026 v ON u.UserID = v.UserID0
GROUP BY province 
ORDER BY Sessions DESC;

---UTC to SAST Conversion---Time & Date
-------Function to split the tiem and date in the RecordDate2 column
SELECT 
    RecordDate2,
    split_part(RecordDate2, ' ', 1) AS date_part,
    split_part(RecordDate2, ' ', 2) AS time_part
FROM workspace.default.bright_tv_viewership2026;

---function to convert date into date format and time into time format
SELECT 
    RecordDate2,
    TO_DATE(REPLACE(SPLIT_PART(RecordDate2, ' ', 1), '/', '-'), 'yyyy-MM-dd') AS date_part,
    SPLIT_PART(RecordDate2, ' ', 2) AS time_part
FROM workspace.default.bright_tv_viewership2026;

SELECT
    RecordDate2,
    -- Convert string to timestamp in UTC and then to RSA time
    CONVERT_TIMEZONE(
        'UTC', 
        'Africa/Johannesburg', 
        RecordDate2
    ) AS rsa_timestamp,
    -- Extract date and time separately if needed
    DATE(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', RecordDate2)) AS rsa_date,
    DATE_FORMAT(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', RecordDate2), 'HH:mm:ss') AS rsa_time
FROM workspace.default.bright_tv_viewership2026;

---Viewership by Province
SELECT Province,
       COUNT(DISTINCT UserID) AS users
FROM workspace.default.bright_tv_userprofile2026 v
JOIN workspace.default.bright_tv_viewership2026 u  ON v.UserID = u.UserID0
WHERE Province IS NOT NULL
GROUP BY Province
ORDER BY users DESC;

---Viewership by Age Group
SELECT 
    CASE 
        WHEN u.Age < 18 THEN '<18'
        WHEN u.Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN u.Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN u.Age BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+' 
    END AS AgeGroup,
    COUNT(*) AS Sessions
FROM workspace.default.bright_tv_viewership2026 v
INNER JOIN workspace.default.bright_tv_userprofile2026 u ON u.UserID = v.UserID0
GROUP BY CASE 
        WHEN u.Age < 18 THEN '<18'
        WHEN u.Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN u.Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN u.Age BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+'
    END;

---ORDER BY TotalMinutes DESC;
---Sessions by age group
SELECT 
     CASE
          WHEN Age BETWEEN 0 AND 17 THEN 'Under 18'
           WHEN Age BETWEEN 18 AND 25 THEN '18-25'
           WHEN Age BETWEEN 26 AND 35 THEN '26-35'
           WHEN Age BETWEEN 36 AND 45 THEN '36-45'
           WHEN Age BETWEEN 46 AND 60 THEN '46-60'
           ELSE '60+'
      END AS AgeGroup,
      COUNT(*) AS Sessions
FROM workspace.default.bright_tv_userprofile2026 u
JOIN workspace.default.bright_tv_viewership2026 v ON u.UserID = v.UserID0
GROUP BY AgeGroup
ORDER BY Sessions DESC;

-- Sessions by gender
SELECT Gender, COUNT(*) AS Sessions
FROM workspace.default.bright_tv_userprofile2026 u
JOIN workspace.default.bright_tv_viewership2026 v ON u.UserID = v.UserID0
GROUP BY Gender
ORDER BY Sessions DESC;

-- Sessions by province
SELECT Province, COUNT(*) AS Sessions
FROM workspace.default.bright_tv_userprofile2026 u
JOIN workspace.default.bright_tv_viewership2026 v ON u.UserID = v.UserID0
GROUP BY Province
ORDER BY Sessions DESC;

---Sessions & watch time

SELECT
  COUNT(*) AS total_sessions,
  SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) AS total_watch_time
FROM workspace.default.bright_tv_viewership2026;

------Top 10
SELECT
  UserID0,
  COUNT(*) AS sessions,
   SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) AS watch_time
FROM workspace.default.bright_tv_viewership2026
GROUP BY UserID0
ORDER BY watch_time DESC
LIMIT 10;

---Top 10 Channels by Viewership
SELECT 
    Channel2,
    COUNT(*) AS sessions,
    SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) AS TotalMinutes
FROM workspace.default.bright_tv_viewership2026
GROUP BY Channel2
ORDER BY TotalMinutes DESC
LIMIT 10;

--- Average duration by demographics
SELECT
  Gender,
  AVG(`Duration 2`) AS avg_watch_time
FROM workspace.default.bright_tv_viewership2026 v
JOIN workspace.default.bright_tv_userprofile2026 u ON u.UserID = v.UserID0
WHERE Gender IS NOT NULL
GROUP BY Gender;

SELECT
  u.Province,
  AVG(`Duration 2`) AS avg_watch_time
FROM workspace.default.bright_tv_viewership2026 v
JOIN workspace.default.bright_tv_userprofile2026 u ON u.UserID = v.UserID0
WHERE Province IS NOT NULL
GROUP BY Province
ORDER BY avg_watch_time DESC;

--- Identify low-consumption days 

SELECT
  DATE(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) AS view_date,
  SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) AS watch_time
FROM workspace.default.bright_tv_viewership2026
GROUP BY view_date
ORDER BY watch_time ASC
LIMIT 10;

--- Target users for engagement
SELECT
  UserID0,
  COUNT(*) AS sessions
FROM workspace.default.bright_tv_viewership2026
GROUP BY UserID0
HAVING COUNT(*) < 5;

--- Users with social handles (5375)
SELECT
  COUNT(*) AS users_with_social
FROM workspace.default.bright_tv_userprofile2026
WHERE `Social Media Handle` IS NOT NULL;

-- Most popular channels on low-consumption days
SELECT Channel2, COUNT(*) AS Sessions
FROM workspace.default.bright_tv_viewership2026
WHERE DATE(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', RecordDate2)) IN (
    SELECT SA_Date
    FROM (
        SELECT DATE(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', RecordDate2)) AS SA_Date,
               COUNT(*) AS Sessions
        FROM workspace.default.bright_tv_viewership2026
        GROUP BY SA_Date
        HAVING COUNT(*) < (
            SELECT AVG(SessionCount)
            FROM (
                SELECT COUNT(*) AS SessionCount
                FROM workspace.default.bright_tv_viewership2026
                GROUP BY DATE(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', RecordDate2))
            ) AS AvgSessions
        )
    ) AS LowDays
)
GROUP BY Channel2
ORDER BY Sessions DESC;

-- Active users per month
SELECT 
    Channel2,
    SUM(
        HOUR(`Duration 2`) * 3600 +
        MINUTE(`Duration 2`) * 60 +
        SECOND(`Duration 2`)
    ) AS total_duration_seconds
FROM workspace.default.bright_tv_viewership2026
GROUP BY Channel2
ORDER BY total_duration_seconds DESC;

-----Inactive users
SELECT
  UserID0,
  MAX(RecordDate2) AS last_seen
FROM workspace.default.bright_tv_viewership2026
GROUP BY UserID0
HAVING MAX(RecordDate2) < date_sub(current_date(), 30);

-- Channels with highest engagement
SELECT Channel2,
       COUNT(*) AS Sessions,
       AVG(
        HOUR(`Duration 2`) * 3600 +
        MINUTE(`Duration 2`) * 60 +
        SECOND(`Duration 2`)
    )  AS AvgDurationSeconds
FROM workspace.default.bright_tv_viewership2026
GROUP BY Channel2
ORDER BY 
    Sessions DESC;

SELECT 
    Channel2,
    -- Total duration in seconds
    SUM(
        HOUR(`Duration 2`) * 3600 +
        MINUTE(`Duration 2`) * 60 +
        SECOND(`Duration 2`)
    ) AS total_duration_seconds,

    -- Total duration formatted as HH:MI:SS
    TO_VARCHAR(
        DATEADD(
            second, 
            SUM(
        HOUR(`Duration 2`) * 3600 +
        MINUTE(`Duration 2`) * 60 +
        SECOND(`Duration 2`)
            ), 
            CAST('1970-01-01 00:00:00' AS TIMESTAMP)
        ), 
        'HH24:MI:SS'
    ) AS total_duration_time
FROM workspace.default.bright_tv_viewership2026
GROUP BY Channel2
ORDER BY total_duration_seconds DESC;

SELECT
Channel2,
CAST(SUM(`Duration 2`) AS STRING) AS total_viewing_time
FROM workspace.default.bright_tv_viewership2026
GROUP BY Channel2 
ORDER BY total_viewing_time DESC;

------------------Final code--------------------
SELECT CHANNEL2,
       GENDER,
       RACE,
       PROVINCE,
       Email,
       `Social Media Handle`,
----Classification of age groups
CASE
    WHEN Age BETWEEN 0 AND 17 THEN 'Under 18'
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60++'
    END AS AgeGroup,
    COUNT(*) AS Sessions,


    -- Extraction of date and time separately 
    DATE(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', RecordDate2)) AS rsa_date,
    DATE_FORMAT(CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', RecordDate2), 'HH:mm:ss') AS rsa_time,
    `Duration 2`,
    date_format( RecordDate2, 'EEEE') AS Day_name
    
FROM workspace.default.bright_tv_userprofile2026 u
JOIN workspace.default.bright_tv_viewership2026 v ON u.UserID = v.UserID0
GROUP BY ALL;
