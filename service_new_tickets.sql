with service as (

select 
 tickets.id                      as "Ticket ID",
 date (tickets.create_date)      as "Ticket Creation Date",
 employees."name"				AS "Updator",
 employees2."name"				AS "Creator",
 date(tickets.message_last_post) as "Last Message Date",
 tickets.state_service           as "State",
 'Service'::TEXT 				AS "Stage"

from ticket_ticket as tickets
left join res_partner as customers on
 customers.id = tickets.partner_id
left join res_branch as branch on 
 branch.id = customers.branch_id
left join res_users as users on
	users.id = tickets.write_uid
left join res_partner as employees on
 employees.id = users.partner_id
left join res_users as users2 on
	users2.id = tickets.x_create_uid
left join res_partner as employees2 on
 employees.id = users2.partner_id
where tickets."type" = 'service' AND
tickets.company_id = 1 AND
DATE(tickets.create_date) >'2018-01-01' AND 
 		DATE(tickets.create_date) <='2018-08-31' 
),
install AS ( select 
 tickets.id                      as "Ticket ID",
 date (tickets.create_date)      as "Ticket Creation Date",
 employees."name"				AS "Updator",
 employees2."name"				AS "Creator",
 date(tickets.message_last_post) as "Last Message Date",
 tickets.state_install           as "State",
 'Install'::TEXT 				AS "Stage"

from ticket_ticket as tickets
left join res_partner as customers on
 customers.id = tickets.partner_id
left join res_branch as branch on 
 branch.id = customers.branch_id
left join res_users as users on
	users.id = tickets.write_uid
left join res_partner as employees on
 employees.id = users.partner_id
left join res_users as users2 on
	users2.id = tickets.x_create_uid
left join res_partner as employees2 on
 employees.id = users2.partner_id
where tickets."type" = 'install' AND
tickets.company_id = 1 AND 
DATE(tickets.create_date) >'2018-01-01' AND 
 		DATE(tickets.create_date) <='2018-08-31' 
)

select * 
from service
UNION ALL
SELECT * FROM install


--SELECT * FROM ticket_ticket LIMIT 10