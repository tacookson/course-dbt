# Week 1 Project

## How many users do we have?

130

```sql
select

    count(distinct user_id) as user_count
    
from dev_db.dbt_alexmusoracom.stg_postgres__users
```

## On average, how many orders do we receive per hour?

~ 7.5

```sql
with


orders_hourly as (

    select
    
        date_trunc(hour, created_at) as order_hour,
        count(*) as order_count
        
    from dev_db.dbt_alexmusoracom.stg_postgres__orders
    group by 1

),


final as (

    select

        avg(order_count) as mean_orders_hourly

    from orders_hourly

)


select * from final
```

## On average, how long does an order take from being placed to being delivered?

~3.9 days

```sql
with


delivery_times as (

    select
    
        order_id,
        /* deliveries seem to be at the exact same time as orders, but for real world
        data, this would give some additional options for granularity */
        datediff(minute, created_at, delivered_at) as delivery_minutes,
        delivery_minutes / 60 as delivery_hours,
        delivery_hours / 24 as delivery_days
        
    from dev_db.dbt_alexmusoracom.stg_postgres__orders

    where true
        /* exclude orders that haven't been delivered yet */
        and delivered_at is not null

),


final as (

    select

        avg(delivery_days) as mean_delivery_days

    from delivery_times

)


select * from final
```

## How many users have only made one purchase? Two purchases? Three+ purchases?

Here is the breakdown:

- One purchase: 25 users
- Two purchases: 28 users
- Three+ purchases: 71 users

```sql
with


purchase_counts as (

    select
    
        user_id,
        count(order_id) as purchase_count
        
    from dev_db.dbt_alexmusoracom.stg_postgres__orders
    
    group by 1

),


final as (

    select

        iff(purchase_count <3, purchase_count::varchar, '3+') as purchase_count_category,
        count(user_id) as user_count

    from purchase_counts

    group by 1
    order by 1

)


select * from final
```

## On average, how many unique sessions do we have per hour?

~ 16.3

```sql
with


sessions_hourly as (

    select
    
        date_trunc(hour, created_at) as session_hour,
        count(distinct session_id) as session_count
        
    from dev_db.dbt_alexmusoracom.stg_postgres__events
    group by 1

),


final as (

    select

        avg(session_count) as mean_sessions_hourly

    from sessions_hourly

)


select * from final
```
