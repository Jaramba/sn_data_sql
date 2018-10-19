WITH sales_pipeline AS (
	SELECT 
 		DATE(orders.create_date )		AS "Date",
 		orders.state 					AS "State",
 		branches."name" 				AS "BranchName",
 		employees."name" 				AS "SalesPerson",
 		orders.amount_total 			AS "GrossAmount",
 		orders.amount_net_sales 		AS "NetAmount",
 		orders.company_id 				AS "Country",
 		'Orders' ::TEXT 				AS "PipelineStage"
 	FROM 
 		sale_order AS orders
	LEFT JOIN res_branch AS branches ON
		branches.id  = orders.branch_id
	LEFT JOIN sale_order_type AS client_type ON
		client_type.id = orders.order_type
	LEFT JOIN res_users AS sales_people ON 
		sales_people.id = orders.user_id
	 LEFT JOIN res_partner AS employees ON  
	  	employees.id = sales_people.partner_id
	WHERE 
	  	date(orders.create_date) >= '2016-01-01' AND
		orders.amount_total > 0
),
 draft_revenue_all as(
	SELECT 
	 	date (invoices.create_date)		AS "Date",
	 	tickets.state_install			AS "State",
   		branches."name"					AS "BranchName",
   		employees."name" 				AS "SalesPerson",
  		invoices.amount_total        	AS "GrossAmount",
   		invoices.amount_net_invoice  	AS "NetAmount",
   		invoices.company_id          	AS "Country", 
   		'Installation' ::TEXT 			AS "PipelineStage",
   		(ROW_NUMBER () OVER (PARTITION BY invoices.partner_id ORDER BY tickets.create_date DESC)) AS "Numbers"
	FROM  
 		account_invoice AS  invoices
 	LEFT JOIN  res_branch AS  branches ON 
		branches.id  = invoices.branch
	LEFT JOIN  sale_order AS  orders ON 
   		invoices.sale_order = orders.id
	LEFT JOIN res_partner AS  customers ON 
	 	customers.id = invoices.partner_id
	LEFT JOIN  res_users AS  sales_people ON  
		sales_people.id = orders.user_id
	 LEFT JOIN res_partner AS  employees ON  
	  	employees.id = sales_people.partner_id
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
   		"BranchName",
   		"SalesPerson",
  		"GrossAmount",
   		"NetAmount",
   		"Country", 
   		"PipelineStage"
	 FROM draft_revenue_all
	WHERE 
		"Numbers" = 1 AND
		"State" IN ('open','stock_given_out','installed','in_complete')
 
),
verified_revenue as (
	SELECT  
	 	invoices.date_invoice 			AS"Date",
	 	invoices.state					AS "State",
   		branches."name"					AS "BranchName",
   		employees."name" 				AS "SalesPerson",
  		invoices.amount_total        	AS "GrossAmount",
   		invoices.amount_net_invoice  	AS "NetAmount",
   		invoices.company_id          	AS "Country", 
   		'Invoices' ::TEXT 				AS "Pipeline Stage"
   		
	FROM  
 		account_invoice AS  invoices
 	LEFT JOIN  res_branch AS  branches ON 
		branches.id  = invoices.branch
	LEFT JOIN  sale_order AS  orders ON 
   		invoices.sale_order = orders.id
	LEFT JOIN  res_users AS  sales_people ON  
		sales_people.id = orders.user_id
	 LEFT JOIN res_partner AS  employees ON  
	  	employees.id = sales_people.partner_id
	WHERE  
  		invoices."type" = 'out_invoice' AND 
  		invoices.state IN ('open','paid') AND
  		invoices.date_invoice >= '2016-01-01' 	
),
merged_all AS (
		SELECT  * 
		FROM  sales_pipeline
		UNION  ALL
		SELECT  *
		FROM  verified_revenue
		UNION  ALL
		SELECT  *
		FROM  draft_revenue
)

SELECT
	"Date",
	"State",
   	"BranchName",
   	"SalesPerson",
  	SUM("GrossAmount") 	AS "GrossAmount",
   	SUM("NetAmount")	AS "NetAmount",
   	"Country", 
   	"PipelineStage"
FROM merged_all
GROUP BY 
	"Date",
	"State",
   	"BranchName",
   	"SalesPerson",
  	"Country", 
   	"PipelineStage"

