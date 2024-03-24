with payment_source as (
    select 
      id
      , first_name
      , last_name
    from {{ ref('customers_raw') }}
)

select * from payment_source