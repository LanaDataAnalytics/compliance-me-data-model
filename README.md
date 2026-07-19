# EU Financial Transparency System (FTS) Pipeline

## Project Overview
This repository contains an end-to-end ELT pipeline engineered to ingest, clean, and model European Union financial data. The architecture establishes a reliable Single Source of Truth (SSOT) to monitor grant absorption rates, analyze institutional spending patterns, and isolate high-risk compliance variances.

## Tableau Live Dashboard
[View the Interactive Compliance & Risk Dashboard](https://public.tableau.com/views/fts-compliance-me-data-model/Dashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Architecture
- **Entity Resolution & De-duplication:** Addressed highly fragmented institutional naming conventions (e.g., standardizing multiple variants of member state government bodies like Germany and Greece) within the SQL layer to ensure accurate macro-level volume aggregations in the BI layer.
- **Data Warehouse:** Google BigQuery for relational modeling and Star Schema implementation.
- **Business Intelligence:** Tableau for interactive risk monitoring and executive KPI reporting.

## Key Technical Implementations
- **Regex-Driven Sanitization:** Executed strict regular expression logic to neutralize currency formatting inconsistencies (e.g., non-breaking spaces, varying European decimal standards) prior to database load, ensuring strictly typed numeric pipelines.
- **SSOT Engineering & Validation:** Developed a resilient pipeline using COALESCE and IFNULL logic to handle intermittent missing values in beneficiary-specific contracted amounts by defaulting to total commitment values. This guarantees no nulls bypass the risk-engine thresholds.
- **Risk Engine Modeling:** Engineered a proprietary high_risk_variance_flag within the SQL Fact layer (threshold: >€100k committed with <85% absorption). Offloading this Boolean calculation to the warehouse optimizes BI performance.
- **Aggregate BI Logic:** Reconciled portfolio-wide KPI calculations by utilizing weighted aggregate ratios (SUM(Consumed) / SUM(Committed)) in the visualization layer, avoiding the mathematical pitfalls of row-level averages.

## Repository Structure

- `stg-view.sql` : Staging view implementing SSOT fallback logic dimensions
- `dim_beneficiary.sql` : Window-function and hardcoded entity resolution
- `dim_programme.sql` : Standardized categorical programme hierarchy
- `fact_financial_execution.sql` : Fact table executing the risk-flagging engine
