with

source as (

    select * from {{ source('postgres', 'addresses') }}

),

renamed as (

    select

        -- primary key
        address_id,
        
        -- foreign keys
        -- none

        -- properties
        address,
        zipcode,
        state,
        country

        -- timestamps
        -- none

    from source

)

select * from renamed