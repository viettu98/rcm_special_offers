WITH base AS (
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
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2026-02-10')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND a.storeid in (2579, 2798, 3111, 3215, 3262, 3802, 4476, 4746, 6187, 7300, 7993, 8191, 9484, 9939, 9984, 10066, 13845, 14555, 14786, 15106, 27948, 27973, 28021, 3388, 4075, 6628, 6989, 7335, 7601, 13659, 29965, 28044, 13616, 2911, 3002, 3093, 3095, 3098, 3248, 3250, 3251, 3254, 3255, 3257, 3261, 3342, 3386, 3391, 3432, 3437, 3454, 3469, 3588, 3589, 3600, 3668, 3692, 3712, 3750, 3751, 3771, 3773, 3826, 3827, 3836, 3853, 3890, 3970, 4244, 4288, 4361, 4407, 4520, 4550, 4701, 4745, 4817, 4834, 4946, 4997, 5007, 5073, 5074, 5095, 5273, 5388, 5453, 5454, 5455, 5776, 5803, 5979, 5980, 6020, 6064, 6155, 6184, 6188, 6189, 6278, 6402, 6420, 6581, 6582, 6588, 6747, 6968, 7029, 7031, 7277, 7325, 7687, 7688, 8254, 8284, 8863, 8865, 9028, 9138, 9208, 9253, 9271, 9294, 9295, 9458, 9933, 9964, 10102, 10109, 13035, 13592, 13714, 13733, 14112, 14135, 14136, 14275, 14390, 14396, 14463, 14477, 14517, 14570, 14634, 14650, 14666, 14720, 14736, 14748, 14762, 14815, 15040, 15718, 15743, 15796, 15803, 16861, 17864, 27939, 27961, 28022, 28034, 28051, 28096, 28276, 28577, 28670, 28772, 28834, 29922, 15795, 29884, 29941, 29939)	
)
SELECT
    DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
  ON a.outputvoucherid = b.outputvoucherid
JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
      ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
JOIN base ON base.customer_id = a.crmcustomerid
WHERE b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
--  AND HOUR(FROM_UNIXTIME(a.outputdate / 1000 - 25200)) >= 17
--  AND p.productid IN ('1495245000185', '1495245000184', '1495245000188', '1495245000189', '1495245000191', '1495245000179')
  AND p.subgroupid IN (2834, 5445, 3129, 5540, 2842, 3122, 2833)
--)


;

SELECT
    * FROM "pinot-group01"."default".bhx_bhx_masterdata_pm_product p
    WHERE p.productname LIKE '%sữa rửa mặt%'
--ORDER BY 




























