{% set columns = 
    [
    'BOOKING_ID', 
    'LISTING_ID', 
    'BOOKING_AMOUNT'
    ]
%}

SELECT 

    {% for column in columns %}
        {{ column }}
            {% if not loop.last %},{% endif %}
    {% endfor %}

FROM 
    {{ref('bronze_bookings')}}