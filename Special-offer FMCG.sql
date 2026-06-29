1063083000223 TRÀ XANH C2 VỊ CHANH CHAI 225ML TH24
1063083000222 TRÀ XANH C2 VỊ TÁO CHAI 225ML TH24
1063083000243 TRÀ ĐEN C2 HƯƠNG ĐÀO CHAI 225ML TH24
1063083000400 TRÀ XANH C2 ỔI HỒNG CHANH DÂY CHAI 225ML TH24

Thời gian xử lý dữ liệu: Từ 01/04 - 13/10/2025
1. Khách hàng có mua các sản phẩm trên ít nhất 2 bill/tháng
;
SELECT DISTINCT customer_id
FROM (
    SELECT
        a.crmcustomerid AS customer_id,
        DATE_TRUNC('month', FROM_UNIXTIME(a.outputdate / 1000 - 25200)) AS order_month
    FROM
        "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-04-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-10-14')
        AND a.crmcustomerid > 5
        AND b.productid IN ('1063083000223','1063083000222',
                            '1063083000243','1063083000400')
    GROUP BY 
        a.crmcustomerid,
        DATE_TRUNC('month', FROM_UNIXTIME(a.outputdate / 1000 - 25200))
    HAVING 
        COUNT(DISTINCT a.outputvoucherid) >= 2
) t;

2. Khách hàng có khả năng mua nhóm sản phẩm trên
;
-- tiem nang trung binh
WITH tmp1 AS (
  SELECT
        DISTINCT a.crmcustomerid AS customer_id,
        'tb' AS tiem_nang
    FROM
        "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-04-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-10-14')
        AND a.crmcustomerid > 5
        AND p.subgroupid in (3083, 3082, 3025, 4174, 3023, 4719, 3084, 3821, 3205)
        AND p.quantityunitid = 5
 )
SELECT 
    t.customer_id,
    t.tiem_nang,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp1 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = CAST(app.customer_id AS VARCHAR)


;
-- tiem nang cao
WITH tmp1 AS (
SELECT
        DISTINCT a.crmcustomerid AS customer_id,
        'cao' AS tiem_nang
    FROM
        "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-04-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-10-14')
        AND a.crmcustomerid > 5
        AND b.productid IN ('1063083000223','1063083000222',
                            '1063083000243','1063083000400')
 )
 SELECT 
    t.customer_id,
    t.tiem_nang,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp1 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = CAST(app.customer_id AS VARCHAR)
 ;



--- tiem nang thap
WITH tmp1 AS (
  SELECT distinct
     a.crmcustomerid AS customer_id,
     'thap' AS tiem_nang
    FROM
        "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-04-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-10-14')
        AND a.crmcustomerid > 5
        AND p.subgroupid in (3083, 3047)
   	GROUP BY a.crmcustomerid, a.outputvoucherid 
    HAVING COUNT(DISTINCT p.subgroupid) = 2
 )
SELECT DISTINCT 
    t.customer_id,
    t.tiem_nang,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp1 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = CAST(app.customer_id AS VARCHAR)
        
;


KH có mua hàng BHX từ 1/1/2024 đến 17/11/2025 nhưng chưa từng mua 
Nước rửa chén (Mã nhóm 3041 ), Tẩy bếp (Mã nhóm 3118 ), Nước lau sàn (Mã nhóm 3116 ), 
Nước lau kính (Mã nhóm 3115 ), Tẩy vệ sinh (Mã nhóm 3120 ) 
;

SELECT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-17')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
HAVING SUM(CASE WHEN p.subgroupid IN (3041, 3115, 3116, 3118, 3119, 3120) THEN 1 ELSE 0 END) = 0
    
 ;
Từ 1/1/2024 có mua Gạo (mã nhóm 3054 Gạo, nếp các loại) nhưng tháng 8-9-10/2025 khách chưa mua lại
;
WITH mua_gao AS (
SELECT DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-17')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.subgroupid IN (3054)
),
co_mua_gao8910 AS (
SELECT DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-08-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-11-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.subgroupid IN (3054)
)
SELECT DISTINCT a.customer_id
FROM mua_gao a
LEFT JOIN co_mua_gao8910 b
ON a.customer_id = b.customer_id 
WHERE b.customer_id IS NULL 

; 

Từ 1/1/2024 có mua Gạo (mã nhóm 3054 Gạo, nếp các loại) nhưng tháng 8-9-10/2025 khách chưa mua lại
theo  list siêu thị
;
WITH mua_gao AS (
SELECT DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-17')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.subgroupid IN (3054)
),
co_mua_gao8910 AS (
SELECT DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-08-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-11-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.subgroupid IN (3054)
        AND a.storeid  IN (161, 191, 202, 1257, 1374, 1418, 1451, 1489, 1521, 1531, 1561, 1630, 1694, 1698, 1699, 1769, 1829, 1832, 1837, 1861, 1865, 1933, 1935, 1970, 1992, 2012, 2024, 2099, 2103, 2111, 2113, 2115, 2191, 2208, 2236, 2247, 2338, 2442, 2535, 2546, 2579, 2596, 2643, 2713, 2794, 2823, 2842, 2847, 2854, 2900, 2911, 3002, 3069, 3092, 3093, 3094, 3095, 3098, 3111, 3114, 3199, 3207, 3231, 3233, 3235, 3248, 3250, 3251, 3254, 3255, 3258, 3261, 3263, 3264, 3322, 3324, 3326, 3365, 3369, 3386, 3387, 3388, 3418, 3425, 3427, 3437, 3454, 3469, 3471, 3501, 3520, 3547, 3555, 3588, 3589, 3590, 3610, 3612, 3624, 3647, 3650, 3652, 3668, 3682, 3683, 3692, 3696, 3711, 3712, 3741, 3759, 3761, 3768, 3771, 3773, 3786, 3826, 3827, 3836, 3854, 3856, 3857, 3890, 3892, 3893, 3915, 3959, 3970, 3971, 3985, 3990, 3999, 4001, 4003, 4073, 4074, 4075, 4077, 4086, 4134, 4219, 4223, 4231, 4247, 4250, 4263, 4269, 4271, 4272, 4288, 4290, 4291, 4292, 4300, 4320, 4325, 4331, 4332, 4333, 4339, 4341, 4362, 4364, 4365, 4371, 4373, 4374, 4375, 4382, 4384, 4386, 4388, 4389, 4407, 4408, 4410, 4411, 4414, 4416, 4428, 4429, 4430, 4437, 4438, 4440, 4448, 4450, 4451, 4459, 4460, 4462, 4463, 4467, 4476, 4477, 4479, 4480, 4487, 4492, 4499, 4501, 4502, 4505, 4506, 4511, 4512, 4520, 4524, 4530, 4532, 4533, 4534, 4535, 4537, 4540, 4541, 4548, 4550, 4551, 4554, 4569, 4570, 4573, 4581, 4582, 4584, 4593, 4596, 4598, 4602, 4603, 4610, 4612, 4623, 4624, 4626, 4630, 4634, 4635, 4636, 4637, 4641, 4642, 4643, 4658, 4659, 4665, 4671, 4676, 4678, 4684, 4685, 4686, 4687, 4688, 4691, 4692, 4693, 4701, 4707, 4708, 4713, 4720, 4721, 4722, 4723, 4724, 4729, 4730, 4731, 4741, 4742, 4743, 4745, 4748, 4750, 4752, 4753, 4754, 4756, 4760, 4761, 4762, 4763, 4765, 4766, 4767, 4768, 4771, 4774, 4775, 4778, 4779, 4780, 4781, 4788, 4799, 4806, 4807, 4812, 4814, 4817, 4820, 4821, 4823, 4834, 4836, 4837, 4843, 4844, 4845, 4846, 4854, 4867, 4869, 4870, 4875, 4876, 4877, 4880, 4883, 4885, 4887, 4888, 4889, 4890, 4893, 4895, 4897, 4898, 4901, 4903, 4904, 4905, 4906, 4907, 4914, 4916, 4917, 4925, 4928, 4933, 4934, 4935, 4937, 4938, 4939, 4941, 4947, 4950, 4951, 4963, 4967, 4968, 4969, 4971, 4972, 4978, 4979, 4986, 4990, 4991, 4993, 4995, 4998, 5002, 5006, 5007, 5010, 5015, 5016, 5017, 5019, 5021, 5022, 5027, 5028, 5029, 5034, 5036, 5037, 5039, 5040, 5043, 5048, 5049, 5055, 5064, 5068, 5076, 5077, 5078, 5079, 5082, 5083, 5084, 5092, 5095, 5096, 5099, 5101, 5102, 5117, 5120, 5128, 5134, 5143, 5151, 5152, 5153, 5163, 5166, 5169, 5176, 5177, 5179, 5181, 5190, 5191, 5203, 5206, 5208, 5211, 5214, 5217, 5218, 5219, 5220, 5221, 5226, 5227, 5228, 5233, 5234, 5235, 5236, 5237, 5239, 5242, 5245, 5246, 5247, 5256, 5261, 5272, 5278, 5284, 5289, 5290, 5292, 5293, 5296, 5298, 5300, 5304, 5307, 5308, 5310, 5311, 5312, 5313, 5314, 5331, 5333, 5334, 5346, 5347, 5353, 5354, 5356, 5387, 5388, 5396, 5397, 5405, 5413, 5414, 5421, 5425, 5426, 5428, 5444, 5451, 5452, 5453, 5456, 5458, 5460, 5461, 5473, 5484, 5485, 5486, 5489, 5490, 5658, 5659, 5661, 5662, 5663, 5680, 5690, 5706, 5722, 5723, 5727, 5743, 5744, 5745, 5759, 5762, 5798, 5799, 5804, 5805, 5807, 5808, 5810, 5811, 5815, 5816, 5818, 5820, 5822, 5896, 5897, 5942, 5945, 5948, 5951, 5978, 5979, 5980, 6004, 6006, 6007, 6026, 6027, 6029, 6030, 6040, 6041, 6042, 6043, 6054, 6055, 6058, 6059, 6060, 6063, 6064, 6070, 6073, 6075, 6086, 6098, 6110, 6112, 6114, 6116, 6130, 6131, 6133, 6135, 6136, 6143, 6149, 6153, 6154, 6155, 6158, 6166, 6183, 6184, 6189, 6191, 6192, 6193, 6198, 6202, 6204, 6205, 6211, 6212, 6215, 6216, 6217, 6218, 6222, 6224, 6225, 6232, 6233, 6234, 6235, 6238, 6239, 6243, 6244, 6245, 6247, 6251, 6256, 6257, 6258, 6259, 6260, 6262, 6264, 6267, 6268, 6269, 6272, 6278, 6279, 6281, 6282, 6286, 6289, 6290, 6291, 6294, 6295, 6296, 6304, 6306, 6309, 6311, 6312, 6313, 6314, 6328, 6330, 6332, 6341, 6343, 6347, 6348, 6349, 6359, 6362, 6363, 6367, 6371, 6376, 6378, 6380, 6381, 6384, 6387, 6388, 6392, 6393, 6398, 6402, 6403, 6406, 6407, 6408, 6410, 6415, 6417, 6418, 6421, 6422, 6424, 6426, 6429, 6430, 6434, 6438, 6439, 6440, 6442, 6453, 6454, 6456, 6466, 6468, 6473, 6474, 6475, 6476, 6477, 6483, 6488, 6492, 6498, 6499, 6509, 6511, 6512, 6514, 6516, 6518, 6519, 6520, 6521, 6525, 6527, 6530, 6534, 6537, 6539, 6540, 6543, 6549, 6553, 6554, 6556, 6557, 6560, 6561, 6563, 6564, 6565, 6566, 6570, 6577, 6578, 6580, 6581, 6583, 6584, 6586, 6588, 6590, 6594, 6596, 6602, 6604, 6616, 6617, 6622, 6628, 6630, 6632, 6633, 6634, 6669, 6670, 6671, 6680, 6691, 6692, 6740, 6741, 6744, 6745, 6746, 6747, 6749, 6753, 6759, 6764, 6765, 6768, 6771, 6773, 6774, 6776, 6777, 6785, 6787, 6788, 6797, 6798, 6811, 6812, 6818, 6819, 6824, 6830, 6831, 6834, 6835, 6841, 6842, 6851, 6858, 6862, 6863, 6864, 6866, 6871, 6877, 6884, 6890, 6891, 6893, 6894, 6897, 6898, 6902, 6903, 6905, 6922, 6923, 6966, 6967, 6968, 6969, 6971, 6984, 6990, 6995, 6996, 7006, 7011, 7013, 7014, 7015, 7029, 7033, 7039, 7047, 7104, 7109, 7112, 7139, 7140, 7154, 7155, 7158, 7159, 7160, 7166, 7167, 7169, 7171, 7172, 7221, 7223, 7224, 7226, 7237, 7238, 7241, 7250, 7254, 7255, 7278, 7283, 7284, 7285, 7300, 7302, 7317, 7325, 7326, 7333, 7335, 7337, 7549, 7586, 7601, 7661, 7664, 7665, 7666, 7667, 7669, 7672, 7673, 7678, 7685, 7686, 7687, 7714, 7717, 7758, 7770, 7775, 7789, 7790, 7815, 7817, 7819, 7821, 7842, 7843, 7844, 7861, 7863, 7865, 7882, 7883, 7917, 7918, 7932, 7950, 7951, 7967, 7985, 7993, 7994, 8018, 8024, 8026, 8039, 8040, 8047, 8102, 8104, 8105, 8108, 8109, 8110, 8124, 8151, 8153, 8154, 8186, 8187, 8190, 8210, 8221, 8222, 8225, 8254, 8255, 8284, 8344, 8346, 8347, 8349, 8360, 8363, 8364, 8534, 8536, 8538, 8539, 8540, 8552, 8555, 8564, 8566, 8588, 8601, 8602, 8650, 8656, 8666, 8667, 8668, 8678, 8730, 8750, 8753, 8761, 8764, 8781, 8795, 8810, 8828, 8835, 8843, 8844, 8845, 8846, 8856, 8863, 8865, 8867, 8882, 8890, 8896, 8901, 8904, 8909, 8911, 8913, 8919, 8922, 8945, 8951, 8955, 9011, 9020, 9028, 9032, 9034, 9037, 9079, 9101, 9103, 9120, 9121, 9126, 9134, 9138, 9147, 9149, 9153, 9156, 9158, 9160, 9178, 9210, 9214, 9215, 9235, 9237, 9247, 9253, 9272, 9278, 9279, 9287, 9294, 9305, 9306, 9307, 9308, 9309, 9371, 9448, 9450, 9451, 9452, 9465, 9467, 9468, 9474, 9478, 9481, 9484, 9491, 9495, 9498, 9508, 9576, 9667, 9668, 9731, 9738, 9745, 9746, 9761, 9762, 9874, 9919, 9933, 9941, 9950, 9951, 9954, 9964, 9965, 9966, 9971, 9975, 9980, 9985, 9995, 10000, 10005, 10018, 10037, 10038, 10047, 10048, 10053, 10067, 10068, 10073, 10102, 10103, 10104, 10106, 10109, 10115, 10136, 10137, 10140, 10151, 10167, 10293, 10296, 10297, 10301, 10319, 10320, 10345, 10354, 10355, 10358, 10377, 10378, 10380, 10390, 10397, 10438, 10444, 10445, 10485, 10495, 10497, 10506, 10520, 12797, 12995, 13035, 13592, 13593, 13656, 13659, 13665, 13668, 13714, 13718, 13721, 13725, 13739, 13775, 13776, 13785, 13788, 13797, 13830, 13837, 13838, 13839, 13845, 13846, 13853, 13855, 13986, 13991, 14012, 14100, 14101, 14103, 14108, 14109, 14110, 14112, 14113, 14114, 14116, 14123, 14126, 14127, 14128, 14129, 14131, 14132, 14133, 14135, 14136, 14137, 14138, 14143, 14149, 14150, 14152, 14153, 14169, 14170, 14171, 14172, 14175, 14178, 14179, 14180, 14181, 14198, 14218, 14219, 14222, 14223, 14265, 14266, 14269, 14270, 14271, 14273, 14275, 14278, 14279, 14287, 14288, 14289, 14297, 14298, 14299, 14300, 14303, 14305, 14310, 14312, 14316, 14317, 14318, 14319, 14321, 14324, 14326, 14329, 14330, 14331, 14332, 14333, 14335, 14336, 14337, 14339, 14340, 14342, 14343, 14344, 14345, 14346, 14349, 14350, 14351, 14353, 14354, 14355, 14356, 14357, 14359, 14360, 14363, 14364, 14370, 14374, 14381, 14383, 14385, 14387, 14388, 14389, 14390, 14394, 14395, 14397, 14398, 14399, 14401, 14403, 14404, 14408, 14409, 14410, 14411, 14412, 14420, 14421, 14426, 14428, 14429, 14432, 14433, 14438, 14443, 14447, 14449, 14450, 14451, 14454, 14457, 14458, 14459, 14460, 14461, 14463, 14471, 14472, 14473, 14477, 14478, 14484, 14489, 14490, 14491, 14492, 14493, 14494, 14495, 14496, 14498, 14499, 14502, 14504, 14507, 14508, 14509, 14514, 14515, 14518, 14519, 14521, 14522, 14524, 14525, 14526, 14528, 14529, 14530, 14531, 14532, 14534, 14535, 14536, 14537, 14538, 14549, 14550, 14551, 14553, 14558, 14564, 14565, 14566, 14567, 14568, 14570, 14573, 14574, 14575, 14576, 14577, 14579, 14581, 14582, 14583, 14584, 14586, 14587, 14589, 14590, 14592, 14593, 14598, 14599, 14600, 14604, 14609, 14613, 14615, 14616, 14617, 14618, 14619, 14621, 14622, 14623, 14624, 14628, 14636, 14637, 14640, 14650, 14652, 14653, 14656, 14657, 14658, 14660, 14661, 14662, 14663, 14664, 14665, 14666, 14668, 14669, 14671, 14673, 14682, 14683, 14687, 14688, 14689, 14691, 14693, 14694, 14695, 14698, 14700, 14701, 14703, 14704, 14717, 14718, 14720, 14723, 14724, 14725, 14726, 14727, 14733, 14734, 14736, 14737, 14748, 14749, 14754, 14756, 14757, 14758, 14759, 14764, 14765, 14767, 14768, 14769, 14770, 14771, 14773, 14774, 14775, 14778, 14779, 14780, 14782, 14784, 14785, 14786, 14787, 14788, 14789, 14792, 14793, 14794, 14795, 14799, 14801, 14802, 14804, 14806, 14807, 14808, 14814, 14817, 14818, 14820, 14821, 14822, 14823, 14824, 14831, 14832, 14833, 14834, 14836, 14837, 14839, 14841, 14848, 14850, 14851, 14925, 14926, 14927, 14929, 14930, 14935, 14936, 14937, 14939, 14940, 14942, 14943, 14944, 14945, 14946, 14947, 14948, 14949, 14950, 14952, 14953, 14959, 14961, 14962, 14963, 14964, 14965, 14966, 14967, 14968, 14969, 14970, 14971, 14972, 14977, 14978, 14979, 14980, 14982, 14984, 14985, 14986, 14987, 14989, 14992, 14993, 14994, 14996, 14997, 14999, 15000, 15004, 15006, 15009, 15010, 15013, 15014, 15021, 15022, 15023, 15024, 15025, 15026, 15029, 15033, 15035, 15037, 15038, 15041, 15042, 15043, 15052, 15055, 15057, 15083, 15084, 15094, 15104, 15107, 15110, 15111, 15115, 15116, 15121, 15439, 15446, 15447, 15457, 15510, 15516, 15519, 15523, 15878, 16861, 17864, 27902)
)
SELECT DISTINCT a.customer_id
FROM mua_gao a
LEFT JOIN co_mua_gao8910 b
ON a.customer_id = b.customer_id 
WHERE b.customer_id IS NULL 




;
WITH mua_gao AS (
SELECT DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-17')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.subgroupid IN (3054)
),
ko_mua_gao8910 AS (
SELECT DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-08-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-11-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
HAVING SUM(CASE WHEN (p.subgroupid IN (3054) 
				AND a.storeid  IN (161, 191, 202, 1257, 1374, 1418, 1451, 1489, 1521, 1531, 1561, 1630, 1694, 1698, 1699, 1769, 1829, 1832, 1837, 1861, 1865, 1933, 1935, 1970, 1992, 2012, 2024, 2099, 2103, 2111, 2113, 2115, 2191, 2208, 2236, 2247, 2338, 2442, 2535, 2546, 2579, 2596, 2643, 2713, 2794, 2823, 2842, 2847, 2854, 2900, 2911, 3002, 3069, 3092, 3093, 3094, 3095, 3098, 3111, 3114, 3199, 3207, 3231, 3233, 3235, 3248, 3250, 3251, 3254, 3255, 3258, 3261, 3263, 3264, 3322, 3324, 3326, 3365, 3369, 3386, 3387, 3388, 3418, 3425, 3427, 3437, 3454, 3469, 3471, 3501, 3520, 3547, 3555, 3588, 3589, 3590, 3610, 3612, 3624, 3647, 3650, 3652, 3668, 3682, 3683, 3692, 3696, 3711, 3712, 3741, 3759, 3761, 3768, 3771, 3773, 3786, 3826, 3827, 3836, 3854, 3856, 3857, 3890, 3892, 3893, 3915, 3959, 3970, 3971, 3985, 3990, 3999, 4001, 4003, 4073, 4074, 4075, 4077, 4086, 4134, 4219, 4223, 4231, 4247, 4250, 4263, 4269, 4271, 4272, 4288, 4290, 4291, 4292, 4300, 4320, 4325, 4331, 4332, 4333, 4339, 4341, 4362, 4364, 4365, 4371, 4373, 4374, 4375, 4382, 4384, 4386, 4388, 4389, 4407, 4408, 4410, 4411, 4414, 4416, 4428, 4429, 4430, 4437, 4438, 4440, 4448, 4450, 4451, 4459, 4460, 4462, 4463, 4467, 4476, 4477, 4479, 4480, 4487, 4492, 4499, 4501, 4502, 4505, 4506, 4511, 4512, 4520, 4524, 4530, 4532, 4533, 4534, 4535, 4537, 4540, 4541, 4548, 4550, 4551, 4554, 4569, 4570, 4573, 4581, 4582, 4584, 4593, 4596, 4598, 4602, 4603, 4610, 4612, 4623, 4624, 4626, 4630, 4634, 4635, 4636, 4637, 4641, 4642, 4643, 4658, 4659, 4665, 4671, 4676, 4678, 4684, 4685, 4686, 4687, 4688, 4691, 4692, 4693, 4701, 4707, 4708, 4713, 4720, 4721, 4722, 4723, 4724, 4729, 4730, 4731, 4741, 4742, 4743, 4745, 4748, 4750, 4752, 4753, 4754, 4756, 4760, 4761, 4762, 4763, 4765, 4766, 4767, 4768, 4771, 4774, 4775, 4778, 4779, 4780, 4781, 4788, 4799, 4806, 4807, 4812, 4814, 4817, 4820, 4821, 4823, 4834, 4836, 4837, 4843, 4844, 4845, 4846, 4854, 4867, 4869, 4870, 4875, 4876, 4877, 4880, 4883, 4885, 4887, 4888, 4889, 4890, 4893, 4895, 4897, 4898, 4901, 4903, 4904, 4905, 4906, 4907, 4914, 4916, 4917, 4925, 4928, 4933, 4934, 4935, 4937, 4938, 4939, 4941, 4947, 4950, 4951, 4963, 4967, 4968, 4969, 4971, 4972, 4978, 4979, 4986, 4990, 4991, 4993, 4995, 4998, 5002, 5006, 5007, 5010, 5015, 5016, 5017, 5019, 5021, 5022, 5027, 5028, 5029, 5034, 5036, 5037, 5039, 5040, 5043, 5048, 5049, 5055, 5064, 5068, 5076, 5077, 5078, 5079, 5082, 5083, 5084, 5092, 5095, 5096, 5099, 5101, 5102, 5117, 5120, 5128, 5134, 5143, 5151, 5152, 5153, 5163, 5166, 5169, 5176, 5177, 5179, 5181, 5190, 5191, 5203, 5206, 5208, 5211, 5214, 5217, 5218, 5219, 5220, 5221, 5226, 5227, 5228, 5233, 5234, 5235, 5236, 5237, 5239, 5242, 5245, 5246, 5247, 5256, 5261, 5272, 5278, 5284, 5289, 5290, 5292, 5293, 5296, 5298, 5300, 5304, 5307, 5308, 5310, 5311, 5312, 5313, 5314, 5331, 5333, 5334, 5346, 5347, 5353, 5354, 5356, 5387, 5388, 5396, 5397, 5405, 5413, 5414, 5421, 5425, 5426, 5428, 5444, 5451, 5452, 5453, 5456, 5458, 5460, 5461, 5473, 5484, 5485, 5486, 5489, 5490, 5658, 5659, 5661, 5662, 5663, 5680, 5690, 5706, 5722, 5723, 5727, 5743, 5744, 5745, 5759, 5762, 5798, 5799, 5804, 5805, 5807, 5808, 5810, 5811, 5815, 5816, 5818, 5820, 5822, 5896, 5897, 5942, 5945, 5948, 5951, 5978, 5979, 5980, 6004, 6006, 6007, 6026, 6027, 6029, 6030, 6040, 6041, 6042, 6043, 6054, 6055, 6058, 6059, 6060, 6063, 6064, 6070, 6073, 6075, 6086, 6098, 6110, 6112, 6114, 6116, 6130, 6131, 6133, 6135, 6136, 6143, 6149, 6153, 6154, 6155, 6158, 6166, 6183, 6184, 6189, 6191, 6192, 6193, 6198, 6202, 6204, 6205, 6211, 6212, 6215, 6216, 6217, 6218, 6222, 6224, 6225, 6232, 6233, 6234, 6235, 6238, 6239, 6243, 6244, 6245, 6247, 6251, 6256, 6257, 6258, 6259, 6260, 6262, 6264, 6267, 6268, 6269, 6272, 6278, 6279, 6281, 6282, 6286, 6289, 6290, 6291, 6294, 6295, 6296, 6304, 6306, 6309, 6311, 6312, 6313, 6314, 6328, 6330, 6332, 6341, 6343, 6347, 6348, 6349, 6359, 6362, 6363, 6367, 6371, 6376, 6378, 6380, 6381, 6384, 6387, 6388, 6392, 6393, 6398, 6402, 6403, 6406, 6407, 6408, 6410, 6415, 6417, 6418, 6421, 6422, 6424, 6426, 6429, 6430, 6434, 6438, 6439, 6440, 6442, 6453, 6454, 6456, 6466, 6468, 6473, 6474, 6475, 6476, 6477, 6483, 6488, 6492, 6498, 6499, 6509, 6511, 6512, 6514, 6516, 6518, 6519, 6520, 6521, 6525, 6527, 6530, 6534, 6537, 6539, 6540, 6543, 6549, 6553, 6554, 6556, 6557, 6560, 6561, 6563, 6564, 6565, 6566, 6570, 6577, 6578, 6580, 6581, 6583, 6584, 6586, 6588, 6590, 6594, 6596, 6602, 6604, 6616, 6617, 6622, 6628, 6630, 6632, 6633, 6634, 6669, 6670, 6671, 6680, 6691, 6692, 6740, 6741, 6744, 6745, 6746, 6747, 6749, 6753, 6759, 6764, 6765, 6768, 6771, 6773, 6774, 6776, 6777, 6785, 6787, 6788, 6797, 6798, 6811, 6812, 6818, 6819, 6824, 6830, 6831, 6834, 6835, 6841, 6842, 6851, 6858, 6862, 6863, 6864, 6866, 6871, 6877, 6884, 6890, 6891, 6893, 6894, 6897, 6898, 6902, 6903, 6905, 6922, 6923, 6966, 6967, 6968, 6969, 6971, 6984, 6990, 6995, 6996, 7006, 7011, 7013, 7014, 7015, 7029, 7033, 7039, 7047, 7104, 7109, 7112, 7139, 7140, 7154, 7155, 7158, 7159, 7160, 7166, 7167, 7169, 7171, 7172, 7221, 7223, 7224, 7226, 7237, 7238, 7241, 7250, 7254, 7255, 7278, 7283, 7284, 7285, 7300, 7302, 7317, 7325, 7326, 7333, 7335, 7337, 7549, 7586, 7601, 7661, 7664, 7665, 7666, 7667, 7669, 7672, 7673, 7678, 7685, 7686, 7687, 7714, 7717, 7758, 7770, 7775, 7789, 7790, 7815, 7817, 7819, 7821, 7842, 7843, 7844, 7861, 7863, 7865, 7882, 7883, 7917, 7918, 7932, 7950, 7951, 7967, 7985, 7993, 7994, 8018, 8024, 8026, 8039, 8040, 8047, 8102, 8104, 8105, 8108, 8109, 8110, 8124, 8151, 8153, 8154, 8186, 8187, 8190, 8210, 8221, 8222, 8225, 8254, 8255, 8284, 8344, 8346, 8347, 8349, 8360, 8363, 8364, 8534, 8536, 8538, 8539, 8540, 8552, 8555, 8564, 8566, 8588, 8601, 8602, 8650, 8656, 8666, 8667, 8668, 8678, 8730, 8750, 8753, 8761, 8764, 8781, 8795, 8810, 8828, 8835, 8843, 8844, 8845, 8846, 8856, 8863, 8865, 8867, 8882, 8890, 8896, 8901, 8904, 8909, 8911, 8913, 8919, 8922, 8945, 8951, 8955, 9011, 9020, 9028, 9032, 9034, 9037, 9079, 9101, 9103, 9120, 9121, 9126, 9134, 9138, 9147, 9149, 9153, 9156, 9158, 9160, 9178, 9210, 9214, 9215, 9235, 9237, 9247, 9253, 9272, 9278, 9279, 9287, 9294, 9305, 9306, 9307, 9308, 9309, 9371, 9448, 9450, 9451, 9452, 9465, 9467, 9468, 9474, 9478, 9481, 9484, 9491, 9495, 9498, 9508, 9576, 9667, 9668, 9731, 9738, 9745, 9746, 9761, 9762, 9874, 9919, 9933, 9941, 9950, 9951, 9954, 9964, 9965, 9966, 9971, 9975, 9980, 9985, 9995, 10000, 10005, 10018, 10037, 10038, 10047, 10048, 10053, 10067, 10068, 10073, 10102, 10103, 10104, 10106, 10109, 10115, 10136, 10137, 10140, 10151, 10167, 10293, 10296, 10297, 10301, 10319, 10320, 10345, 10354, 10355, 10358, 10377, 10378, 10380, 10390, 10397, 10438, 10444, 10445, 10485, 10495, 10497, 10506, 10520, 12797, 12995, 13035, 13592, 13593, 13656, 13659, 13665, 13668, 13714, 13718, 13721, 13725, 13739, 13775, 13776, 13785, 13788, 13797, 13830, 13837, 13838, 13839, 13845, 13846, 13853, 13855, 13986, 13991, 14012, 14100, 14101, 14103, 14108, 14109, 14110, 14112, 14113, 14114, 14116, 14123, 14126, 14127, 14128, 14129, 14131, 14132, 14133, 14135, 14136, 14137, 14138, 14143, 14149, 14150, 14152, 14153, 14169, 14170, 14171, 14172, 14175, 14178, 14179, 14180, 14181, 14198, 14218, 14219, 14222, 14223, 14265, 14266, 14269, 14270, 14271, 14273, 14275, 14278, 14279, 14287, 14288, 14289, 14297, 14298, 14299, 14300, 14303, 14305, 14310, 14312, 14316, 14317, 14318, 14319, 14321, 14324, 14326, 14329, 14330, 14331, 14332, 14333, 14335, 14336, 14337, 14339, 14340, 14342, 14343, 14344, 14345, 14346, 14349, 14350, 14351, 14353, 14354, 14355, 14356, 14357, 14359, 14360, 14363, 14364, 14370, 14374, 14381, 14383, 14385, 14387, 14388, 14389, 14390, 14394, 14395, 14397, 14398, 14399, 14401, 14403, 14404, 14408, 14409, 14410, 14411, 14412, 14420, 14421, 14426, 14428, 14429, 14432, 14433, 14438, 14443, 14447, 14449, 14450, 14451, 14454, 14457, 14458, 14459, 14460, 14461, 14463, 14471, 14472, 14473, 14477, 14478, 14484, 14489, 14490, 14491, 14492, 14493, 14494, 14495, 14496, 14498, 14499, 14502, 14504, 14507, 14508, 14509, 14514, 14515, 14518, 14519, 14521, 14522, 14524, 14525, 14526, 14528, 14529, 14530, 14531, 14532, 14534, 14535, 14536, 14537, 14538, 14549, 14550, 14551, 14553, 14558, 14564, 14565, 14566, 14567, 14568, 14570, 14573, 14574, 14575, 14576, 14577, 14579, 14581, 14582, 14583, 14584, 14586, 14587, 14589, 14590, 14592, 14593, 14598, 14599, 14600, 14604, 14609, 14613, 14615, 14616, 14617, 14618, 14619, 14621, 14622, 14623, 14624, 14628, 14636, 14637, 14640, 14650, 14652, 14653, 14656, 14657, 14658, 14660, 14661, 14662, 14663, 14664, 14665, 14666, 14668, 14669, 14671, 14673, 14682, 14683, 14687, 14688, 14689, 14691, 14693, 14694, 14695, 14698, 14700, 14701, 14703, 14704, 14717, 14718, 14720, 14723, 14724, 14725, 14726, 14727, 14733, 14734, 14736, 14737, 14748, 14749, 14754, 14756, 14757, 14758, 14759, 14764, 14765, 14767, 14768, 14769, 14770, 14771, 14773, 14774, 14775, 14778, 14779, 14780, 14782, 14784, 14785, 14786, 14787, 14788, 14789, 14792, 14793, 14794, 14795, 14799, 14801, 14802, 14804, 14806, 14807, 14808, 14814, 14817, 14818, 14820, 14821, 14822, 14823, 14824, 14831, 14832, 14833, 14834, 14836, 14837, 14839, 14841, 14848, 14850, 14851, 14925, 14926, 14927, 14929, 14930, 14935, 14936, 14937, 14939, 14940, 14942, 14943, 14944, 14945, 14946, 14947, 14948, 14949, 14950, 14952, 14953, 14959, 14961, 14962, 14963, 14964, 14965, 14966, 14967, 14968, 14969, 14970, 14971, 14972, 14977, 14978, 14979, 14980, 14982, 14984, 14985, 14986, 14987, 14989, 14992, 14993, 14994, 14996, 14997, 14999, 15000, 15004, 15006, 15009, 15010, 15013, 15014, 15021, 15022, 15023, 15024, 15025, 15026, 15029, 15033, 15035, 15037, 15038, 15041, 15042, 15043, 15052, 15055, 15057, 15083, 15084, 15094, 15104, 15107, 15110, 15111, 15115, 15116, 15121, 15439, 15446, 15447, 15457, 15510, 15516, 15519, 15523, 15878, 16861, 17864, 27902)
				)THEN 1 ELSE 0 END) = 0
        )
SELECT DISTINCT a.customer_id
FROM mua_gao a
JOIN ko_mua_gao8910 b
ON a.customer_id = b.customer_id 

Từ 1/1/2024 có mua Gạo (mã nhóm 3054 Gạo, nếp các loại) nhưng tháng 8-9-10/2025 khách chưa mua lại
;
WITH mua_gao AS (
SELECT DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-11-17')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.subgroupid IN (3054)
),
co_mua_gao8910 AS (
SELECT DISTINCT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-08-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-11-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
HAVING SUM(CASE WHEN (p.subgroupid IN (3054)
				)THEN 1 ELSE 0 END) = 0
        )
SELECT DISTINCT a.customer_id
FROM mua_gao a
JOIN co_mua_gao8910 b
ON a.customer_id = b.customer_id 



;
-- Nhóm KH chưa từng mua nhóm Xúc Xích, Lạp Xưởng, Giò Chả Các Loại  24/07/2025 - 24/11/2025

WITH base as(
SELECT DISTINCT a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-07-24')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-11-25')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
HAVING SUM(CASE WHEN p.subgroupid IN (3930) 
				THEN 1 ELSE 0 END) = 0
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM base t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id


;
--- 1/1/2024 có mua hàng tại BHX on /off line nhưng không mua nước suối (mã nhóm: 3025) 

WITH mua_hang AS (
SELECT a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-12-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
),
ko_mua_suoi3025 AS (
SELECT  a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <=  DATE('2025-12-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.subgroupid IN (3025) 
				THEN 1 ELSE 0 END) = 0
)
SELECT DISTINCT a.customer_id,
a.is_online 
FROM mua_hang a
JOIN ko_mua_suoi3025 b
ON a.customer_id = b.customer_id 



--Chưa từng mua nước xả vải (1/9 -> 30/11 có mua hàng BHX, nhưng chưa mua NXV)
WITH ko_mua_xa2835 AS (
SELECT  a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.subgroupid IN (2835) 
				THEN 1 ELSE 0 END) = 0
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM ko_mua_xa2835 t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id


-- Chưa mua lại NXV trong 3 tháng gần nhất (1/1/2025 -> 31/8/2025: có mua nxv, nhưng 1/9 -> 30/11 chưa mua lại)

WITH mua_xa AS (
SELECT a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-09-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.subgroupid IN (2835)
GROUP BY a.crmcustomerid 
),
ko_mua_xa AS (
SELECT  a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.subgroupid IN (2835) 
				THEN 1 ELSE 0 END) = 0
),
tmp AS (
SELECT DISTINCT a.customer_id,
a.is_online 
FROM mua_xa a
JOIN ko_mua_xa b
ON a.customer_id = b.customer_id
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;


--1) KH  chưa từng mua dao cạo từ 1/1 - 30/11
WITH tmp AS (
SELECT a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.subgroupid IN (3163) 
				THEN 1 ELSE 0 END) = 0
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;
--2) KH  chưa từng mua kem đánh răng từ 1/1 - 30/11
WITH tmp AS (
SELECT a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.subgroupid IN (2712) 
				THEN 1 ELSE 0 END) = 0
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id

    
    
--3) khách chưa từng mua nước giặt 1/1 - 30/11
WITH tmp AS (
SELECT a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-01')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.subgroupid IN (3163) 
				THEN 1 ELSE 0 END) = 0
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id
;
----- check ---------
SELECT 
    DISTINCT a.crmcustomerid AS customer_id,
    p.subgroupid 
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
CAST(a.crmcustomerid  AS VARCHAR) = '1090499359'
-- and p.subgroupid in (3025) 
 and FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
 
 ----

-- danh sách KH có mua BHX cả online và Offline từ thời gian 10/09/2025 -  10/12/2025
Có mua các ngành hàng sau:
- Kem các loại (Mã ngành 1355)
- Thực phẩm đông lạnh - Hàng mát các loại (Mã ngành hàng 990)
- Sản Phẩm Từ Sữa - Bảo Quản Mát (mã ngành hàng 1354)
;

SELECT a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-10')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-11')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.maingroupid IN (1355, 990, 1354)
GROUP BY a.crmcustomerid 
;

WITH mua_xa AS (
SELECT a.crmcustomerid AS customer_id
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN
        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
            ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-09')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
        AND p.maingroupid IN (1254, 1234, 1235, 1236, 993)
GROUP BY a.crmcustomerid 
),
ko_mua_xa AS (
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
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-09')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.maingroupid IN (1056) 
				THEN 1 ELSE 0 END) = 0
)
SELECT DISTINCT a.customer_id
FROM mua_xa a
JOIN ko_mua_xa b
ON a.customer_id = b.customer_id
;


--WITH mua_xa AS (
--SELECT a.crmcustomerid AS customer_id
--FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
--    JOIN
--        "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
--            ON a.outputvoucherid = b.outputvoucherid
--    JOIN
--        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
--            ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
--WHERE 
--        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-01-01')
--        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-09')
--        AND b.outputtypeid IN (1903, 3)
--        AND a.crmcustomerid > 5
--        AND p.maingroupid IN (1255)
--GROUP BY a.crmcustomerid 
--),
--ko_mua_xa AS (
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
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-12-16')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.subgroupid IN (3163) 
				THEN 1 ELSE 0 END) = 0 -- 3,109,077
--)
--SELECT DISTINCT a.customer_id
--FROM mua_xa a
--JOIN ko_mua_xa b
--ON a.customer_id = b.customer_id

-- Chưa từng mua sản phẩm Ariel (1/9 -> 30/11 có mua hàng BHX, nhưng chưa mua sản phẩm Ariel) 01/09/2025 - 30/11/2025

WITH tmp AS (
SELECT DISTINCT  a.crmcustomerid AS customer_id,
CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1
	ELSE 0
END AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE 
        FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
        AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) <  DATE('2025-11-30')
        AND b.outputtypeid IN (1903, 3)
        AND a.crmcustomerid > 5
GROUP BY a.crmcustomerid 
        HAVING SUM(CASE WHEN p.brandid IN (6373) 
				THEN 1 ELSE 0 END) = 0
)
SELECT 
    t.customer_id,
    t.is_online,
    COALESCE(app.co_caidatapp, '0') AS co_caidatapp
FROM tmp t
LEFT JOIN "pinot"."default".rcm_khachhang_coappbhx app 
    ON CAST(t.customer_id AS VARCHAR) = app.customer_id

;
Ngành hàng: 1054 
Timeline: 3 tháng gần nhất (T10,T11,T12.2025)
Kênh : online + offline
 ;

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
  FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-10-01')
  AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2026-01-01')
  AND b.outputtypeid IN (1903, 3)
  AND a.crmcustomerid > 5
  AND p.maingroupid IN (1054)
 GROUP BY a.crmcustomerid

;

--- có mua BHX (on và offline) từ 1/1/2024 nhưng từ 1/1/2026-31/01/2026 chưa mua Brand:  7973 - Unilever
--- 2. Có mua BHX (on và offline) từ 1/1/2024 nhưng từ 31/01/2026-02/02/2026 chưa mua Ngành 1236 - Thịt gia súc gia cầm các loại
--- 3. Có mua BHX (on và offline) từ 01/01/2026-31/01/2026 nhưng từ 31/01/2026-02/02/2026 chưa mua ngành hàng 1235 - Trái cây các loại từ
WITH online_flag AS (
    SELECT
        a1.crmcustomerid,
        CASE 
            WHEN MAX(CASE WHEN b1.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
                THEN 1
            ELSE 0
        END AS is_online
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a1
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b1
        ON a1.outputvoucherid = b1.outputvoucherid
    WHERE
        b1.outputtypeid IN (3, 1903)
        AND DATE(from_unixtime(a1.outputdate / 1000 - 25200))
    		BETWEEN DATE '2026-01-01' AND DATE '2026-01-31'
    GROUP BY a1.crmcustomerid
 )
SELECT DISTINCT
    a.crmcustomerid AS customerid,
    COALESCE(f.is_online, 0) AS is_online
FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
LEFT JOIN online_flag f
    ON a.crmcustomerid = f.crmcustomerid
WHERE 
    a.crmcustomerid > 5
    -- PHASE 1: từng mua
    AND EXISTS (
        SELECT DISTINCT a1.crmcustomerid 
        FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a1
        JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b1
            ON a1.outputvoucherid = b1.outputvoucherid
        JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p1
            ON b1.productid = p1.productid
        WHERE 
            a1.crmcustomerid = a.crmcustomerid
--            a1.crmcustomerid > 5 
            AND b1.outputtypeid IN (3, 1903)
--            AND p1.maingroupid = 1235
            AND DATE(from_unixtime(a1.outputdate / 1000 - 25200))
    			BETWEEN DATE '2026-01-01' AND DATE '2026-01-31'
    )
    -- PHASE 2: chưa mua lại
    AND NOT EXISTS (
        SELECT DISTINCT a2.crmcustomerid
        FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a2
        JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b2
            ON a2.outputvoucherid = b2.outputvoucherid
        JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p2
            ON b2.productid = p2.productid
        JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_brand brand 
      ON p2.brandid = brand.brandid  
        WHERE 
            a2.crmcustomerid = a.crmcustomerid
--             a2.crmcustomerid >5 
            AND b2.outputtypeid IN (3, 1903)
            AND p2.maingroupid  IN (1235) 
            AND DATE(from_unixtime(a2.outputdate / 1000 - 25200))
                BETWEEN DATE '2026-01-31' AND DATE '2026-02-02'
    )























