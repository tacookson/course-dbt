with

source as (

    select * from {{ source('postgres', 'addresses') }}

),

renamed as (

    select

        -- primary key
        address_id,
        
        address,
        zipcode,
        state,
        country

    from source

)


select * from renamed