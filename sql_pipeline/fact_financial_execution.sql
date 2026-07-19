CREATE OR REPLACE TABLE `compliance-me-data-model.stg_fts_raw.fact_financial_execution` AS

SELECT
    -- 1. Generating a unique ID for this specific financial execution record
    GENERATE_UUID() AS execution_id,
    
    -- 2. Core natural keys from the raw data
    stg.grant_id,
    stg.commitment_year,

    -- 3. Foreign Keys linking to our Dimension tables
    b.beneficiary_id,
    p.programme_id,

    -- 4. Base Financial Metrics
    stg.amount_committed_eur,
    -- Using IFNULL to handle cases where consumed amount is blank (meaning 0 spent)
    IFNULL(stg.amount_consumed_eur, 0) AS amount_consumed_eur,

    -- 5. Engineered M&E Metrics (The Business Intelligence layer)
    
    -- Variance: How much money is left on the table?
    (stg.amount_committed_eur - IFNULL(stg.amount_consumed_eur, 0)) AS variance_amount_eur,
    
    -- Absorption Rate: What percentage of the promised funds did they actually use?
    -- NULLIF prevents division-by-zero errors if committed amount is somehow 0
    ROUND((IFNULL(stg.amount_consumed_eur, 0) / NULLIF(stg.amount_committed_eur, 0)), 4) AS absorption_rate,

    -- 6. The High-Risk Flag
    -- Flags any execution where the grant is over €100k AND they failed to absorb more than 15% of it
    CASE 
        WHEN stg.amount_committed_eur >= 100000 
             AND (IFNULL(stg.amount_consumed_eur, 0) / NULLIF(stg.amount_committed_eur, 0)) < 0.85 
        THEN TRUE 
        ELSE FALSE 
    END AS high_risk_variance_flag

FROM `compliance-me-data-model.stg_fts_raw.v_stg_fts_typed` AS stg

-- Joining the Beneficiary Dimension to grab the ID
LEFT JOIN `compliance-me-data-model.stg_fts_raw.dim_beneficiary` AS b
    ON stg.beneficiary_name_raw = b.beneficiary_name_raw
    AND stg.country = b.country
    AND stg.city = b.city
    AND stg.vat_number = b.vat_number

-- Joining the Programme Dimension to grab the ID
LEFT JOIN `compliance-me-data-model.stg_fts_raw.dim_programme` AS p
    ON stg.programme_name = p.programme_name
    AND stg.budget_code = p.budget_code;