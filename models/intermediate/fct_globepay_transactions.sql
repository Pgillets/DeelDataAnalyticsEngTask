{{ config(
    materialized="table",
    tags=["globepay"]
) }}

WITH
acceptance_report AS (
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
        {{ ref( 'stg_globepay_report_acceptance' ) }}
),

chargeback_report AS (
    SELECT
        external_ref,
        status,
        source,
        chargeback
    FROM
        {{ ref( 'stg_globepay_report_chargeback' ) }}
),

transactions AS (
    SELECT
        acc.external_ref,
        acc.status,
        acc.source,
        acc.ref,
        acc.date_time,
        acc.state,
        cha.chargeback,
        acc.cvv_provided,
        acc.amount,
        acc.country,
        acc.currency,
        parse_json(acc.rates)[acc.currency]::FLOAT
            AS currency_rate_used,
        round(acc.amount / currency_rate_used, 2)::NUMBER(38, 2)
            AS amount_in_usd
    FROM
        acceptance_report AS acc
    LEFT JOIN
        chargeback_report AS cha
        ON acc.external_ref = cha.external_ref
)

SELECT * FROM transactions
