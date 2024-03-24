-- depends_on: {{ ref('stg_payments_raw') }}
-- depends_on: {{ ref('stg_customers_raw') }}
{{ config(tags=['unit-test']) }}

{% call dbt_unit_testing.test('stg_convert_thai_baht_to_us_dollars', 
'test when order_id was not matched it should return no rows pipe format') %}
  {% call dbt_unit_testing.mock_ref ('stg_payments_raw', {"input_format": "csv", "column_separator": "|"}) %}
    id  | order_id | payment_method | thai_amount::int
    1   | 1        | 'credit card'  | 50000
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_customers_raw', {"input_format": "csv", "column_separator": "|"}) %}
    id  | first_name | last_name
    45  | 'Thomas'   | 'B.'
   
    {% endcall %}

  {% call dbt_unit_testing.expect_no_rows() %}
  {% endcall %}
{% endcall %}