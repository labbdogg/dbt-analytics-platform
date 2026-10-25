{% set configs = [
    {
        "table": "DBT_ANALYTICS_PLATFORM_BUCKET.MEDALLION_GOLD.ONE_BIG_TABLE",
        "columns": "ONE_BIG_TABLE.BOOKING_ID, ONE_BIG_TABLE.LISTING_ID, ONE_BIG_TABLE.HOST_ID, ONE_BIG_TABLE.TOTAL_AMOUNT, ONE_BIG_TABLE.SERVICE_FEE, ONE_BIG_TABLE.CLEANING_FEE, ONE_BIG_TABLE.PRICE_PER_NIGHT",
        "alias": "ONE_BIG_TABLE"
    }
] %}

SELECT
    {% for item in configs %}
        {{ item['columns'] }}{% if not loop.last %},{% endif %}
    {% endfor %}
FROM
    {{ configs[0]['table'] }} AS {{ configs[0]['alias'] }}
