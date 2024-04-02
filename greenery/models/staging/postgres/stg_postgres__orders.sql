with

source as (

    select * from {{ source('postgres', 'orders') }}

),

renamed as (

    select

        -- primary key
        order_id,

        -- foreign keys
        promo_id,
        user_id,
        address_id,

        -- properties
        order_cost,
        shipping_cost,
        order_total,
        tracking_id,
        shipping_service,
        status,

        -- timestamps
        created_at,
        estimated_delivery_at,
        delivered_at

    from source

)

select * from renamed