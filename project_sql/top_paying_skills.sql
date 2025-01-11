/*
Question: What are the top paying skills based on salary?
    -look at average salary associated with skills for Data Scientist
    -focus on roles with specified salaries (location irrelevant)
Reasoning: focus on most financially rewarding skills to hone
*/

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