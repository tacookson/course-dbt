
# Week 2 Project

## What is our repeat user rate?

99 users have made at least two orders.

```sql
with

orders as (

    select * from dev_db.dbt_alexmusoracom.stg_postgres__orders

),

user_orders as (

    select

        user_id,
        count(order_id) as order_count

    from orders

    group by 1

),

final as (

    select

        count(user_id) as user_count

    from user_orders

    where true
        and order_count >= 2

)

select * from final
```
