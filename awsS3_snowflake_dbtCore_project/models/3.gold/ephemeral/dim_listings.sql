{{
    config(
    materialized = 'ephemeral'
    )
}}


WITH LISTINGS AS (
    SELECT
        ROW_NUMBER() OVER(ORDER BY LISTING_ID) AS DIM_LISTINGS_SK,
        *
    FROM
   ( 
    SELECT DISTINCT
        LISTING_ID,
        PROPERTY_TYPE,
        ROOM_TYPE,
        CITY,
        COUNTRY,
        ACCOMMODATES,
        BEDROOMS,
        BATHROOMS,
        PRICE_PER_NIGHT_TAG,
        LISTING_CREATED_AT
    FROM
        {{ ref('one_big_table') }}
 )
)

SELECT * FROM LISTINGS



