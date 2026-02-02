create  database customer_db;
USE customer_db;
SELECT * FROM customer_data limit 3;
-- total revenue genrated by male vs female
SELECT 
    gender, SUM(purchase_amount) AS revenue
FROM
    customer_data
GROUP BY gender;
-- which customer use discount but still they spent more than ang purches amount
SELECT 
    customer_id, purchase_amount
FROM
    customer_data
WHERE
    discount_applied = 'Yes'
        AND purchase_amount > (SELECT 
            AVG(purchase_amount)
        FROM
            customer_data); 
-- which are top five product with highest avg review rating
SELECT 
    item_purchased,
    ROUND(AVG(review_rating), 2) AS avg_review_rating
FROM
    customer_data
GROUP BY item_purchased
ORDER BY avg_review_rating DESC
LIMIT 5;
-- comapre between the avg purchase amount between standerd and express shipping 
SELECT 
    shipping_type, AVG(purchase_amount) AS avg_spending
FROM
    customer_data
WHERE
    shipping_type IN ('Standard' , 'Express')
GROUP BY shipping_type;
-- do subscribed customer spend more ? comapre avg spend and total revenue between subscribed and non_subscrid
  SELECT 
    subscription_status,
    COUNT(*) AS total_customer,
    AVG(purchase_amount) AS avg_spend,
    SUM(purchase_amount) AS total_revenue
FROM
    customer_data
GROUP BY subscription_status;
-- which 5 products have the highst percentage of purchase with discount applied?
select item_purchased, round(100* sum(case when discount_applied = 'Yes' Then 1 else 0 end) / count(*),2) as discount_rate
from customer_data 
group by item_purchased
order by discount_rate desc limit 5;
-- segment customer into new, returning  and loyal base on total purchase  and show count of each segment
with customer_type as (
select customer_id, previous_purchases,
case 
when  previous_purchases = 1 then 'New'
when  previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from customer_data)
select customer_segment, count(*) as 'no.of customer'
from customer_type group by customer_segment;
-- Are customer who are repet buyers (more tahn 5 previous purchases) also likely to subscribe?
SELECT 
    subscription_status, COUNT(customer_id) AS repet_byers
FROM
    customer_data
WHERE
    previous_purchases > 5
GROUP BY subscription_status;
-- revenue by age group
select age_group, sum(purchase_amount) as total_revnue from customer_data group by age_group 
order by  total_revnue desc;


