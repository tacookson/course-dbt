{{
  config(
    materialized='table'
  )
}}

with

session_event_counts as (

    select * from {{ ref('int_session_event_counts') }}

),

sessions as (

    select * from {{ ref('stg_postgres__events') }}

),

session_event_booleans as (

    select
    
        session_id,
        /* we're not using boolean values here because we're going to aggregate them
        in a later CTE, and snowflake doesn't automatically coerce TRUE/FALSE to 1/0 */
        iff(page_view_count > 0, 1, 0) as has_page_view,
        iff(add_to_cart_count > 0, 1, 0) as has_add_to_cart,
        iff(checkout_count > 0, 1, 0) as has_checkout
        /* we are not including package_shipped because marketing doesn't care */
        
    from session_event_counts

),

session_timestamps as (

    select
    
        session_id,
        min(created_at) as start_at,
        max(created_at) as end_at,
        datediff(minute, start_at, end_at) as session_length_min
    
    from sessions

    group by 1

),

joined as (

    select
    
        session_timestamps.session_id,
        session_timestamps.start_at,
        session_timestamps.end_at,
        session_timestamps.session_length_min,
        session_event_booleans.has_page_view,
        session_event_booleans.has_add_to_cart,
        session_event_booleans.has_checkout
        
    from session_timestamps
    left join session_event_booleans
        on session_timestamps.session_id = session_event_booleans.session_id

),

final as (

    select

        /* use session start_at timestamp to aggregate daily metrics, even if events
        occurred into the next day */
        to_date(date_trunc(day, start_at)) as session_date,
        count(session_id) as session_count,
        sum(has_checkout) as checkout_count,
        avg(has_add_to_cart) as add_to_cart_pct,
        avg(has_checkout) as checkout_pct

    from joined

    group by 1

)

select * from final
order by 1