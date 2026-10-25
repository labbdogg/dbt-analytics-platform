{% raw %}
/*

# MANUAL DEMO OF INCREMENTAL LOADING 

{% set incremental_flag = 1 %}
{% set incremental_column = 'CREATED_AT' %}

SELECT 
    *
FROM 
    {{ source('raw', 'listings') }}
{% if incremental_flag == 1 %}
    WHERE 
        {{ incremental_column }} > (
                SELECT 
                    COALESCE(
                            MAX(
                                {{ incremental_column }}
                                ), 
                            CAST('1900-01-01' AS TIMESTAMP)
                    ) 
                FROM {{ ref('bronze_listings') }} 
                -- FROM {{ this }} 
                
                
                FROM {{ this }} 
                
                ⚠️ WHY {{ this }} FAILS IN THE VS CODE PREVIEW ENGINE:
                The "dbt Power User" extension intercepts query previews and runs them as isolated,
                temporary objects. Because it isn't executing a formal 'dbt run', it overwrites
                the {{ this }} variable with a randomized temporary table string. Snowflake then 
                throws an error because that temporary object doesn't actually exist in your database.
                Using {{ ref('bronze_bookings') }} allows the preview window to resolve a stable path.

                ⚙️ WHAT {{ this }} ACTUALLY DOES IN DBT:
                In production execution (via 'dbt run'), {{ this }} points dynamically to the 
                target table being built (DBT_ANALYTICS_PLATFORM_BUCKET.MEDALLION_BRONZE.BRONZE_BOOKINGS).
                Using {{ this }} inside a model's own file prevents dbt from throwing a "Circular Dependency" 
                error during formal DAG compilation.
                
        )
{% endif %}

*/
{% endraw %}

{{
  config(
    materialized = 'incremental'
    )
}}

SELECT
    *
FROM
    {{ source('raw','listings') }}
{% if is_incremental() %}
  WHERE CREATED_AT >
                (
         SELECT 
            COALESCE(
                    MAX(
                        CREATED_AT
                        ), 
                    CAST('1900-01-01' AS TIMESTAMP)
            )
        FROM {{ this }}
)
{% endif %}