with

order_items as (

    select * from {{ ref('stg_postgres__order_items') }}

),

products as (

    select * from {{ ref('stg_postgres__products') }}

),

add_prices as (

    select

        order_items.order_id,
        order_items.product_id,
        products.price as unit_price,
        order_items.quantity

    from order_items
    left join products
        on order_items.product_id = products.product_id

),

line_totals as (

    select

        order_id,
        /* this is a degenerate dimension that has no real meaning, except to make the table
        more readable */
        row_number() over (partition by order_id order by product_id) as line_number,
        product_id,
        unit_price * quantity as line_cost
        
    from add_prices

),

final as (

    select

        /* we generate a surrogate key to act as the new primary key, since we have regrained this
        table to be one record per order line */
        {{ dbt_utils.generate_surrogate_key(['order_id','line_number']) }} as order_key,
        order_id,
        line_number,
        product_id,
        line_cost

    from line_totals

)

select * from final