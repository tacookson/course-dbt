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

        users.user_id,
        users.address_id,
        users.first_name,
        users.last_name,
        users.email,
        users.phone_number,
        order_metrics.aov,
        coalesce(order_metrics.order_count, 0) as order_count,
        coalesce(order_metrics.lifetime_spend, 0) as lifetime_spend,
        order_metrics.first_order_at,
        order_metrics.last_order_at,
        users.created_at,
        users.updated_at

    from users
    left join order_metrics
        on users.user_id = order_metrics.user_id

),

rfm_scores as (

  select

    *,
    /* we would normally use days since last order, but since this is a toy example
    with limited range of order dates, we'll use hours to have a greater spread for
    the ntile() calculation */
    datediff(hour, last_order_at, current_date()) as hours_since_last_order,
    /* calculating a rudimentary rfm score (1-3, with 3 being good) based on:
      - recency: time since last order
      - frequency: total number of orders
      - monetary: total spend */
    ntile(3) over (order by hours_since_last_order desc) as recency, 
    ntile(3) over (order by order_count asc) as frequency,
    ntile(3) over (order by lifetime_spend asc) as monetary,
    recency + frequency + monetary as rfm_score
      
  from joined

),

final as (

  select

    -- primary key
    user_id,
    
    -- foreign keys
    address_id,

    -- properties
    first_name,
    last_name,
    email,
    phone_number,
    aov,
    order_count,
    lifetime_spend,
    recency,
    frequency,
    monetary,
    rfm_score,

    -- timestamps
    first_order_at,
    last_order_at,
    created_at,
    updated_at

  from rfm_scores

)

select * from final