with

addresses as (

    select * from {{ ref('stg_postgres__addresses') }}

)

select * from addresses