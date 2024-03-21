with

source as (

    select * from {{ source('postgres', 'products') }}

),

renamed as (

    select

        -- primary key
        product_id,

        name,
        price,
        inventory

    from source

)


select * from renamed