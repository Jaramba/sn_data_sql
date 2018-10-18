SELECT  
	 	invoices.date_invoice 			AS"Date",
   		branches."name"					AS "Branch Name",
   		jobs."name"						AS "Role",
   		contracts.date_start			AS "StartDate",
		contracts.date_end				AS "EndDate",
   		employees."name" 				AS "Sales Person",
  		invoices.amount_total        	AS "Gross Amount",
   		invoices.amount_net_invoice  	AS "Net Amount"
   		
	FROM  
 		account_invoice AS  invoices
 	LEFT JOIN  sale_order AS  orders ON 
   		invoices.sale_order = orders.id
 	LEFT JOIN  res_branch AS  branches ON 
		branches.id  = invoices.branch
	LEFT JOIN res_partner AS  customers ON 
	 	customers.id = invoices.partner_id
	LEFT JOIN  res_users AS  sales_people ON  
		sales_people.id = orders.user_id
	 LEFT JOIN res_partner AS  employees ON  
	  	employees.id = sales_people.partner_id
	 LEFT JOIN resource_resource  AS resource ON 
	 	resource.user_id = sales_people.id
	 LEFT JOIN hr_employee AS staff ON
	 	staff.resource_id = resource.id
	 LEFT JOIN hr_job AS jobs ON 
	 	jobs.id = staff.job_id
	 LEFT JOIN hr_contract AS contracts ON 
 	contracts.employee_id = staff.id 
	 
	  
	  
	WHERE  
  		invoices."type" = 'out_invoice' AND 
  		invoices.state IN ('open','paid') AND
  		invoices.date_invoice >= '2018-01-01' AND
  		invoices.date_invoice <= '2018-08-31' AND
  		invoices.company_id = 1
  		