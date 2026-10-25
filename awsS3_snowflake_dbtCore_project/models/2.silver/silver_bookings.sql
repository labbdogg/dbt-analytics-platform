{{ config(
    materialized='incremental',
    unique_key='BOOKING_ID'
) }}
-- Adding unique_key='id' enables upsert behavior for incremental models by updating existing records with matching IDs and inserting new records

SELECT  
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE,
    {{ multiply ('NIGHTS_BOOKED', 'BOOKING_AMOUNT', 2)}} + CLEANING_FEE + SERVICE_FEE AS TOTAL_AMOUNT,
    SERVICE_FEE,
    CLEANING_FEE,
    BOOKING_STATUS,
    CREATED_AT
FROM
    {{ ref ('bronze_bookings')}}