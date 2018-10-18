SELECT 
	DATE(staff.create_date)	AS "CreationDate",
	staff.id 				AS "ID",
	staff.birthday 			AS  "DOB",
	staff.name_related		AS "StaffName",
	department."name"		AS "Department",
	jobs."name"				AS "Job",
	staff.gender		 	AS "Gender",
	contracts.date_start	AS "StartDate",
	contracts.date_end		AS "EndDate",
	res.company_id			AS "Country", 
	ROW_NUMBER () OVER (PARTITION BY staff.id ORDER BY contracts.date_start DESC ) AS "Numbers"
	
 FROM hr_employee AS staff 
 LEFT JOIN hr_job AS jobs ON 
 	jobs.id = staff.job_id 
 LEFT JOIN resource_resource AS res  ON  
 	res.id = staff.resource_id
 LEFT JOIN hr_department AS department ON 
 	department.id = staff.department_id
 LEFT JOIN hr_contract AS contracts ON 
 	contracts.employee_id = staff.id 
ORDER BY 
staff.create_date desc
	