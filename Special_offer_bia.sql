with tmp as 
(SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-08-20')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.maingroupid in (1255)
  and a.storeid in (4823, 6183, 7687, 3248, 3589, 3257, 3692, 3751, 5979, 3751, 3773, 4834, 6747, 9933, 7277, 8284, 7277, 7325, 8254, 8865, 9294, 14570, 3391, 4937, 6188, 4701, 9271, 2911, 3254, 3454, 3454, 3469, 4550, 4550, 5074, 6064, 6064, 9964, 13616, 14761, 5007, 5776, 14135, 14666, 16861, 3002, 3342, 4288, 4361, 4361, 5454, 5980, 7029, 9138, 13592, 3093, 3255, 3261, 3600, 3853, 4244, 4997, 5095, 10109, 6278, 7688, 7688)
  and b.productid in ('1253021000258', '1253021000266', '1253021000246', '1063021000020', '1253021000037', '8934822801335', '1063021000015', '1253021000032', '1253021000259', '8936094291203', '1253021000157', '1253021000143', '1063021000032', '1253021000191')
  )
 SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
where co_caidatapp  = 1
    
    
    
    
;

select storeid from "pinot-group01"."default".bhx_inventory_inv_outputvoucher
where outputvoucherid  = 'OV107688406224742'
;
select refstoreid  from "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail
where outputvoucherid  = 'OV107688406224742'


;
-- khách có mua brand sting từ 1/06/2025 - hiện tại n  nhưng ko mua brand Warrior

 with tmp2 as (
 SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-01')
--  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-08-14')
  and b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.brandid in (6767)
  and p.brandid not in (11113)
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp2 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id;
 
 

 -----------------------
 

 
 with tmp1 as 
 (
 SELECT 
 	a.crmcustomerid AS customer_id,
    Round(AVG(ROUND(b.saleprice * (1 + (CAST(b.vat AS DOUBLE) / 100)), 0) * b.quantity),0) AS avg_revenue
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-08-28')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.subgroupid in (2980, 3020, 3047)
  and p.subgroupid not in (3205, 3024)
  and a.storeid in (1975, 2023, 2115, 2214, 2338, 2425, 2436, 2442, 2714, 2808, 2847, 2900, 3043, 3092, 3093, 3207, 3237, 3251, 3255, 3257, 3261, 3263, 3370, 3376, 3386, 3387, 3391, 3440, 3447, 3547, 3612, 3667, 3750, 3751, 3807, 3826, 3854, 3874, 3969, 4074, 4220, 4222, 4231, 4269, 4284, 4324, 4333, 4375, 4383, 4384, 4390, 4405, 4416, 4430, 4431, 4440, 4448, 4450, 4460, 4482, 4539, 4584, 4602, 4610, 4628, 4636, 4683, 4686, 4687, 4689, 4691, 4720, 4743, 4753, 4757, 4761, 4768, 4771, 4775, 4819, 4821, 4822, 4834, 4847, 4867, 4871, 4876, 4880, 4906, 4937, 4967, 4968, 4978, 4981, 4995, 5003, 5007, 5014, 5034, 5038, 5055, 5056, 5066, 5074, 5079, 5082, 5083, 5094, 5098, 5163, 5176, 5177, 5228, 5231, 5239, 5272, 5273, 5274, 5284, 5307, 5308, 5309, 5399, 5431, 5453, 5460, 5485, 5686, 5690, 5723, 5726, 5744, 5776, 5799, 5980, 6004, 6007, 6008, 6025, 6027, 6043, 6055, 6057, 6138, 6155, 6157, 6183, 6219, 6226, 6234, 6235, 6239, 6244, 6247, 6250, 6254, 6259, 6263, 6290, 6292, 6296, 6307, 6308, 6340, 6362, 6363, 6369, 6377, 6406, 6408, 6418, 6424, 6426, 6450, 6473, 6474, 6475, 6490, 6499, 6519, 6526, 6527, 6534, 6539, 6551, 6553, 6556, 6564, 6574, 6581, 6588, 6591, 6594, 6622, 6628, 6629, 6690, 6692, 6726, 6744, 6756, 6764, 6766, 6768, 6812, 6831, 6839, 6857, 6858, 6873, 6879, 6966, 6970, 6989, 6990, 6991, 7027, 7111, 7140, 7224, 7241, 7250, 7277, 7300, 7326, 7335, 7601, 7670, 7672, 7747, 7789, 7882, 7883, 7884, 7917, 7932, 7951, 7985, 8018, 8026, 8105, 8190, 8251, 8284, 8341, 8347, 8362, 8534, 8542, 8564, 8656, 8730, 8830, 8844, 8846, 8873, 8909, 8934, 9079, 9125, 9145, 9190, 9208, 9253, 9271, 9279, 9294, 9295, 9302, 9305, 9432, 9448, 9452, 9458, 9475, 9521, 9745, 9762, 9933, 9980, 9986, 9998, 10053, 10081, 10102, 10103, 10151, 10167, 10299, 10397, 10449, 10495, 12995, 13035, 13592, 13608, 13656, 13733, 13775, 13837, 13845, 14153, 14299, 14325, 14326, 14332, 14410, 14463, 14471, 14488, 14504, 14532, 14549, 14553, 14577, 14581, 14585, 14589, 14615, 14657, 14660, 14661, 14663, 14668, 14703, 14704, 14749, 14764, 14769, 14779, 14788, 14790, 14832, 14929, 14993, 27902, 27917)
group by a.crmcustomerid
)
 SELECT 
    t.customer_id,
    t.avg_revenue,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp1 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
  ;
 
 
--   1. 01/2025 - 07/09/2025 không có mua nhóm hàng nước xả vải
--with tmp as (;
SELECT 
    distinct a.crmcustomerid AS customer_id
--    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-07')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.subgroupid not in (2835);
 )
 SELECT 
    t.customer_id,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
  
  
  
--  2. Có mua NXV tháng 1/2025 - 30/05/2025, và từ 01/06/2025 đến này ko có mua 
 with tmp1 as
 (
 SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-08')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.subgroupid in (2835)
 ),
tmp2 as (
 SELECT 
    distinct a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-08')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.subgroupid in (2835)
),
tmp3 as(
select tmp1.*
from tmp1 
where not exists (
					select 1 
					from tmp2 
					where tmp1.customer_id = tmp2.customer_id)
)
 SELECT 
    t.customer_id,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp3 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
  
 ;

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
CAST(a.crmcustomerid  AS VARCHAR) = '1094092847'
 and p.subgroupid in (3054)
-- and FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-07-22')
 ;
 
 -- - Game Hàng Tươi Sống
--    Mã Brand: 993, 1234, 1235, 1236 , 1254
--    Điều kiện: Khách hàng đã mua hàng tại BHX (tính từ tháng 1/2025) nhưng chưa mua Fresh trong 2 tuần (25/8 - 7/9)

with tmp1 as
 (
 SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-07')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
 ),
tmp2 as (
 SELECT 
    distinct a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-08-25')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-07')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5 -- có định danh
  and p.maingroupid in (993, 1234, 1235, 1236 , 1254)
)
select tmp1.*
from tmp1 
where not exists (
					select 1 
					from tmp2 
					where tmp1.customer_id = tmp2.customer_id)
 ;

-- mua hàng ở BHX từ tháng 1/2025 nhưng không mua fresh từ tháng 9/2025
with tmp as 
(SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-10')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and b.productid in ('9932855000177', '1232855000223', '1232855000231', '1232854000709', '1232854000672', '9932855000009')
  )
 SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
where CAST(co_caidatapp as INTEGER)  = 1
; 

 -- Từ 01/09-15/09: KH có mua all sp BHX nhưng không mua fresh

with tmp as 
(SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.maingroupid not in (993, 1234, 1235, 1236 , 1254)
  )
 SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
where CAST(co_caidatapp as INTEGER)  = 1
 
 -- 05/08-24/08: KH có mua all sản phẩm, không trừ brand hay nhóm hàng gì và từ 25/08-15/09 không phát sinh đơn hàng nào khác
 
 with tmp1 as 
(
SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-08-05')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  ),
tmp2 as (
 SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-08-25')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5 -- có định danh
),
tmp3 as 
(
select tmp1.*
from tmp1 
where not exists (
					select 1 
					from tmp2 
					where tmp1.customer_id = tmp2.customer_id)
)
 SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp3 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
where CAST(co_caidatapp as INTEGER)  = 1

 
--Trong 3 tháng gần nhất chưa mua nước tăng lực (Mã nhóm: 3084):

--with tmp1 as
-- (
-- SELECT 
--    distinct a.crmcustomerid AS customer_id,
--    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
--FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
--JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
--    ON a.outputvoucherid = b.outputvoucherid
--JOIN
--    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
--    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
--WHERE 
--  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
--  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
--  AND b.outputtypeid IN (1903, 3)
--  AND a.crmcustomerid > 5
--),
WITH tmp2 as (
 SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-15')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.subgroupid NOT IN (3084)
GROUP BY  a.crmcustomerid
--),
--tmp3 as(
--select tmp1.*
--from tmp1 
--where not exists (
--					select 1 
--					from tmp2 
--					where tmp1.customer_id = tmp2.customer_id)
)
 SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp2 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
    ;
-- Trong 3 tháng gần nhất chưa mua nước suối (Mã nhóm: 3025)
--with tmp1 as
-- (
-- SELECT 
--    distinct a.crmcustomerid AS customer_id,
--    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
--FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
--JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
--    ON a.outputvoucherid = b.outputvoucherid
--JOIN
--    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
--    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
--WHERE 
--  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
--  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
--  AND b.outputtypeid IN (1903, 3)
--  AND a.crmcustomerid > 5
--),
WITH 
tmp2 as (
 SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-15')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.subgroupid NOT in (3025)
--),
--tmp3 as(
--select tmp1.*
--from tmp1 
--where not exists (
--					select 1 
--					from tmp2 
--					where tmp1.customer_id = tmp2.customer_id)
)
 SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp2 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;
--- Có khả năng mua các SKU (theo file đính kèm) ____ CAO _____
SELECT 
    distinct a.crmcustomerid AS customer_id,
    CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-15')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
  and b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.productid in ('1063084000102', '1063084000174', '1063084000059', '18938503000014', '9892850000463', '1063025000193', '1063025000194')
GROUP BY a.crmcustomerid
    

 --- Có khả năng mua các SKU (theo file đính kèm) ____ TB, THẤP _____ : top mua theo bill 
  
 WITH tmp1 AS (
SELECT
	DISTINCT a.crmcustomerid AS customer_id,
	CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
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
	FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-15')
	AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-09-15')
	AND b.outputtypeid IN (1903, 3)
	AND a.crmcustomerid > 5
	AND p.subgroupid IN (3025, 3084)
	AND p.productid NOT IN ('1063084000102', '1063084000174', '1063084000059', '18938503000014', '9892850000463', '1063025000193', '1063025000194')
GROUP BY
	a.crmcustomerid
  ),
  tmp2 AS 
  (
SELECT
	DISTINCT a.crmcustomerid customer_id,
	count (DISTINCT a.outputvoucherid) AS count_bill
FROM
	"pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON
	a.outputvoucherid = b.outputvoucherid
WHERE
	b.outputtypeid IN (1903, 3)
		AND a.crmcustomerid > 5
	GROUP BY
		a.crmcustomerid
  ),
base AS(
 SELECT DISTINCT tmp1.customer_id ,
  tmp1.is_online ,
  tmp2.count_bill 
 FROM tmp1 LEFT JOIN tmp2
 ON tmp1.customer_id = tmp2.customer_id
),
ranked AS (
SELECT
	customer_id,
	is_online,
	count_bill,
	percent_rank() OVER (
ORDER BY
	count_bill DESC,
	customer_id) AS pr
	-- 0..1
FROM
	base
)
SELECT
	customer_id,
	is_online,
	count_bill,
	pr
FROM
	ranked
--WHERE
--	pr >= 0.6
--	AND count_bill > 1
	-- giữ top ~60% theo count_bill (desc)
ORDER BY
	count_bill DESC;
  
   
  WITH t AS (
  SELECT
      a.crmcustomerid AS customer_id,
      COUNT(DISTINCT a.outputvoucherid) AS count_bill
  FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
  JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
        ON a.outputvoucherid = b.outputvoucherid
  WHERE
      b.outputtypeid IN (1903, 3)
      AND a.crmcustomerid > 5
      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-06-15'
      AND from_unixtime(a.outputdate / 1000 - 25200) <  DATE '2025-09-16'   -- bao phủ hết 15/09
  GROUP BY a.crmcustomerid
)
SELECT
    customer_id,
    count_bill,
    MIN(count_bill) OVER () AS min_count_bill
FROM t
  ;
  
   SELECT 
 distinct a.crmcustomerid AS customer_id,
   CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1 ELSE 0
     END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND a.crmcustomerid = 1073375657
  and p.subgroupid in (3025, 3084)
GROUP BY a.crmcustomerid
  
  
--Từ 21/07-21/09:  KH có mua hàng BHX (on và offline) không quan tâm brand hay nhóm hàng nào nhưng không có mua fresh (993, 1234, 1235, 1236 , 1254)
 
--SELECT 
--DISTINCT a.crmcustomerid AS customer_id
---- CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
----            THEN 1 ELSE 0
----     END AS is_online
--FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
--JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
--    ON a.outputvoucherid = b.outputvoucherid
--JOIN
--    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
--    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
--WHERE 
--  b.outputtypeid IN (1903, 3)
--  AND a.crmcustomerid > 5
--  and p.maingroupid  NOT IN (993, 1234, 1235, 1236 , 1254)
--  AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-07-21'
--  AND from_unixtime(a.outputdate / 1000 - 25200) <  DATE '2025-09-21'
----  AND a.crmcustomerid = 1023631875
  ;

SELECT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
    b.outputtypeid IN (1903, 3)
    AND a.crmcustomerid > 5
    AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-07-21'
    AND from_unixtime(a.outputdate / 1000 - 25200) <  DATE '2025-09-22'
    AND a.crmcustomerid = 1023631875
GROUP BY a.crmcustomerid
HAVING SUM(CASE WHEN p.maingroupid IN (993, 1234, 1235, 1236, 1254) THEN 1 ELSE 0 END) = 0


;
--- Khách hàng không mua Fresh từ ngày 01/03/2025 -> 01/08/2025
--- Khách hàng có mua Fresh từ ngày 01/08/2025 -> 23/09/2025
--=> Chỉ xét theo hình thức xuất online 1903
WITH buyers_late AS (   -- KH có mua Fresh trong 01/08/2025 → 23/09/2025
  SELECT DISTINCT a.crmcustomerid AS customer_id
  FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
  JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
  JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
  WHERE b.outputtypeid = 1903
    AND a.crmcustomerid > 5
    AND p.maingroupid IN (993, 1234, 1235, 1236, 1254)
    AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-08-01'
    AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-09-24'
),
buyers_early AS (       -- KH có mua Fresh trong 01/03/2025 → trước 01/08/2025
  SELECT DISTINCT a.crmcustomerid AS customer_id
  FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
  JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
    ON a.outputvoucherid = b.outputvoucherid
  JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
  WHERE b.outputtypeid = 1903
    AND a.crmcustomerid > 5
    AND p.maingroupid IN (993, 1234, 1235, 1236, 1254)
    AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-03-01'
    AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-08-01'
)
SELECT l.customer_id
FROM buyers_late l
LEFT JOIN buyers_early e ON l.customer_id = e.customer_id
WHERE e.customer_id IS NULL  -- có mua giai đoạn sau, KHÔNG mua giai đoạn trước
;

--  Từ 22/07-22/09 có phát sinh mua hàng ở BHX on&offline, không quan tâm brand hay nhóm hàng nào nhưng chưa từng mua GẠO (3054).


WITH buy_recent AS (
    SELECT
        a.crmcustomerid AS customer_id,
        CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1 ELSE 0
     	END AS is_online
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    WHERE b.outputtypeid IN (1903, 3)
      AND a.crmcustomerid > 5
      AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-07-22'
      AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-09-23'
    GROUP BY a.crmcustomerid
),
never_rice AS (
    /* KH chưa từng mua subgroup 3054 (mọi thời điểm) */
    SELECT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903, 3)
      AND a.crmcustomerid > 5
    GROUP BY a.crmcustomerid
    HAVING MAX(CASE WHEN p.subgroupid = 3054 THEN 1 ELSE 0 END) = 0
)
SELECT
    br.customer_id,
    br.is_online
FROM buy_recent br
JOIN never_rice nr
  ON br.customer_id = nr.customer_id;

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
WHERE b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-06-24'
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-09-25'
GROUP BY a.crmcustomerid
HAVING SUM(CASE WHEN p.maingroupid IN (993, 1234, 1235, 1236, 1254) THEN 1 ELSE 0 END) = 0

--2. 01/08-09/09: KH có mua all sản phẩm, không trừ brand hay nhóm hàng gì và từ 10/09-24/09 không phát sinh đơn hàng nào khác

WITH buy_august AS (
	/*01/08-09/09: KH có mua all sản phẩm */
    SELECT
        a.crmcustomerid AS customer_id,
        CASE WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1 ELSE 0
     	END AS is_online
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    WHERE b.outputtypeid IN (1903, 3)
      AND a.crmcustomerid > 5
      AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-08-01'
      AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-09-10'
    GROUP BY a.crmcustomerid
),
buy_recent AS (
    /* 10/09-24/09 không phát sinh đơn hàng nào */
    SELECT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
      ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE b.outputtypeid IN (1903, 3)
      AND a.crmcustomerid > 5
      AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-09-10'
      AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-09-25'
    GROUP BY a.crmcustomerid
)
SELECT
    ba.customer_id,
    ba.is_online
FROM buy_august ba
LEFT JOIN buy_recent br
  ON br.customer_id = ba.customer_id
WHERE br.customer_id IS NULL;




--- Khách hàng chưa mua nước giặt, bột giặt trong 3 tháng gần nhất (01/07 - 15/10)
--Mã nhóm hàng: 3039, 3059
WITH tmp2 as(
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
WHERE b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-07-01'
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-10-16'
GROUP BY a.crmcustomerid
HAVING SUM(CASE WHEN p.subgroupid IN (3039, 3059) THEN 1 ELSE 0 END) = 0
)
 SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp2 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id;



;
-- KH có mua hàng của nhóm "Dầu ăn, nước mắm, gia vị" từ (01/07-20/10)
SELECT
    DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE b.outputtypeid IN (1903)
  AND a.crmcustomerid > 5
  AND p.subgroupid IN (3085, 3046, 3092, 2832, 3093, 3094, 3095, 3096, 3097, 3098, 3099, 3100, 3101, 3102, 3103, 2840, 3105, 3106, 5400, 3058, 3057, 3107, 4040, 3108, 3109)
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-07-01'
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-10-21'




--Tệp 1: Khách hàng chưa mua Nước thể thao (= A - Tệp khách đã mua Nước thể thao)
--Thời gian: Trong 3 tháng gần nhất (T08.2025 - T10.2025)

with tmp1 as
 (
 SELECT 
     a.crmcustomerid AS customer_id,
    CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-10-31')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid
),
tmp2 as (
 SELECT 
    distinct a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-08-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-10-31')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and p.subgroupid IN (3025)
)
select tmp1.*
from tmp1 
where not exists (	select 1 
					from tmp2 
					where tmp1.customer_id = tmp2.customer_id)
;

WITH store_freq AS (
    SELECT
        a.crmcustomerid AS customer_id,
        storeid,
        COUNT(DISTINCT a.outputvoucherid) AS total_orders
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
    WHERE 
	  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
	  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-10-31')
	  AND b.outputtypeid IN (1903, 3)
	  AND a.crmcustomerid > 5
	GROUP BY a.crmcustomerid, a.storeid
),
ranked AS (
    SELECT
        customer_id,
        storeid,
        total_orders,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total_orders DESC) AS rn
    FROM store_freq
)
SELECT
    customer_id,
    storeid AS most_visited_store
FROM ranked
WHERE rn = 1;


1. Khách hàng có khả năng mua 2 sản phẩm này 
- 18934564600149 NƯỚC C2 TRÀ XANH HƯƠNG CHANH CHAI 360ML TH24
- 18934564600187 NƯỚC C2 TRÀ XANH HƯƠNG TÁO CHAI 360ML/355ML TH24
2. Khách hàng có định danh 
3. Volume < 500.000 ID
;

SELECT 
	a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
--JOIN
--    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
--    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-11-05')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  and b.productid IN ('18934564600149', '18934564600187')
GROUP BY a.crmcustomerid 
HAVING COUNT(DISTINCT a.outputvoucherid) > 1

;

;

WITH sku_qty AS (
  SELECT
      a.outputvoucherid AS bill_id,
      a.crmcustomerid   AS customer_id,
      SUM(b.quantity)   AS qty_per_sku_in_bill,
      CAST(b.productid AS VARCHAR) AS product_id
  FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
  JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
    ON a.outputvoucherid = b.outputvoucherid
  JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
  WHERE FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-08-01'
    AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-11-01'
    AND b.outputtypeid IN (1903, 3)
    AND a.crmcustomerid > 5
--    and b.productid IN ('18934564600149', '18934564600187'
	and p.subgroupid IN (3083)
  GROUP BY a.outputvoucherid, a.crmcustomerid, CAST(b.productid AS VARCHAR)
),
bill_all_sku_gt1 AS (
  SELECT customer_id, bill_id
  FROM sku_qty
  GROUP BY customer_id, bill_id
  HAVING MIN(qty_per_sku_in_bill) > 1
)
SELECT DISTINCT customer_id
FROM bill_all_sku_gt1;

WITH bill_subgroup AS (
  SELECT
      a.crmcustomerid                     AS customer_id,
      a.outputvoucherid                   AS bill_id,
      p.subgroupid                        AS subgroup_id,
      SUM(b.quantity)                     AS total_qty_in_subgroup,
      COUNT(*)                            AS line_cnt_in_subgroup,
      COUNT(DISTINCT CAST(b.productid AS VARCHAR)) AS sku_cnt_in_subgroup
  FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
  JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
    ON a.outputvoucherid = b.outputvoucherid
  JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
  WHERE FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE '2025-08-01'
    AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE '2025-11-01'
    AND b.outputtypeid IN (1903, 3)
    AND a.crmcustomerid > 5
    AND p.subgroupid = 3083
  GROUP BY a.crmcustomerid, a.outputvoucherid, p.subgroupid
)
SELECT
  DISTINCT customer_id
FROM bill_subgroup
WHERE total_qty_in_subgroup >= 2;   -- cùng 1 subgroup trong bill có tổng qty ≥ 2


---  KH từ 1/1/2024 có mua hàng tại BHX on /off line nhưng không mua nước suối (mã nhóm: 3025)

SELECT 
	a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <= DATE('2025-12-01')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid
HAVING SUM(CASE WHEN p.subgroupid IN (3025) THEN 1 ELSE 0 END) = 0

;

--KH đã mua thương hiệu, hình thức xuất cả online và offline "tháng 8, 9, 10 mở scope lấy từ 1/1/2025-> 31/10/2025"

SELECT 
	DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-12-01')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND p.brandid  IN (13978)	
  
  
  -- 
SELECT 
  brandid AS customer_id
FROM "pinot-group01"."default".bhx_bhx_masterdata_pm_brand 
WHERE LOWER(brandname) LIKE '%pepsi%'

---
Khách ON/off 
từ 1-1-2024 đến 26-12
có app/ko app
1255 bia 
1060 nước uống
---
;
WITH tmp AS (
SELECT 
	a.crmcustomerid AS customer_id,
	CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-12-27')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND p.maingroupid IN (1255, 1060)
GROUP BY a.crmcustomerid
--HAVING COUNT(DISTINCT p.maingroupid) = 2
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;
Khách ON/off 
từ 1-1-2024 đến 26-12
có app/ko app:
Ngành hàng: 
1354 Sản Phẩm Từ Sữa - Bảo Quản Mát
1096 Đồ dùng mẹ và bé
1355 Kem các loại
Nhóm hàng
3024 Nước dinh dưỡng
3205 Nước dinh dưỡng giải khát
;
WITH tmp AS (
SELECT 
	a.crmcustomerid AS customer_id,
	CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-12-27')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND (p.maingroupid IN (1354, 1096, 1355) OR  p.subgroupid IN (3024, 3205))
GROUP BY a.crmcustomerid
--HAVING COUNT(DISTINCT p.maingroupid) = 3 AND COUNT(DISTINCT p.subgroupid) = 2
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;

"Ngành hàng:
1014 Hóa phẩm các loại
925  Mỹ phẩm các loại
1055 Thực phẩm - Gia vị các loại
1235 Trái Cây Các Loại
1236 Thịt gia cầm gia súc các loại
1234 Rau Củ Các Loại
1254 Thủy Hải Sản Các Loại
993 Thực phẩm tươi sống"
;

WITH tmp AS (
SELECT 
	a.crmcustomerid AS customer_id,
	CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-12-27')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND p.maingroupid IN (1014, 925, 1055, 1235, 1236, 1234, 1254, 993)
GROUP BY a.crmcustomerid
--HAVING COUNT(DISTINCT p.maingroupid) = 8
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
    
;
"Ngành hàng:
1235 Trái Cây Các Loại
1236 Thịt gia cầm gia súc các loại
1234 Rau Củ Các Loại
1254 Thủy Hải Sản Các Loại
993 Thực phẩm tươi sống
1055 Thực phẩm - Gia vị các loại        "
"Nhóm hàng: 
2551 Băng vệ sinh"

WITH tmp AS (
SELECT 
	a.crmcustomerid AS customer_id,
	CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-12-27')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND (p.maingroupid IN (1235, 1236, 1234,1254,993,1055) OR  p.subgroupid IN (2551))
GROUP BY a.crmcustomerid
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;
"991 BHX - Hàng khuyến mãi
1060  Thức uống giải khát các loại
1355 Kem các loại
1354 Sản Phẩm Từ Sữa - Bảo Quản Mát"
"Nhóm hàng:
3047 Mì ăn liền"
;

WITH tmp AS (
SELECT 
	a.crmcustomerid AS customer_id,
	CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-12-27')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND (p.maingroupid IN (991, 1060, 1355,1354) OR  p.subgroupid IN (3047))
GROUP BY a.crmcustomerid
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;

"Ngành hàng:
3188 Hoa Tươi Các Loại
1235 Trái Cây Các Loại"
"Nhóm hàng: 
4040 Thực Phẩm - Gia Vị Chay
6659 Thực Phẩm Ăn Liền Chay Các Loại
Khách hàng có phát sinh đơn hàng trong các ngày 30, mùng 1, 14, 15 âm lịch"


WITH tmp AS (
SELECT 
	a.crmcustomerid AS customer_id,
	CASE
		WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
		ELSE 0
	END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
  DATE(
    FROM_UNIXTIME(a.outputdate / 1000 - 25200)
)
IN (
    DATE '2025-02-11', DATE '2025-02-12',
    DATE '2025-03-13', DATE '2025-03-14',
    DATE '2025-04-11', DATE '2025-04-12',
    DATE '2025-05-11', DATE '2025-05-12',
    DATE '2025-06-08', DATE '2025-06-09',
    DATE '2025-07-08', DATE '2025-07-09',
    DATE '2025-08-07', DATE '2025-08-08',
    DATE '2025-09-05', DATE '2025-09-06',
    DATE '2025-10-05', DATE '2025-10-06',
    DATE '2025-11-04', DATE '2025-11-05',
    DATE '2025-12-03', DATE '2025-12-04'
)
--  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
--  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-12-27')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND (p.maingroupid IN (3188, 1235) OR  p.subgroupid IN (4040, 6659))
GROUP BY a.crmcustomerid
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;


WITH beer_bill AS (
    SELECT DISTINCT
        a.outputvoucherid
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
        ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-03-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-06-01')
        AND p.subgroupid in (3021, 3022)
),
beer_bill_total AS (
    SELECT COUNT(*) AS total_bill_beer
    FROM beer_bill
),
co_purchase AS (
    SELECT DISTINCT
        d.outputvoucherid,
        d.productid,
        p.productname
    FROM beer_bill bb
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail d
        ON bb.outputvoucherid = d.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
        ON CAST(d.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE p.subgroupid NOT IN (3021, 3022) AND p.productid <> '9442592000005'
)
SELECT
    cp.productid AS product_id,
    cp.productname,
    COUNT(*) AS bill_cnt_with_beer,
    bt.total_bill_beer,
    ROUND(
        100.0 * COUNT(*) / bt.total_bill_beer,
        2
    ) AS attach_rate_pct
FROM co_purchase cp
CROSS JOIN beer_bill_total bt
GROUP BY
    cp.productid,
    cp.productname,
    bt.total_bill_beer
ORDER BY bill_cnt_with_beer DESC
LIMIT 30;














