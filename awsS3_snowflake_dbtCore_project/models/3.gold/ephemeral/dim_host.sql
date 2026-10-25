{{
    config(
    materialized = 'ephemeral'
    )
}}


WITH HOST AS (
    SELECT
        ROW_NUMBER() OVER(ORDER BY HOST_ID) AS DIM_HOST_SK,
        *
    FROM
   ( 
    SELECT DISTINCT
        HOST_ID,
        HOST_NAME,
        HOST_SINCE,
        IS_SUPERHOST,
        RESPONSE_RATE,
        RESPONSE_RATE_QUALITY,
        HOST_CREATED_AT,
    FROM
        {{ ref('one_big_table') }}
 )
)

SELECT * FROM HOST