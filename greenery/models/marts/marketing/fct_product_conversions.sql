{{
  config(
    materialized='table'
  )
}}

with

product_views as (

    select
    
        distinct
        session_id,
        product_id
        
    from {{ ref('int_pageviews') }}

),

session_orders as (

    select

        distinct
        session_id,
        order_id

    from {{ ref('stg_postgres__events') }}

    where true
        /* we'll be using this CTE to identify conversions, so anything with a NULL order_id
        can be excluded since we know there's no conversion there. */
        and order_id is not null

),

order_products as (

    select
    
        distinct
        order_id,
        product_id
        
    from {{ ref('int_order_line_totals') }}

),

product_conversions as (

    select

        product_views.session_id,
        product_views.product_id,
        session_orders.order_id,
        true as has_converted

    from product_views
    left join session_orders
        on product_views.session_id = session_orders.session_id
    /* use an inner join as a filtering join, so we get only the records
    where order_id and product_id match. this indicated a conversion for that
    particular combination. */
    inner join order_products
        on session_orders.order_id = order_products.order_id
        and product_views.product_id = order_products.product_id

),

final as (

    select

        product_views.session_id,
        product_views.product_id,
        /* if we don't get a true from the left join, there is no conversion and
        we know this combination of session and product has not converted */
        coalesce(product_conversions.has_converted, false) as has_converted

    from product_views
    left join product_conversions
        on product_views.session_id = product_conversions.session_id
        and product_views.product_id = product_conversions.product_id

)

select * from final