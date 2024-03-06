-- 2. **Store Count Overview:**
 --  Generate a report showing the number of stores in each city, sorted in descending order of store counts. 
 -- Include essential fields: city and store count.

Select city,count(*)as Cnt 
  from dim_stores
group by city
order by Cnt desc ;