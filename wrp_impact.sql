WITH sales_pipeline AS (
	SELECT 
 		DATE(orders.create_date )		AS "Date",
 		orders.state 					AS "State",
 		UPPER (TRIM(customers."name")) 	AS "CustomerName",
 		customers.phone 				AS "Phone",
 		customers."ref" 				AS "Customer Reference",
 		client_type."name" 				AS "Client Type",
 		terms."name"					AS "Payment Term",
 		products."name" 				AS "Product",
 		branches."name" 				AS "Branch Name",
 		employees."name" 				AS "Sales Person",
 		orders.amount_total 			AS "Gross Amount",
 		orders.amount_net_sales 		AS "Net Sales",
 		orders.company_id 				AS "Country",
 		'Orders' ::TEXT 				AS "Pipeline Stage"
 	
 	FROM 
 		sale_order AS orders
	LEFT JOIN res_branch AS branches ON
		branches.id  = orders.branch_id
	LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	LEFT JOIN res_partner AS  customers ON 
	 	customers.id = orders.partner_id
	LEFT JOIN res_users AS sales_people ON 
		sales_people.id = orders.user_id
	 LEFT JOIN res_partner AS employees ON  
	  	employees.id = sales_people.partner_id
	 LEFT JOIN product_pricelist AS products ON 
	 	orders.pricelist_id = products.id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	WHERE 
	  	date(orders.create_date) >= '2016-01-01' AND
		orders.amount_total > 0
),
 draft_revenue_all as(
	SELECT 
	 	date (invoices.create_date)		AS "Date",
	 	invoices.state					AS "State",
   		UPPER (TRIM(customers."name")) 	AS "CustomerName",
 		customers.phone 				AS "Phone",
 		customers."ref" 				AS "Customer Reference",
 		client_type."name" 				AS "Client Type",
 		terms."name"					AS "Payment Term",
 		products."name" 				AS "Product",
   		branches."name"					AS "Branch Name",
   		employees."name" 				AS "Sales Person",
  		invoices.amount_total        	AS "Gross Amount",
   		invoices.amount_net_invoice  	AS "Net Amount",
   		invoices.company_id          	AS "Country", 
   		'Invoices' ::TEXT 				AS "Pipeline Stage",
   		'Revenue' ::TEXT 				AS "Revenue",
   		tickets.state_install 			AS "Install",
   		(ROW_NUMBER () OVER (PARTITION BY invoices.partner_id ORDER BY tickets.create_date DESC)) AS "Numbers"
	FROM  
 		account_invoice AS  invoices
 	LEFT JOIN  res_branch AS  branches ON 
		branches.id  = invoices.branch
	LEFT JOIN  sale_order AS  orders ON 
   		invoices.sale_order = orders.id
	LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	LEFT JOIN res_partner AS  customers ON 
	 	customers.id = invoices.partner_id
	LEFT JOIN  res_users AS  sales_people ON  
		sales_people.id = orders.user_id
	 LEFT JOIN res_partner AS  employees ON  
	  	employees.id = sales_people.partner_id
	 LEFT JOIN product_pricelist AS products ON 
	 	orders.pricelist_id = products.id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	 LEFT JOIN ticket_ticket AS tickets ON
	 	tickets.partner_id = invoices.partner_id
	WHERE  
  		invoices."type" = 'out_invoice' AND 
  		invoices.state IN ('draft') AND
  		date (invoices.create_date) >= '2016-01-01'
  		
),
draft_revenue as (
	SELECT
		"Date",
	 	 "State",
   		"CustomerName",
 		"Phone",
 		 "Customer Reference",
 		"Client Type",
 		 "Payment Term",
 		 "Product",
   		 "Branch Name",
   		"Sales Person",
  		"Gross Amount",
   		 "Net Amount",
   		"Country", 
   		"Pipeline Stage"
   	

	 FROM draft_revenue_all
	WHERE 
		"Numbers" = 1 AND
		"Install" IN ('open','stock_given_out','installed')
 
),
installed_revenue as (
	SELECT  
	 	invoices.date_invoice 			AS"Date",
	 	invoices.state					AS "State",
   		UPPER (TRIM(customers."name")) 	AS "CustomerName",
 		customers.phone 				AS "Phone",
 		customers."ref" 				AS "Customer Reference",
 		client_type."name" 				AS "Client Type",
 		terms."name"					AS "Payment Term",
 		products."name" 				AS "Product",
   		branches."name"					AS "Branch Name",
   		employees."name" 				AS "Sales Person",
  		invoices.amount_total        	AS "Gross Amount",
   		invoices.amount_net_invoice  	AS "Net Amount",
   		invoices.company_id          	AS "Country", 
   		'Invoices' ::TEXT 				AS "Pipeline Stage"
   		
	FROM  
 		account_invoice AS  invoices
 	LEFT JOIN  res_branch AS  branches ON 
		branches.id  = invoices.branch
	LEFT JOIN  sale_order AS  orders ON 
   		invoices.sale_order = orders.id
	LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	LEFT JOIN res_partner AS  customers ON 
	 	customers.id = invoices.partner_id
	LEFT JOIN  res_users AS  sales_people ON  
		sales_people.id = orders.user_id
	 LEFT JOIN res_partner AS  employees ON  
	  	employees.id = sales_people.partner_id
	 LEFT JOIN product_pricelist AS products ON 
	 	orders.pricelist_id = products.id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	WHERE  
  		invoices."type" = 'out_invoice' AND 
  		invoices.state IN ('open','paid') AND
  		invoices.date_invoice >= '2018-01-01' 	
),
merged_all AS (
		SELECT  * 
		FROM  sales_pipeline
		UNION  ALL
		SELECT  *
		FROM  installed_revenue
		UNION  ALL
		SELECT  *
		FROM  draft_revenue
)

SELECT *
FROM merged_all






		