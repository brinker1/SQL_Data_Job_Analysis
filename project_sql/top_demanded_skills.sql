/*
Question: most in demand skills for data scientist?
    -join job postings to skills tables
    -identify top 5 skills for data scientist
    -include job count
Reason: use larger pool of job data to see most popular skills
*/

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

