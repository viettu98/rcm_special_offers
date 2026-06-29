
--Nhóm A mua thường xuyên (tần suất mua > = 3 lần/tháng), và chỉ mua FMCG

WITH mua_online AS (
SELECT  a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-18')
        AND b.outputtypeid IN (1903)
        AND a.crmcustomerid > 5
        AND p.maingroupid  IN (925, 990, 992, 993, 1014, 1034, 1054, 1055, 1056, 1060, 1096, 1196, 1234, 1235, 1236, 1254, 1255, 1354, 1355, 1374, 1474, 1494, 1514, 1515)
GROUP BY a.crmcustomerid 
HAVING count (DISTINCT a.outputvoucherid) >= 30
),
chua_mua_fresh AS 
(
SELECT  a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-18')
        AND b.outputtypeid IN (1903)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
HAVING SUM(CASE WHEN p.maingroupid IN (925, 990, 992, 993, 1014, 1034, 1054, 1055, 1056, 1060, 1096, 1196, 1234, 1235, 1236, 1254, 1255, 1354, 1355, 1374, 1474, 1494, 1514, 1515) THEN 1 ELSE 0 END) = 0
)
SELECT mo.customer_id  
FROM mua_online mo
LEFT JOIN chua_mua_fresh cmf
ON mo.customer_id = cmf.customer_id 
WHERE cmf.customer_id IS NULL


--Nhóm A mua thường xuyên và trung thành với Brand (FMCG) 
tính số lượng brand của từng subgroup A, 
tính số lượng brand mà KH mua của từng subgroup B, 

tính số lượng brand của bảng bhx_inventory_inv_outputvoucherdetail
tính số lượng brand mà KH mua
tính % brand mà KH mua của subgroup % = B/A, 
chỉ lấy ~KH <= 15%
số lần xuất hiện mỗi brand trong từng khách hàng >2
--những brand này chiếm >= 80% doanh thu của khách
;

WITH total_brand AS (
    -- A: tổng số lượng brand toàn bộ hệ
    SELECT COUNT(DISTINCT p.brandid) AS tong_brand
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-18')
        AND b.outputtypeid IN (1903)
        AND a.crmcustomerid > 5
        AND p.maingroupid IN (925, 990, 992, 993, 1014, 1034, 1054, 1055, 1056, 1060, 1096, 1196, 1234, 1235, 1236, 1254, 1255, 1354, 1355, 1374, 1474, 1494, 1514, 1515)
),
often_cust AS (
SELECT
	a.crmcustomerid AS customer_id
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
        ON
	a.outputvoucherid = b.outputvoucherid
WHERE
	FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
		AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-18')
			AND b.outputtypeid IN (1903)
				AND a.crmcustomerid > 5
			GROUP BY
				a.crmcustomerid
			HAVING
				count (DISTINCT a.outputvoucherid) >= 20
),
cust_brand AS (
-- Đếm số lần xuất hiện mỗi brand trong từng KH
-- chỉ giữ những brand có n > 2
SELECT
	a.crmcustomerid AS customer_id,
	p.brandid,
	COUNT(*) AS cnt_brand
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
	AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-18')
	AND b.outputtypeid IN (1903)
	AND a.crmcustomerid IN (SELECT * FROM often_cust)
	AND p.maingroupid IN (925, 990, 992, 993, 1014, 1034, 1054, 1055, 1056, 1060, 1096, 1196, 1234, 1235, 1236, 1254, 1255, 1354, 1355, 1374, 1474, 1494, 1514, 1515)
GROUP BY
	a.crmcustomerid,
	p.brandid
HAVING
	COUNT(*) > 2
),
cust_brand_agg AS (
    -- B: số lượng brand mà KH mua (chỉ tính các brand n>2)
    SELECT 
        customer_id,
        COUNT(DISTINCT brandid) AS brand_da_mua
    FROM cust_brand
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.brand_da_mua,
    t.tong_brand,
    (c.brand_da_mua * 1.0 / t.tong_brand) * 100 AS pct_brand   -- %C = B/A * 100
FROM cust_brand_agg c
CROSS JOIN total_brand t
WHERE 
(c.brand_da_mua * 1.0 / t.tong_brand) > 0.2           -- chỉ lấy KH có %C <= 20%
ORDER BY  brand_da_mua desc
;

397,823  

397,828

-- fmcg
396,725 -- 0.2 --> 70,627
tổng 710,867


--Nhóm A mua thường xuyên và trung thành với Fresh:
đếm tổng số bill của KH A
đếm số bill có fresh B
A/B >= 80 % thì tính 

WITH base AS (
    SELECT 
    DISTINCT a.crmcustomerid AS customer_id,
     a.outputvoucherid,
        p.maingroupid
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-18')
        AND b.outputtypeid IN (1903)
        AND a.crmcustomerid > 5
),
cust_total_bill AS (
    -- A: tổng số bill của mỗi KH
    SELECT
        customer_id,
        COUNT(DISTINCT outputvoucherid) AS total_bill
    FROM base
    GROUP BY customer_id
    HAVING count (DISTINCT outputvoucherid) >= 20
),
bill_fresh AS (
  SELECT
        customer_id,
        COUNT(DISTINCT outputvoucherid) AS fresh_bill
    FROM base
    WHERE maingroupid IN (993, 1234, 1235, 1236 , 1254)
    GROUP BY customer_id
    HAVING count (DISTINCT outputvoucherid) >= 20
),
cust_ratio AS (
    SELECT
        t.customer_id,
        t.total_bill AS A,
        COALESCE(f.fresh_bill, 0) AS B,
        COALESCE(f.fresh_bill, 0) * 1.0 / t.total_bill AS ratio_B_A
    FROM cust_total_bill t
    LEFT JOIN bill_fresh f
        ON t.customer_id = f.customer_id
)
SELECT
    customer_id,
    A AS tong_bill,
    B AS bill_mua_fresh,
    ratio_B_A * 100 AS pct_bill_fresh
FROM cust_ratio
WHERE ratio_B_A < 0.8      -- B/A >= 80%
ORDER BY  bill_mua_fresh DESC;
23,090
tổng 711,407
B/A >= 80% 224,891
;



-- Nhóm A mua thường xuyên Nhóm/Ngành hàng
WITH total_subgroup AS (
    -- A: tổng số lượng subgroup toàn bộ hệ
    SELECT COUNT(DISTINCT p.subgroupid) AS tong_subgroup
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-18')
        AND b.outputtypeid IN (1903)
        AND a.crmcustomerid > 5
        ),
often_cust AS (
SELECT
	a.crmcustomerid AS customer_id
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
        ON
	a.outputvoucherid = b.outputvoucherid
WHERE
	FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
		AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-18')
			AND b.outputtypeid IN (1903)
				AND a.crmcustomerid > 5
			GROUP BY
				a.crmcustomerid
			HAVING
				count (DISTINCT a.outputvoucherid) >= 20
),
cust_subgroup AS (
-- Đếm số lần xuất hiện mỗi subgroup trong từng KH
-- chỉ giữ những subgroup có n > 2
SELECT
	a.crmcustomerid AS customer_id,
	p.subgroupid,
	COUNT(*) AS cnt_subgroup
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
	AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-18')
	AND b.outputtypeid IN (1903)
	AND a.crmcustomerid IN (SELECT * FROM often_cust)
	GROUP BY
	a.crmcustomerid,
	p.subgroupid
HAVING
	COUNT(*) > 2
),
cust_subgroup_agg AS (
    -- B: số lượng subgroup mà KH mua (chỉ tính các subgroup n>2)
    SELECT 
        customer_id,
        COUNT(DISTINCT subgroupid) AS subgroup_da_mua
    FROM cust_subgroup
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.subgroup_da_mua,
    t.tong_subgroup,
    (c.subgroup_da_mua * 1.0 / t.tong_subgroup) * 100 AS pct_subgroup   -- %C = B/A * 100
FROM cust_subgroup_agg c
CROSS JOIN total_subgroup t
WHERE 
(c.subgroup_da_mua * 1.0 / t.tong_subgroup) <= 0.15           -- chỉ lấy KH có %C <= 20%
ORDER BY  subgroup_da_mua DESC;










-----------------------
--Nhóm A mua thường xuyên (tần suất mua >=3 lần/quý), có doanh thu từ 501.000 đến < 1.000.000)

WITH often_cust AS (
SELECT
	a.crmcustomerid AS customer_id
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
        ON
	a.outputvoucherid = b.outputvoucherid
WHERE
	FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
		AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-18')
			AND b.outputtypeid IN (1903)
				AND a.crmcustomerid > 5
			GROUP BY
				a.crmcustomerid
			HAVING
				count (DISTINCT a.outputvoucherid) < 27
),
revenue_con AS (
SELECT
    a.crmcustomerid AS customer_id,
    CONCAT(
        DATE_FORMAT(from_unixtime(a.outputdate / 1000 - 25200), '%Y'),
        '-Q',
        CAST(CEIL(MONTH(from_unixtime(a.outputdate / 1000 - 25200)) / 3.0) AS VARCHAR)
    ) AS year_quarter,
    ROUND(
        SUM(
            ROUND(b.saleprice * (1 + (CAST(b.vat AS DOUBLE) / 100)), 0) * b.quantity
        ),
        0
    ) AS total_revenue
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
        ON a.outputvoucherid = b.outputvoucherid
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
    AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
    AND b.outputtypeid IN (1903)
    AND a.crmcustomerid > 5
GROUP BY
    a.crmcustomerid,
    CONCAT(
        DATE_FORMAT(from_unixtime(a.outputdate / 1000 - 25200), '%Y'),
        '-Q',
        CAST(CEIL(MONTH(from_unixtime(a.outputdate / 1000 - 25200)) / 3.0) AS VARCHAR)
    )
)
SELECT DISTINCT  a.customer_id 
FROM  often_cust a
JOIN revenue_con b
ON a.customer_id = b.customer_id 
WHERE b.total_revenue > 500000
AND b.total_revenue < 1000000
;















