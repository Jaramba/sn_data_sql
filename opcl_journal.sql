
	SELECT 
	    account_lines.move_id 							AS "Journal Entry",
	    account_lines."date" 							AS "Effective Date",
	    account_lines."name"							AS "Detailed Description",
	    account_lines."ref" 							AS "Reference",
	    journals."name" 								AS "Account Name",
	    accounts."name"									AS "Cost",
	    accounts.code            						AS "Account",
	    --COALESCE (cost_centers."name",'No Cost Center') AS "Cost Center", 
	    account_lines.company_id 						AS "Company",
	    account_lines.amount      						AS "Amount"
    
	FROM 
		account_move_line AS account_lines
	LEFT JOIN  account_journal AS journals ON  
 		account_lines.journal_id = journals.id
	LEFT JOIN  account_account AS accounts ON 
		 accounts.id = account_lines.account_id
	LEFT JOIN  account_cost_center AS cost_centers ON 
 		account_lines.cost_center_id = cost_centers.id 
	WHERE   
		journals.code = 'OPCL'
  	
