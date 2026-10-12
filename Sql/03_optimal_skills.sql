/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/


SELECT
    sd.skills,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY jpf.salary_year_avg)::numeric,
        1
    ) AS median_salary,
    COUNT(DISTINCT jpf.job_id) AS demand_count,
    ROUND(LN(COUNT(jpf.*))::numeric, 1) AS ln_demand_count,
    ROUND(
    (
        LN(COUNT(jpf.*))
        * PERCENTILE_CONT(0.5)
          WITHIN GROUP (ORDER BY jpf.salary_year_avg)
        / 1000000 
    )::numeric,2
         ) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_work_from_home IS TRUE
GROUP BY
    sd.skills
HAVING
    COUNT(DISTINCT jpf.job_id) >= 100
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
Here's a breakdown of the most optimal skills for Data Engineers, based on both high demand and high salaries:

Top Skills by Optimal Score:**
- Terraform leads the list with a median salary of $184K and 193 job postings, achieving the highest optimal score of 0.97.
- Python and SQL dominate demand, with 1,133 and 1,128 job postings, respectively, and median salaries of $135K and $130K.
- AWS stands out with 783 postings and a median salary of approximately $137.3K, while Spark (503 postings, $140K) and Airflow (386 postings, $150K) are also strong choices.
- Kafka offers a median salary of $145K across 292 postings, while Snowflake combines a $135.5K median salary with 438 postings.
- Azure has 475 postings and a median salary of $128K, making it another relevant cloud technology.

DevOps & Engineering Tools:**
- Airflow ($150K), Kubernetes ($150.5K), and Docker ($135K) offer competitive median salaries for data engineering roles.
- Git ($140K across 208 postings) and GitHub ($135K across 127 postings) are useful tools for version control and collaborative development.
- Terraform's high optimal score highlights the value of infrastructure-as-code skills, even though its demand count is lower than that of Python and SQL.

Programming Languages:**
- Java has 303 postings and a median salary of $135K, while Scala has 247 postings and a median salary of approximately $137.3K.
- Go offers a median salary of $140K across 113 postings.
- Python remains particularly attractive because it combines high demand with a competitive median salary.
- R has 133 postings and a median salary of approximately $134.8K.

Databases, Cloud & Big Data Technologies:**
- Spark ($140K across 503 postings), PySpark ($140K across 152 postings), Hadoop ($135K across 198 postings), and NoSQL ($134.4K across 193 postings) are relevant technologies for data processing and engineering.
- Databricks has 266 postings and a median salary of $132.75K, while Redshift has 274 postings and a median salary of $130K.
- GCP offers a median salary of $136K across 196 postings, while BigQuery has 123 postings and a median salary of $135K.

Summary:

The optimal scores suggest that Terraform, Python, AWS, and SQL are particularly attractive when balancing salary and demand. Terraform ranks first with a score of 0.97, followed by Python at 0.95, AWS at 0.91, and SQL at 0.91. However, Python and SQL have substantially more job postings than Terraform, making them valuable foundational skills for accessing a wider range of data engineering opportunities.

These results suggest that a balanced skill set combining programming (Python and SQL), cloud platforms (AWS, Azure, or GCP), data processing (Spark and PySpark), and infrastructure tools (Terraform and Kubernetes) can be a strategic approach to developing a competitive data engineering profile.

Results:

┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │          193 │             5.3 │          0.98 │
│ python     │      135000.0 │         1133 │             7.0 │          0.95 │
│ aws        │      137320.3 │          783 │             6.7 │          0.92 │
│ sql        │      130000.0 │         1128 │             7.0 │          0.91 │
│ airflow    │      150000.0 │          386 │             6.0 │           0.9 │
│ spark      │      140000.0 │          503 │             6.2 │          0.87 │
│ kafka      │      145000.0 │          292 │             5.7 │          0.83 │
│ snowflake  │      135500.0 │          438 │             6.1 │          0.83 │
│ azure      │      128000.0 │          475 │             6.2 │          0.79 │
│ java       │      135000.0 │          303 │             5.7 │          0.77 │
│ scala      │      137290.5 │          247 │             5.5 │          0.76 │
│ git        │      140000.0 │          208 │             5.3 │          0.75 │
│ kubernetes │      150500.0 │          147 │             5.0 │          0.75 │
│ databricks │      132750.0 │          266 │             5.6 │          0.74 │
│ redshift   │      130000.0 │          274 │             5.6 │          0.73 │
│ gcp        │      136000.0 │          196 │             5.3 │          0.72 │
│ hadoop     │      135000.0 │          198 │             5.3 │          0.72 │
│ nosql      │      134415.0 │          193 │             5.3 │          0.71 │
│ pyspark    │      140000.0 │          152 │             5.0 │           0.7 │
│ docker     │      135000.0 │          144 │             5.0 │          0.67 │
│ r          │      134775.0 │          133 │             4.9 │          0.66 │
│ go         │      140000.0 │          113 │             4.7 │          0.66 │
│ github     │      135000.0 │          127 │             4.8 │          0.65 │
│ bigquery   │      135000.0 │          123 │             4.8 │          0.65 │
│ postgresql │      122500.0 │          129 │             4.9 │          0.60 │
├────────────┴───────────────┴──────────────┴─────────────────┴───────────────┤
│ 25 rows                                                           5 columns │
└─────────────────────────────────────────────────────────────────────────────┘

*/