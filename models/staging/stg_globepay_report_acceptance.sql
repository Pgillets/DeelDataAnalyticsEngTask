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
        ref,
        date_time,
        state,
        cvv_provided,
        amount,
        country,
        currency,
        rates
    FROM
        {{ source('globepay', 'ACCEPTANCE') }}
)

SELECT * FROM source_data
