select 
 branches."name"              as "Branch",
 employees."name"             as  "Sales Person",
 tickets.create_date          as "Created On",
 tickets.dispatch_date        as "Dispatch Date",
 tickets.state_install        as "Installation State",
 customers."name"             as  "CustomerName",
 customers.phone              as  "Phone",
 customers."ref"              as "Customer Reference",
 order_lines.product_id       as "Product ID",
 order_lines."name"           as "Product",
 order_lines.product_uom_qty  as  "Quantity" 
from ticket_ticket  as tickets
 left join res_branch as branches on 
 tickets.partner_branch_id = branches.id
 left join res_partner as customers on 
 tickets.partner_id = customers.id
 left join sale_order as orders on 
  orders.id = tickets.sale_order_id
 left join sale_order_line as order_lines on
  order_lines.order_id = orders.id
 left join res_users as sales_people on 
  sales_people.id = orders.user_id
 left join res_partner as employees on 
  employees.id = sales_people.partner_id
where 
 tickets."type" = 'install' and
  order_lines.product_id in (695,693,739) and 
  date(tickets.create_date) >'2018-05-01'
  