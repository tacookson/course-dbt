with

source as (

    select * from {{ source('postgres', 'events') }}

),

renamed as (

    select

        -- primary key
        event_id,
        
        -- foreign keys
        session_id,
        user_id,
        order_id,
        product_id,

        -- properties
        event_type,
        page_url,

        -- timestamps
        created_at

    from source

)

select * from renamed