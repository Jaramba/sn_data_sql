WITH invoices AS (
	SELECT   
		customers."name"            			AS "CustomerName",
	   	customers."ref"             			AS "Customer Reference",
	   	customers.gender  						AS "Gender",
	   	customers.birthdate2					AS "DOB",
	   	customers.phone             			AS "Phone",
	   	branches."name"             			AS "Branch Name",
	   	employees."name"            			AS "Sales Person",
	   	invoices.date_invoice       			AS "Invoice Date",
	 	templates."name"						AS "Product",
	 	products.id								AS "ProductId",
	 	lines.product_uom_qty 					AS "Quantity",
	 	lines.price_unit*lines.product_uom_qty 	AS "Price",	 									
	 	templates."type" 						AS "Type",
	 	lines.company_id						AS "Country"
 	FROM  
 		account_invoice as invoices
	LEFT JOIN  sale_order as orders on
 		invoices.sale_order = orders.id
	LEFT  JOIN  sale_order_line as lines on
		orders.id = lines.order_id
	LEFT JOIN product_product AS products ON 
		products.id = lines.product_id
	LEFT JOIN product_template AS templates ON 
		templates.id = products.product_tmpl_id
	left join res_branch as branches on
		branches.id  = orders.branch_id
	left join res_partner as customers on
 		customers.id = orders.partner_id
	left join res_users as sales_people on 
		sales_people.id = customers.user_id
 	left join res_partner as employees on 
 		 employees.id = sales_people.partner_id
	where 
		invoices."type" = 'out_invoice' AND
		invoices.state IN ('open', 'paid')
 
)
SELECT *
FROM invoices
WHERE 
invoices."Type" = 'product' AND 
invoices."ProductId" IN  ('459',
'693',
'356',
'168',
'681',
'616',
'695',
'739')



