with

source as (

    select * from {{ source('postgres', 'promos') }}

),

renamed as (

    select

        -- primary key
        promo_id,

        discount,
        status

    from source

)


select * from renamed