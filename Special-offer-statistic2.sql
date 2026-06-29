with 
tmp1 as (
SELECT
    distinct p.subgroupid,
    a.outputvoucherid 
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-08-30')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-09-08')
    AND b.outputtypeid IN (3, 1903)
    AND a.crmcustomerid > 5
    and p.subgroupid in (3020, 3047, 3044, 2980, 3023, 2855, 2844, 2848, 2850, 3901, 3084, 2856, 2841, 3083, 3141, 3102, 3942, 3819, 2854, 2852, 3090, 3934, 3929, 3109, 3142, 3025, 3082, 2712, 3058, 3089, 3927, 3106, 4279, 2551, 3087, 3137, 3110, 3932, 3138, 3900, 3197, 3080, 4259, 5549, 3100, 3086, 3931, 4261, 2849, 3139)
--    and a.storeid in (116, 1559, 1698, 1933, 1885, 1972, 1975, 2023, 2111, 2229, 2214, 2379, 2792, 2714, 2854, 3098, 3251, 3326, 3233, 3471, 3502, 3388, 3387, 3612, 3590, 3624, 3092, 3761, 3836, 3892, 3771, 3969, 3555, 4075, 3696, 4477, 4970, 4880, 5056, 4745, 4906, 5073, 5388, 5485, 5757, 5229, 5484, 5065, 6008, 6290, 6155, 6306, 6588, 6628, 5455, 6420, 4407, 6526, 6989, 6968, 6873, 7241, 7335, 7601, 7747, 7670, 7758, 7985, 8223, 8152, 8875, 8863, 9208, 9028, 8904, 9079, 9253, 10299, 10151, 8795, 10068, 27921, 27902, 13739, 13659, 13785, 13839, 14112, 14275, 14396, 14565, 14477, 14650, 14623, 14765, 14830, 15031, 14736, 14740, 3094, 3114, 3786, 4478, 4893, 4616, 7841, 8105, 6970, 9998, 3322, 3427, 3647, 3743, 3652, 4448, 4899, 5258, 6138, 10051, 9125, 13018, 13608, 14128, 15521, 3207, 3394, 3645, 3713, 4675, 4845, 7882, 7951, 7821, 8656, 13665, 13984, 3393, 3854, 5726, 6004, 7326, 6245, 9141, 10357, 10358, 8866, 13741, 13799, 14265, 15565, 15615, 3399, 3440, 3520, 3972, 4637, 6984, 8024, 9075, 9248, 9432, 9281, 9986, 13627, 14375, 14556, 14695, 14850, 3271, 3355, 3231, 4547, 4992, 6022, 8678, 8727, 9509, 10168, 9508, 15029, 15458, 3673, 3828, 4406, 4603, 4844, 4898, 5725, 6117, 6475, 6834, 7032, 8776, 10115, 13593, 2109, 2093, 2217, 2208, 2191, 2308, 2182, 2333, 2271, 2401, 2265, 2453, 2477, 2423, 2452, 2470, 2405, 2436, 2579, 2643, 2425, 2546, 2422, 2713, 2736, 2798, 2725, 2847, 2717, 2882, 2535, 3111, 2823, 2715, 3043, 2786, 3105, 3262, 3263, 3215, 3320, 3390, 3376, 3501, 3235, 3365, 3324, 3264, 3768, 3802, 3610, 3825, 3989, 4074, 4476, 4585, 4822, 4546, 4548, 4746, 4883, 4583, 4593, 5046, 4892, 2338, 5344, 5179, 5451, 5426, 6187, 6421, 6029, 6065, 6541, 6695, 6586, 6422, 5076, 7013, 7169, 7300, 7301, 7672, 7993, 8191, 8588, 8190, 8558, 8919, 9191, 8920, 9484, 9939, 9416, 9984, 9491, 10377, 10066, 9214, 12995, 13797, 13618, 13845, 14555, 14598, 14599, 14621, 14671, 14786, 14735, 14752, 14956, 14957, 14930, 14844, 15106, 14567, 14848, 2911, 3002, 3093, 3095, 3261, 3248, 3254, 3255, 3250, 3432, 3342, 3391, 3386, 3425, 3257, 3437, 3469, 3589, 3692, 3454, 3751, 3827, 3600, 3588, 3712, 3890, 3668, 3970, 3750, 4134, 3853, 3773, 4288, 4244, 3826, 4550, 4361, 4520, 4701, 4823, 4834, 4817, 4997, 4946, 5007, 5095, 5074, 5273, 4937, 5453, 5454, 5776, 6020, 5979, 5980, 5803, 6189, 6188, 6184, 6581, 6154, 6278, 6064, 6747, 6582, 6402, 7031, 7325, 7029, 7600, 7687, 7688, 6183, 7883, 8254, 8341, 7277, 8284, 9294, 9272, 8865, 9295, 9933, 9138, 9964, 9271, 9458, 10102, 10109, 10397, 16861, 17864, 13035, 13592, 13656, 13668, 13645, 13616, 13733, 13743, 13714, 14135, 13853, 14136, 14381, 14390, 14570, 14517, 14666, 14463, 14634, 14720, 14761, 14815, 14748, 202, 161, 191, 1157, 1257, 1374, 1418, 1451, 1489, 1521, 1531, 1532, 1561, 1630, 1633, 1610, 1694, 1642, 1699, 1769, 1837, 1829, 1832, 1864, 1865, 1935, 1942, 1969, 2012, 1970, 1992, 2024, 1696, 2046, 2099, 2130, 2108, 2144, 2004, 2103, 2143, 2272, 2247, 2236, 2251, 1861, 2403, 2442, 2337, 2192, 2113, 2596, 2115, 2835, 2858, 2842, 3069, 2794, 3112, 3199, 3070, 3238, 3258, 3370, 3371, 3400, 2808, 3237, 3369, 2900, 3418, 3447, 3547, 3669, 3646, 3759, 3711, 3852, 3818, 4220, 4345, 3999, 4677, 4405, 4594, 5004, 5260, 5458, 5488, 5953, 5804, 6272, 6725, 6403, 6370, 6743, 6851, 6835, 6991, 7167, 7279, 7278, 7790, 7770, 7673, 7950, 7588, 8602, 8576, 8730, 8535, 8896, 8927, 7549, 8917, 8910, 9190, 9226, 9279, 9287, 9155, 8350, 7746, 9449, 9490, 10186, 10136, 10137, 9450, 10125, 10081, 9215, 10110, 9378, 10345, 12943, 15878, 27905, 27917, 13613, 14428, 14419, 14608, 14727, 14362, 14846, 14756, 15111, 3650, 3616, 3741, 3683, 3615, 3837, 3667, 3682, 3774, 3807, 3871, 3829, 3959, 3985, 3893, 3983, 3874, 3971, 4003, 3990, 4245, 4369, 4370, 4408, 4504, 4461, 4512, 4410, 4581, 4598, 4077, 4748, 4533, 4611, 4947, 4730, 4833, 4584, 4870, 4812, 4928, 4887, 4713, 4219, 4902, 4935, 4953, 4963, 5219, 5105, 4955, 5204, 5117, 5180, 5034, 4624, 5290, 5064, 5154, 4869, 5487, 5271, 4888, 5313, 5119, 5807, 5450, 5274, 4634, 5951, 5300, 5336, 4749, 6070, 6071, 5182, 5727, 6072, 6027, 6393, 6398, 6031, 6226, 6603, 6520, 6573, 6474, 6745, 6225, 6746, 6579, 6744, 5029, 6905, 7302, 7159, 6283, 6884, 7014, 6307, 7918, 8798, 6442, 8667, 8347, 8916, 9121, 8845, 8764, 9481, 9251, 9667, 9521, 9374, 9388, 9032, 9383, 9983, 9952, 10067, 9262, 9951, 10005, 8346, 10167, 6857, 13718, 13855, 13991, 14300, 14484, 14604, 14607, 14552, 14443, 14800, 4537, 4652, 4691, 4788, 4871, 4901, 4967, 5043, 4903, 5242, 5099, 5003, 4993, 5181, 5101, 5176, 5444, 5169, 4995, 5415, 5744, 6086, 6328, 6295, 6296, 6616, 6633, 6632, 6797, 6966, 6858, 6768, 6923, 6866, 7047, 7111, 7815, 7932, 8349, 8650, 8750, 8867, 8364, 9210, 9460, 10140, 10301, 10378, 14833, 14822, 15094, 15510, 15583)
--GROUP BY
),
tmp2 as
(
SELECT
    a.outputvoucherid,
    Round(SUM(ROUND(b.saleprice * (1 + (CAST(b.vat AS DOUBLE) / 100)), 0) * b.quantity),0) AS revenue,
    p.maingroupid 
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-08-30')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-09-08')
    AND b.outputtypeid IN (3, 1903)
--    AND a.crmcustomerid > 5
--    and p.maingroupid in (1255)
group by a.outputvoucherid
),
tmp3 as (
select tmp2.outputvoucherid,
    revenue
from tmp2
)
select 
tmp1.subgroupid,
sum (tmp2.revenue) as revenue,
count(tmp1.outputvoucherid) as bill_count
from tmp1 join tmp2 
on tmp1.outputvoucherid = tmp2.outputvoucherid
group by tmp1.subgroupid

;
-- OV104693509135562 126000.0
--OV206536509132496	60000.0
--OV106990508074633	60000.0
--OV106347509266647	180000.0
with 
billbia as
(
SELECT
    a.outputvoucherid
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-05-01')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-08-20')
    AND b.outputtypeid IN (3, 1903)
    and p.maingroupid in (1255)
),
tmp_revenue as
(
SELECT
    a.outputvoucherid,
    Round(SUM(ROUND(b.saleprice * (1 + (CAST(b.vat AS DOUBLE) / 100)), 0) * b.quantity),0) AS revenue 
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-05-01')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-08-20')
    AND b.outputtypeid IN (3, 1903)
    and a.outputvoucherid in 
    (SELECT outputvoucherid from billbia)
group by a.outputvoucherid 
),
tmp1 as (
SELECT
    distinct p.subgroupid,
    a.outputvoucherid 
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-05-01')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-08-20')
    AND b.outputtypeid IN (3, 1903)
    AND a.crmcustomerid > 5
    and p.subgroupid in (3020, 3047, 3044, 2980, 3023, 2855, 2844, 2848, 2850, 3901, 3084, 2856, 2841, 3083, 3141, 3102, 3942, 3819, 2854, 2852, 3090, 3934, 3929, 3109, 3142, 3025, 3082, 2712, 3058, 3089, 3927, 3106, 4279, 2551, 3087, 3137, 3110, 3932, 3138, 3900, 3197, 3080, 4259, 5549, 3100, 3086, 3931, 4261, 2849, 3139)
    and a.storeid in (116, 1559, 1698, 1933, 1885, 1972, 1975, 2023, 2111, 2229, 2214, 2379, 2792, 2714, 2854, 3098, 3251, 3326, 3233, 3471, 3502, 3388, 3387, 3612, 3590, 3624, 3092, 3761, 3836, 3892, 3771, 3969, 3555, 4075, 3696, 4477, 4970, 4880, 5056, 4745, 4906, 5073, 5388, 5485, 5757, 5229, 5484, 5065, 6008, 6290, 6155, 6306, 6588, 6628, 5455, 6420, 4407, 6526, 6989, 6968, 6873, 7241, 7335, 7601, 7747, 7670, 7758, 7985, 8223, 8152, 8875, 8863, 9208, 9028, 8904, 9079, 9253, 10299, 10151, 8795, 10068, 27921, 27902, 13739, 13659, 13785, 13839, 14112, 14275, 14396, 14565, 14477, 14650, 14623, 14765, 14830, 15031, 14736, 14740, 3094, 3114, 3786, 4478, 4893, 4616, 7841, 8105, 6970, 9998, 3322, 3427, 3647, 3743, 3652, 4448, 4899, 5258, 6138, 10051, 9125, 13018, 13608, 14128, 15521, 3207, 3394, 3645, 3713, 4675, 4845, 7882, 7951, 7821, 8656, 13665, 13984, 3393, 3854, 5726, 6004, 7326, 6245, 9141, 10357, 10358, 8866, 13741, 13799, 14265, 15565, 15615, 3399, 3440, 3520, 3972, 4637, 6984, 8024, 9075, 9248, 9432, 9281, 9986, 13627, 14375, 14556, 14695, 14850, 3271, 3355, 3231, 4547, 4992, 6022, 8678, 8727, 9509, 10168, 9508, 15029, 15458, 3673, 3828, 4406, 4603, 4844, 4898, 5725, 6117, 6475, 6834, 7032, 8776, 10115, 13593, 2109, 2093, 2217, 2208, 2191, 2308, 2182, 2333, 2271, 2401, 2265, 2453, 2477, 2423, 2452, 2470, 2405, 2436, 2579, 2643, 2425, 2546, 2422, 2713, 2736, 2798, 2725, 2847, 2717, 2882, 2535, 3111, 2823, 2715, 3043, 2786, 3105, 3262, 3263, 3215, 3320, 3390, 3376, 3501, 3235, 3365, 3324, 3264, 3768, 3802, 3610, 3825, 3989, 4074, 4476, 4585, 4822, 4546, 4548, 4746, 4883, 4583, 4593, 5046, 4892, 2338, 5344, 5179, 5451, 5426, 6187, 6421, 6029, 6065, 6541, 6695, 6586, 6422, 5076, 7013, 7169, 7300, 7301, 7672, 7993, 8191, 8588, 8190, 8558, 8919, 9191, 8920, 9484, 9939, 9416, 9984, 9491, 10377, 10066, 9214, 12995, 13797, 13618, 13845, 14555, 14598, 14599, 14621, 14671, 14786, 14735, 14752, 14956, 14957, 14930, 14844, 15106, 14567, 14848, 2911, 3002, 3093, 3095, 3261, 3248, 3254, 3255, 3250, 3432, 3342, 3391, 3386, 3425, 3257, 3437, 3469, 3589, 3692, 3454, 3751, 3827, 3600, 3588, 3712, 3890, 3668, 3970, 3750, 4134, 3853, 3773, 4288, 4244, 3826, 4550, 4361, 4520, 4701, 4823, 4834, 4817, 4997, 4946, 5007, 5095, 5074, 5273, 4937, 5453, 5454, 5776, 6020, 5979, 5980, 5803, 6189, 6188, 6184, 6581, 6154, 6278, 6064, 6747, 6582, 6402, 7031, 7325, 7029, 7600, 7687, 7688, 6183, 7883, 8254, 8341, 7277, 8284, 9294, 9272, 8865, 9295, 9933, 9138, 9964, 9271, 9458, 10102, 10109, 10397, 16861, 17864, 13035, 13592, 13656, 13668, 13645, 13616, 13733, 13743, 13714, 14135, 13853, 14136, 14381, 14390, 14570, 14517, 14666, 14463, 14634, 14720, 14761, 14815, 14748, 202, 161, 191, 1157, 1257, 1374, 1418, 1451, 1489, 1521, 1531, 1532, 1561, 1630, 1633, 1610, 1694, 1642, 1699, 1769, 1837, 1829, 1832, 1864, 1865, 1935, 1942, 1969, 2012, 1970, 1992, 2024, 1696, 2046, 2099, 2130, 2108, 2144, 2004, 2103, 2143, 2272, 2247, 2236, 2251, 1861, 2403, 2442, 2337, 2192, 2113, 2596, 2115, 2835, 2858, 2842, 3069, 2794, 3112, 3199, 3070, 3238, 3258, 3370, 3371, 3400, 2808, 3237, 3369, 2900, 3418, 3447, 3547, 3669, 3646, 3759, 3711, 3852, 3818, 4220, 4345, 3999, 4677, 4405, 4594, 5004, 5260, 5458, 5488, 5953, 5804, 6272, 6725, 6403, 6370, 6743, 6851, 6835, 6991, 7167, 7279, 7278, 7790, 7770, 7673, 7950, 7588, 8602, 8576, 8730, 8535, 8896, 8927, 7549, 8917, 8910, 9190, 9226, 9279, 9287, 9155, 8350, 7746, 9449, 9490, 10186, 10136, 10137, 9450, 10125, 10081, 9215, 10110, 9378, 10345, 12943, 15878, 27905, 27917, 13613, 14428, 14419, 14608, 14727, 14362, 14846, 14756, 15111, 3650, 3616, 3741, 3683, 3615, 3837, 3667, 3682, 3774, 3807, 3871, 3829, 3959, 3985, 3893, 3983, 3874, 3971, 4003, 3990, 4245, 4369, 4370, 4408, 4504, 4461, 4512, 4410, 4581, 4598, 4077, 4748, 4533, 4611, 4947, 4730, 4833, 4584, 4870, 4812, 4928, 4887, 4713, 4219, 4902, 4935, 4953, 4963, 5219, 5105, 4955, 5204, 5117, 5180, 5034, 4624, 5290, 5064, 5154, 4869, 5487, 5271, 4888, 5313, 5119, 5807, 5450, 5274, 4634, 5951, 5300, 5336, 4749, 6070, 6071, 5182, 5727, 6072, 6027, 6393, 6398, 6031, 6226, 6603, 6520, 6573, 6474, 6745, 6225, 6746, 6579, 6744, 5029, 6905, 7302, 7159, 6283, 6884, 7014, 6307, 7918, 8798, 6442, 8667, 8347, 8916, 9121, 8845, 8764, 9481, 9251, 9667, 9521, 9374, 9388, 9032, 9383, 9983, 9952, 10067, 9262, 9951, 10005, 8346, 10167, 6857, 13718, 13855, 13991, 14300, 14484, 14604, 14607, 14552, 14443, 14800, 4537, 4652, 4691, 4788, 4871, 4901, 4967, 5043, 4903, 5242, 5099, 5003, 4993, 5181, 5101, 5176, 5444, 5169, 4995, 5415, 5744, 6086, 6328, 6295, 6296, 6616, 6633, 6632, 6797, 6966, 6858, 6768, 6923, 6866, 7047, 7111, 7815, 7932, 8349, 8650, 8750, 8867, 8364, 9210, 9460, 10140, 10301, 10378, 14833, 14822, 15094, 15510, 15583)
)
select 
tmp1.subgroupid,
sum (tmp_revenue.revenue) as revenue,
count(distinct tmp1.outputvoucherid) as bill_count
from tmp1 join tmp_revenue 
on tmp1.outputvoucherid = tmp_revenue.outputvoucherid
group by tmp1.subgroupid

;
-- TỔng bill bia
SELECT
    count( distinct a.outputvoucherid)
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-05-01')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-08-20')
    AND b.outputtypeid IN (3, 1903)
    and p.maingroupid in (1255)
    and a.storeid in (116, 1559, 1698, 1933, 1885, 1972, 1975, 2023, 2111, 2229, 2214, 2379, 2792, 2714, 2854, 3098, 3251, 3326, 3233, 3471, 3502, 3388, 3387, 3612, 3590, 3624, 3092, 3761, 3836, 3892, 3771, 3969, 3555, 4075, 3696, 4477, 4970, 4880, 5056, 4745, 4906, 5073, 5388, 5485, 5757, 5229, 5484, 5065, 6008, 6290, 6155, 6306, 6588, 6628, 5455, 6420, 4407, 6526, 6989, 6968, 6873, 7241, 7335, 7601, 7747, 7670, 7758, 7985, 8223, 8152, 8875, 8863, 9208, 9028, 8904, 9079, 9253, 10299, 10151, 8795, 10068, 27921, 27902, 13739, 13659, 13785, 13839, 14112, 14275, 14396, 14565, 14477, 14650, 14623, 14765, 14830, 15031, 14736, 14740, 3094, 3114, 3786, 4478, 4893, 4616, 7841, 8105, 6970, 9998, 3322, 3427, 3647, 3743, 3652, 4448, 4899, 5258, 6138, 10051, 9125, 13018, 13608, 14128, 15521, 3207, 3394, 3645, 3713, 4675, 4845, 7882, 7951, 7821, 8656, 13665, 13984, 3393, 3854, 5726, 6004, 7326, 6245, 9141, 10357, 10358, 8866, 13741, 13799, 14265, 15565, 15615, 3399, 3440, 3520, 3972, 4637, 6984, 8024, 9075, 9248, 9432, 9281, 9986, 13627, 14375, 14556, 14695, 14850, 3271, 3355, 3231, 4547, 4992, 6022, 8678, 8727, 9509, 10168, 9508, 15029, 15458, 3673, 3828, 4406, 4603, 4844, 4898, 5725, 6117, 6475, 6834, 7032, 8776, 10115, 13593, 2109, 2093, 2217, 2208, 2191, 2308, 2182, 2333, 2271, 2401, 2265, 2453, 2477, 2423, 2452, 2470, 2405, 2436, 2579, 2643, 2425, 2546, 2422, 2713, 2736, 2798, 2725, 2847, 2717, 2882, 2535, 3111, 2823, 2715, 3043, 2786, 3105, 3262, 3263, 3215, 3320, 3390, 3376, 3501, 3235, 3365, 3324, 3264, 3768, 3802, 3610, 3825, 3989, 4074, 4476, 4585, 4822, 4546, 4548, 4746, 4883, 4583, 4593, 5046, 4892, 2338, 5344, 5179, 5451, 5426, 6187, 6421, 6029, 6065, 6541, 6695, 6586, 6422, 5076, 7013, 7169, 7300, 7301, 7672, 7993, 8191, 8588, 8190, 8558, 8919, 9191, 8920, 9484, 9939, 9416, 9984, 9491, 10377, 10066, 9214, 12995, 13797, 13618, 13845, 14555, 14598, 14599, 14621, 14671, 14786, 14735, 14752, 14956, 14957, 14930, 14844, 15106, 14567, 14848, 2911, 3002, 3093, 3095, 3261, 3248, 3254, 3255, 3250, 3432, 3342, 3391, 3386, 3425, 3257, 3437, 3469, 3589, 3692, 3454, 3751, 3827, 3600, 3588, 3712, 3890, 3668, 3970, 3750, 4134, 3853, 3773, 4288, 4244, 3826, 4550, 4361, 4520, 4701, 4823, 4834, 4817, 4997, 4946, 5007, 5095, 5074, 5273, 4937, 5453, 5454, 5776, 6020, 5979, 5980, 5803, 6189, 6188, 6184, 6581, 6154, 6278, 6064, 6747, 6582, 6402, 7031, 7325, 7029, 7600, 7687, 7688, 6183, 7883, 8254, 8341, 7277, 8284, 9294, 9272, 8865, 9295, 9933, 9138, 9964, 9271, 9458, 10102, 10109, 10397, 16861, 17864, 13035, 13592, 13656, 13668, 13645, 13616, 13733, 13743, 13714, 14135, 13853, 14136, 14381, 14390, 14570, 14517, 14666, 14463, 14634, 14720, 14761, 14815, 14748, 202, 161, 191, 1157, 1257, 1374, 1418, 1451, 1489, 1521, 1531, 1532, 1561, 1630, 1633, 1610, 1694, 1642, 1699, 1769, 1837, 1829, 1832, 1864, 1865, 1935, 1942, 1969, 2012, 1970, 1992, 2024, 1696, 2046, 2099, 2130, 2108, 2144, 2004, 2103, 2143, 2272, 2247, 2236, 2251, 1861, 2403, 2442, 2337, 2192, 2113, 2596, 2115, 2835, 2858, 2842, 3069, 2794, 3112, 3199, 3070, 3238, 3258, 3370, 3371, 3400, 2808, 3237, 3369, 2900, 3418, 3447, 3547, 3669, 3646, 3759, 3711, 3852, 3818, 4220, 4345, 3999, 4677, 4405, 4594, 5004, 5260, 5458, 5488, 5953, 5804, 6272, 6725, 6403, 6370, 6743, 6851, 6835, 6991, 7167, 7279, 7278, 7790, 7770, 7673, 7950, 7588, 8602, 8576, 8730, 8535, 8896, 8927, 7549, 8917, 8910, 9190, 9226, 9279, 9287, 9155, 8350, 7746, 9449, 9490, 10186, 10136, 10137, 9450, 10125, 10081, 9215, 10110, 9378, 10345, 12943, 15878, 27905, 27917, 13613, 14428, 14419, 14608, 14727, 14362, 14846, 14756, 15111, 3650, 3616, 3741, 3683, 3615, 3837, 3667, 3682, 3774, 3807, 3871, 3829, 3959, 3985, 3893, 3983, 3874, 3971, 4003, 3990, 4245, 4369, 4370, 4408, 4504, 4461, 4512, 4410, 4581, 4598, 4077, 4748, 4533, 4611, 4947, 4730, 4833, 4584, 4870, 4812, 4928, 4887, 4713, 4219, 4902, 4935, 4953, 4963, 5219, 5105, 4955, 5204, 5117, 5180, 5034, 4624, 5290, 5064, 5154, 4869, 5487, 5271, 4888, 5313, 5119, 5807, 5450, 5274, 4634, 5951, 5300, 5336, 4749, 6070, 6071, 5182, 5727, 6072, 6027, 6393, 6398, 6031, 6226, 6603, 6520, 6573, 6474, 6745, 6225, 6746, 6579, 6744, 5029, 6905, 7302, 7159, 6283, 6884, 7014, 6307, 7918, 8798, 6442, 8667, 8347, 8916, 9121, 8845, 8764, 9481, 9251, 9667, 9521, 9374, 9388, 9032, 9383, 9983, 9952, 10067, 9262, 9951, 10005, 8346, 10167, 6857, 13718, 13855, 13991, 14300, 14484, 14604, 14607, 14552, 14443, 14800, 4537, 4652, 4691, 4788, 4871, 4901, 4967, 5043, 4903, 5242, 5099, 5003, 4993, 5181, 5101, 5176, 5444, 5169, 4995, 5415, 5744, 6086, 6328, 6295, 6296, 6616, 6633, 6632, 6797, 6966, 6858, 6768, 6923, 6866, 7047, 7111, 7815, 7932, 8349, 8650, 8750, 8867, 8364, 9210, 9460, 10140, 10301, 10378, 14833, 14822, 15094, 15510, 15583)
;

--tổng số revenue bia
with 
billbia as
(
SELECT
    a.outputvoucherid
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-08-30')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-09-08')
    AND b.outputtypeid IN (3, 1903)
    and p.maingroupid in (1255)
    and a.storeid in (116, 1559, 1698, 1933, 1885, 1972, 1975, 2023, 2111, 2229, 2214, 2379, 2792, 2714, 2854, 3098, 3251, 3326, 3233, 3471, 3502, 3388, 3387, 3612, 3590, 3624, 3092, 3761, 3836, 3892, 3771, 3969, 3555, 4075, 3696, 4477, 4970, 4880, 5056, 4745, 4906, 5073, 5388, 5485, 5757, 5229, 5484, 5065, 6008, 6290, 6155, 6306, 6588, 6628, 5455, 6420, 4407, 6526, 6989, 6968, 6873, 7241, 7335, 7601, 7747, 7670, 7758, 7985, 8223, 8152, 8875, 8863, 9208, 9028, 8904, 9079, 9253, 10299, 10151, 8795, 10068, 27921, 27902, 13739, 13659, 13785, 13839, 14112, 14275, 14396, 14565, 14477, 14650, 14623, 14765, 14830, 15031, 14736, 14740, 3094, 3114, 3786, 4478, 4893, 4616, 7841, 8105, 6970, 9998, 3322, 3427, 3647, 3743, 3652, 4448, 4899, 5258, 6138, 10051, 9125, 13018, 13608, 14128, 15521, 3207, 3394, 3645, 3713, 4675, 4845, 7882, 7951, 7821, 8656, 13665, 13984, 3393, 3854, 5726, 6004, 7326, 6245, 9141, 10357, 10358, 8866, 13741, 13799, 14265, 15565, 15615, 3399, 3440, 3520, 3972, 4637, 6984, 8024, 9075, 9248, 9432, 9281, 9986, 13627, 14375, 14556, 14695, 14850, 3271, 3355, 3231, 4547, 4992, 6022, 8678, 8727, 9509, 10168, 9508, 15029, 15458, 3673, 3828, 4406, 4603, 4844, 4898, 5725, 6117, 6475, 6834, 7032, 8776, 10115, 13593, 2109, 2093, 2217, 2208, 2191, 2308, 2182, 2333, 2271, 2401, 2265, 2453, 2477, 2423, 2452, 2470, 2405, 2436, 2579, 2643, 2425, 2546, 2422, 2713, 2736, 2798, 2725, 2847, 2717, 2882, 2535, 3111, 2823, 2715, 3043, 2786, 3105, 3262, 3263, 3215, 3320, 3390, 3376, 3501, 3235, 3365, 3324, 3264, 3768, 3802, 3610, 3825, 3989, 4074, 4476, 4585, 4822, 4546, 4548, 4746, 4883, 4583, 4593, 5046, 4892, 2338, 5344, 5179, 5451, 5426, 6187, 6421, 6029, 6065, 6541, 6695, 6586, 6422, 5076, 7013, 7169, 7300, 7301, 7672, 7993, 8191, 8588, 8190, 8558, 8919, 9191, 8920, 9484, 9939, 9416, 9984, 9491, 10377, 10066, 9214, 12995, 13797, 13618, 13845, 14555, 14598, 14599, 14621, 14671, 14786, 14735, 14752, 14956, 14957, 14930, 14844, 15106, 14567, 14848, 2911, 3002, 3093, 3095, 3261, 3248, 3254, 3255, 3250, 3432, 3342, 3391, 3386, 3425, 3257, 3437, 3469, 3589, 3692, 3454, 3751, 3827, 3600, 3588, 3712, 3890, 3668, 3970, 3750, 4134, 3853, 3773, 4288, 4244, 3826, 4550, 4361, 4520, 4701, 4823, 4834, 4817, 4997, 4946, 5007, 5095, 5074, 5273, 4937, 5453, 5454, 5776, 6020, 5979, 5980, 5803, 6189, 6188, 6184, 6581, 6154, 6278, 6064, 6747, 6582, 6402, 7031, 7325, 7029, 7600, 7687, 7688, 6183, 7883, 8254, 8341, 7277, 8284, 9294, 9272, 8865, 9295, 9933, 9138, 9964, 9271, 9458, 10102, 10109, 10397, 16861, 17864, 13035, 13592, 13656, 13668, 13645, 13616, 13733, 13743, 13714, 14135, 13853, 14136, 14381, 14390, 14570, 14517, 14666, 14463, 14634, 14720, 14761, 14815, 14748, 202, 161, 191, 1157, 1257, 1374, 1418, 1451, 1489, 1521, 1531, 1532, 1561, 1630, 1633, 1610, 1694, 1642, 1699, 1769, 1837, 1829, 1832, 1864, 1865, 1935, 1942, 1969, 2012, 1970, 1992, 2024, 1696, 2046, 2099, 2130, 2108, 2144, 2004, 2103, 2143, 2272, 2247, 2236, 2251, 1861, 2403, 2442, 2337, 2192, 2113, 2596, 2115, 2835, 2858, 2842, 3069, 2794, 3112, 3199, 3070, 3238, 3258, 3370, 3371, 3400, 2808, 3237, 3369, 2900, 3418, 3447, 3547, 3669, 3646, 3759, 3711, 3852, 3818, 4220, 4345, 3999, 4677, 4405, 4594, 5004, 5260, 5458, 5488, 5953, 5804, 6272, 6725, 6403, 6370, 6743, 6851, 6835, 6991, 7167, 7279, 7278, 7790, 7770, 7673, 7950, 7588, 8602, 8576, 8730, 8535, 8896, 8927, 7549, 8917, 8910, 9190, 9226, 9279, 9287, 9155, 8350, 7746, 9449, 9490, 10186, 10136, 10137, 9450, 10125, 10081, 9215, 10110, 9378, 10345, 12943, 15878, 27905, 27917, 13613, 14428, 14419, 14608, 14727, 14362, 14846, 14756, 15111, 3650, 3616, 3741, 3683, 3615, 3837, 3667, 3682, 3774, 3807, 3871, 3829, 3959, 3985, 3893, 3983, 3874, 3971, 4003, 3990, 4245, 4369, 4370, 4408, 4504, 4461, 4512, 4410, 4581, 4598, 4077, 4748, 4533, 4611, 4947, 4730, 4833, 4584, 4870, 4812, 4928, 4887, 4713, 4219, 4902, 4935, 4953, 4963, 5219, 5105, 4955, 5204, 5117, 5180, 5034, 4624, 5290, 5064, 5154, 4869, 5487, 5271, 4888, 5313, 5119, 5807, 5450, 5274, 4634, 5951, 5300, 5336, 4749, 6070, 6071, 5182, 5727, 6072, 6027, 6393, 6398, 6031, 6226, 6603, 6520, 6573, 6474, 6745, 6225, 6746, 6579, 6744, 5029, 6905, 7302, 7159, 6283, 6884, 7014, 6307, 7918, 8798, 6442, 8667, 8347, 8916, 9121, 8845, 8764, 9481, 9251, 9667, 9521, 9374, 9388, 9032, 9383, 9983, 9952, 10067, 9262, 9951, 10005, 8346, 10167, 6857, 13718, 13855, 13991, 14300, 14484, 14604, 14607, 14552, 14443, 14800, 4537, 4652, 4691, 4788, 4871, 4901, 4967, 5043, 4903, 5242, 5099, 5003, 4993, 5181, 5101, 5176, 5444, 5169, 4995, 5415, 5744, 6086, 6328, 6295, 6296, 6616, 6633, 6632, 6797, 6966, 6858, 6768, 6923, 6866, 7047, 7111, 7815, 7932, 8349, 8650, 8750, 8867, 8364, 9210, 9460, 10140, 10301, 10378, 14833, 14822, 15094, 15510, 15583)
)
select
    (Round(SUM(ROUND(b.saleprice * (1 + (CAST(b.vat AS DOUBLE) / 100)), 0) * b.quantity),0)) AS total_revenue 
FROM
    "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
JOIN
    "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
    ON a.outputvoucherid = b.outputvoucherid
JOIN
    "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
    ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
WHERE
    from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-08-30')
    AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-09-08')
    AND b.outputtypeid IN (3, 1903)
    and a.outputvoucherid in 
    (SELECT outputvoucherid from billbia)
    
 ;
 
-- 1.Tính trên các user đã định danh, mua hàng cả offline và online, có phát sinh đơn mua trong tháng 6-7-8 (mỗi tháng đều có ít nhất 1 đơn mua hàng bất kì thì mới tính)
--   NH cần thông tin tỷ lệ % và SL KH đã định danh nói trên:
---  Chưa từng mua 1 trong các sản phẩm trong file danh sách đính kèm, subgroup đính kèm
with
customer_orders AS (
    SELECT 
        a.crmcustomerid AS customer_id,
        CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END AS is_online,
        DATE_TRUNC('month', FROM_UNIXTIME(a.outputdate / 1000 - 25200)) AS order_month
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE FROM_UNIXTIME(a.outputdate / 1000 - 25200) >= DATE('2025-06-01')
      AND FROM_UNIXTIME(a.outputdate / 1000 - 25200) < DATE('2025-09-01')
      AND b.outputtypeid IN (3, 1903)
      AND a.crmcustomerid > 5
),
tmp1 as (
SELECT distinct customer_id
FROM customer_orders
GROUP BY (customer_id)
HAVING COUNT(DISTINCT order_month) = 3
),
--tmp2 AS (
--SELECT tmp1.customer_id FROM tmp1 
--LEFT JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucher a 
--	ON tmp1.customer_id = a.crmcustomerid
--LEFT JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
--        ON a.outputvoucherid = b.outputvoucherid
--LEFT JOIN "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
--        ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
--WHERE a.crmcustomerid > 5
--      and p.productid in ('1034170000432', '1034170000436', '1034170000439', '1034170000449', '9923302000011', '1034170000431', '1034170000430', '9923302000010', '9923302000009', '1034170000435', '1034170000434', '1034170000437', '1034170000438', '1034170000447', '1034170000448', '1034168000070', '1034168000100', '1034168000080', '1034168000081', '1032999001271', '1034168000094', '1034168000098', '1034168000008', '1034168000102', '1034168000006', '1034168000014', '1032999000606', '8936059006163', '1034170000451', '9923197000537', '1034170000165', '1034170000446', '1034170000444', '1034170000443', '1034170000413', '1034170000412', '9923197000526', '9923197000527', '9923197000549', '9923197000521', '9923197000529', '9923197000542', '9923197000553', '9923197000536', '9923197000535', '9923197000523', '9923197000522', '1034170000433', '9923197000137', '9923197000134', '9923197000135', '9923197000119', '9923197000533', '8936059009782', '9923197000532', '9923197000525', '9923197000524', '8936059004596', '1034170000445', '9923197000546', '9923197000547', '9923197000550', '9923197000528', '9923197000295', '9923197000540', '9923197000534', '9923197000544', '8936059009003', '9923197000531', '9923197000539', '9923197000541', '9923197000538')   
--),
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
       b.outputtypeid IN (3, 1903)
      AND a.crmcustomerid > 5
      AND p.productid in ('1034170000432', '1034170000436', '1034170000439', '1034170000449', '9923302000011', '1034170000431', '1034170000430', '9923302000010', '9923302000009', '1034170000435', '1034170000434', '1034170000437', '1034170000438', '1034170000447', '1034170000448', '1034168000070', '1034168000100', '1034168000080', '1034168000081', '1032999001271', '1034168000094', '1034168000098', '1034168000008', '1034168000102', '1034168000006', '1034168000014', '1032999000606', '8936059006163', '1034170000451', '9923197000537', '1034170000165', '1034170000446', '1034170000444', '1034170000443', '1034170000413', '1034170000412', '9923197000526', '9923197000527', '9923197000549', '9923197000521', '9923197000529', '9923197000542', '9923197000553', '9923197000536', '9923197000535', '9923197000523', '9923197000522', '1034170000433', '9923197000137', '9923197000134', '9923197000135', '9923197000119', '9923197000533', '8936059009782', '9923197000532', '9923197000525', '9923197000524', '8936059004596', '1034170000445', '9923197000546', '9923197000547', '9923197000550', '9923197000528', '9923197000295', '9923197000540', '9923197000534', '9923197000544', '8936059009003', '9923197000531', '9923197000539', '9923197000541', '9923197000538')
), 
tmp3 as (
select tmp1.customer_id
from tmp1 left join tmp2 
on tmp1.customer_id = tmp2.customer_id
where tmp2.customer_id IS NULL
),
tmp4 as (
SELECT 
       distinct a.crmcustomerid AS customer_id        
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b 
        ON a.outputvoucherid = b.outputvoucherid
    JOIN
        "pinot-group01"."default".bhx_bhx_masterdata_pm_product p 
        ON CAST(b.productid  AS VARCHAR) = CAST(p.productid AS VARCHAR)
    WHERE 
       b.outputtypeid IN (3, 1903)
      AND a.crmcustomerid > 5
      and p.productid in ('9923197000526', '9923197000527', '9923197000549', '9923197000521', '9923197000529', '9923197000542', '9923197000553', '9923197000536', '9923197000535', '9923197000523', '9923197000522', '1034170000433', '9923197000137', '9923197000134', '9923197000135', '9923197000119', '9923197000533', '8936059009782', '9923197000532', '9923197000525', '9923197000524', '8936059004596', '1034170000445', '9923197000546', '9923197000547', '9923197000550', '9923197000528', '9923197000295', '9923197000540', '9923197000534', '9923197000544', '8936059009003', '9923197000531', '9923197000539', '9923197000541', '9923197000538')   
),
tmp5 AS (
select tmp1.customer_id
from tmp1 left join tmp4
on tmp1.customer_id = tmp4.customer_id
where tmp4.customer_id IS NULL
),
--tmp6 AS (
--select tmp5.customer_id
--from tmp5 LEFT join tmp3
--on tmp5.customer_id = tmp3.customer_id
--WHERE tmp3.customer_id IS NULL
--)
tmp6 AS (
    SELECT tmp5.customer_id
    FROM tmp5
    INNER JOIN tmp2
        ON tmp5.customer_id = tmp2.customer_id
)
select count (*) from tmp6
;

--- Số lượng Khách hàng mới tháng 07/2025 (Khách chưa mua hàng từ tháng 01/2024 - và có phát sinh đơn hàng tháng 07/2025)
WITH old_customers AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-07-01')
),
customers_july2025 AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-07-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-08-01')
)
SELECT 
    COUNT(DISTINCT ju.customer_id) AS new_customer_count
FROM customers_july2025 ju
LEFT JOIN old_customers o 
    ON ju.customer_id = o.customer_id
WHERE o.customer_id IS NULL; -- Kết quả: 145332


--- Số lượng Khách hàng mới tháng 08/2025 (Khách chưa mua hàng từ tháng 01/2024 - và có phát sinh đơn hàng tháng 08/2025)

WITH old_customers AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-08-01')
),
customers_august2025 AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-08-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-09-01')
)
SELECT 
    COUNT(DISTINCT ju.customer_id) AS new_customer_count
FROM customers_august2025 ju
LEFT JOIN old_customers o 
    ON ju.customer_id = o.customer_id
WHERE o.customer_id IS NULL; -- kết quả : 162364

--- Số lượng Khách hàng mới tháng 09/2025 (Khách chưa mua hàng từ tháng 01/2024 - và có phát sinh đơn hàng tháng 09/2025)

WITH old_customers AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN ( 1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-09-01')
),
customers_sept2025 AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN ( 1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-09-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
)
SELECT 
    COUNT(DISTINCT ju.customer_id) AS new_customer_count
FROM customers_sept2025 ju
LEFT JOIN old_customers o 
    ON ju.customer_id = o.customer_id
WHERE o.customer_id IS NULL; --kết quả : 159742

--- Số lượng Khách hàng mới tháng 10/2025 (Khách chưa mua hàng từ tháng 01/2024 - và có phát sinh đơn hàng đầu tháng 10/2025)

WITH old_customers AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
),
customers_sept2025 AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-10-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-07')
)
SELECT 
    COUNT(DISTINCT ju.customer_id) AS new_customer_count
FROM customers_sept2025 ju
LEFT JOIN old_customers o 
    ON ju.customer_id = o.customer_id
WHERE o.customer_id IS NULL; --kết quả : 29276



--- Số lượng Khách hàng mới tháng 10/2025 (Khách chưa mua hàng từ tháng 01/2024 - và có phát sinh đơn hàng từ đầu t10 đến  26/10/2025)

WITH old_customers AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
),
customers_sept2025 AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-10-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) <= DATE('2025-10-31')
)
SELECT 
    COUNT(DISTINCT ju.customer_id) AS new_customer_count
FROM customers_sept2025 ju
LEFT JOIN old_customers o 
    ON ju.customer_id = o.customer_id
WHERE o.customer_id IS NULL; --kết quả : 14522
;

SELECT COUNT(*) AS new_customer_count
FROM (
    SELECT a.crmcustomerid
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN (1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-20')
    GROUP BY a.crmcustomerid
    HAVING 
        SUM(CASE WHEN from_unixtime(a.outputdate / 1000 - 25200) BETWEEN DATE('2025-10-01') AND DATE('2025-10-19') THEN 1 ELSE 0 END) > 0
        AND SUM(CASE WHEN from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01') THEN 1 ELSE 0 END) = 0
) t;


--- Số lượng Khách hàng mới tháng 01/2025 (Khách chưa mua hàng từ tháng 01/2024 - và có phát sinh đơn hàng tháng 01/2025)

WITH old_customers AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN ( 1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2024-01-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-06-01')
),
customers_sept2025 AS (
    SELECT DISTINCT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN ( 1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-06-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-07-01')
)
SELECT 
    COUNT(DISTINCT ju.customer_id) AS new_customer_count
FROM customers_sept2025 ju
LEFT JOIN old_customers o 
    ON ju.customer_id = o.customer_id
WHERE o.customer_id IS NULL; --kết quả :

;
--Thời gian: 01/09-30/09
--Nhóm hàng: Gạo, nếp các loại 
WITH customers AS (
SELECT
	DISTINCT a.crmcustomerid AS customer_id
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
	AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2024-09-01')
	AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-10-01')
	AND p.subgroupid = 3054
),
SELECT
	COUNT(DISTINCT c.customer_id) AS customer_count
FROM
	customers c;
---------------------------------------

                2835	3039	3059	3110	3111	3113	3114
- Từng tệp khách hàng là khách hàng mới chưa mua nhóm hàng đó từ 01/2025 đến hiện tại
- Request 3 tháng gần nhất (Tháng 8, 9, 10), mỗi tháng KH phải ít nhất có 1 ĐƠN HÀNG ONLINE

----------------------------------------
;

WITH nobuy_customers AS (
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
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-11-07')
    GROUP BY a.crmcustomerid
    HAVING SUM(CASE WHEN p.subgroupid IN (3114) THEN 1 ELSE 0 END) = 0
),
buyonl_customers AS (
    SELECT a.crmcustomerid AS customer_id
    FROM "pinot-group01"."default".bhx_inventory_inv_outputvoucher a
    JOIN "pinot-group01"."default".bhx_inventory_inv_outputvoucherdetail b
        ON a.outputvoucherid = b.outputvoucherid
    WHERE 
        a.crmcustomerid > 5
        AND b.outputtypeid IN ( 1903)
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-08-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-11-07')
    GROUP BY a.crmcustomerid
    HAVING count (DISTINCT DATE_TRUNC('month', FROM_UNIXTIME(a.outputdate / 1000 - 25200))) >= 3 
)
SELECT 
    nc.customer_id
FROM nobuy_customers nc
JOIN buyonl_customers bc
    ON nc.customer_id = bc.customer_id

;

 KH đã mua hàng tại BHX (Tính từ tháng 1/2025) 
 nhưng chưa từng mua Fresh (mã ngành 993, 1234, 1235, 1236, 1254 )trong 6 tháng gần nhất 
 (1/5/2025 - 31/10/2025) = -0 > KH MỚI


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
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-05-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-11-01')
        AND p.maingroupid IN (993, 1234, 1235, 1236, 1254)
    GROUP BY a.crmcustomerid
    ;
--  danh sách các thông tin  "Mã khách hàng ; Mã đơn hàng ; Tên ngành hàng ; Ngày xuất hàng ; Doanh thu


SELECT a.crmcustomerid AS customer_id,
	CASE
	WHEN MAX(CASE WHEN b.outputtypeid = 1903 THEN 1 ELSE 0 END) = 1
            THEN 1 ELSE 0
	END AS is_online
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
        AND from_unixtime(a.outputdate / 1000 - 25200) >= DATE('2025-05-01')
        AND from_unixtime(a.outputdate / 1000 - 25200) < DATE('2025-11-01')
        AND p.maingroupid IN (993, 1234, 1235, 1236, 1254)
    GROUP BY a.crmcustomerid












 
   

    
    
    