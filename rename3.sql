WITH order_lines AS (
SELECT 
	lines.id 				AS "ID",
	lines.product_uom_qty 	AS "Quantity",
	lines.order_partner_id  AS "PartnerID",
	lines.order_id 			AS "OrderID",
	lines.product_id		AS "ProductID",
	templates."name"		AS "PrductName",
	templates."type"		AS "Type",
	categories."name" 		AS "Category"
	
FROM sale_order_line AS lines
LEFT JOIN product_product AS product ON  
	product.id = lines.product_id
LEFT JOIN product_template AS templates ON
	templates.id = product.product_tmpl_id
LEFT JOIN product_category AS categories ON 
	categories.id = templates.categ_id

WHERE 
	templates."type" = 'product'
),
invoices_upgrades AS (
	SELECT  
	 	COALESCE (invoices.date_invoice, DATE(invoices.create_date)) 	AS "Date",
	 	invoices.state													AS "State",
   		UPPER (TRIM(customers."name")) 									AS "CustomerName",
 		customers.phone 												AS "Phone",
 		customers."ref" 												AS "Customer Reference",
 		client_type."name" 												AS "Client Type",
 		terms."name"													AS "Payment Term",	 
   		branches."name"													AS "Branch Name"	,
   		lines.*
	FROM 
 		account_invoice AS invoices
 	LEFT JOIN  res_branch AS branches ON
		branches.id  = invoices.branch
	LEFT JOIN  sale_order AS  orders ON 
 		invoices.sale_order = orders.id
 	LEFT JOIN order_lines AS lines ON 
 		orders.id = lines."OrderID"
	LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	LEFT JOIN  res_partner AS customers ON 
	 	customers.id = orders.partner_id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	 WHERE  
 		invoices."type" = 'out_invoice' AND
 		client_type."name" = '2. Returning Client' AND
 		invoices.state NOT IN ('cancel')
 		),
invoices_new AS (
	SELECT 
	 	COALESCE (invoices.date_invoice, DATE(invoices.create_date)) 	AS "Date",
	 	invoices.state													AS "State",
   		UPPER (TRIM(customers."name")) 									AS "CustomerName",
 		customers.phone 												AS "Phone",
 		customers."ref" 												AS "Customer Reference",
 		client_type."name" 												AS "Client Type",
 		terms."name"													AS "Payment Term",
   		branches."name"													AS "Branch Name",
   		lines.*
   				
	FROM 
 		account_invoice AS invoices
 	LEFT JOIN  res_branch AS branches ON
		branches.id  = invoices.branch
	LEFT JOIN  sale_order AS  orders ON   
 		invoices.sale_order = orders.id
 	LEFT JOIN order_lines AS lines ON 
 		orders.id = lines."OrderID"
	LEFT JOIN sale_order_type AS client_type ON 
		client_type.id = orders.order_type
	LEFT JOIN  res_partner AS customers ON 
	 	customers.id = orders.partner_id
	LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
		
	RIGHT JOIN invoices_upgrades ON 
	invoices_upgrades."Customer Reference" = customers."ref"
	 WHERE  
 		invoices."type" = 'out_invoice' AND
 		client_type."name" = '1. New Client' AND
 		invoices.state NOT IN ('cancel')
),
combined_data AS (
	SELECT * 
	FROM invoices_new
	UNION ALL
	SELECT * 
	FROM invoices_upgrades

)
SELECT DISTINCT * 

FROM combined_data
WHERE 
	combined_data."Date" >= '2016-01-01' AND
	combined_data."Date" <= '2018-08-31'

