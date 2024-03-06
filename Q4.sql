-- 4. **Diwali Campaign ISU% Report:**
--   Produce a report calculating Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. Include category, isu%, and rank order. ISU% is the percentage change in quantity sold (after promo) compared to before promo.

with cte1 as(
Select *,
  CASE 
    WHEN promo_type = 'BOGOF' THEN `quantity_sold(after_promo)`*2
  ELSE
`quantity_sold(after_promo)`
End as quantity_sold_after_prm
from  fact_events
 ),
cte2 AS (
    SELECT
        d.category,
        SUM(`quantity_sold(before_promo)`) AS ISU_before,
        SUM(`quantity_sold_after_prm`) AS ISU_after
    FROM cte1 fe
    JOIN dim_products d ON fe.product_code = d.product_code
    WHERE fe.campaign_id = 'CAMP_DIW_01'
    GROUP BY d.category
)

SELECT
    *,
    ((ISU_after - ISU_before) / ISU_before) * 100 AS ISU_Pct,
    DENSE_RANK() OVER (ORDER BY ((ISU_after - ISU_before) / ISU_before) DESC) AS dens_rank
FROM cte2;
