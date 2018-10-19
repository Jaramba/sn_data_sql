select
	invoices.sale_order                     as "Sale Order",
	date(invoices.date_invoice) 			as "Invoice Date",
	invoices.reference                      as "Invoice Reference", 
	invoices.amount_total 					as "Total",
	invoices.residual 						as "Balance",
	invoices.residual                       as "Residual Balance",
	customers.ref 							as "Client Reference",
	customers.name 							as "Client Name",
	customers.phone 						as "Phone Number",
	branches.name      						as "Branch Name",
	customers.days_overdue      			as "Days Overdue",
	customers.payplan_summary 				as "Payplan Summary",
	customers.overdue_installment_count 	as "Overdue Installments",
	customers.days_next_payment 			as "Days Till Next Payment",
	staff.name_related                      as  "Credit Officer" ,
	(select name as Sales_Officer from res_partner where id = users1.partner_id),
	customers.company_id                   as "Company"
from account_invoice as invoices
left join res_partner as customers on  
customers.id = invoices.partner_id 
left join sale_order as orders on
orders.id = invoices.sale_order
left join res_branch as branches on 
 branches.id = customers.branch_id
 left join hr_employee as staff on 
customers.credit_responsible = staff.id 
left join res_users users1 on 
customers.write_uid = users1.id 
left join res_users users2 on 
customers.create_uid = users2.id 
where 
	invoices."type" = 'out_invoice' and
	invoices.residual > 0
	