-- 1. **High-Value BOGOF Products:**
 --  Provide a list of products with a base price greater than 500 and featured in promo type 'BOGOF' (Buy One Get One Free).

SELECT distinct(product_name) , base_price
FROM fact_events  F
join dim_products d
  on d.product_code=f.product_code
where base_price>500 and promo_type="BOGOF"
;




