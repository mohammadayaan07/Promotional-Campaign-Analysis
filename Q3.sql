-- 3. **Campaign Revenue Analysis:**
   -- Generate a report displaying each campaign, total revenue before and after the campaign, in millions.
   -- Fields: campaign_name, total_revenue(before_promotion), total_revenue(after_promotion).

WITH cte AS (
SELECT *,
CASE 
      WHEN promo_type = '50% OFF' THEN (base_price * 0.50)
      WHEN promo_type = '25% OFF' THEN (base_price * 0.75)
      WHEN promo_type = '33% OFF' THEN (base_price * 0.67)  
      WHEN promo_type = '500 Cashback' THEN (base_price -500)
      #WHEN promo_type = 'BOGOF' THEN (base_price * 0.5) 
      else base_price
    END AS base_price_promo
  FROM fact_events
)

SELECT
  d.campaign_name,
  FORMAT(SUM(`quantity_sold(before_promo)` * base_price) / 1000000, 2) AS Revenue_before_in_million,
  format(SUM(`quantity_sold(after_promo)` * base_price_promo) / 1000000, 2) AS Revenue_after_in_million
FROM cte
JOIN dim_campaigns d ON cte.campaign_id = d.campaign_id
GROUP BY d.campaign_name;
