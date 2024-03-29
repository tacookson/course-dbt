with

events as (

    select * from {{ ref('stg_postgres__events') }}

),

final as (

    select

        -- primary key
        event_id,

        -- foreign keys
        user_id,
        session_id,
        product_id,

        -- properties
        page_url,

        -- timestamps
        created_at
        
    from events

    where true
        and event_type = 'page_view'

)

select * from final
order by created_at