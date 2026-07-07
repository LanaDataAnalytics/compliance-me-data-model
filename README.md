# EU Financial Transparency System (FTS) Pipeline

## Project Overview
This repository contains an end-to-end ELT pipeline engineered to ingest, clean, and model European Union financial data. The architecture establishes a reliable Single Source of Truth (SSOT) to monitor grant absorption rates, analyze institutional spending patterns, and isolate high-risk compliance variances.

## Tableau Live Dashboard
[View the Interactive Compliance & Risk Dashboard](https://public.tableau.com/views/fts-compliance-me-data-model/Dashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Architecture
- **Ingestion & Processing:** Python (Pandas) utilizing strict Regex sanitization for financial data integrity.
- **Data Warehouse:** Google BigQuery for relational modeling and Star Schema implementation.
- **Business Intelligence:** Tableau for interactive risk monitoring and executive KPI reporting.

## Key Technical Implementations
- **Regex-Driven Sanitization:** Executed strict regular expression logic to neutralize currency formatting inconsistencies (e.g., non-breaking spaces, varying European decimal standards) prior to database load, ensuring strictly typed numeric pipelines.
- **SSOT Engineering:** Developed a resilient staging layer using COALESCE logic to handle intermittent nulls in beneficiary-specific contracted amounts by defaulting to total commitment values.
- **Risk Engine Modeling:** Engineered a proprietary high_risk_variance_flag within the SQL Fact layer (threshold: >€100k committed with <85% absorption). Offloading this logic to the warehouse optimizes BI performance and enforces a consistent compliance definition across all reporting layers.

## Repository Structure

- `stg-view.sql` : Staging view implementing SSOT fallback logic dimensions
- `dim_beneficiary.sql` : De-duplicated master entity records
- `dim_programme.sql` : Categorical programme hierarchy
- `fact_financial_execution.sql` : Fact table executing the risk-flagging engine
