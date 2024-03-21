with

source as (

    select * from {{ source('postgres', 'order_items') }}

),

renamed as (

    select

        -- primary key
        order_id,

        product_id,
        quantity

    from source

)


select * from renamed