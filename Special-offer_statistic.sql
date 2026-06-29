--Tổng có bao nhiêu KH có mua 1 trong 2 và cả 2SP này trên cùng bill.

SELECT 
    distinct a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
--JOIN
--    "pinot-group01"."default".bhx_"pinot-group01"."default"_pm_product p 
--    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
--  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-07-25')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and b.productid in ('1013059000296', '1013059000926')
--  and p.subgroupid not in (3039, 3059, 3041, 3116)
  ;
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp2 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
    
;
SELECT * FROM "pinot-group01"."default".bhx_inventory_inv_ov_promotiondiscount

;
select * from "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail
where 
outputvoucherid = 'OV106312507282431'
and productid in ('1013059000296', '1013059000926')

;
SELECT o.outputvoucherid
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail o
left join "pinot-group01"."default".bhx_inventory_inv_ov_promotiondiscount p
on o.outputvoucherid = p.outputvoucherid 
WHERE o.productid IN ('1013059000296', '1013059000926')
and p.promotionid in (5838385);
--GROUP BY o.outputvoucherid
--HAVING COUNT(DISTINCT o.productid) = 2;


----- Trong đó tỷ lệ khách hàng có mua KM combo 2 túi là bao nhiêu %?

SELECT 
    distinct a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
join "pinot-group01"."default".bhx_inventory_inv_ov_promotiondiscount p
    on b.outputvoucherid = p.outputvoucherid 
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
--  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-07-25')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and b.productid in ('1013059000296', '1013059000926')
  and p.promotionid in (4458295, 4724825, 4724824, 4776441, 4776442, 4830556, 4859627, 4859626, 4884108, 4884109, 4999678, 5044717, 5079848, 5079849, 5191534, 5296114, 5380503, 5380507, 5456768, 5456745, 5456746, 5456767, 5505441, 5505442, 5610256, 5762382, 5762383, 5778278, 5838385, 5762384, 5697261, 5697260, 5919866, 5953090, 5857782, 5857781, 6100839, 5857784, 5857783, 6110837, 6153220, 6153223, 3123199, 3123632, 3145451, 3138080, 3334917, 3373772, 3375189, 3375297, 3138235, 3390561, 3383387, 3383496, 3464551, 3453468, 3392701, 3479101, 3571560, 3138236, 3582116, 3582117, 3571823, 3803084, 3803000, 3894969, 3898736, 3905429, 3914434, 3918931, 3896792, 3918790, 4053707, 4081079, 4089516, 4081325, 4089430, 4144069, 4144193, 4153534, 4153695, 4221289, 4271235, 4221435, 4322941, 4290470, 4313068, 4322831, 4362322, 4362395, 4416898, 4437202, 4458342, 4493782, 4452238, 4452239, 4493907, 4557736, 4587075, 4587074, 4558813, 4592136, 4587231, 4499703, 4452240, 4474036, 4524620, 4557737, 4586712, 4592058, 4658013, 4698158, 4716458, 4716457, 4716328, 4698324, 4698274, 4771596, 4776359, 4724603, 4745829, 4830309, 4859458, 4821958, 4830423, 4821813, 4821812, 4999677, 4990722, 4990654, 4999092, 4999169, 5044802, 5059670, 5053752, 5102633, 5136489, 5295146, 5380504, 5380506, 5380505, 5295145, 5690415, 5690416, 5676848, 5676849)
  

  
SELECT outputvoucherid
FROM "pinot-group01"."default".bhx_inventory_inv_ov_promotiondiscount
where promotionid in (5838385)
GROUP BY outputvoucherid
HAVING COUNT(DISTINCT promotionid) = 2;

SELECT op.*,
		p.promotiontype ,
		p.discount
FROM "pinot-group01"."default".bhx_inventory_inv_ov_promotiondiscount op
join "pinot-group01"."default".pm_promotiongiftgroup p
on op.promotionid  = p.promotionid 
where outputvoucherid = 'OV106312507282431'
--and productid IN ('1013059000296', '1013059000926')


 ---- Thời gian trung bình KH mua lặp lại combo 2 túi là bao nhiêu %? (Tần suất)
WITH base AS (
    SELECT
        a.crmcustomerid AS customerid,
        p.promotionid,
        -- epoch ms -> timestamp with time zone
        from_unixtime(CAST(a.outputdate / 1000 AS BIGINT)) AS order_ts
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
        ON a.outputvoucherid = b.outputvoucherid
    join "pinot-group01"."default".bhx_inventory_inv_ov_promotiondiscount p
    	on b.outputvoucherid = p.outputvoucherid
    where b.productid in ('1013059000296', '1013059000926')
),
ordered AS (
    SELECT
        customerid,
        promotionid,
        order_ts,
        LEAD(order_ts) OVER (
            PARTITION BY customerid, promotionid
            ORDER BY order_ts
        ) AS next_ts
    FROM base
),
diffs AS (
    SELECT
        customerid,
        promotionid,
        date_diff('day', order_ts, next_ts) AS diff_days
    FROM ordered
    WHERE next_ts IS NOT NULL
)
SELECT
    promotionid,
    AVG(diff_days) AS avg_days_between_purchase
FROM diffs
WHERE promotionid IN (3123631, 4089517, 4322979, 4452236, 4452237, 5760312, 5760313, 4458295, 4724825, 4724824, 4776441, 4776442, 4830556, 4859627, 4859626, 4884108, 4884109, 4999678, 5044717, 5079848, 5079849, 5191534, 5296114, 5380503, 5380507, 5456768, 5456745, 5456746, 5456767, 5505441, 5505442, 5610256, 5762382, 5762383, 5778278, 5838385, 5762384, 5697261, 5697260, 5919866, 5953090, 5857782, 5857781, 6100839, 5857784, 5857783, 6110837, 6153220, 6153223, 3123199, 3123632, 3145451, 3138080, 3334917, 3373772, 3375189, 3375297, 3138235, 3390561, 3383387, 3383496, 3464551, 3453468, 3392701, 3479101, 3571560, 3138236, 3582116, 3582117, 3571823, 3803084, 3803000, 3894969, 3898736, 3905429, 3914434, 3918931, 3896792, 3918790, 4053707, 4081079, 4089516, 4081325, 4089430, 4144069, 4144193, 4153534, 4153695, 4221289, 4271235, 4221435, 4322941, 4290470, 4313068, 4322831, 4362322, 4362395, 4416898, 4437202, 4458342, 4493782, 4452238, 4452239, 4493907, 4557736, 4587075, 4587074, 4558813, 4592136, 4587231, 4499703, 4452240, 4474036, 4524620, 4557737, 4586712, 4592058, 4658013, 4698158, 4716458, 4716457, 4716328, 4698324, 4698274, 4771596, 4776359, 4724603, 4745829, 4830309, 4859458, 4821958, 4830423, 4821813, 4821812, 4999677, 4990722, 4990654, 4999092, 4999169, 5044802, 5059670, 5053752, 5102633, 5136489, 5295146, 5380504, 5380506, 5380505, 5295145, 5690415, 5690416, 5676848, 5676849)
GROUP BY promotionid
ORDER BY avg_days_between_purchase;


SELECT 
    p.promotionid,
    p.promotionname,
    p.promotiontype,
    p.fromdate,
    p.todate
FROM "pinot-group01"."default".bhx_bhx_masterdata_pm_promotion p
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_promotiongiftgroup pp
    ON p.promotionid = pp.promotionid
LEFT JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_promotion_applyproduct pap
    ON p.promotionid = pap.promotionid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_promotion_applysubgroup pas
    ON p.promotionid = pas.promotionid
LEFT JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product ppr
    ON ppr.productid = pap.productid
LEFT JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product AS pm_productapplysubgroup
	ON pm_productapplysubgroup.subgroupid = pas.subgroupid
	AND pm_productapplysubgroup.isdeleted = 'FALSE'
	AND pm_productapplysubgroup.isactived = 'TRUE' 
WHERE p.promotionid IN (5760312, 5760313, 5857781, 5380506)
--  AND pap.productid IN ('1013059000296', '1013059000926');
;

-- Tính khoảng cách ngày giữa các lần mua bất kỳ
WITH all_orders AS (
    SELECT
        a.crmcustomerid AS customerid,
        from_unixtime(CAST(a.outputdate/1000 AS BIGINT)) AS order_ts
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    WHERE a.crmcustomerid IN (
        SELECT DISTINCT a.crmcustomerid
        FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
        JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
        -- Nếu cần join product thì bật lại và sửa schema/table đúng
        -- JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        --     ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
        WHERE FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
          -- AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-07-25')
          AND b.outputtypeid IN (1903, 3)
          AND a.crmcustomerid > 5
          AND b.productid IN ('1013059000296', '1013059000926')
    )
),
all_diffs AS (
    SELECT
        customerid,
        date_diff(
            'day',
            order_ts,
            LEAD(order_ts) OVER (
                PARTITION BY customerid ORDER BY order_ts
            )
        ) AS diff_days
    FROM all_orders
),
avg_all AS (
    SELECT AVG(diff_days) AS avg_days_all
    FROM all_diffs
    WHERE diff_days IS NOT NULL
)
SELECT a.avg_days_all 
FROM avg_all a;


-----------------------------------------------------------------     % khách hàng có Mua Total CSCáNhân/Total khách của BHX: --------------------------------------------------------------------

SELECT 
     count (distinct a.crmcustomerid) AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-08-15')
  AND b.outputtypeid IN ( 1903, 3)
  AND a.crmcustomerid > 5
  and p.subgroupid   in (2712)
  
  
  ;
  
 ------------------------------------- Tính số revenue và số bill của từng Khách hàng theo tháng -------------------------------------

SELECT
    a.crmcustomerid AS customer_id,
    DATE_FORMAT(from_unixtime(a.outputdate / 1000 - 25200), '%Y-%m') AS year_month,
--    ROUND(SUM(
--        CASE WHEN b.outputtypeid = 1903
--             THEN ROUND(b.saleprice 	* (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity
--             ELSE 0 END
--    ), 0) AS total_revenue_offline,
--    ROUND(SUM(
--        CASE WHEN b.outputtypeid = 3
--             THEN ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity
--             ELSE 0 END
--    ), 0) AS total_revenue_online,
    count (distinct DATE_FORMAT(from_unixtime(a.outputdate / 1000 - 25200), '%Y-%m-%d')) AS total_day
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-06-01')
    AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-08-27')
    AND b.outputtypeid IN (3, 1903)
    AND a.crmcustomerid > 5
--    and a.crmcustomerid = 1055314497
GROUP BY
    a.crmcustomerid,
    DATE_FORMAT(from_unixtime(a.outputdate / 1000 - 25200), '%Y-%m')
;

SELECT
    a.crmcustomerid AS customer_id,
    DATE_FORMAT(from_unixtime(a.outputdate / 1000 - 25200), '%Y-%m') AS year_month,
    Round(SUM(ROUND(b.saleprice * (1 + (CAST(b.vat AS DOUBLE) / 100)), 0) * b.quantity),0) AS total_revenue,
    count (distinct a.outputvoucherid) as total_bill,
    count (distinct DATE_FORMAT(from_unixtime(a.outputdate / 1000 - 25200), '%Y-%m-%d')) as total_days
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-06-01')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-08-27')
    AND b.outputtypeid IN (3, 1903)
    AND a.crmcustomerid > 5
    and a.crmcustomerid = 1088840595
GROUP BY
    a.crmcustomerid,
    DATE_FORMAT(from_unixtime(a.outputdate / 1000 - 25200), '%Y-%m')
    
    ;
    
    -- TỔNG SỐ BILL CÓ CÁC BRAND CỦA U TÍCH ĐIỂM  (OFFLINE ) - DS sheet 1  01/09 - 24/09
--    TỔNG SỐ BILL CÓ CÁC BRAND CỦA U TÍCH ĐIỂM X2  (OFFLINE ) - DS sheet 2
WITH calc AS (
	SELECT
		a.outputvoucherid,
		ROUND(ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity, 0) AS line_revenue
	FROM
		"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
	JOIN
	    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
	    ON
		a.outputvoucherid = b.outputvoucherid
	WHERE
		from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
		AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-09-25')
		AND b.outputtypeid IN (1903)
		AND a.crmcustomerid > 5
		AND b.productid IN ('1013059000712', '1013059000711', '1013059000793', '1013059000796', '1013120000316', '1012835000843', '1012835000774', '1012835000738')
), /* IN có nghĩa là lấy thông tin từng dòng sp trong 1 bill  */
agg AS (
	SELECT
		round(sum(line_revenue), 0) AS total_revenue,
		COUNT(DISTINCT outputvoucherid) AS total_bill
	FROM
		calc
)
SELECT
	total_bill,
	total_revenue,
	round(CAST(total_revenue AS DOUBLE) / NULLIF(total_bill, 0),0) AS tb_gio_hang
FROM
	agg
	
	;
	
	SELECT
		a.outputvoucherid,
		ROUND(ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity, 0) AS line_revenue
	FROM
		"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
	JOIN
	    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
	    ON
		a.outputvoucherid = b.outputvoucherid
	WHERE
		from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
		AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-09-02')
		AND b.outputtypeid IN (3)
		AND a.crmcustomerid > 5
		AND a.outputvoucherid = 'OV114624509038387'
--		AND b.productid IN ('9252836000008')

  ;
  
  
     -- Trung bình giá trị giỏ hàng KH có mua nước giặt bột giặt chưa mua nước xả U
WITH calc AS (
	SELECT
		a.outputvoucherid,
		SUM( ROUND(ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity, 0) ) AS bill_revenue
	FROM
		"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
	JOIN
	    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
	    ON
		a.outputvoucherid = b.outputvoucherid
	JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
		ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
	WHERE
		from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-07-01')
		AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
		AND b.outputtypeid IN (3)
		AND a.crmcustomerid > 5
		AND p.subgroupid IN (3039, 3059)
	GROUP BY a.outputvoucherid 
	HAVING SUM(CASE WHEN p.productid IN ('1012835000271', '1012835000270', '1012835000738', '1012835000664', '1012835000759', '8934868114055', '1012835000762', '1012835000774', '1012835000668', '8934868115243', '1012835000610', '1012835000272', '8934868115427', '1012835000652', '9252835000232', '1012835000653', '1012835000736', '1012835000781', '9252835000233', '9252835000079', '1012835000761', '1012835000550', '1012835000683', '1012835000795', '1012835000817', '1012835000815', '1012835000824', '1012835000775', '1012835000843', '1012835000833', '1012835000800') THEN 1 ELSE 0 END) = 0
), /* IN có nghĩa là lấy thông tin từng dòng sp trong 1 bill  */
agg AS (
	SELECT
		round(sum(bill_revenue), 0) AS total_revenue,
		COUNT(DISTINCT outputvoucherid) AS total_bill
	FROM
		calc
)
SELECT
	total_bill,
	total_revenue,
	round(CAST(total_revenue AS DOUBLE) / NULLIF(total_bill, 0),0) AS tb_gio_hang
FROM
	agg;
     

   -- Trung bình giá trị giỏ hàng KH có mua hóa phẩm khác chưa mua nước xả U
WITH calc AS (
	SELECT
		a.outputvoucherid,
		a.crmcustomerid,
		SUM( ROUND(ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity, 0) ) AS bill_revenue
	FROM
		"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
	JOIN
	    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
	    ON
		a.outputvoucherid = b.outputvoucherid
	JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
		ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
	WHERE
		from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-07-01')
		AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
		AND b.outputtypeid IN (3)
		AND a.crmcustomerid > 5
		AND p.subgroupid IN (3110, 3113, 3121, 2835, 3580, 3043, 3119, 3118, 3120, 3117, 3041, 3040, 3115, 3111, 3114, 3112, 3116, 3042, 4120)
	GROUP BY a.outputvoucherid, a.crmcustomerid
	HAVING SUM(CASE WHEN p.productid IN ('1012835000271', '1012835000270', '1012835000738', '1012835000664', '1012835000759', '8934868114055', '1012835000762', '1012835000774', '1012835000668', '8934868115243', '1012835000610', '1012835000272', '8934868115427', '1012835000652', '9252835000232', '1012835000653', '1012835000736', '1012835000781', '9252835000233', '9252835000079', '1012835000761', '1012835000550', '1012835000683', '1012835000795', '1012835000817', '1012835000815', '1012835000824', '1012835000775', '1012835000843', '1012835000833', '1012835000800') THEN 1 ELSE 0 END) = 0
), /* IN có nghĩa là lấy thông tin từng dòng sp trong 1 bill  */
agg AS (
	SELECT
		round(sum(bill_revenue), 0) AS total_revenue,
		COUNT(DISTINCT outputvoucherid) AS total_bill,
		COUNT(DISTINCT crmcustomerid) AS customer_count
	FROM
		calc
)
SELECT
	total_bill,
	customer_count,
	total_revenue,
	round(CAST(total_revenue AS DOUBLE) / NULLIF(total_bill, 0),0) AS tb_gio_hang
FROM
	agg;
     
   -- Số lượng KH có mua nước giặt bột giặt chưa mua nước giặt U
--   Trung bình giá trị giỏ hàng KH có mua nước giặt bột giặt chưa mua nước giặt U
WITH calc AS (
	SELECT
		a.outputvoucherid,
		a.crmcustomerid,
		SUM( ROUND(ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity, 0) ) AS bill_revenue
	FROM
		"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
	JOIN
	    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
	    ON
		a.outputvoucherid = b.outputvoucherid
	JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
		ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
	WHERE
		from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-07-01')
		AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
		AND b.outputtypeid IN (3)
		AND a.crmcustomerid > 5
		AND p.subgroupid IN (3039, 3059)
	GROUP BY a.outputvoucherid, a.crmcustomerid
	HAVING SUM(CASE WHEN p.productid IN ('1013059000609', '1013059000795', '1013059000796', '1013059000739', '1013059000791', '1013059000793', '1013059000797', '1013059000298', '1013059000711', '1013059000301', '1013059000738', '1013059000299', '1013059000740', '1013059000300', '1013059000666', '1013059000252', '1013059000051', '1013059000445', '1013059000712', '1013039000128', '1013059000688', '1013059000434', '1013059000464', '9252835000372', '8934868028604', '8934868106203', '1013059000463', '9252835000362', '1013059000714', '1013059000713', '1013059000685', '1013059000741', '1013059000743', '1013059000742', '1013059000744', '1013059000794', '1013059000837', '1013059000838', '1013059000923', '1013059000962', '1013059000965') THEN 1 ELSE 0 END) = 0
), /* IN có nghĩa là lấy thông tin từng dòng sp trong 1 bill  */
agg AS (
	SELECT
		round(sum(bill_revenue), 0) AS total_revenue,
		COUNT(DISTINCT outputvoucherid) AS total_bill,
		COUNT(DISTINCT crmcustomerid) AS customer_count
	FROM
		calc
)
SELECT
	total_bill,
	customer_count,
	total_revenue,
	round(CAST(total_revenue AS DOUBLE) / NULLIF(total_bill, 0),0) AS tb_gio_hang
FROM
	agg;
  
   
--   Số lượng KH có mua hóa phẩm khác chưa mua nước giặt U
--   Trung bình giá trị giỏ hàng KH có mua hóa phẩm khác chưa mua nước giặt U
WITH calc AS (
	SELECT
		a.outputvoucherid,
		a.crmcustomerid,
		SUM( ROUND(ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity, 0) ) AS bill_revenue
	FROM
		"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
	JOIN
	    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
	    ON
		a.outputvoucherid = b.outputvoucherid
	JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
		ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
	WHERE
		from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-07-01')
		AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
		AND b.outputtypeid IN (3)
		AND a.crmcustomerid > 5
		AND p.subgroupid IN (3110, 3113, 3121, 2835, 3580, 3043, 3119, 3118, 3120, 3117, 3041, 3040, 3115, 3111, 3114, 3112, 3116, 3042, 4120)
	GROUP BY a.outputvoucherid, a.crmcustomerid
	HAVING SUM(CASE WHEN p.productid IN ('1013059000609', '1013059000795', '1013059000796', '1013059000739', '1013059000791', '1013059000793', '1013059000797', '1013059000298', '1013059000711', '1013059000301', '1013059000738', '1013059000299', '1013059000740', '1013059000300', '1013059000666', '1013059000252', '1013059000051', '1013059000445', '1013059000712', '1013039000128', '1013059000688', '1013059000434', '1013059000464', '9252835000372', '8934868028604', '8934868106203', '1013059000463', '9252835000362', '1013059000714', '1013059000713', '1013059000685', '1013059000741', '1013059000743', '1013059000742', '1013059000744', '1013059000794', '1013059000837', '1013059000838', '1013059000923', '1013059000962', '1013059000965') THEN 1 ELSE 0 END) = 0
), /* IN có nghĩa là lấy thông tin từng dòng sp trong 1 bill  */
agg AS (
	SELECT
		round(sum(bill_revenue), 0) AS total_revenue,
		COUNT(DISTINCT outputvoucherid) AS total_bill,
		COUNT(DISTINCT crmcustomerid) AS customer_count
	FROM
		calc
)
SELECT
	total_bill,
	customer_count,
	total_revenue,
	round(CAST(total_revenue AS DOUBLE) / NULLIF(total_bill, 0),0) AS tb_gio_hang
FROM
	agg;
  
 -- Số lượng KH có mua tẩy rửa chưa mua Sunlight VIM
--  Trung bình giá trị giỏ hàng KH có mua tẩy rửa chưa mua Sunlight VIM
WITH calc AS (
	SELECT
		a.outputvoucherid,
		a.crmcustomerid,
		SUM( ROUND(ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity, 0) ) AS bill_revenue
	FROM
		"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
	JOIN
	    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
	    ON
		a.outputvoucherid = b.outputvoucherid
	JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
		ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
	WHERE
		from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-07-01')
		AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
		AND b.outputtypeid IN (3)
		AND a.crmcustomerid > 5
		AND p.subgroupid IN (3127, 3120, 3041, 3118)
	GROUP BY a.outputvoucherid, a.crmcustomerid
	HAVING SUM(CASE WHEN p.productid IN ('1013041000183', '1013041000354', '1013116000200', '1013116000093', '1013118000083', '1013041000305', '1013116000092', '8934868101376', '1013041000185', '1013116000201', '1013115000043', '1013118000084', '9252835000001', '1013116000313', '8934868088707', '1013041000356', '8934868102298', '8934868113935', '1013116000094', '1013118000082', '8934868102281', '1013116000331', '8934868113942', '1013116000091', '8934868102229', '1013041000355', '1013116000255', '1013041000410', '1013041000303', '8934868088660', '1013041000306', '1013041000191', '1013116000329', '1013116000268', '1013116000254', '1013118000091', '1013041000463', '1013041000457',  '1013120000065', '9252835000065', '8934868088745', '8934868110712', '1013120000106', '1013120000316', '1013120000152', '1013120000166', '1013120000146') THEN 1 ELSE 0 END) = 0
), /* IN có nghĩa là lấy thông tin từng dòng sp trong 1 bill  */
agg AS (
	SELECT
		round(sum(bill_revenue), 0) AS total_revenue,
		COUNT(DISTINCT outputvoucherid) AS total_bill,
		COUNT(DISTINCT crmcustomerid) AS customer_count
	FROM
		calc
)
SELECT
	total_bill,
	customer_count,
	total_revenue,
	round(CAST(total_revenue AS DOUBLE) / NULLIF(total_bill, 0),0) AS tb_gio_hang
FROM
	agg;
 
 
 
-- Số lượng KH có mua hóa phẩm khác chưa mua Sunlight VIM
-- Trung bình giá trị giỏ hàng KH có mua hóa phẩm khác chưa mua  Sunlight VIM
WITH calc AS (
	SELECT
		a.outputvoucherid,
		a.crmcustomerid,
		SUM( ROUND(ROUND(b.saleprice * (1 + CAST(b.vat AS DOUBLE) / 100), 0) * b.quantity, 0) ) AS bill_revenue
	FROM
		"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
	JOIN
	    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
	    ON
		a.outputvoucherid = b.outputvoucherid
	JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
		ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
	WHERE
		from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-07-01')
		AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
		AND b.outputtypeid IN (3)
		AND a.crmcustomerid > 5
		AND p.subgroupid IN (3110, 3113, 3121, 2835, 3580, 3043, 3119, 3118, 3120, 3117, 3041, 3040, 3115, 3111, 3114, 3112, 3116, 3042, 4120)
	GROUP BY a.outputvoucherid, a.crmcustomerid
	HAVING SUM(CASE WHEN p.productid IN ('1013041000183', '1013041000354', '1013116000200', '1013116000093', '1013118000083', '1013041000305', '1013116000092', '8934868101376', '1013041000185', '1013116000201', '1013115000043', '1013118000084', '9252835000001', '1013116000313', '8934868088707', '1013041000356', '8934868102298', '8934868113935', '1013116000094', '1013118000082', '8934868102281', '1013116000331', '8934868113942', '1013116000091', '8934868102229', '1013041000355', '1013116000255', '1013041000410', '1013041000303', '8934868088660', '1013041000306', '1013041000191', '1013116000329', '1013116000268', '1013116000254', '1013118000091', '1013041000463', '1013041000457',  '1013120000065', '9252835000065', '8934868088745', '8934868110712', '1013120000106', '1013120000316', '1013120000152', '1013120000166', '1013120000146') THEN 1 ELSE 0 END) = 0
), /* IN có nghĩa là lấy thông tin từng dòng sp trong 1 bill  */
agg AS (
	SELECT
		round(sum(bill_revenue), 0) AS total_revenue,
		COUNT(DISTINCT outputvoucherid) AS total_bill,
		COUNT(DISTINCT crmcustomerid) AS customer_count
	FROM
		calc
)
SELECT
	total_bill,
	customer_count,
	total_revenue,
	round(CAST(total_revenue AS DOUBLE) / NULLIF(total_bill, 0),0) AS tb_gio_hang
FROM
	agg;



-- Khách hàng đã mua hàng Nhóm hàng Tẩy/ Rửa nhưng chưa Tẩy/Rửa của 2 NSX Sunlight và Vim
-- dữ liệu 3 tháng gần nhất

SELECT
	a.crmcustomerid AS customer_id
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON
	a.outputvoucherid = b.outputvoucherid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
	ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	from_unixtime(a.outputdate / 1000 - 25200) >= date_add('month', -3, DATE('2025-10-29')) 
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-29')
	AND b.outputtypeid IN (1903, 3)
	AND a.crmcustomerid > 5
	AND p.subgroupid IN (3041, 3115, 3116, 3118, 3119, 3120)
GROUP BY a.crmcustomerid
HAVING SUM(CASE WHEN p.subgroupid IN (3041, 3115, 3116, 3118, 3119, 3120) AND p.brandid IN (6883,6736) THEN 1 ELSE 0 END) = 0


-- 1) chưa từng mua nxv 3 tháng gần nhất

SELECT
	a.crmcustomerid AS customer_id,
	CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1 ELSE 0
	END AS is_online
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON
	a.outputvoucherid = b.outputvoucherid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
	ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
	from_unixtime(a.outputdate / 1000 - 25200) >= date_add('month', -3, DATE('2025-10-29')) 
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-29')
	AND b.outputtypeid IN (1903, 3)
	AND a.crmcustomerid > 5
	AND p.subgroupid IN (3041, 3115, 3116, 3118, 3119, 3120)
GROUP BY a.crmcustomerid
HAVING SUM(CASE WHEN p.subgroupid IN (3041, 3115, 3116, 3118, 3119, 3120) AND p.brandid IN (6883,6736) THEN 1 ELSE 0 END) = 0







