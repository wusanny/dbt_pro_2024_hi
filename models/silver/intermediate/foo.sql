with

diff_sources as (

    select * from


    {% if target.name == 'prod' %}
 -- use this source for data if prod
        {{ source('jaffle_shop', 'customers') }}

    
    {% else %}
            -- use this source for data if non-prod   
            {{ source('jaffle_shop', 'orders') }}

    {% endif %}

)

select * from diff_sources