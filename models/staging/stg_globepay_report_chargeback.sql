{{ config(
    materialized="table",
    tags=["globepay"]
) }}

WITH
source_data AS (
    SELECT
        external_ref,
        status,
        source,
        chargeback
    FROM
        {{ source('globepay', 'CHARGEBACK') }}
)

SELECT * FROM source_data
