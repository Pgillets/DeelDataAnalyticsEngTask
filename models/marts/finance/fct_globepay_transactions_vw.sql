{{ config(
    materialized="view",
    tags=["globepay"]
) }}

SELECT * FROM {{ ref( "fct_globepay_transactions" ) }}
