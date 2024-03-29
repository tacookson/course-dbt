{{
  config(
    materialized='table'
  )
}}

with

pageviews as (

    select * from {{ ref('int_pageviews') }}

),

products as (

    select * from {{ ref('stg_postgres__products') }}

),

product_pageviews as (

    select
    
        to_date(date_trunc(day, created_at)) as pageview_date,
        product_id,
        count(event_id) as pageview_count,
        count(distinct user_id) as user_count
        
    from pageviews

    group by 1,2

),

final as (

    select

        -- primary keys
        /* this is a composite key because of the aggregation to daily reporting */
        product_pageviews.pageview_date,
        product_pageviews.product_id,

        -- foreign keys
        -- none

        -- properties
        products.name as product_name,
        product_pageviews.pageview_count,
        product_pageviews.user_count

        -- timestamps
        -- none

    from product_pageviews
    left join products
        on product_pageviews.product_id = products.product_id

)

select * from final
order by 1,2