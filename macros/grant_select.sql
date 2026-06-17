-- dbt run-operation grant_select --args '{"role": "lecteur"}'

{% macro grant_select(role) %}

    {% if execute %}
        {% if target.type == 'postgres' %}
            {% set sql %}
                GRANT USAGE ON SCHEMA {{ schema }} TO {{ role }};
                GRANT SELECT ON all tables IN schema {{ schema }} TO {{ role }};
            {% endset %}

            {% for agate_row in list_schemas(target.database) %}

                {% set schema = agate_row.values()[0] %}
                {# 
                if schema.startswith(target.schema)             (python)
                if schema.replace(target.schema, '') != schema  (jinja)
                #}
                {% if schema.startswith(target.schema) %}
                    {{ log("Granting Select on schema " ~ schema ~ " to role " ~ role, info=True) }}
                    {% do run_query(sql) %}
                {% endif %}

            {% endfor %}
        {% else %}
            {{ log('NOT IMPLEMENTED for ' ~ target.type, info=True) }}
        {% endif %}
    {% endif %}

{% endmacro %}
