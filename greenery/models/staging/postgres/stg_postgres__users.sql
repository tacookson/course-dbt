with

source as (

    select * from {{ source('postgres', 'users') }}

),

renamed as (

    select

        -- primary key
        user_id,

        -- foreign keys
        address_id,

        -- properties
        first_name,
        last_name,
        email,
        phone_number,

        -- timestamps
        created_at,
        updated_at

    from source

)

select * from renamed