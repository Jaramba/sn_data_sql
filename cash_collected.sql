
WITH lines AS (
SELECT 
	DATE (banks."date") 					AS "Date",
	DATE (customers.create_date)			AS "SPV Date",
	DATE (banks.create_date)				AS "Date",
	branches."name"							AS "Branch",
	state_ments."name"						AS "Statement",
	customers."ref" 						AS "CustomerReference",
	customers."name" 						AS "PartnerName",
	banks.amount							AS "Amount",
	banks.payplan_reconciliation_summary 	AS "Summary"
FROM account_bank_statement_line AS banks 
LEFT JOIN res_partner AS customers ON 
	customers.id = banks.partner_id
LEFT JOIN res_branch AS branches ON 
	branches.id = customers.branch_id
LEFT JOIN account_journal AS journals ON
	journals.id = banks.journal_id
LEFT JOIN account_bank_statement AS state_ments ON
	state_ments.id =  banks.statement_id
	

WHERE 
	banks.amount > 0 AND
	DATE (banks.create_date) >= '2016-05-01' AND
	DATE (banks.create_date) <= '2018-09-30' AND
	banks.company_id = 1 AND 
	journals.id	IN ('112','25','53','18','20','47','19','110','13')
	

)

SELECT DISTINCT "name" FROM account_move_line LIMIT 10
SELECT * FROM lines
WHERE lines."CustomerReference" IS NOT NULL

LIMIT 10
SELECT * FROM account_bank_statement LIMIT 10 
SELECT * FROM account_bank_statement_line  LIMIT 10
SELECT * FROM account_move_line LIMIT 10 
SELECT * FROM res_partner LIMIT 10

SELECT * FROM account