ST 3853
- KH có mua Fresh tháng 11, 12, 01/2026 (tối thiểu T1 phải có đơn hàng) -> Định nghĩa KH thường xuyên
- HTX 1903, 221 và 03 ( tức online và offline)
;

WITH base AS (
    SELECT DISTINCT 
        a.crmcustomerid AS customer_id, 
        DATE_TRUNC('month', FROM_UNIXTIME(a.outputdate / 1000 - 25200)) AS order_month
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
    ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
            ON b.productid = p.productid
    WHERE p.maingroupid IN (990, 993, 1234, 1235, 1236, 1254)
      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-11-01'
      AND from_unixtime(a.outputdate / 1000 - 25200) <  DATE '2026-02-02'
      AND a.crmcustomerid > 5 
      AND b.outputtypeid IN (3, 1903, 221)
      AND a.storeid = 3853
),
flag_by_month AS (
    SELECT
        customer_id,
        MAX(CASE WHEN order_month = DATE '2025-11-01' THEN 1 ELSE 0 END) AS buy_2025_11,
        MAX(CASE WHEN order_month = DATE '2025-12-01' THEN 1 ELSE 0 END) AS buy_2025_12,
        MAX(CASE WHEN order_month = DATE '2026-01-01' THEN 1 ELSE 0 END) AS buy_2026_01
    FROM base
    GROUP BY customer_id
)
SELECT DISTINCT customer_id
FROM flag_by_month
WHERE buy_2026_01 = 1
;   -- điều kiện bắt buộc

SELECT DISTINCT 
        a.outputvoucherid,
        a.storeid,
        p.productname,
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) AS order_date
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
    ON a.outputvoucherid = b.outputvoucherid
    JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
            ON b.productid = p.productid
    WHERE 
    a.crmcustomerid = 1008703836
--    p.maingroupid IN (990, 993, 1234, 1235, 1236, 1254)
--      AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE '2025-11-01'
--      AND from_unixtime(a.outputdate / 1000 - 25200) <  DATE '2026-02-02'
--      AND a.crmcustomerid > 5 
--      AND b.outputtypeid IN (3, 1903, 221)
      AND a.storeid = 3853





