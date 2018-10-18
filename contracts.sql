WITH all_orders AS (
	SELECT 
 		date(orders.create_date )		AS "Date",
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
 		sale_order as orders
	left join res_branch as branches on
		branches.id  = orders.branch_id
	LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	left join res_partner as customers on
	 	customers.id = orders.partner_id
	left join res_users as sales_people on 
		sales_people.id = orders.user_id
	 left join res_partner as employees on 
	  	employees.id = sales_people.partner_id
	 LEFT JOIN product_pricelist AS products ON 
	 	orders.pricelist_id = products.id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	where 
	  	date(orders.create_date) >= '2015-01-01' AND
	  	orders.state IN ('draft','cancel', 'rejected','sent','incomplete','approved','assessment','approval') AND
		orders.amount_total > 0
)

SELECT *
FROM all_orders

 
  SELECT * FROM sale LIMIT 10 
  SELECT DISTINCT state FROM  sale_order
  
  SELECT * FROM hr_employee WHERE name_related LIKE 'Edg%'
  
  SELECT * FROM mail_message LIMIT 10 