{{ config(
    materialized="table",
    tags=["globepay"]
) }}

WITH
source_data AS (
    SELECT
        external_ref::VARCHAR AS external_ref,
        status::BOOLEAN AS status,
        source::VARCHAR AS source,
        ref::VARCHAR AS ref,
        date_time::TIMESTAMP_NTZ AS date_time,
        state::VARCHAR AS state,
        cvv_provided::BOOLEAN AS cvv_provided,
        amount::NUMBER(38, 2) AS amount,
        country::VARCHAR AS country,
        currency::VARCHAR AS currency,
        rates::VARCHAR AS rates
    FROM
        {{ source('globepay', 'ACCEPTANCE') }}
)

SELECT * FROM source_data
