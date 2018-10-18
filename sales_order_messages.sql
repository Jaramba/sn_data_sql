SELECT 
	orders.id						AS "ExternalID",
	messages.body					AS "Contents",
	messages.record_name			AS "Record",
	employees."name"				AS "CreatedBy",
	DATE(messages.create_date)		AS "CreateDate"
FROM mail_message AS messages 
LEFT JOIN  res_users AS users ON 
	users.id = messages.create_uid
LEFT JOIN  res_partner AS employees ON
 	employees.id = users.partner_id
LEFT JOIN sale_order AS orders ON 
	orders."name" =messages.record_name
WHERE 
	messages.model = 'sale.order' AND
	DATE(messages.create_date) >='2018-01-01' AND
	users.company_id = 1