-- stg_convert_thai_baht_to_us_dollars.sql
with payment_source as (
    select 
      id
      , order_id
      , payment_method
      , amount
    from {{ ref('payments_raw') }}
)

, customer_source as (
    select 
      id
      , first_name
      , last_name
    from {{ ref('customers_raw') }}
)

, map_payment_and_event as (
    select 
        payment_source.id as payment_id
        , customer_source.first_name
        , customer_source.last_name
        , payment_source.order_id
        , payment_source.payment_method 
        , payment_source.amount
    from payment_source
    join customer_source 
    on payment_source.id = customer_source.id
)

, concat_customer_name as (
  select
    payment_id
    , concat(first_name, ' ',last_name) as name
    , payment_method
    , amount
  from map_payment_and_event
)

, convert_thai_baht_to_us_dollars as (
    select
      payment_id
      , name
      , payment_method
      -- `price` is currently stored in Thai Baht, 
      -- so we convert it to us dollars
      , round(amount / 35.93, 2) as dollars_amount
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