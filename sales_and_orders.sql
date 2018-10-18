SELECT  
	 	invoices.date_invoice 			AS"Date",
  		SUM (invoices.amount_total )    AS "Gross Amount",
   		invoices.company_id          	AS "Country"
   		
	FROM  
 		account_invoice AS  invoices
	WHERE  
  		invoices."type" = 'out_invoice' AND 
  		invoices.state IN ('open','paid') AND
  		invoices.date_invoice >= '2018-06-01' 
  	GROUP BY 
  		invoices.date_invoice,
  		invoices.company_id      
  
  SELECT 
 		DATE(orders.create_date )		AS "Date",
 		orders.state 					AS "State",
 		COUNT (orders.id) 				AS "Orders",
 		orders.company_id
		 	
 	FROM 
 		sale_order AS orders
	WHERE 
	  	date(orders.create_date) >= '2018-06-01' AND
		orders.amount_total > 0
	GROUP BY
		DATE(orders.create_date ),
		orders.state ,
		orders.company_id