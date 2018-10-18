WITH credit_officers AS (
	SELECT
		DATE(staff.create_date)	AS "CreationDate",
		staff.id 				AS "ID",
		users.id				AS "UserId",
		staff.birthday 			AS  "DOB",
		staff.name_related		AS "StaffName",
		department."name"		AS "Department",
		jobs.id              	AS "JobID",
		jobs."name"				AS "Job",
		staff.gender		 	AS "Gender",
		res.company_id			AS "Country"
	
 	FROM hr_employee AS staff 
 	LEFT JOIN hr_job AS jobs ON 
 		jobs.id = staff.job_id 
 	LEFT JOIN resource_resource AS res  ON  
 		res.id = staff.resource_id
 	LEFT JOIN hr_department AS department ON 
 		department.id = staff.department_id
 	LEFT JOIN res_users AS users ON 
 		users.id = res.user_id
	WHERE 
		--jobs.id = 14  AND 
		jobs.company_id = 1
	ORDER BY staff.birthday ASC
),
partner_comments AS (
  SELECT 
 		DATE(partner_comments.create_date) 								AS "Create Date",
 		partner_comments.partner_id 									AS "Partner ID",
 		COALESCE (Officers."StaffName",cco."StaffName") 				AS "Comment Creator",
 		partner_comments."name" 										AS " Comment",
 		partner_comments.x_followupaction 								AS "Action",
 		ROW_NUMBER () OVER (PARTITION BY partner_comments.partner_id 	ORDER BY 
 		partner_comments.create_date DESC  ) 							AS "Number"
 	FROM partner_comment AS partner_comments 
 	LEFT JOIN credit_officers AS officers on 
		partner_comments.create_uid = officers."UserId"
	RIGHT JOIN credit_officers AS cco on 
		partner_comments.write_uid = cco."UserId"
 	WHERE 
 		DATE(partner_comments.create_date) >'2018-01-01' AND 
 		DATE(partner_comments.create_date) <='2018-08-31' 

)

SELECT 
	"Create Date",
	"Comment Creator",
	COUNT (*)
FROM partner_comments
GROUP BY 
	"Create Date",
	"Comment Creator"
	
 		
