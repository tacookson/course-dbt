# Week 3 Project

## What is our overall conversion rate?

~ 62.5%. We already had a mart model that calculated session conversion rate by day, so we can sum up the conversions and sessions for all time to get our overall conversion rate.

```sql
select

    sum(checkout_count) / sum(session_count) as conversion_pct
    
from dev_db.dbt_alexmusoracom.fct_session_conversion_daily

```
