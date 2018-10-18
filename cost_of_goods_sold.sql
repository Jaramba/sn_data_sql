SELECT 
	    account_lines.move_id 							AS "Journal Entry",
	    account_lines."date" 							AS "Effective Date",
	    account_lines."name"							AS "Detailed Description",
	    account_lines."ref" 							AS "Reference",
	     account_lines.quantity							AS "Quantity",
	     account_lines.product_id 						AS "Product",
	     products.name_template							AS "Products",
	    prods_temp.description_purchase					AS "Description",
	    journals."name" 								AS "Account Name",
	    accounts."name"									AS "Cost",
	    categories."name"								AS "Categories",
	    accounts.code            						AS "Account",
	    COALESCE (cost_centers."name",'No Cost Center') AS "Cost Center", 
	    account_lines.company_id 						AS "Company",
	    account_lines.amount      						AS "Amount"
    
	FROM 
		account_move_line AS account_lines
	LEFT JOIN  account_journal AS journals ON  
 		account_lines.journal_id = journals.id
	LEFT JOIN  account_account AS accounts ON 
		 accounts.id = account_lines.account_id
	LEFT JOIN  account_cost_center AS cost_centers ON 
 		account_lines.cost_center_id = cost_centers.id 
 	LEFT JOIN product_product AS products ON 
 		account_lines.product_id = products.id
 	LEFT JOIN product_template AS prods_temp ON
 		prods_temp.id = products.product_tmpl_id
 	LEFT JOIN product_category AS categories ON 
 		categories.id = prods_temp.categ_id
	WHERE   
  		account_lines."date" > '2016-01-01' AND 
  		account_lines.amount > 0 AND 
  		accounts.code IN ('420001','410001')

  		SELECT * FROM account_move_line LIMIT 10 
  		SELECT * FROM product_product LIMIT 10 
  		SELECT * FROM product_template LIMIT 10 
  		SELECT * FROM product_category
  		