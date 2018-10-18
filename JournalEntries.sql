WITH salary_journal_entries AS (
	SELECT 
	    account_lines.move_id 							AS "Journal Entry",
	    account_lines."date" 							AS "Effective Date",
	    account_lines."name"							AS "Detailed Description",
	    account_lines."ref" 							AS "Reference",
	    journals."name" 								AS "Account Name",
	    accounts."name"									AS "Cost",
	    accounts.code            						AS "Account",
	    COALESCE (cost_centers."name",'No Cost Center') AS "Cost Center", 
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
  		account_lines."date" > '2018-01-01' AND 
  		account_lines.amount > 0 AND
   		journals."name" = 'Salary'
),
other_journal_entries AS (
	SELECT 
	    account_lines.move_id 							AS "Journal Entry",
	    account_lines."date" 							AS "Effective Date",
	    account_lines."name"							AS "Detailed Description",
	    account_lines."ref" 							AS "Reference",
	    journals."name" 								AS "Account Name",
	    accounts."name"									AS "Cost",
	    accounts.code            						AS "Account",
	    COALESCE (cost_centers."name",'No Cost Center') AS "Cost Center", 
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
  		account_lines."date" > '2018-01-01' AND 
  		journals."name" != 'Salary' AND
   		accounts.code in ('431001',
							'431002',
							'431300',
							'431400',
							'431500',
							'431600',
							'431700',
							'431800',
							'431900',
							'433011',
							'435008',
							'435006',
							'433004',
							'433005',
							'433006',
							'433007',
							'433008',
							'435001',
							'435002',
							'435003',
							'435004',
							'435005',
							'435007',
							'435009',
							'435010',
							'435011',
							'432',
							'432001',
							'432002',
							'432003',
							'432004',
							'432005',
							'432006',
							'432007',
							'432008',
							'433',
							'433001',
							'433002',
							'433003',
							'433010',
							'433020',
							'433021',
							'433022',
							'433023',
							'433024',
							'433025',
							'433026',
							'433030',
							'433031',
							'433040',
							'433041',
							'433042',
							'433043',
							'433044',
							'433000',
							'434',
							'434001',
							'434002',
							'434004',
							'434005',
							'434006',
							'434007',
							'434008',
							'434009',
							'434010',
							'434011',
							'434012',
							'434013',
							'434014',
							'434015',
							'434016',
							'434017',
							'434018',
							'434019',
							'434020',
							'434021',
							'434022',
							'434023',
							'434024',
							'434025',
							'434026',
							'434100',
							'436',
							'436007'
)
),
merged AS (
SELECT *
 FROM salary_journal_entries
UNION ALL
SELECT *
 FROM other_journal_entries)

SELECT * FROM merged
WHERE merged."Effective Date" >= '2018-09-01'