## Introduction
This project was done by following a YouTube tutorial by Luke Barousse titled "SQL for Data Analytics." Using data provided by Barousse, I explored top paying jobs, in-demand skills, and optimal skills for data scientists. 

Link to SQL queries here: [project_sql folder](/project_sql/)
## Background
Data was pre-collected from actual job posting sites, provided by [this course](https://www.lukebarousse.com/sql) on SQL. The original data includes a variety of job types related to data analysis, though for this project I focused particularly on data science jobs.

The project asked the following questions:

1. What are the top-paying data scientist jobs?
2. What skills are required for top-paying jobs?
3. What skills are most in demand for data scientists?
4. What skills are associated with higher salaries?
5. What are the optimal skills to learn?
## Tools Used
The project used the following tools:

- **SQL**: "Structured Query Language," the main tool used in the analysis.
- **PostgreSQL**: The chosen database management system.
- **Visual Studio Code**: The IDM used to execute SQL queries.
- **Git and Github**: version control system allowing for project tracking and sharing results.
## The Analysis
Each query responded to a particular question exploring one aspect of the job market.
### Top paying data scientist jobs
To identify the top paying data scientist jobs, I filtered by data science jobs that included salaries, then ordered by salary descending, limiting to ten. 
```sql
SELECT  
    job_id,
    job_title,
    company_dim.name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Scientist' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
Running the query, I found the top ten jobs ranged from $300K to $550k yearly salary, coming from a variety of employers. 

### Top paying skills
Using the previous query as a CTE, this query pulls the skills associated with the ten top paying jobs. It joins the skill tables and orders by descending yearly salary.   
```sql

WITH top_paying_jobs AS (
    SELECT  
        job_id,
        job_title,
        company_dim.name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Scientist' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_job_dim.skill_id,
    skills_dim.skills AS skill_name

FROM
top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY top_paying_jobs.salary_year_avg DESC
```
The results show SQL, Python, and Java, as well as others (cassandra, spark, hadoop, aws, tensorflow).

### Highest demand skills
This query found the demand count for each skill grouping by skills, then ordered by descending demand count, limit ten. The result is given as the top ten skills by demand count for data scientist jobs. 
```sql
SELECT
    skills,
    COUNT(jpf.job_id) AS demand_count
FROM
    job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
WHERE job_title_short = 'Data Scientist' 
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10
```
Highest demand skills for data science were python, sql, and r, with the demand count as 114,016, 79,174, and 59,754 respectively. 

### Higher salary skills
This query grouped by skills for data science jobs and ordered by descending average salary, with average salary being calculated for the jobs utilizing each skill. The results showed the skills with the highest average salary.
```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM
    job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
WHERE job_title_short = 'Data Scientist' AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25
```
Running this query, I found the top three highest paying skills to be asana, airtable, and redhat, with average salary per skill ranging from $190k to $215k. These results are not terribly informative, since the job count for each skill is low. Further, these skills presuppose more common skills.
### Optimal skills to learn
Similar to the previous query, this query looks at skills with high paying salaries, but forces the job count associated with each skill to be over ten. 
```sql
WITH average_salary AS (
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
    FROM
        job_postings_fact jpf
    INNER JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
    INNER JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
    WHERE job_title_short = 'Data Scientist' AND
        jpf.salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id
), skills_demand AS (
    SELECT
        sd.skill_id,
        sd.skills,
        COUNT(jpf.job_id) AS demand_count
    FROM
        job_postings_fact jpf
    INNER JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
    INNER JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
    WHERE job_title_short = 'Data Scientist' AND
        jpf.salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM
    skills_demand
INNER JOIN average_salary ON average_salary.skill_id = skills_demand.skill_id
WHERE
    demand_count > 10
ORDER BY
    average_salary DESC
LIMIT 25;
```
The optimal skills, according to this query, are watson, slack, rshiny, notion, and neo4j, with associated average salaries ranging from $163k to $187k. This query suffers from a similar limitation, though, since high paying skills that are also necessary for lower paying jobs get penalized. Further, the high-demand skills with lower average salaries are often necessary for higher-paying skills. 
## What I Learned
Technical skills I learned in this process include crafting complex queries in SQL, including the use of CTEs and "group by" functions. Additionally, I got a sense of how similar queries can yeild different results depending on the details. 
## Conclusions
From this analysis, I learned that while Python, SQL, and R are high-demand skills used in high-paying jobs, they aren't the highest paying skills due to their wide applicability. Nevertheless, SQL, Python, and R are a good foundation for beginning one's data science career path.