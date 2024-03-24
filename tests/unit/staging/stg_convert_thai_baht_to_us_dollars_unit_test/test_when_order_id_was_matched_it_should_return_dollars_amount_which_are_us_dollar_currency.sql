-- depends_on: {{ ref('stg_payments_raw') }}
-- depends_on: {{ ref('stg_customers_raw') }}
{{ config(tags=['unit-test']) }}

{% call dbt_unit_testing.test('stg_convert_thai_baht_to_us_dollars', 
'test when order_id was matched it should return dollars_amount 
which are us dollar currency') %}
  
  {% call dbt_unit_testing.mock_ref ('stg_payments_raw') %}
    select 
      1 as id
      , 1 as order_id
      , 'credit_card' as payment_method
      , 300000 thai_amount
  {% endcall %}

  {% call dbt_unit_testing.mock_ref ('stg_customers_raw') %}
    select 
      1 as id
      , 'Napat' as first_name
      , 'P.' as last_name
  {% endcall %}

  {% call dbt_unit_testing.expect() %}
     select 
      1 as payment_id
      , 'Napat P.' as name
      , 'credit_card' as payment_method
      , 8349.57 as dollars_amount
  {% endcall %}
{% endcall %}