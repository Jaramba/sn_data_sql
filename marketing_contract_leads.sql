WITH merged AS 

(SELECT 
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
 		'Orders' ::TEXT 				AS "Pipeline Stage",
 		leads."type"            		AS "Status",
		lead_type."name"        		AS "Occupation ",
		channel."name"          		AS "Channel",
		stages."name"           		AS "Stage",
		sources."name" 					AS "Source"
 	FROM 
 		sale_order as orders
	left join res_branch as branches on
		branches.id  = orders.branch_id
	LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	left join res_partner as customers on
	 	customers.id = orders.partner_id
	LEFT JOIN crm_lead AS leads ON 
	    leads.id = customers.lead_id
	left join res_users as sales_people on 
		sales_people.id = orders.user_id
	 left join res_partner as employees on 
	  	employees.id = sales_people.partner_id
	 LEFT JOIN product_pricelist AS products ON 
	 	orders.pricelist_id = products.id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	 LEFT JOIN crm_lead_category AS lead_type ON 
	lead_type.id = leads.category_id
LEFT JOIN crm_case_stage AS stages ON 
	stages.id = leads.stage_id
LEFT JOIN crm_lead_category_rel AS relation ON
	relation.lead_id = leads.id
LEFT JOIN crm_case_categ AS channel ON
	channel.id  = relation.category_id
LEFT JOIN ir_model AS models ON 
	models.id = channel.object_id AND
	models.id = 328
LEFT JOIN crm_tracking_source AS sources ON 
	sources.id = leads.source2_id
	where 
	  	date(orders.create_date) >= '2018-01-01' AND
	  	orders.state IN ('draft','cancel', 'rejected','sent','incomplete','assessment','approval') AND
		orders.amount_total > 0 AND 
		orders.company_id = 1 

)

SELECT *
FROM merged 
WHERE merged."Channel" IS NOT NULL AND
merged."Channel" NOT IN ('Sales representative')

