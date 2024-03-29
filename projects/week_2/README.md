
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

## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? 

Many Marketing teams use an [RFM model](https://docs.getdbt.com/blog/historical-user-segmentation) as a rough way to gauge the quality of customers. Recency and Frequency -- the R and F in the model -- can be good proxies for whether a user is likely or unlikely to purchase again.

Specifically, if there is a user who has made a purchase recently and has made frequent purchases in the past, we can guess that they will be more likely to purchase again. On the other hand, if we have a user who's last purchase was far in the past and they have only made one purchase, we can guess that they are less likely to purchase again.

Predicting purchases has long been a topic of interest for Marketing teams. One other approach is the [Buy 'Til You Die model](https://en.wikipedia.org/wiki/Buy_Till_you_Die), but there are many, many others.


## If you had more data, what features would you want to look into to answer this question?

I would want more data on all the touchpoints Greenery has with users. For example, if Greenery relies extensively on email marketing, I would look at whether users have opted in to marketing communications and whether or not they engage with those communications. A user who opens and clicks through every email they get from Greenery is likely much more likely to buy than one who is unsubscribed from marketing emails.

## Explain the product mart models you added. Why did you organize the models in the way you did?

I added a single mart model in `product`. I focused on breadth across `core` and `marketing` schemas, rather than breadth within `product`.

The model is `fct_product_pageviews_daily`, which provides a summary of pageviews and unique users, by product, by day. I also created an intermediate model of raw pageviews, `int_pageviews`, as a step to building this model. My rationale is that the Product team would want data ready-to-consume in the form of a report with a grain of one row per product per day. I kept pageviews as an intermediate model because this seemed too in-the-weeds for end users on the Product team. (Though maybe I'm not giving enough credit to the Greenery Product team's SQL skills!)
