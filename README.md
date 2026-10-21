<p align="center">
  <img src="https://raw.githubusercontent.com/dbt-labs/dbt-core/fa1ea14ddfb1d5ae319d5141844910dd53ab2834/etc/dbt-core.svg" alt="dbt logo" width="300"/>
</p>

<h1 align="center">End-to-End Analytics Engineering Pipeline</h1>

<p align="center">
  A production-style analytics engineering project built with
  <strong>dbt</strong>, <strong>Snowflake</strong>, and <strong>AWS S3</strong>.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/dbt-FF694B?logo=dbt&logoColor=white" alt="dbt"/>
  <img src="https://img.shields.io/badge/Snowflake-29B5E8?logo=snowflake&logoColor=white" alt="Snowflake"/>
  <img src="https://img.shields.io/badge/AWS_S3-569A31?logo=amazons3&logoColor=white" alt="AWS S3"/>
</p>

---

## Overview

This project implements an end-to-end analytics engineering pipeline using the
**Medallion Architecture**. Raw data lands in AWS S3, is loaded into Snowflake,
transformed with dbt, and published as a **Star Schema** for analytics and BI.

**Highlights**

- Metadata-driven, modular transformations
- Incremental models and reusable Jinja macros
- Star Schema with fact and dimension tables
- Automated data quality tests
- SCD Type 2 history tracking via dbt snapshots

## Architecture

<table align="center">
  <tr>
    <td align="center" width="200">
      <img src="https://raw.githubusercontent.com/awslabs/aws-icons-for-plantuml/main/dist/Storage/SimpleStorageService.png" alt="AWS S3" height="64"/>
    </td>
    <td align="center" width="110"><sub>extract &amp; load</sub><br/>➜</td>
    <td align="center" width="200">
      <img src="https://cdn.simpleicons.org/snowflake/29B5E8" alt="Snowflake" height="64"/>
    </td>
    <td align="center" width="110"><sub>transform</sub><br/>➜</td>
    <td align="center" width="200">
      <img src="https://raw.githubusercontent.com/dbt-labs/dbt-core/fa1ea14ddfb1d5ae319d5141844910dd53ab2834/etc/dbt-core.svg" alt="dbt" height="64"/>
    </td>
  </tr>
  <tr>
    <td align="center"><strong>AWS S3</strong></td>
    <td></td>
    <td align="center"><strong>Snowflake</strong></td>
    <td></td>
    <td align="center"><strong>dbt</strong></td>
  </tr>
  <tr>
    <td align="center"><sub>Source<br/>Raw files landing zone</sub></td>
    <td></td>
    <td align="center"><sub>Warehouse<br/>Hosts Bronze, Silver &amp; Gold</sub></td>
    <td></td>
    <td align="center"><sub>Transformation<br/>Models, tests &amp; snapshots</sub></td>
  </tr>
  <tr>
    <td colspan="5" align="center">
      <br/>
      <img src="https://cdn.simpleicons.org/git/F05032" alt="Git" height="28"/>
      &nbsp;&nbsp;
      <img src="https://cdn.simpleicons.org/github/8B949E" alt="GitHub" height="28"/>
      <br/>
      <sub><strong>Git / GitHub</strong> · Version control and development (VS Code / GitHub Codespaces)</sub>
    </td>
  </tr>
</table>

### Medallion Layers

| Layer | Purpose | Models |
|-------|---------|--------|
| 🥉 **Bronze** | Raw ingestion, minimal transformation, history preserved | `bronze_bookings`, `bronze_hosts`, `bronze_listings` |
| 🥈 **Silver** | Cleaned, typed, standardized, with business logic | `silver_bookings`, `silver_hosts`, `silver_listings` |
| 🥇 **Gold** | Business-ready Star Schema (facts and dimensions) | `fact`, `obt`, ephemeral helper models |

## Data Source

<!-- Fill this in -->
- **Dataset:** [describe the dataset and its entities]
- **Ingestion:** [e.g. S3 external stage + `COPY INTO`, or Snowpipe]

## Project Structure

```text
.
├── models/
│   ├── sources/            # Source definitions (sources.yml)
│   ├── bronze/             # Raw layer
│   ├── silver/             # Cleaned layer
│   └── gold/               # Star Schema + ephemeral/ helper models
├── macros/                 # Reusable Jinja/SQL (schema naming, tagging, helpers)
├── snapshots/              # SCD Type 2 configurations
├── tests/                  # Singular data quality tests
├── analyses/               # Ad-hoc exploration queries
├── seeds/                  # Static reference data
└── dbt_project.yml
```

## Key Features

**Incremental loading.** Large models process only new or changed rows:

```sql
{{ config(materialized='incremental') }}

select * from {{ source('staging', 'bookings') }}
{% if is_incremental() %}
  where created_at > (select coalesce(max(created_at), '1900-01-01') from {{ this }})
{% endif %}
```

**Reusable macros.** Business logic lives in macros instead of being copy-pasted across models.

**Dynamic SQL with Jinja.** Loops and config lists keep joins in the Gold layer maintainable.

**Slowly Changing Dimensions (Type 2).** Snapshots track historical changes with valid-from / valid-to dates for point-in-time analysis.

**Schema organization.** A custom `generate_schema_name` macro routes each layer to its own schema (`BRONZE`, `SILVER`, `GOLD`).

## Data Quality

- Not-null and unique key checks
- Referential integrity (relationships) tests
- Source data validation
- Custom business-rule tests in `tests/`

## Getting Started

**Prerequisites:** Python 3.9+, a Snowflake account, and access to the S3 data (or sample files).

```bash
git clone https://github.com/labbdogg/dbt-analytics-platform.git
cd dbt-analytics-platform
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\Activate.ps1
pip install dbt-snowflake
```

Add this to `~/.dbt/profiles.yml` (never commit credentials):

```yaml
dbt_analytics_platform:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <account_identifier>
      user: <user>
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      role: <role>
      warehouse: <warehouse>
      database: <database>
      schema: <schema>
      threads: 4
```

Run it:

```bash
dbt debug                               # verify connection
dbt build                               # models + tests + snapshots
dbt run --select bronze                 # or silver / gold
dbt run --full-refresh                  # rebuild incremental models
dbt docs generate && dbt docs serve     # docs and lineage
```

## Data Lineage

dbt builds a DAG of model dependencies automatically. Run
`dbt docs generate && dbt docs serve` to explore this project's lineage locally.

<p align="center">
  <img src="https://raw.githubusercontent.com/dbt-labs/dbt-core/6c6649f9129d5d108aa3b0526f634cd8f3a9d1ed/etc/dbt-dag.png" alt="Example dbt DAG" width="700"/>
  <br/>
  <em>Illustrative dbt DAG (source: dbt Labs)</em>
</p>

## Future Enhancements

- [ ] CI/CD with automated `dbt build` on pull requests
- [ ] Data quality dashboards and alerting
- [ ] BI layer on top of the Gold models

## Project Objective

Demonstrate how dbt can turn raw data into a reliable, scalable, business-ready
analytics layer using modular transformations, dimensional modeling, automated
testing, incremental processing, and historical tracking.