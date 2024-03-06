-- 5. **Top 5 Products by IR%:**
 --  Create a report featuring the top 5 products ranked by Incremental Revenue Percentage (IR%) across all campaigns. 
 -- Include product name, category, and ir%. This analysis helps identify successful products in terms of incremental revenue.
WITH cte AS (
  SELECT 
    *,
    CASE 
      WHEN promo_type = '50% OFF' THEN (base_price * 0.50)
      WHEN promo_type = '25% OFF' THEN (base_price * 0.75)
      WHEN promo_type = '33% OFF' THEN (base_price * 0.67)  
      WHEN promo_type = '500 Cashback' THEN (base_price - 500)
      WHEN promo_type = 'BOGOF' THEN (base_price * 0.5)
    END AS base_price_promo,
    CASE WHEN promo_type = 'BOGOF' THEN quantity_sold * 2 ELSE quantity_sold END AS quantity_sold_after_promo
  FROM fact_events
),
cte2 AS (
  SELECT
    d.product_name,
    c.product_code,
    d.category,
    SUM(quantity_sold * base_price) AS revenue_before,
    SUM(quantity_sold_after_promo * base_price_promo) AS revenue_after_promo
  FROM cte c
  JOIN dim_products d ON d.product_code = c.product_code
  GROUP BY c.product_code
  ORDER BY revenue_after_promo DESC
)

SELECT
  *,
  ((revenue_after_promo - revenue_before) / revenue_before) * 100 AS IRU
FROM cte2
ORDER BY IRU DESC
LIMIT 5;
