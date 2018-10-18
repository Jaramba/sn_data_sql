SELECT 
	DATE (payslips.create_date)		AS "Date",
	benefits.employee_amount		AS "Amount",
	categories."name" 				AS "Description",
	staff.name_related 				AS "Employee"	
FROM hr_payslip_benefit_line AS benefits
LEFT JOIN hr_employee_benefit_category AS categories ON
categories.id = benefits.category_id
LEFT JOIN hr_payslip AS payslips ON 
benefits.payslip_id = payslips.id
LEFT JOIN hr_employee AS staff ON 
staff.id = payslips.employee_id
WHERE 
	date (payslips.create_date) >= '2018-01-01' AND
	benefits.employee_amount > 0  AND 
	categories."name" IN ('Overtime','Bonus') AND 
	payslips.company_id = 1