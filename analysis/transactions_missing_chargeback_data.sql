WITH
transactions AS (
    SELECT
        ref,
        chargeback,
        date_time
    FROM {{ ref('fct_globepay_transactions') }}
),

transactions_missing_chargeback_data AS (
    SELECT
        ref,
        date_time
    FROM transactions
    WHERE chargeback IS null
)

SELECT * FROM transactions_missing_chargeback_data
