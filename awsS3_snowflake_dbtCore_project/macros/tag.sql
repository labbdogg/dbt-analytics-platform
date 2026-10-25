{% macro tag(x) %}
    CASE 
        WHEN {{x}} < 100 THEN 'low'
        WHEN {{x}} < 200 THEN 'medium'
        ELSE 'high'
    END
{% endmacro %}