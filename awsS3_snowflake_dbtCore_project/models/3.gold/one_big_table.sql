{% set configs = [
    {
        "table": "DBT_ANALYTICS_PLATFORM_BUCKET.MEDALLION_SILVER.SILVER_BOOKINGS",
        "columns": "SILVER_BOOKINGS.*",
        "alias": "SILVER_BOOKINGS" 
    },
    {
        "table": "DBT_ANALYTICS_PLATFORM_BUCKET.MEDALLION_SILVER.SILVER_LISTINGS",
        "columns": "SILVER_LISTINGS.HOST_ID, SILVER_LISTINGS.PROPERTY_TYPE, SILVER_LISTINGS.ROOM_TYPE, SILVER_LISTINGS.CITY, SILVER_LISTINGS.COUNTRY, SILVER_LISTINGS.ACCOMMODATES, SILVER_LISTINGS.BEDROOMS, SILVER_LISTINGS.BATHROOMS, SILVER_LISTINGS.PRICE_PER_NIGHT, SILVER_LISTINGS.PRICE_PER_NIGHT_TAG, SILVER_LISTINGS.CREATED_AT AS LISTING_CREATED_AT",
        "alias": "SILVER_LISTINGS",
        "join_condition": "SILVER_BOOKINGS.LISTING_ID = SILVER_LISTINGS.LISTING_ID"

    },
    {
        "table": "DBT_ANALYTICS_PLATFORM_BUCKET.MEDALLION_SILVER.SILVER_HOST",
        "columns": "SILVER_HOST.HOST_NAME, SILVER_HOST.HOST_SINCE, SILVER_HOST.IS_SUPERHOST, SILVER_HOST.RESPONSE_RATE, SILVER_HOST.RESPONSE_RATE_QUALITY, SILVER_HOST.CREATED_AT AS HOST_CREATED_AT",
        "alias": "SILVER_HOST",
        "join_condition": "SILVER_LISTINGS.HOST_ID = SILVER_HOST.HOST_ID" 
    },
] %}


SELECT
    {% for item in configs %}
        {{ item['columns'] }}{% if not loop.last %},
        {% endif %}
    {% endfor %}
FROM
    {% for item in configs %}
    {% if loop.first %}
        {{ item['table'] }} AS {{ item['alias'] }}
    {% else %}
        LEFT JOIN {{ item['table'] }} AS {{ item['alias'] }}
        ON {{ item['join_condition'] }}
        {% endif %}
        {% endfor %}