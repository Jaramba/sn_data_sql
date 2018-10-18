WITH channels AS 

(
 	SELECT  
	 	date (invoices.date_invoice) 	AS"Date",
	 	invoices.state					AS "State",
   		UPPER (TRIM(customers."name")) 	AS "CustomerName",
 		
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
 		leads."type"            		AS "Status",
		lead_type."name"        		AS "Occupation ",
		channel."name"          		AS "Channel",
		stages."name"           		AS "Stage",
		sources."name" 					AS "Source",
		ROW_NUMBER () OVER (PARTITION BY customers."ref" ORDER BY channel."name" DESC  ) AS "Number"
 
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
  		invoices.date_invoice >= '20180801' AND 
  		invoices.company_id = 1
  		

)



SELECT 
	channels.*, 
	channels."Net Amount"/ channels."Number" AS "NetAmountPerChannel"
FROM channels

