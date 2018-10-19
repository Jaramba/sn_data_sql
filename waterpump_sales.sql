WITH waterpump_orders  AS (
		SELECT
	 		orders.id		 				AS "ID",
	 		UPPER (TRIM(customers."name")) 	AS "CustomerName",		
 			customers."ref" 				AS "CustomerReference",
 			customers."phone"				AS "CustomerPhone",
 			branches."name"					AS "BranchName",
   			employees."name" 				AS "SalesPerson",
   			DATE (orders.create_date) 		AS "Date",
   			lines.product_id       			AS "ProductID",
		 	lines."name"           			AS "ProductName",	
   			lines.product_uom_qty 			AS "Quantity",
   			channel."name"          		AS "Channel",
	 		orders.state					AS "State",
  			orders.amount_total        		AS "GrossAmount",
   			orders.amount_net_sales  		AS "NetAmount",
   			'Orders' ::TEXT 				AS "Pipeline Stage", 
			ROW_NUMBER () OVER (PARTITION BY orders.id ORDER BY channel."name" DESC  ) AS "Numbers"
		FROM  
			sale_order AS  orders
 		LEFT JOIN  res_branch AS  branches ON 
			branches.id  = orders.branch_id
		LEFT  JOIN  sale_order_line as lines on
			orders.id = lines.order_id
		LEFT JOIN res_partner AS  customers ON 
	 		customers.id = orders.partner_id
		LEFT JOIN  res_users AS  sales_people ON  
			sales_people.id = orders.user_id
		 LEFT JOIN res_partner AS  employees ON  
	  		employees.id = sales_people.partner_id
	 	LEFT JOIN product_pricelist AS products ON 
	 		orders.pricelist_id = products.id
		LEFT JOIN crm_lead AS leads ON 
	   	 	leads.id = customers.lead_id
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
		WHERE  
		  	DATE (orders.create_date)  >= '20180101' AND 
	  		orders.company_id = 1 AND 
	  		lines.product_id IN ('459','693','356','168','681','616','695','739')
),

waterpump_installation_tickets AS (
	SELECT
	 		tickets.id		 				AS "ID",
	 		UPPER (TRIM(customers."name")) 	AS "CustomerName",		
 			customers."ref" 				AS "CustomerReference",
 			customers."phone"				AS "CustomerPhone",
 			branches."name"					AS "BranchName",
   			employees."name" 				AS "SalesPerson",
   			DATE (tickets.create_date) 		AS "Date",
   			lines.product_id       			AS "ProductID",
		 	lines."name"           			AS "ProductName",	
   			lines.product_uom_qty 			AS "Quantity",
   			channel."name"          		AS "Channel",
	 		tickets.state_install			AS "State",
  			orders.amount_total        		AS "GrossAmount",
   			orders.amount_net_sales  		AS "NetAmount",
   			'Installation' ::TEXT 			AS "Pipeline Stage", 
			ROW_NUMBER () OVER (PARTITION BY orders.id ORDER BY channel."name" DESC  ) AS "Numbers"
		FROM  
			ticket_ticket  AS tickets
		left join sale_order AS orders on 
 			 orders.id = tickets.sale_order_id
 		LEFT JOIN  res_branch AS  branches ON 
			branches.id  = orders.branch_id
		LEFT  JOIN  sale_order_line as lines on
			orders.id = lines.order_id
		LEFT JOIN res_partner AS  customers ON 
	 		customers.id = orders.partner_id
		LEFT JOIN  res_users AS  sales_people ON  
			sales_people.id = orders.user_id
		 LEFT JOIN res_partner AS  employees ON  
	  		employees.id = sales_people.partner_id
	 	LEFT JOIN product_pricelist AS products ON 
	 		orders.pricelist_id = products.id
		LEFT JOIN crm_lead AS leads ON 
	   	 	leads.id = customers.lead_id
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
		WHERE  
		  	DATE (tickets.create_date)  >= '20180101' AND 
	  		orders.company_id = 1 AND 
	  		lines.product_id IN ('459','693','356','168','681','616','695','739')	

),
water_pump_invoices AS (
		SELECT
	 		invoices.id		 				AS "ID",
	 		UPPER (TRIM(customers."name")) 	AS "CustomerName",		
 			customers."ref" 				AS "CustomerReference",
 			customers."phone"				AS "CustomerPhone",
 			branches."name"					AS "BranchName",
   			employees."name" 				AS "SalesPerson",
   			date (invoices.date_invoice) 	AS "Date",
   			lines.product_id       			AS "ProductID",
		 	lines."name"           			AS "ProductName",	
   			lines.product_uom_qty 			AS "Quantity",
   			channel."name"          		AS "Channel",
	 		invoices.state					AS "State",
  			invoices.amount_total        	AS "GrossAmount",
   			invoices.amount_net_invoice  	AS "NetAmount",
   			'Invoices' ::TEXT 				AS "Pipeline Stage", 
			ROW_NUMBER () OVER (PARTITION BY invoices.id ORDER BY channel."name" DESC  ) AS "Numbers"
		FROM  
 			account_invoice AS  invoices
 		LEFT JOIN  res_branch AS  branches ON 
			branches.id  = invoices.branch
		LEFT JOIN  sale_order AS  orders ON 
   			invoices.sale_order = orders.id
		LEFT  JOIN  sale_order_line as lines on
			orders.id = lines.order_id
		LEFT JOIN res_partner AS  customers ON 
	 		customers.id = invoices.partner_id
		LEFT JOIN  res_users AS  sales_people ON  
			sales_people.id = orders.user_id
		 LEFT JOIN res_partner AS  employees ON  
	  		employees.id = sales_people.partner_id
	 	LEFT JOIN product_pricelist AS products ON 
	 		orders.pricelist_id = products.id
		LEFT JOIN crm_lead AS leads ON 
	   	 	leads.id = customers.lead_id
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
		WHERE  
		  	invoices."type" = 'out_invoice' AND 
	  		invoices.state IN ('open','paid') AND 
	  		invoices.date_invoice >= '20180101' AND 
	  		invoices.company_id = 1 AND 
	  		lines.product_id IN ('459','693','356','168','681','616','695','739')
),
merged AS (
		SELECT 
		*
		FROM  
			waterpump_orders
		UNION ALL
		SELECT 
		*
		FROM 
			water_pump_invoices
		UNION ALL
		SELECT 
		*
		FROM 
			waterpump_installation_tickets

),

count_occurrence AS (
		SELECT 
			merged."ID" 			AS "ID",
			MAX(merged."Numbers") 	AS "Occurrences"
		FROM 
			merged
		GROUP BY 
			merged."ID"

)

SELECT 
	merged.*, 
	merged."NetAmount"/ count_occurrence."Occurrences" AS "NetAmount",
	merged."GrossAmount" / count_occurrence."Occurrences" AS "GrossAmount",
	count_occurrence."Occurrences"
FROM 
	merged
LEFT JOIN count_occurrence ON 
	count_occurrence."ID" =merged."ID"