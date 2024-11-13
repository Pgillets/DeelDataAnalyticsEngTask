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
        acceptance_report.external_ref,
        acceptance_report.status,
        acceptance_report.source,
        acceptance_report.ref,
        acceptance_report.date_time,
        acceptance_report.state,
        chargeback_report.chargeback,
        acceptance_report.cvv_provided,
        acceptance_report.amount,
        acceptance_report.country,
        acceptance_report.currency,
        acceptance_report.rates
    FROM
        acceptance_report
    LEFT JOIN
        chargeback_report
        ON acceptance_report.external_ref = chargeback_report.external_ref
)

SELECT * FROM transactions
