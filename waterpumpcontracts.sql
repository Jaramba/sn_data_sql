select  
 orders.create_date 		  as "Date",
 orders.state                 as "State",
 orders.pricelist_id          as "Price_List",
 customers."name"             as  "CustomerName",
 customers.phone              as  "Phone",
 customers."ref"              as  "Customer Reference",
 branches."name"              as  "Branch Name",
employees."name"              as  "Sales Person",
 order_lines.product_id       as "Product ID",
   order_lines."name"           as  "ProductName",
   order_lines.product_uom_qty  as  "Quantity"   
 
from 
 sale_order as orders
left join sale_order_line as order_lines on
orders.id = order_lines.order_id
left join res_branch as branches on
branches.id  = orders.branch_id
left join res_partner as customers on
 customers.id = orders.partner_id
left join res_users as sales_people on 
sales_people.id = orders.user_id
 left join res_partner as employees on 
  employees.id = sales_people.partner_id
where 
  order_lines.product_id in (695,693,739) and 
  date(orders.create_date) >= '2018-05-01'
 
 

