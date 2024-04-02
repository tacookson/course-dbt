with

source as (

    select * from {{ source('postgres', 'promos') }}

),

renamed as (

    select

        -- primary key
        promo_id,

        -- foreign keys
        -- none

        -- properties
        discount,
        status

        -- timestamps
        -- none

    from source

)

select * from renamed