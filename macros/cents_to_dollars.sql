{% macro cents_to_dollars(column_name, scale=2) %}
    ({{ column_name }} / 100)::numeric(16, {{ scale }})
{% endmacro %}

{%- macro get_active_or_deleted_record(table) -%}
    ({{table}}.audit_active_ind = 'Y' or {{table}}.audit_delete_flag = 'Y')
{%- endmacro -%}

{%- macro get_active_record(table) -%}
    ({{table}}.audit_active_ind = 'Y')
{%- endmacro -%}

{%- macro get_surrogate_id_column(surrogate_id_column) -%}
    if({{ surrogate_id_column.split('.')[0] }}.audit_active_ind = 'Y' and {{surrogate_id_column}} is not null, 
       {{surrogate_id_column}}, 
       '-1')
{%- endmacro -%}

{%- macro get_latest_processed_timestamp(tables) -%}
    {%- if tables is string and tables == 'current_time' -%}
        current_timestamp()
    {%- else -%}
        {%- if tables | length > 1 -%}  greatest( {%- endif -%}
        {%- for table in tables -%}
            {%- if 'slv' in table -%}
                if(
                    {{ table.split('.')[1] }}.audit_delete_flag = 'Y',
                    {{ table.split('.')[1] }}.audit_to_timestamp::timestamp,
                    {{ table.split('.')[1] }}.audit_from_timestamp::timestamp
                )
            {%- elif 'cte' in table -%}
                {{ table.split('.')[1] }}.audit_from_timestamp::timestamp
            {%- else -%}
                {{ table.split('.')[1] }}.audit_src_processed_timestamp::timestamp
            {%- endif -%}
            {%- if not loop.last -%} ,   {%- endif -%}
        {%- endfor -%}
        {%- if tables | length > 1 -%}){%- endif -%}
    {%- endif -%}
{%- endmacro -%}

{%- macro get_surrogate_key(unique_key, updated_at) -%}
    {{ dbt_utils.generate_surrogate_key([unique_key, updated_at]) }}
{%- endmacro -%}