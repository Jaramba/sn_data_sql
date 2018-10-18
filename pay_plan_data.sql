WITH customer_details AS (

		SELECT 
			invoices.id 											AS "InvoiceId",
			invoices.reference										AS "InvoiceReference",
			invoices."date_invoice"									AS "InvoiceDate",
			COALESCE (invoices."number",invoices.internal_number)	AS "InternalNumber",
			trim (upper (customers."name")	)						AS "Name",
			customers.id 											AS "PartnerID",
			customers."ref" 										AS "CustomersReference",
			invoices.move_id										AS "MoveId",
			product_type.id											AS "ProductId",
			product_type.x_name										AS "ProductName",
			invoices.amount_downpayment								AS "DepositFee",
			invoices.amount_net_invoice								AS "TotalFee"
		FROM account_invoice AS invoices
		LEFT JOIN res_partner AS customers ON 
			customers.id = partner_id
		LEFT JOIN sale_order as orders on
			orders.id = invoices.sale_order	
		LEFT JOIN x_x_product_type_sale_order_x_product_type_rel AS product_sales ON
			product_sales.id1 = orders.id
		LEFT JOIN x_product_type AS product_type ON 
			product_sales.id2 = product_type.id
		 LEFT JOIN account_payment_term AS terms ON 
	 		terms.id = orders.payment_term AND 
	 		terms.id != 10 
		WHERE 
			invoices.state IN ('open','paid') AND 
			invoices."type" = 'out_invoice' AND
			invoices.company_id = 1 AND 
			DATE (invoices."date_invoice") >= '2016-03-01' AND
			DATE (invoices."date_invoice") <= '2018-09-30' 
),
down_payments AS (
		SELECT 
			customers.id 				AS "PartnerID",
			customers."ref" 			AS "CustomersReference",
			customers."name"			AS "CustomerName",
			DATE (lines.create_date) 	AS "Date",
			lines."ref"					AS "Reference",
			lines.move_id				AS "MoveId",
			moves."name"				AS "Name",
			lines.payplan_type			AS "PayplanType",
			lines.amount				AS "Amount",
			lines.orig_date_maturity 	AS "OriginalMaturity",
			lines.date_maturity			AS "Maturity",
			lines.open_amount			AS "OpenAmount",
			lines.installment_state 	AS "State",
			lines.date_paid 			AS "DatePaid",
			lines.x_original_due_date   AS "OriginalDueDate"	
	FROM 
		account_move_line AS lines
	LEFT JOIN account_move AS moves ON 
		moves.id = lines.move_id
	LEFT JOIN res_partner AS customers ON 
			customers.id = lines.partner_id	
	WHERE 
		lines.company_id = 1 AND 
		--lines.payplan_type = 'downpayment'
		lines.payplan_type = 'interest'
		
	ORDER BY lines.move_id	
),
installments AS (
		SELECT 
			lines."ref"					AS "Reference",
			lines.date_maturity    		AS "OriginalDueDate",
			moves."name"				AS "Name",
			SUM (lines.amount)			AS "Amount",
			(ROW_NUMBER () OVER (PARTITION BY moves."name" ORDER BY lines.date_maturity ASC )) AS "Numbers"
		FROM 
			account_move_line AS lines
		LEFT JOIN account_move AS moves ON 
			moves.id = lines.move_id
		WHERE 
			lines.company_id = 1 AND 
			--lines.payplan_type IN ('principal','interest') AND
			lines.payplan_type = 'interest'
		GROUP BY 	
			lines."ref",
			lines.date_maturity ,
			moves."name"
),
bank_payments AS (
		SELECT 
			banks.id								AS "TransactionID",
			banks.partner_id						AS "PartnerID",
			DATE (banks."date") 					AS "TransactionDate",
			moves.id								AS "MoveId",
			DATE (banks.create_date)				AS "Date",
			state_ments."name"						AS "Statement",
			banks.amount							AS "TransactionAmount"
		FROM account_bank_statement_line AS banks 
		LEFT JOIN account_journal AS journals ON
			journals.id = banks.journal_id
		LEFT JOIN account_bank_statement AS state_ments ON
			state_ments.id =  banks.statement_id
		LEFT JOIN account_move AS moves ON 
			moves.id = banks.journal_entry_id		
		WHERE 
			banks.amount > 0 AND
			DATE (banks.create_date) >= '2016-05-01' AND
			DATE (banks.create_date) <= '2018-09-30' AND
			banks.company_id = 1 AND 
			journals.id	IN ('112','25','53','18','20','47','19','110','13')
)
SELECT 
	customer_details."CustomersReference"		AS "PartnerID",
   	customer_details."InvoiceDate"		AS "InvoiceDate",
   	customer_details."InvoiceReference"	AS "Reference",
 	customer_details."InvoiceId"		AS "AccountID",
 	customer_details."ProductId"		AS "ProductId",
	customer_details."ProductName"		AS "ProductName",
	down_payments."DatePaid"			AS "DepositFeeDate",
	customer_details."DepositFee" 		AS "DepositFee",
	installments."Amount" 				AS "MonthlyFee",
	customer_details."TotalFee" 		AS "TotalFee",
	bank_payments."TransactionID"		AS "TransactionID",
	bank_payments."TransactionDate"		AS "TransactionDate",
	bank_payments."TransactionAmount"	AS "TransactionAmount"

FROM 
	customer_details 
LEFT JOIN bank_payments ON 
	bank_payments."PartnerID"= customer_details."PartnerID"
LEFT JOIN down_payments ON 
	down_payments."Name" = customer_details."InternalNumber"
LEFT JOIN installments ON 
	installments."Name" = customer_details."InternalNumber" AND
	installments."Numbers" = 1

WHERE 
	bank_payments."TransactionAmount" > 0




 
 
 
 
 
 
 
 