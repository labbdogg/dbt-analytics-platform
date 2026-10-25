{% set flag = 1 %}


SELECT 
    * 
FROM 
    {{ ref ('bronze_bookings') }}
{% if flag == 1 %}
    WHERE NIGHTS_BOOKED > 2
{% else %}
    WHERE NIGHTS_BOOKED < 2
{% endif %}