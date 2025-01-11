
SELECT 
    first_quarter_jobs.job_title_short,
    first_quarter_jobs.job_location,
    first_quarter_jobs.job_posted_date::DATE,
    first_quarter_jobs.salary_year_avg
FROM ( 
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS first_quarter_jobs

WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'