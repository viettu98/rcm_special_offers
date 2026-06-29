
--1. Từ 24/06-24/09: KH có mua all sp BHX nhưng không mua fresh (993, 1234, 1235, 1236 , 1254)
SELECT
    a.crmcustomerid AS customer_id,
    CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
        THEN 1 ELSE 0
 	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE b.outputtypeid IN (1903)
  AND a.crmcustomerid > 5
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-06-24'
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-09-25'
GROUP BY a.crmcustomerid
HAVING SUM(CASE WHEN p.maingroupid IN (993, 1234, 1235, 1236, 1254) THEN 1 ELSE 0 END) = 0;

--3. TỆP 3: Mua ít - từ tháng 01/2025 - 10/2025 (chỉ mua có 1 lần)
WITH customer_orders AS (
SELECT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
  ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE b.outputtypeid IN (1903)
  AND p.maingroupid IN (1234, 1235, 1236, 1254)
  AND a.crmcustomerid > 5
  AND from_unixtime(a.outputdate/1000 - 25200) >= DATE '2025-01-01'
  AND from_unixtime(a.outputdate/1000 - 25200) <  DATE '2025-10-02'
GROUP BY a.crmcustomerid
HAVING COUNT(DISTINCT a.outputvoucherid) = 1
)
SELECT 
    t.customer_id,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM customer_orders t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
WHERE co_caidatapp = '1'

	-- Check::: tìm KH có mã xx có phát sinh đơn vào tháng xx/ có phát sinh đơn theo subgroupid
SELECT 
    distinct a.crmcustomerid AS customer_id,
    a.outputvoucherid
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
CAST(a.crmcustomerid  AS VARCHAR) = '1026532727'
 and p.maingroupid in (1234, 1235, 1236, 1254) 
 and FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
 ;
	
	
--4. TỆP 4: 1 Tuần gần nhất chưa mua lại (24/09 - 01/10)
	    
WITH buy_fresh_recent AS (
    SELECT
        DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903)
      AND a.crmcustomerid > 5
      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-09-24'
	  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-10-02'
	  AND p.maingroupid IN (1234, 1235, 1236, 1254)
),
buy_fresh AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903)
      AND a.crmcustomerid > 5
      AND p.maingroupid IN (1234, 1235, 1236, 1254)
),
Left_anti AS (
SELECT
    DISTINCT bf.customer_id
FROM buy_fresh bf
LEFT JOIN buy_fresh_recent br
  ON br.customer_id = bf.customer_id
WHERE br.customer_id IS NULL 
)
SELECT 
    t.customer_id,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM Left_anti t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
WHERE co_caidatapp = '1'
	
	
-- Tập 1: có phát sinh đơn mua fresh   (993, 1234, 1235, 1236 , 1254) từ 26/07-26/08 Nhưng từ 27/08-04/10 không mua
	
WITH buy_fresh_recent AS (
SELECT
    a.crmcustomerid AS customer_id,
    CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
        THEN 1 ELSE 0
 	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN
"pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE b.outputtypeid IN (1903,3)
  AND a.crmcustomerid > 5
  AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-08-27'
  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-10-05'
  AND p.maingroupid IN (993, 1234, 1235, 1236 , 1254)
GROUP BY a.crmcustomerid 
),
buy_fresh_early AS (
    SELECT 
      a.crmcustomerid AS customer_id,
      	CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
        	THEN 1 ELSE 0
 		END AS is_online
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903,3)
      AND a.crmcustomerid > 5
      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-07-26'
  	  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-08-27'
      AND p.maingroupid IN (993, 1234, 1235, 1236 , 1254)
    GROUP BY a.crmcustomerid
)
SELECT
    DISTINCT bfe.customer_id,
    bfe.is_online
FROM buy_fresh_early bfe
LEFT JOIN buy_fresh_recent br
  ON br.customer_id = bfe.customer_id
WHERE br.customer_id IS NULL ;

-- Tập 2: có phát sinh đơn mua thủy hản sản (1254) từ 26/07-26/08 Nhưng từ 27/08-04/10 không mua

	WITH buy_fresh_recent AS (
SELECT
    a.crmcustomerid AS customer_id,
    CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
        THEN 1 ELSE 0
 	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN
"pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE b.outputtypeid IN (1903,3)
  AND a.crmcustomerid > 5
  AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-08-27'
  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-10-05'
  AND p.maingroupid IN (1254)
GROUP BY a.crmcustomerid 
),
buy_fresh_early AS (
    SELECT 
      a.crmcustomerid AS customer_id,
      	CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
        	THEN 1 ELSE 0
 		END AS is_online
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903,3)
      AND a.crmcustomerid > 5
      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-07-26'
  	  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-08-27'
      AND p.maingroupid IN ( 1254)
    GROUP BY a.crmcustomerid
)
SELECT
    DISTINCT bfe.customer_id,
    bfe.is_online
FROM buy_fresh_early bfe
LEFT JOIN buy_fresh_recent br
  ON br.customer_id = bfe.customer_id
WHERE br.customer_id IS NULL ;
	
	
-- Tập 1: có phát sinh đơn mua thủy hản sản (1254) từ 01/09-30/09
SELECT
    a.crmcustomerid AS customer_id,
    CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
        THEN 1 ELSE 0
 	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN
"pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE b.outputtypeid IN (1903,3)
  AND a.crmcustomerid > 5
  AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-09-01'
  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-10-01'
  AND p.maingroupid IN (1254)
GROUP BY a.crmcustomerid 

--  Tập 1: có phát sinh đơn mua fresh   (993, 1234, 1235, 1236 , 1254) từ 12/09-12/10

SELECT
    a.crmcustomerid AS customer_id
--    CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
--        THEN 1 ELSE 0
-- 	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN
"pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE b.outputtypeid IN (1903)
  AND a.crmcustomerid > 5
  AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-09-12'
  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-10-13'
  AND p.maingroupid IN (993, 1234, 1235, 1236 , 1254)
--GROUP BY a.crmcustomerid 


--  Tập 2: có phát sinh đơn mua thủy hản sản (1254) từ 12/09-12/10
SELECT
    a.crmcustomerid AS customer_id
--    CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
--        THEN 1 ELSE 0
-- 	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN
"pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE b.outputtypeid IN (1903)
  AND a.crmcustomerid > 5
  AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-09-12'
  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-10-13'
  AND p.maingroupid IN (1254)
--GROUP BY a.crmcustomerid 
;
  
--  * FRESH : bao gồm các mã Ngành hàng 1234, 1235, 1236, 1254* 
--
--1. Tệp 1: Khách hàng FRESH nhưng chưa mua Rau (mã NH 1234)
--2. Tệp 2: Khách hàng FRESH nhưng chưa mua Trái cây (mã NH 1235)
--3. Tệp 3: Khách hàng FRESH nhưng chưa mua Thịt (mã NH 1236)
--4. Tệp 4: Khách hàng FRESH nhưng chưa mua Thuỷ hải sản (1254)


--tối thiểu 1 đơn hàng fresh gtrong 6 tháng gần nhất
WITH cust_6month AS (
SELECT
    a.crmcustomerid AS customer_id,
    CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
        THEN 1 ELSE 0
 	END AS is_online
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
        ON a.outputvoucherid = b.outputvoucherid
JOIN
"pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    b.outputtypeid IN (1903, 3)  -- lọc loại phiếu bán hàng
    AND a.crmcustomerid > 5
    AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-04-01'  -- 6 tháng gần nhất
    AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-10-25'
    AND p.maingroupid IN (1234, 1235, 1236, 1254)
GROUP BY
    a.crmcustomerid
HAVING
    COUNT(DISTINCT a.outputvoucherid) >= 1
),
cust_notbuy1sub AS (
    SELECT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903, 3)
      AND a.crmcustomerid > 5
      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-04-01'  -- 6 tháng gần nhất
   	  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-10-25'
    GROUP BY a.crmcustomerid
    HAVING MAX(CASE WHEN p.maingroupid = 1254 THEN 1 ELSE 0 END) = 0
),
cust_join AS (
SELECT a.customer_id , a.is_online 
FROM cust_6month a 
JOIN cust_notbuy1sub b
ON a.customer_id = b.customer_id 
)
SELECT 
    t.customer_id, t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM cust_join t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
WHERE co_caidatapp = '1'
;


Tập khách hàng có định danh online, 
có phát sinh đơn mua bất kỳ sản phẩm tại Bách hóa xanh từ 27/10-09/11 nhưng không mua thịt (mã ngành 1236) 

SELECT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-10-27')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-11-09')
    GROUP BY a.crmcustomerid
    HAVING SUM(CASE WHEN p.maingroupid IN (1236) THEN 1 ELSE 0 END) = 0

;


-- Tập KH on/offline có mua Thịt (mã ngành 1236) từ 01/01/2025 - 16/11/2025 nhưng từ 17/11/2025 - 30/11/2025 chưa mua lại


WITH buy_fresh_recent AS (
    SELECT
    DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903,3)
      AND a.crmcustomerid > 5
      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-05-23'
	  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-11-24'
	  AND p.maingroupid IN (1235)
),
buy_fresh AS (
    SELECT  a.crmcustomerid AS customer_id,
    CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
        THEN 1 ELSE 0
 	END AS is_online
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903,3)
      AND a.crmcustomerid > 5
      AND p.maingroupid IN (1235)
      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-11-24'
	  AND from_unixtime(a.outputdate / 1000 - 25200) < DATE '2025-12-01'
	GROUP BY a.crmcustomerid
)
SELECT
    DISTINCT bf.customer_id
FROM buy_fresh bf
LEFT JOIN buy_fresh_recent br
  ON br.customer_id = bf.customer_id
WHERE br.customer_id IS NULL 
;


-- Khách hàng chưa mua Fresh (Mã NH: 1234, 1235, 1236, 1254, 993) (Từ 01/2025 - 11/2025)
EXPLAIN ANALYZE
SELECT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903, 3)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-12-01')
    GROUP BY a.crmcustomerid
    HAVING SUM(CASE WHEN p.maingroupid IN (1234, 1235, 1236, 1254, 993) THEN 1 ELSE 0 END) = 0

;

-- Khách hàng chưa mua nhóm 3941 (Từ 01/2025)
SELECT a.crmcustomerid AS customer_id,
		12 AS group_promotionid
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
AND b.outputtypeid IN (1903, 3)
AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-12-07')
GROUP BY
(a.crmcustomerid)
HAVING
SUM(CASE WHEN p.maingroupid IN (1056) THEN 1 ELSE 0 END) = 0



WITH base AS (
        SELECT
            a.crmcustomerid AS customer_id,
            a.outputdate,
            CAST(b.productid AS VARCHAR) AS productid,
            p.subgroupid,
            p.maingroupid
        FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
        JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
            ON a.outputvoucherid = b.outputvoucherid
        JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
        WHERE 
            a.crmcustomerid > 5
            AND b.outputtypeid IN (1903, 3)
            AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('{from_date}')
            AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('{to_date}')
    ),
    all_customers AS (
        SELECT DISTINCT customer_id
        FROM base
    )
;

--2. KH có mua BHX on/offline  từ 01/01/2024 nhưng không mua  cả ba nhóm: 
--990 - Thực phẩm đông lạnh - Hàng mát các loại, 1355 - Kem các loại, 1354 - Sản Phẩm Từ Sữa - Bảo Quản Mát


WITH bad_vouchers AS (
  SELECT
    b.outputvoucherid
  FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
  JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
    ON a.outputvoucherid = b.outputvoucherid
  JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
  WHERE
    FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
    AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-12-10')
    AND b.outputtypeid IN (1903, 3)
  GROUP BY b.outputvoucherid
  HAVING COUNT(DISTINCT CASE WHEN p.maingroupid IN (990, 1355, 1354) THEN p.maingroupid END) = 3
)
SELECT
  a.crmcustomerid AS customer_id,
  CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
  ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-12-10')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND b.outputvoucherid NOT IN (SELECT outputvoucherid FROM bad_vouchers)
GROUP BY a.crmcustomerid;


----- CHECK ĐƠN HÀNG -----
SELECT DISTINCT a.crmcustomerid AS customer_id,
		b.outputvoucherid,
		b.outputtypeid ,
		from_unixtime(a.outputdate / 1000 - 25200) AS outputdate,
		p.productname,
		p.productid,
		p.productidref 
--		p.maingroupid,
--		p.subgroupid 
FROM
"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON
a.outputvoucherid = b.outputvoucherid
JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON
	CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
--JOIN
--    "pinot-group01"."default".bhx_bhx_masterdata_pm_subgroup  sg 
--    ON
--CAST(p.subgroupid  AS VARCHAR) = CAST(sg.subgroupid AS VARCHAR)
WHERE 
        a.crmcustomerid IN (1011733697 )
AND b.outputtypeid IN (1903, 3)
--AND p.maingroupid IN (993, 1234, 1235, 1236 , 1254)
AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2026-01-01')
AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2026-05-21')
ORDER BY outputdate DESC

;
--














	
	
	