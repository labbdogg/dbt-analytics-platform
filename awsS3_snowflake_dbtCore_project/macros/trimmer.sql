{% raw %}

{% macro trimmer (x) %}
    upper(
        trim(
            {{x}}
            )
)
{% endmacro %}

{% endraw %}

{% macro trimmer (x, node) %}
    {{x | trim | upper}}
{% endmacro %}