/* SELECT * 
FROM DBT_ANALYTICS_PLATFORM_BUCKET.BRONZE.LISTINGS 
LIMIT 5
*/



/*
=============================================================================
DBT SOURCE RESOLUTION NOTE
=============================================================================
Using {{ source('raw', 'bookings') }} abstracts the physical location:

1. Looks up the source named 'raw' in sources.yml.
2. Retrieves its defined `database` (DBT_ANALYTICS_PLATFORM_BUCKET) and `schema` (BRONZE)[cite: 1].
3. Locates the target table identifier ('bookings')[cite: 1].
4. Compiles into the fully qualified path:
   DBT_ANALYTICS_PLATFORM_BUCKET.BRONZE.bookings

This keeps physical warehouse paths configurable in YAML without needing 
to refactor downstream SQL models when locations change.
=============================================================================
*/

{{ config(materialized = 'table')}}

SELECT *
FROM {{ source('raw', 'bookings') }}
LIMIT 5