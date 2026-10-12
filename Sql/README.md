# Data Engineer Job Market Analysis | SQL & PostgreSQL

![SQL](https://img.shields.io/badge/SQL-Analysis-336791?style=flat&logo=postgresql&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![VS Code](https://img.shields.io/badge/Editor-VS%20Code-007ACC?style=flat&logo=visualstudiocode&logoColor=white)
![Status](https://img.shields.io/badge/Project-Completed-success?style=flat)

An exploratory data analysis of the data engineering job market using SQL and PostgreSQL. The project examines which skills employers request most often, which skills are associated with higher median salaries, and how demand and compensation can be combined into a single ranking.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Business Questions](#business-questions)
- [Key Findings](#key-findings)
- [Technical Approach](#technical-approach)
- [Database Schema](#database-schema)
- [SQL Analysis](#sql-analysis)
- [Database Migration](#database-migration)
- [Repository Structure](#repository-structure)
- [How to Run the Project](#how-to-run-the-project)
- [Limitations and Interpretation](#limitations-and-interpretation)
- [Conclusion](#conclusion)

---

## Project Overview

Data engineering spans programming languages, cloud platforms, processing frameworks, orchestration tools, and infrastructure. Seeing how these skills appear in job ads, and how the associated salaries differ, helps prioritise what to learn.

This project analyses a dataset of job postings, companies, and job-to-skill associations. The data was originally hosted in MotherDuck and migrated to a local PostgreSQL database. Three analytical SQL queries cover skill demand, salary, and a combined demand-and-salary ranking.

| Component | Description |
|---|---|
| Objective | Analyse skill demand and salary patterns in the data engineering job market |
| Database | PostgreSQL (`data_jobs`) |
| Data model | Relational schema with fact, dimension, and bridge tables |
| Source platform | MotherDuck |
| Analysis | Three analytical SQL queries |
| Tooling | Visual Studio Code, `psql`, Git and GitHub |

**Imported tables**

| Table | Rows |
|---|---:|
| `job_postings_fact` | 1,615,930 |
| `company_dim` | 215,940 |
| `skills_dim` | 262 |
| `skills_job_dim` | 7,193,426 |
| **Total** | **9,025,558** |

These counts describe the imported tables, not the number of Data Engineer postings used in each analysis.

---

## Business Questions

1. **Which skills are most in demand?** Identify the most frequently requested skills in Data Engineer postings, focusing on remote roles.
2. **Which skills are associated with the highest salaries?** Calculate median annual salary per skill and compare it with the number of associated postings.
3. **Which skills balance demand and salary best?** Combine a log-transformed demand metric with median salary to produce a relative ranking.

---

## Key Findings

### 1. Most In-Demand Skills

Top ten skills in remote Data Engineer postings.

| Rank | Skill | Job postings |
|---:|---|---:|
| 1 | SQL | 29,221 |
| 2 | Python | 28,776 |
| 3 | AWS | 17,823 |
| 4 | Azure | 14,143 |
| 5 | Spark | 12,799 |
| 6 | Airflow | 9,996 |
| 7 | Snowflake | 8,639 |
| 8 | Databricks | 8,183 |
| 9 | Java | 7,267 |
| 10 | GCP | 6,446 |

- **SQL and Python lead by a wide margin**, each well ahead of the next-ranked skill.
- **Cloud platforms are prominent:** AWS and Azure rank third and fourth, and GCP also makes the top ten.
- **Processing and orchestration matter:** Spark and Airflow both rank in the top six.
- **Modern data platforms are represented:** Snowflake and Databricks appear in the top ten.

**Implication:** SQL and Python are strong foundations. Cloud, processing, and orchestration tools are useful complements.

### 2. Highest-Paying Skills

Skills ranked by median annual salary (USD, as reported in the dataset).

| Skill | Median annual salary | Job postings |
|---|---:|---:|
| Rust | $210,000 | 232 |
| Terraform | $184,000 | 3,248 |
| Golang | $184,000 | 912 |
| Spring | $175,500 | 364 |
| Neo4j | $170,000 | 277 |
| GDPR | $169,616 | 582 |
| Zoom | $168,438 | 127 |
| GraphQL | $167,500 | 445 |
| Mongo | $162,250 | 265 |
| FastAPI | $157,500 | 204 |
| Kubernetes | $150,500 | 4,202 |
| Airflow | $150,000 | 9,996 |

*Selected rows from the 25 highest-paying skills returned by the query.*

- **Rust has the highest median salary** ($210,000), but with comparatively few associated postings.
- **Terraform pairs high pay with substantial volume:** $184,000 median across 3,248 postings.
- **Kubernetes and Airflow stand out for volume**, with medians of $150,500 and $150,000.
- **Golang, GraphQL, Neo4j, and FastAPI** also rank among higher-paying skills, with smaller posting counts.

**Implication:** The highest-paying skill is not necessarily the one with the most opportunities, so salary and demand should be read together.

### 3. Optimal Skills: Demand vs. Salary

A project-defined score combining median salary with the natural log of demand.

| Rank | Skill | Median salary | Demand count | Optimal score |
|---:|---|---:|---:|---:|
| 1 | Terraform | $184,000 | 193 | 0.98 |
| 2 | Python | $135,000 | 1,133 | 0.95 |
| 3 | AWS | $137,320 | 783 | 0.92 |
| 4 | SQL | $130,000 | 1,128 | 0.91 |
| 5 | Airflow | $150,000 | 386 | 0.90 |
| 6 | Spark | $140,000 | 503 | 0.87 |
| 7 | Kafka | $145,000 | 292 | 0.83 |
| 8 | Snowflake | $135,500 | 438 | 0.83 |
| 9 | Azure | $128,000 | 475 | 0.79 |
| 10 | Java | $135,000 | 303 | 0.77 |

*Selected rows from the 25 skills returned by the query.*

- **Terraform ranks first** (0.98), driven by its $184,000 median.
- **Python and SQL remain attractive foundations**, each with over 1,100 postings and medians of $135,000 and $130,000.
- **AWS combines strong demand and pay** (783 postings, about $137,320 median).
- **Airflow, Spark, and Kafka** are notable complements, with medians between $140,000 and $150,000.
- **Azure and Snowflake** also place in the top ten.

**Implication:** The results favour building a combination of programming, cloud, processing, orchestration, and infrastructure skills rather than chasing salary alone.

The optimal score is defined by this project's SQL query. It is useful for comparing skills under the query's assumptions, but it is not a universal measure of career value or a guarantee of future pay.

---

## Technical Approach

1. **Extract:** Export the four source tables from MotherDuck.
2. **Migrate:** Import the CSV files into a local PostgreSQL database.
3. **Model:** Define primary keys and foreign-key relationships.
4. **Validate:** Check row counts and test for orphaned foreign-key references.
5. **Query:** Write SQL using joins, filtering, aggregation, and statistical functions.
6. **Analyse:** Compare demand, median salary, and the combined optimal score.
7. **Interpret:** Translate results into guidance for skill development.

---

## Database Schema

![Data Warehouse Schema](../../Resources/images/1_2_Data_Warehouse.png)

The schema consists of one fact table, two dimension tables, and one bridge table.

| Table | Role | Key columns |
|---|---|---|
| `job_postings_fact` | Fact table with job details | `job_id`, `company_id`, `job_title_short`, `job_work_from_home`, `salary_year_avg` |
| `company_dim` | Company dimension | `company_id`, `name` |
| `skills_dim` | Skill dimension | `skill_id`, `skills`, `type` |
| `skills_job_dim` | Bridge between jobs and skills | `job_id`, `skill_id` |

**Relationships**

- `job_postings_fact.company_id` → `company_dim.company_id`
- `skills_job_dim.job_id` → `job_postings_fact.job_id`
- `skills_job_dim.skill_id` → `skills_dim.skill_id`

The bridge table lets each posting list many skills and each skill appear in many postings, so queries can aggregate by skill without duplicating the skill catalogue or storing multiple skills in one row.

---

## SQL Analysis

### Query 1: Top Demanded Skills

**File:** [`01_top_demanded_skills.sql`](./01_top_demanded_skills.sql)

**Purpose:** Find the ten most requested skills in remote Data Engineer postings.

**Techniques:** multi-table `INNER JOIN`, boolean and categorical filtering, `COUNT()`, `GROUP BY`, `ORDER BY`, `LIMIT`.

### Query 2: Top Paying Skills

**File:** [`02_top_paying_skills.sql`](./02_top_paying_skills.sql)

**Purpose:** Find skills with the highest median annual salaries and report their posting counts.

**Techniques:** joining job, bridge, and skill tables; excluding missing salaries; grouped statistics; top-N selection.

Median salary is calculated with PostgreSQL's ordered-set aggregate:

```sql
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY salary_year_avg)
```

### Query 3: Optimal Skills

**File:** [`03_optimal_skills.sql`](./03_optimal_skills.sql)

**Purpose:** Rank skills using a combined demand-and-salary metric.

**Techniques:** common table expressions (`WITH`), demand and salary aggregation, `LN()` transformation, calculated metrics, joining intermediate results.

The score's interpretation depends on the formula, normalisation, filters, and dataset used in the script.

---

## Database Migration

The four tables were exported from MotherDuck and imported into a local PostgreSQL database named `data_jobs`. The migration included:

- Creating the database and tables
- Importing CSV files with `\copy`
- Adding primary keys and foreign-key constraints
- Checking for orphaned references
- Indexing commonly joined columns
- Running `ANALYZE` to refresh planner statistics

This gives a local environment for running the queries independently of the original hosted database.

---

## Repository Structure

```text
1_EDA/
├── 01_top_demanded_skills.sql
├── 02_top_paying_skills.sql
├── 03_optimal_skills.sql
└── README.md
```

The SQL files contain the queries; this README documents the database, methodology, and findings. The PostgreSQL database itself is managed by the server and is not committed to the repository.

---

## How to Run the Project

### Prerequisites

- PostgreSQL installed and running
- A `data_jobs` database populated with the four tables
- VS Code with a PostgreSQL extension, or the `psql` client
- The three SQL scripts from this repository

### 1. Connect to PostgreSQL

```bash
psql -U postgres -h localhost -d data_jobs
```

Enter your PostgreSQL password when prompted. To connect through VS Code instead, use:

| Setting | Value |
|---|---|
| Server | `localhost` |
| Port | `5432` |
| User | `postgres` |
| Database | `data_jobs` |
| Password | Your configured password |

### 2. Verify the tables

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

You should see `company_dim`, `job_postings_fact`, `skills_dim`, and `skills_job_dim`.

### 3. Run the queries

Execute the scripts in order against `data_jobs`:

1. `01_top_demanded_skills.sql`
2. `02_top_paying_skills.sql`
3. `03_optimal_skills.sql`

> **Note:** The scripts do not download or recreate the dataset. The database must already contain the imported data.

---

## Limitations and Interpretation

These results describe this dataset and these query definitions. They are not universal estimates of the data engineering job market.

- **Posting counts are not unique job counts.** A posting can list several skills, and counts depend on how each query joins and aggregates the tables.
- **Each query uses different filters.** Demand counts in the optimal-skills query differ from those in the demand query (for example, Python: 28,776 vs. 1,133), so figures should only be compared within the same query.
- **Salary data is incomplete.** Medians use only records with usable annual salary values.
- **A median is not a guaranteed salary.** Pay varies by location, seniority, employer, currency, and posting mix.
- **Small samples are less reliable.** Skills such as Rust and Zoom have relatively few postings, so their medians are less stable.
- **The optimal score is project-defined.** Rankings depend on the chosen formula, normalisation, and filters.
- **The analysis is descriptive.** It shows associations, not that learning a skill causes higher pay.

---

## Conclusion

This project uses PostgreSQL and SQL to analyse a large relational job market dataset. SQL and Python lead in posting frequency, selected technologies such as Terraform and Rust command high median salaries, and the combined demand-and-salary score produces a different ranking than demand alone.

It also covers the supporting database work: migrating from MotherDuck to PostgreSQL, enforcing relational constraints, validating integrity, and indexing join columns.

The result is a reproducible analysis answering a practical question: **which technical skills are most relevant to the data engineering job market, and how does their observed demand relate to compensation?**
