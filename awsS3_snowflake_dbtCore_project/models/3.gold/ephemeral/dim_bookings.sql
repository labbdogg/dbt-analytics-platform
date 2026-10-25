{{
    config(
    materialized = 'ephemeral'
    )
}}


SELECT
    ROW_NUMBER() OVER(ORDER BY BOOKING_ID) AS DIM_BOOKING_SK,
    BOOKING_ID,
    BOOKING_DATE,
    BOOKING_STATUS,
    CREATED_AT
FROM
    {{ ref('one_big_table') }}