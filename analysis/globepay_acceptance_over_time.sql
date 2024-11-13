WITH
transactions AS (
    SELECT
        ref,
        state,
        date_time
    FROM {{ ref('fct_globepay_transactions') }}
),

state_count_per_date AS (
    SELECT
        date(date_time) AS transaction_date,
        count(*) AS total_transactions,
        count_if(upper(state) = 'ACCEPTED') AS accepted_transactions,
        count_if(upper(state) = 'DECLINED') AS rejected_transactions
    FROM transactions
    GROUP BY date(date_time)
),

acceptance_rate_per_date AS (
    SELECT
        transaction_date,
        total_transactions,
        accepted_transactions,
        rejected_transactions,
        round(accepted_transactions / total_transactions::float, 2)
            AS acceptance_rate
    FROM state_count_per_date
    ORDER BY transaction_date
)

SELECT * FROM acceptance_rate_per_date
