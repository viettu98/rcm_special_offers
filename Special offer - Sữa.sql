- Dữ liệu từ 01/2025
Lấy giúp Chị 2 tệp Khách hàng 
1. Nhóm Khách hàng đang mua các sản phẩm sau (file đính kèm) và chưa từng mua grow/Pediasure 6806 | 6855
2. Nhóm chưa từng mua sản phẩm Ensure/Glucerna trong vòng 2 tháng qua 6849 | 6851;


WITH da_mua_A AS (
SELECT
	DISTINCT a.crmcustomerid AS customer_id
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
	AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-19')
	AND b.outputtypeid IN (1903, 3)
	AND a.crmcustomerid > 5
	AND p.productid IN ('1053140000456', '1053140000457', '1053140000417', '1053140000418', '1053140000460', 
	'1053140000458', '1053140000461', '1053140000459', '1053140000179', '1053140000180', '1053140000197', '1053140000181', 
	'5099864008654', '9892845000331', '9892845000224', '1053140000208', '1053140000211', '1053140000212', '1053140000262', 
	'1053140000261', '1053140000260')
),
chua_mua_B AS (
SELECT
	DISTINCT a.crmcustomerid AS customer_id
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
		AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-19')
			AND b.outputtypeid IN (1903, 3)
				AND a.crmcustomerid > 5
			GROUP BY
				a.crmcustomerid
			HAVING
				SUM(CASE WHEN p.productid IN ('9892845000139', '9892845000140', '1053140000422', '1053140000421') THEN 1 ELSE 0 END) = 0
)
SELECT DISTINCT dmA.customer_id  FROM da_mua_A dmA
JOIN chua_mua_B cmB
ON dmA.customer_id = cmB.customer_id 

;

SELECT
	DISTINCT a.crmcustomerid AS customer_id
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-19')
		AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-19')
			AND b.outputtypeid IN (1903, 3)
				AND a.crmcustomerid > 5
			GROUP BY
				a.crmcustomerid
			HAVING
				SUM(CASE WHEN p.productid IN ('1053140000462', '070074118659', '1053140000002', '1053140000249', '1053140000250', '9892845000534', '9892845000330', '1053140000316', '1053140000317', '1053140000318') THEN 1 ELSE 0 END) = 0


