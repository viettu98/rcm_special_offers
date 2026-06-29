-- Data KH có mua gạo từ ngày sớm nhất trong file chị Nhung 
 
SELECT a.crmcustomerid AS customer_id,
 b.productid,
 p.productname,
 Round(SUM(ROUND(b.saleprice * (1 + (CAST(b.vat AS DOUBLE) / 100)), 0) * b.quantity),0) AS total_revenue,
 FROM_UNIXTIME(a.outputdate / 1000 - 25200) AS outputdate
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903, 3)
      AND a.crmcustomerid > 5
      AND p.subgroupid in (3039, 3059)
      AND from_unixtime(a.outputdate / 1000 - 25200) > DATE('2025-09-21')
    GROUP BY (a.crmcustomerid,  b.productid, p.productname, a.outputdate);



--Thời gian: 01/09-30/09
--Nhóm hàng: Gạo, nếp các loại 

-- Đơn chỉ mua gạo:
WITH order_3054 AS (
SELECT
	DISTINCT a.outputvoucherid  
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	a.crmcustomerid > 5
	AND b.outputtypeid IN ( 1903, 3)
	AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
	AND p.subgroupid = 3054
), 
order_1sub AS (
SELECT
	a.outputvoucherid 
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	a.crmcustomerid > 5
	AND b.outputtypeid IN ( 1903, 3)
	AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
GROUP BY ( a.outputvoucherid)
HAVING
	COUNT(DISTINCT p.subgroupid) = 1
)
SELECT
	COUNT(DISTINCT a.outputvoucherid)
FROM
	order_3054 a 
JOIN order_1sub b 
ON a.outputvoucherid = b.outputvoucherid
;
-- Đơn mua gạo và sub khác:
WITH order_3054 AS (
SELECT
	DISTINCT a.outputvoucherid  
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	a.crmcustomerid > 5
	AND b.outputtypeid IN ( 1903, 3)
	AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
	AND p.subgroupid in (3054)
), 
order_multisub AS (
SELECT
	a.outputvoucherid 
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	a.crmcustomerid > 5
	AND b.outputtypeid IN ( 1903, 3)
	AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
GROUP BY ( a.outputvoucherid)
HAVING
	COUNT(DISTINCT p.subgroupid) > 1
)
SELECT
	COUNT(DISTINCT a.outputvoucherid)
FROM
	order_3054 a 
JOIN order_multisub b 
ON a.outputvoucherid = b.outputvoucherid
;


	-- Tìm subgroupid:
WITH customers_3054 AS (
SELECT
	DISTINCT a.outputvoucherid 
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	a.crmcustomerid > 5
	AND b.outputtypeid IN ( 1903, 3)
	AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
	AND p.subgroupid in (3054)
), 
base AS (
    SELECT
        a.crmcustomerid AS customer_id,
        b.outputvoucherid,
        p.subgroupid
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
        ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903, 3)
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-10-01')
),
cus_multi AS (
    SELECT outputvoucherid
    FROM base
    GROUP BY outputvoucherid
    HAVING COUNT(DISTINCT subgroupid) > 1
)
SELECT DISTINCT
    b.subgroupid,
    COUNT(DISTINCT b.customer_id)                                   AS customer_count,
    COUNT(DISTINCT b.outputvoucherid)                                AS order_count,
    COUNT(*)                                                         AS line_count
FROM base b
JOIN cus_multi m 
ON m.outputvoucherid = b.outputvoucherid 
JOIN customers_3054 c
ON c.outputvoucherid = b.outputvoucherid 
WHERE b.subgroupid <> 3054
GROUP BY (b.subgroupid)
ORDER BY order_count DESC 
limit 20
--)
--SELECT
--	COUNT(DISTINCT a.customer_id)
--	b.subgroupid
--FROM
--	customers_3054 a 
--JOIN cus_1sub b 
--ON a.customer_id = b.customer_id
--;
	
	
	-- Đơn mua gạo và 1 sub khác:
WITH order_3054 AS (
SELECT
        a.outputvoucherid,
        p.subgroupid
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
        ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903, 3)
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-10-01')
        AND p.subgroupid IN (3054, 4261)
)
SELECT COUNT(*) AS so_don_mua_ca_2_sub
FROM (
    SELECT outputvoucherid
    FROM order_3054
    GROUP BY outputvoucherid
    HAVING COUNT(DISTINCT subgroupid) = 2   -- có cả 3054 và 3020 trong cùng 1 đơn
)	

	-- tìm ra đơn có mua gạo và các nhóm hàng khác
	WITH customers_3054 AS (
SELECT
	DISTINCT a.outputvoucherid 
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON
	a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	a.crmcustomerid > 5
	AND b.outputtypeid IN ( 1903, 3)
	AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
	AND p.subgroupid in (3054)
),
base AS 
	(SELECT
        a.outputvoucherid,
        p.subgroupid
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
        ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903, 3)
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-10-01')
        AND p.subgroupid IN (3054)
	),
cus_multi AS (
    SELECT outputvoucherid
    FROM base
    GROUP BY outputvoucherid
    HAVING COUNT(DISTINCT subgroupid) > 1
)
SELECT 
    b.outputvoucherid,
    b.subgroupid 
FROM base b
JOIN cus_multi m 
ON m.outputvoucherid = b.outputvoucherid 
JOIN customers_3054 c
ON c.outputvoucherid = b.outputvoucherid 
limit 20









	