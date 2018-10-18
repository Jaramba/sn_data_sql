WITH journals AS (
SELECT
	lines.id			AS "TRANSACTIONID",
	lines.date			AS "DATE",
	lines.create_date 	AS "CREATEDATE",
	lines.date_created 	AS "DATECREATED",
	periods."name" 		AS "PERIOD",
	accounts.code 		AS  "ACCOUNTCODE",
	employee."name"		AS "CREATEDBY", 
	lines.credit		AS "CREDIT", 
	lines.debit 		AS "DEBIT",
	lines."ref" 		AS "REFERENCE",
	lines.amount 		AS "AMOUNT",
	lines."name"		AS "DESCRIPTION"

	
FROM account_move_line AS lines
LEFT JOIN res_users AS creators ON 
	creators.id = lines.create_uid
left join res_partner as employee on 
	  	employee.id = creators.partner_id
left join account_account as accounts on
 accounts.id = lines.account_id
	  	
 LEFT JOIN account_period AS periods ON 
 periods.id = lines.period_id
 WHERE  
 accounts.code IN ('121600','121500','121501') AND
 lines.company_id = 1 AND
 	lines.date <= '2018-09-30' 

)

SELECT *
FROM journals