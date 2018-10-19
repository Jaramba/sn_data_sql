SELECT * FROM product_product LIMIT 10 
  SELECT * FROM product_template LIMIT 10 
 SELECT * FROM account_ta
  SELECT * FROM product_category
  SELECT * FROM product_pricelist_version
  

  SELECT * FROM account_account_tax_default_rel
  
  
  
  SELECT 
  	products.name_template		AS "Name",	
  	taxes2.amount,
  	category,
  	description
  	products.company_id
  
  FROM product_product AS products
 
  LEFT JOIN product_taxes_rel AS taxes ON 
  taxes.prod_id = products.id
  LEFT JOIN account_tax AS taxes2 ON
  taxes2.id = taxes.tax_id
  


select count(*)
from information_schema.tables
where table_schema = 'public';

select schemaname, relname, n_live_tup from pg_stat_all_tables WHERE schemaname = 'public' ORDER BY n_live_tup

select schemaname, relname, n_live_tup from pg_stat_user_tables order by n_live_tup
SELECT relname,seq_tup_read,idx_tup_fetch,cast(idx_tup_fetch AS numeric) / (idx_tup_fetch + seq_tup_read) AS idx_tup_pct FROM pg_stat_user_tables WHERE (idx_tup_fetch + seq_tup_read)>0 ORDER BY idx_tup_pct;