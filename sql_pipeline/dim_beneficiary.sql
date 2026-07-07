CREATE OR REPLACE TABLE `compliance-me-data-model.stg_fts_raw.dim_beneficiary` AS

WITH distinct_partners AS (
    SELECT DISTINCT
        beneficiary_name_raw,
        vat_number,
        country,
        city,
        nuts2_region,
        is_ngo,
        is_nfpo
    FROM `compliance-me-data-model.stg_fts_raw.v_stg_fts_typed`
    WHERE beneficiary_name_raw IS NOT NULL
)

SELECT
    GENERATE_UUID() AS beneficiary_id, -- Relational surrogate key
    beneficiary_name_raw,
    UPPER(TRIM(beneficiary_name_raw)) AS beneficiary_name_clean, 
    vat_number,
    UPPER(TRIM(country)) AS country_clean,
    UPPER(TRIM(city)) AS city_clean,
    nuts2_region,
    -- Flagging institutional status clearly
    CASE WHEN UPPER(is_ngo) = 'YES' THEN TRUE ELSE FALSE END AS is_ngo,
    CASE WHEN UPPER(is_nfpo) = 'YES' THEN TRUE ELSE FALSE END AS is_nfpo
FROM distinct_partners;