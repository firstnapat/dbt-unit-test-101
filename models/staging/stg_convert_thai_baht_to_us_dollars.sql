with payment_info as (
    select 
      id
      , order_id
      , payment_method
      , thai_amount
    from {{ ref('stg_payments_raw') }}
)

, customer_info as (
    select 
      id
      , first_name
      , last_name
    from {{ ref('stg_customers_raw') }}
)

, map_payments_and_customers as (
    select 
        payment_info.id as payment_id
        , customer_info.first_name
        , customer_info.last_name
        , payment_info.order_id
        , payment_info.payment_method 
        , payment_info.thai_amount
    from payment_info
    join customer_info 
    on payment_info.id = customer_info.id
)

, concat_customer_name as (
  select
    payment_id
    , concat(first_name, ' ',last_name) as name
    , payment_method
    , thai_amount
  from map_payments_and_customers
)

, convert_thai_baht_to_us_dollars as (
    select
      payment_id
      , name
      , payment_method
      -- `price` is currently stored in Thai Baht, 
      -- so we convert it to us dollars
      , round(thai_amount / 35.93, 2) as dollars_amount
    from concat_customer_name
)

, final as (
  select
    payment_id
    , name
    , payment_method
    , dollars_amount
  from convert_thai_baht_to_us_dollars
)

select * from final