--New Invoices for new clients----
WITH invoices_new AS (
	SELECT 
	 	invoices.date_invoice 			AS "Date",
	 	orders."name"					AS "OrderName",	
	 	invoices.state					AS "State",
   		UPPER (TRIM(customers."name")) 	AS "CustomerName",
 		customers.phone 				AS "Phone",
 		customers."ref" 				AS "CustomerReference",
 		client_type."name" 				AS "ClientType",
 		terms."name"					AS "PaymentTerm",
   		branches."name"					AS "BranchName",
   		product_type.x_name  			AS "ProductName",
   		ROW_NUMBER () OVER (
   			PARTITION BY 
   				customers."ref" 
   			ORDER BY invoices.date_invoice DESC
   		)								AS "Numbers"
	FROM 
 		account_invoice AS invoices
 	LEFT JOIN  res_branch AS branches ON
		branches.id  = invoices.branch
	LEFT JOIN  sale_order AS  orders ON   
 		invoices.sale_order = orders.id
	LEFT JOIN sale_order_type AS client_type ON 
		client_type.id = orders.order_type
	LEFT JOIN  res_partner AS customers ON 
	 	customers.id = orders.partner_id
	LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	LEFT JOIN x_x_product_type_sale_order_x_product_type_rel AS product_sales ON
		product_sales.id1 = orders.id
	LEFT JOIN x_product_type AS product_type ON 
		product_type.id = product_sales.id2
	WHERE  
 		invoices."type" = 'out_invoice' AND
 		--client_type."name" = '1. New Client' AND
 		invoices.state IN ('open','paid')
),
----Upgrades: Returning client trying to link this with all existing clients-----
invoices_upgrades AS (
	SELECT  
	 	invoices.date_invoice	  		AS "Date",
	 	invoices.state					AS "State",
   		UPPER (TRIM(customers."name")) 	AS "CustomerName",
 		customers."ref" 				AS "CustomerReference",
 		client_type."name" 				AS "ClientType",
 		terms."name"					AS "PaymentTerm",	 
   		branches."name"					AS "BranchName",
   		invoices_new."Date"				AS "OriginalBuying Date",
   		invoices_new."ProductName"		AS "OriginalProduct",
   		invoices.amount_total			AS "Amount",
   		product_type.x_name				AS "ProductName"
   		
	FROM 
 		account_invoice AS invoices
 	LEFT JOIN  res_branch AS branches ON
		branches.id  = invoices.branch
	LEFT JOIN  sale_order AS  orders ON 
 		invoices.sale_order = orders.id
	LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	LEFT JOIN  res_partner AS customers ON 
	 	customers.id = orders.partner_id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term 
	 LEFT JOIN invoices_new ON 
		invoices_new."CustomerReference" = customers."ref" AND
		invoices_new."Numbers" = 1	
	LEFT JOIN x_x_product_type_sale_order_x_product_type_rel AS product_sales ON
		product_sales.id1 = orders.id
	LEFT JOIN x_product_type AS product_type ON 
		product_type.id = product_sales.id2
	 WHERE  
 		invoices."type" = 'out_invoice' AND
 		client_type."name" = '2. Returning Client' AND
 		invoices.state IN ('open','paid')

)
SELECT * 
FROM invoices_upgrades 
WHERE
"OriginalProduct" IS NOT NULL

