with

source as (

    select * from {{ source('postgres', 'order_items') }}

),

renamed as (

    select

        -- primary key
        order_id,

        -- foreign keys
        product_id,

        -- properties
        quantity

        -- timestamps
        -- none

    from source

)

select * from renamed