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
        chargeback::BOOLEAN AS chargeback
    FROM
        {{ source('globepay', 'CHARGEBACK') }}
)

SELECT * FROM source_data
