CREATE OR REPLACE TABLE `compliance-me-data-model.fts_me_project.dim_programme` AS

WITH distinct_programmes AS (
    -- Step A: Isolate every unique combination of funding details
    SELECT DISTINCT
        programme_name,
        budget_code,
        funding_type,
        management_type
    FROM `compliance-me-data-model.fts_me_project.v_stg_fts_typed`
    WHERE programme_name IS NOT NULL OR budget_code IS NOT NULL
)

-- Step B: Assign a primary key for the relational join
SELECT
    GENERATE_UUID() AS programme_id, 
    programme_name,
    budget_code,
    funding_type,
    management_type
FROM distinct_programmes;