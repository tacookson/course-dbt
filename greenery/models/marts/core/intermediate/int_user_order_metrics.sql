with

orders as (

    select * from {{ ref('stg_postgres__orders') }}

),

final as (

    select

        -- primary key
        user_id,

        -- foreign keys
        -- none

        -- properties
        count(distinct order_id) as order_count,
        /* only include order_cost as part of spend calculation, since shipping cost is a direct offest */
        round(avg(order_cost), 2) as aov,
        sum(order_cost) as lifetime_spend,

        -- timestamps
        min(created_at) as first_order_at,
        max(created_at) as last_order_at

    from orders

    group by 1

)

select * from final
