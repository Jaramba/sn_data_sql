SELECT 
 		DATE(orders.create_date )		AS "Date",
 		orders.state 					AS "State",
 		branches."name" 				AS "Branch Name",
 		COUNT (orders.id)				AS "Number"
 	
 	FROM  
 		sale_order AS orders
	LEFT JOIN res_branch AS branches ON
		branches.id  = orders.branch_id
	
	WHERE 
	  	date(orders.create_date) >= '2018-01-01' AND
	  	date(orders.create_date) <= '2018-08-31'  AND 
	  	orders.state IN ('assesment','incomplete','approval','approved','done') AND
	  	orders.company_id = 1
	GROUP BY 
			DATE(orders.create_date ),
			orders.state,
			branches."name"
			
	SELECT DISTINCT state FROM sale_order