with payment_source as (
    select 
      id
      , order_id
      , payment_method
      , amount
    from {{ ref('payments_raw') }}
)

, renamed as (
    select
        id
        , order_id
        , payment_method
        , amount as thai_amount
    from payment_source
)

, final as (
    select
        id
        , order_id
        , payment_method
        , thai_amount
    from renamed
)

select * from final