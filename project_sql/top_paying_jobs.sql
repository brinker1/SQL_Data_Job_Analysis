/*
Question: What are the top paying jobs for Data Scientists?
    -Top 10 remote jobs
    -remove nulls, only focus on sallaried positions
Reason: offer insight into lucritive roles and skills for Data Scientists
*/

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
