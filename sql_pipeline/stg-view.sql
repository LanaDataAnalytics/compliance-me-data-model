CREATE OR REPLACE VIEW `compliance-me-data-model.stg_fts_raw.v_stg_fts_typed` AS
SELECT
    -- Identifiers
    TRIM(reference_of_the_legal_commitment__lc_) AS grant_id,
    TRIM(reference__budget_) AS budget_code,
    TRIM(name_of_beneficiary) AS beneficiary_name_raw,
    TRIM(vat_number_of_beneficiary) AS vat_number,
    
    -- Geographic Dimensions
    TRIM(city) AS city,
    TRIM(beneficiary_country) AS country,
    TRIM(nuts2) AS nuts2_region,
    TRIM(geographical_zone) AS geographical_zone,
    
    -- Institutional Compliance Flags (Native BOOLEAN)
    coordinator AS is_coordinator,
    non_governmental_organisation__ngo_ AS is_ngo,
    not_for_profit_organisation__nfpo_ AS is_nfpo,
    
    -- Programme Context
    TRIM(programme_name) AS programme_name,
    TRIM(funding_type) AS funding_type,
    TRIM(management_type) AS management_type,

    -- Temporal Context (Native INTEGER)
    year AS commitment_year,

    -- Financial Metrics (Native FLOAT)
    beneficiary___s_contracted_amount__eur_ AS amount_committed_eur,
    beneficiary___s_estimated_consumed_amount__eur_ AS amount_consumed_eur

FROM `compliance-me-data-model.stg_fts_raw.stg_fts_raw`;