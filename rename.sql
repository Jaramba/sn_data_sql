WITH tracked_all_orders AS (
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
	  	date(orders.create_date) >= '2015-01-01' AND
	  	orders.state IN ('draft','incomplete','assessment','approval','approved','sent','cancel', 'rejected') AND
		orders.amount_total > 0
),
installations AS  (
	SELECT
		date(tickets.create_date )   	AS "Date",
		tickets.state_install        	AS "State",
		customers."name"             	AS "CustomerName",
		customers.phone              	AS "Phone",
		customers."ref"              	AS "Customer Reference",
		client_type."name" 				AS "Client Type",
 		terms."name"					AS "Payment Term",
 		products."name" 				AS "Product",
 		branches."name" 				AS "Branch Name",
 		employees."name" 				AS "Sales Person",
 		orders.amount_total 			AS "Gross Amount",
 		orders.amount_net_sales 		AS "Net Sales",
 		orders.company_id 				AS "Country",
 		'Installation' ::TEXT 			AS "Pipeline Stage"
	 
	from ticket_ticket  as tickets
	 left join res_branch as branches on 
	 tickets.partner_branch_id = branches.id
	 left join res_partner as customers on 
	 tickets.partner_id = customers.id
	 left join sale_order as orders on 
	  orders.id = tickets.sale_order_id
	  LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	 left join res_users as sales_people on 
	  sales_people.id = orders.user_id
	 left join res_partner as employees on 
	  employees.id = sales_people.partner_id
	 LEFT JOIN product_pricelist AS products ON 
	 	orders.pricelist_id = products.id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term 

	where 
	 tickets."type" = 'install' AND 
	 tickets.state_install IN ('open','installed','stock_given_out') AND
	 date(tickets.create_date ) >= '2015-01-01'
),
invoices as (
	SELECT  
	 	invoices.create_date		AS"Date",
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
  		invoices.state IN ('draft') AND
  		invoices.create_date >= '2015-01-01' 	
),
merged_all AS (
		SELECT  * 
		FROM  tracked_all_orders
		UNION  ALL
		SELECT  * 
		FROM  installations
		UNION  ALL
		SELECT  *
		FROM  invoices
)

SELECT *
FROM merged_all
