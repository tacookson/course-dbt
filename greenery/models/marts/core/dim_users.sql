{{
  config(
    materialized='table'
  )
}}

with

users as (

    select * from {{ ref('stg_postgres__users') }}

),

order_metrics as (

    select * from {{ ref('int_user_order_metrics') }}

),

joined as (

    select

        -- primary key
        users.user_id,

        -- foreign keys
        users.address_id,

        -- properties
        users.first_name,
        users.last_name,
        users.email,
        users.phone_number,
        order_metrics.aov,
        coalesce(order_metrics.order_count, 0) as order_count,
        coalesce(order_metrics.lifetime_spend, 0) as lifetime_spend,

        -- timestamps
        order_metrics.last_order_at,
        users.created_at,
        users.updated_at

    from users
    left join order_metrics
        on users.user_id = order_metrics.user_id

)

select * from joined