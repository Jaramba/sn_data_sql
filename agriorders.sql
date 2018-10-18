SELECT  
	 	
   		UPPER (TRIM(customers."name")) 	AS "CustomerName",
 		customers.phone 				AS "Phone",
 		customers."ref" 				AS "Customer Reference",
 		client_type."name" 				AS "Client Type",
 		terms."name"					AS "Payment Term",
 		product_type.x_name				AS "ProductName",
 		products."name" 				AS "Product",
   		branches."name"					AS "Branch Name",
   		employees."name" 				AS "Sales Person",
   		invoices.company_id          	AS "Country", 
   		districts."name"				AS "District",
   		customers.village 				AS "Village",
   		customers.gender				AS "Gender",
   		customers.landmark				AS "Landmark",
   		customers.customer_relative 	AS "CustomerRelative",
   		customers.customer_relative_phone 	AS "RelativePhone"
  
   		
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
	 LEFT JOIN x_x_product_type_sale_order_x_product_type_rel AS product_sales ON
		product_sales.id1 = orders.id
	LEFT JOIN x_product_type AS product_type ON 
		product_sales.id2 = product_type.id
	LEFT JOIN res_district AS districts ON
		districts.id = customers.district_id
	WHERE  
  		invoices."type" = 'out_invoice' AND 
  		invoices.state IN ('open','paid') AND
  		invoices.date_invoice >= '2018-06-01' AND
  		product_type.x_name	LIKE 'Agri%'	