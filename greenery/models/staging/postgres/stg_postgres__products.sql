with

source as (

    select * from {{ source('postgres', 'products') }}

),

renamed as (

    select

        -- primary key
        product_id,

        -- foreign keys
        -- none

        -- properties
        name,
        price,
        inventory

        -- timestamps
        -- none

    from source

)

select * from renamed