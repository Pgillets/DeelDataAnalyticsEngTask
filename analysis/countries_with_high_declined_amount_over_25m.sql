WITH
transactions AS (
    SELECT
        ref,
        state,
        country,
        amount_in_usd,
        date_time
    FROM {{ ref('fct_globepay_transactions') }}
    WHERE upper(state) = 'DECLINED'
),

countries_declined_amount AS (
    SELECT
        country,
        sum(amount_in_usd) AS declined_amount
    FROM transactions
    GROUP BY country
),

countries_with_high_declined_amount AS (
    SELECT
        country,
        declined_amount
    FROM countries_declined_amount
    WHERE declined_amount > 25000000
)

SELECT * FROM countries_with_high_declined_amount
