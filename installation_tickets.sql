WITH installations AS (
	SELECT
		date(tickets.create_date )   as "Date",
		tickets.state_install        as "State",
		customers."name"             as  "CustomerName",
		customers.phone              as  "Phone",
		customers."ref"              as "Customer Reference",
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
	 tickets."type" = 'install'
	)
	SELECT COUNT(*)
	FROM installations
	
	SELECT * FROM 