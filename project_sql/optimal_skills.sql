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