with

events as (

    select * from {{ ref('stg_postgres__events') }}

),

distinct_sessions as (

    select distinct session_id from events

),

distinct_events as (

    select distinct event_type from events

),

cartesian as (

    select

        distinct_sessions.session_id,
        distinct_events.event_type

    from distinct_sessions
    cross join distinct_events

),


session_events_count as (

    select

        cartesian.session_id,
        cartesian.event_type,
        count(events.event_id) as event_count

    from cartesian
    left join events
        on cartesian.session_id = events.session_id
        and cartesian.event_type = events.event_type

    group by 1,2

),


pivoted as (

    select

        session_id,
        "'page_view'" as page_view_count,
        "'add_to_cart'" as add_to_cart_count,
        "'checkout'" as checkout_count,
        "'package_shipped'" as package_shipped_count

    from session_events_count
    pivot(sum(event_count) for event_type in
        (
        'checkout',
        'package_shipped',
        'add_to_cart',
        'page_view'
        )
    ) as p

)

select * from pivoted
