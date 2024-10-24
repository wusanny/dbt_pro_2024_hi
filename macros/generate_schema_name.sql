{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if (target.name == 'prod' or target.name == 'ci') and custom_schema_name is not none -%}
        {{ (custom_schema_name | trim) }}
    {%- else -%}
        {{ (target.schema) }}
    {%- endif -%}
{%- endmacro %}