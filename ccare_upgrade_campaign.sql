WITH ccare_officers AS (
	SELECT
		DATE(staff.create_date)	AS "CreationDate",
		staff.id 				AS "ID",
		users.id				AS "UserId",
		staff.birthday 			AS  "DOB",
		staff.name_related		AS "StaffName",
		department."name"		AS "Department",
		jobs."name"				AS "Job",
		staff.gender		 	AS "Gender",
		res.company_id			AS "Country"
	
 	FROM hr_employee AS staff 
 	LEFT JOIN hr_job AS jobs ON 
 		jobs.id = staff.job_id 
 	LEFT JOIN resource_resource AS res  ON  
 		res.id = staff.resource_id
 	LEFT JOIN hr_department AS department ON 
 		department.id = staff.department_id
 	LEFT JOIN res_users AS users ON 
 		users.id = res.user_id
	WHERE 
		jobs.id = 119		
),
partner_comments AS (
 	SELECT 
 		DATE(partner_comments.create_date) 								AS "CreateDate",
 		partner_comments.partner_id 									AS "Partner ID",
 		COALESCE (Officers."StaffName",cco."StaffName") 				AS "Comment Creator",
 		partner_comments."name" 										AS " Comment",
 		partner_comments.x_followupaction 								AS "Action",
 		ROW_NUMBER () OVER (PARTITION BY partner_comments.partner_id 	ORDER BY 
 		partner_comments.create_date DESC  ) 							AS "Number"
 	FROM partner_comment AS partner_comments 
 	LEFT JOIN ccare_officers AS officers on 
		partner_comments.create_uid = officers."UserId"
	LEFT JOIN ccare_officers AS cco on 
		partner_comments.write_uid = cco."UserId"
 	WHERE 
 		DATE(partner_comments.create_date) >= '2018-07-01' AND 
 		partner_comments.x_followupaction IN ('care')
),
invoices_upgrades AS (
	SELECT  
	 	DATE(invoices.create_date) 										AS "Date",
	 	invoices.state													AS "State",
   		UPPER (TRIM(customers."name")) 									AS "CustomerName",
 		customers.phone 												AS "Phone",
 		orders.create_date												AS "OrderDate",
 		customers."ref" 												AS "Customer Reference",
 		client_type."name" 												AS "Client Type",
 		terms."name"													AS "Payment Term",
 		products."name" 												AS "Product",
   		branches."name"													AS "Branch Name",
   		pcomments."Comment Creator"										AS "Comment/Lead Creator",
   		COALESCE(trim(leads.x_referred),trim(cc."StaffName"))			AS "Referred By",		
   		employees."name" 												AS "Sales Person",
  		invoices.amount_total        									AS "Gross Amount",
   		invoices.amount_net_invoice  									AS "Net Amount",
   		invoices.company_id          									AS "Country", 
   		'Invoices' ::TEXT 												AS "Pipeline Stage" 		
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
	LEFT JOIN crm_lead AS leads ON 
	    leads.id = customers.lead_id
	LEFT JOIN ccare_officers AS cc ON 
		cc."UserId" = leads.create_uid
	LEFT JOIN res_users AS sales_people ON  
		sales_people.id = orders.user_id
	 LEFT JOIN  res_partner AS  employees ON  
	  	employees.id = sales_people.partner_id
	 LEFT JOIN product_pricelist AS products ON 
	 	orders.pricelist_id = products.id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	 LEFT JOIN partner_comments AS pcomments ON 
	 	pcomments."Partner ID" = invoices.partner_id AND 
	 	pcomments."Number" = 1 AND 
	 	pcomments."CreateDate" < DATE(orders.create_date)
	 WHERE  
 		invoices."type" = 'out_invoice' AND
 		client_type."name" = '2. Returning Client' AND
 		invoices.state IN ('open', 'paid','draft') AND
 		invoices.date_invoice >= '2018-08-01'
 ),
invoices_new AS (
	SELECT 
	 	COALESCE (invoices.date_invoice, DATE(invoices.create_date)) 	AS "Date",
	 	invoices.state													AS "State",
   		UPPER (TRIM(customers."name")) 									AS "CustomerName",
 		customers.phone 												AS "Phone",
 		orders.create_date												AS "OrderDate",
 		customers."ref" 												AS "Customer Reference",
 		client_type."name" 												AS "Client Type",
 		terms."name"													AS "Payment Term",
 		products."name" 												AS "Product",
   		branches."name"													AS "Branch Name",
   		COALESCE(trim(cc."StaffName"),trim(cc2."StaffName"))			AS "Comment/Lead Creator",
   		trim(leads.x_referred)											AS "Referred By", 
   		employees."name" 												AS "Sales Person",
  		invoices.amount_total        									AS "Gross Amount",
   		invoices.amount_net_invoice  									AS "Net Amount",
   		invoices.company_id          									AS "Country", 
   		'Invoices' ::TEXT 												AS "Pipeline Stage" 		
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
	LEFT JOIN crm_lead AS leads ON 
	    leads.id = customers.lead_id
	LEFT JOIN crm_lead AS cleads ON 
	    cleads.id = customers.lead_id 
	LEFT JOIN ccare_officers AS cc ON 
		cc."UserId" = leads.create_uid
	LEFT JOIN ccare_officers AS cc2 ON 
		cc2."UserId" = leads.write_uid
	LEFT JOIN res_users AS sales_people ON  
		sales_people.id = orders.user_id
	 LEFT JOIN  res_partner AS  employees ON  
	  	employees.id = sales_people.partner_id
	 LEFT JOIN product_pricelist AS products ON 
	 	orders.pricelist_id = products.id
	 LEFT JOIN account_payment_term AS terms ON 
	 	terms.id = orders.payment_term
	 WHERE  
 		invoices."type" = 'out_invoice' AND
 		client_type."name" = '1. New Client' AND
 		invoices.state IN ('open', 'paid','draft')
 		
 	
),
combined_data AS (
	SELECT * 
	FROM invoices_new
	UNION ALL
	SELECT * 
	FROM invoices_upgrades

)
SELECT * 

FROM combined_data
WHERE 
	combined_data."Date" >= '2018-08-01'

	
