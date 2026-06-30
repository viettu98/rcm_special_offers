# rcm_special_offers

Một bộ tập lệnh SQL dùng để phân tích hành vi khách hàng, tạo tệp khách hàng mục tiêu và đánh giá hiệu quả các chương trình khuyến mãi (special offers) trên dữ liệu BHX. Dành cho nhà phân tích dữ liệu / analyst / BI team có quyền truy cập vào các catalog/tables (ví dụ: `pinot-group01`, `pinot`, `kudu-datasale`) chứa bảng hóa đơn, chi tiết hóa đơn, danh mục sản phẩm và bảng phân tích khách hàng.

## Mục lục
- [Tổng quan dự án](#tổng-quan-dự-án)
- [Tính năng chính](#tính-năng-chính)
- [Danh sách tệp & mô tả ngắn](#danh-sách-tệp--mô-tả-ngắn)
- [Cách sử dụng](#cách-sử-dụng)
- [Công nghệ / Dữ liệu yêu cầu](#công-nghệ--dữ-liệu-yêu-cầu)
- [Cải tiến trong tương lai](#cải-tiến-trong-tương-lai)
- [Hình ảnh / Minh họa](#hình-ảnh--minh-họa)

## Tổng quan dự án
Tập hợp các truy vấn SQL đã được viết sẵn để:
- Lọc và tạo các tệp khách hàng mục tiêu theo điều kiện về ngành hàng, nhãn hàng, tần suất mua, kênh (online/offline), cửa hàng.
- Tính toán các chỉ số thống kê (doanh thu, số bill, trung bình ngày giữa các đơn, tần suất mua lại theo chương trình khuyến mãi).
- Xác định khách hàng mới / khách hàng chưa mua một nhóm hàng nhất định trong khoảng thời gian chỉ định.
Các truy vấn chủ yếu thao tác trên dữ liệu hóa đơn và bảng masterdata sản phẩm để sinh ra tệp KH dùng cho chiến dịch special-offer / retention / targeting.

### Tầm dùng
Dùng cho team BI/DA thực hiện segmentation khách hàng, kiểm tra hiệu quả KM, chuẩn bị danh sách tệp cho marketing (offline/online).

## Tính năng chính
- Truy vấn tách nhóm khách hàng theo ngành hàng (FMCG, mỹ phẩm, kem, bia, gạo…).
- Tạo tệp khách hàng "chưa mua" / "mua lại" / "mua nhiều tháng liên tiếp" / "khách mới".
- Tính toán chỉ số: revenue theo tháng, số bill, trung bình giá trị giỏ hàng, khoảng cách ngày giữa các lần mua, tần suất mua lại theo promotion.
- Lọc theo kênh bán (outputtypeid ví dụ: 1903 = offline, 3 = online; repo dùng flag này để phân biệt).
- Kiểm tra đơn hàng có áp dụng promotion / promotion types và nhóm các outputvoucher liên quan.
- Kết nối với bảng phụ trợ (ví dụ bảng app tick: `rcm_khachhang_coappbhx`) để đánh dấu khách có cài app hay không.

## Danh sách tệp & mô tả ngắn
(Đây là toàn bộ các tệp SQL ở root repo hiện có)

- Special-offer_statistic.sql  
  - Tập các truy vấn phân tích thống kê liên quan tới special offers: khách mua combo, % mua KM, tần suất mua lại, revenue & bill theo khách hàng, nhiều phép tính tổng hợp phức tạp.

- Special-offer-statistic2.sql  
  - Các truy vấn thêm cho phân tích revenue theo subgroup/maingroup, tổng hợp cho tập cửa hàng, tính khách mới theo tháng, các phân đoạn "chưa mua" / "mới" theo nhiều kịch bản.

- Special-offer FMCG.sql  
  - Tập truy vấn dành cho phân khúc FMCG (ví dụ xác định khách mua một danh sách SKU, phân loại theo "tiềm năng" (thấp/trung bình/cao)).

- Special-offer-mypham.sql  
  - Truy vấn định nghĩa tệp khách hàng liên quan nhóm mỹ phẩm / phân vùng cửa hàng nhất định.

- Special offer (kem).sql  
  - Truy vấn liên quan đến category/segment "kem" (ví dụ dùng bảng `rcm_offer_sanluongmua_cate_6months` và metrics liên quan).

- Special offer - siêu thị.sql  
  - Các truy vấn lọc theo cửa hàng (store-level), ví dụ storeid = 3853; logic mua trong các tháng liên tiếp.

- Special offer - 10 tệp KH mẫu.sql  
  - Một số tệp mẫu (ví dụ tập khách hàng mua thường xuyên, trung thành với brand, phân tích tần suất/brand/subgroup).

- Special_offer_Fresh.sql, Special_offer_bia.sql, Special_offer_gao.sql, Special-offer-mypham.sql (tệp chuyên ngành)  
  - Các truy vấn chuyên biệt cho nhóm hàng Fresh, bia, gạo, mỹ phẩm… (tệp chứa logic lọc theo maingroup/subgroup/productid).

> Ghi chú: nhiều truy vấn trong các tệp có comment, danh sách productid/storeid/promotionid cụ thể và khoảng thời gian (ví dụ 2025-xx). Có thể sửa các IDs và khoảng thời gian theo nhu cầu chiến dịch.

## Cách sử dụng
1. Prerequisites
   - Truy cập vào môi trường SQL/catalog nơi có các catalog/tables được tham chiếu trong truy vấn:
     - Catalogs/schemas được dùng trong tệp: `pinot-group01.default`, `pinot.default`, và `kudu-datasale.default` (ví dụ bảng `default.som_customerorder`).
   - Quyền đọc các bảng:
     - bhx_inventory_inv_outputvoucher
     - bhx_inventory_inv_outputvoucherdetail
     - bhx_bhx_masterdata_pm_product
     - bhx_inventory_inv_ov_promotiondiscount, pm_promotiongiftgroup, pm_promotion...
     - pinot."default".rcm_khachhang_coappbhx
     - (và các bảng masterdata / promotion khác được tham chiếu trong file)
   - Một SQL client/CLI hoặc notebook (ví dụ: Trino/Presto/Pinot SQL UI hoặc bất kỳ client nào mà organisation sử dụng to query those catalogs).

2. Chạy một file SQL
   - Mở file .sql tương ứng (ví dụ `Special-offer_statistic.sql`) trong editor hoặc upload vào SQL editor.
   - Thay các biến tham chiếu theo môi trường:
     - Nếu cần thay catalog/schema, chỉnh các tiền tố `"pinot-group01"."default"` -> phù hợp môi trường.
     - Điều chỉnh khoảng thời gian (FROM_UNIXTIME(...)), productid, promotionid, storeid theo nhu cầu.
   - Ví dụ (nếu dùng CLI hỗ trợ file execution):
     - trino-cli / trino UI / bất kỳ client tương ứng: gửi nội dung file và chạy.
   - Lưu kết quả (export CSV) để dùng cho các chiến dịch marketing / upload lên công cụ gửi SMS/email.

3. Lưu ý khi chạy
   - Nhiều truy vấn có điều kiện ngày dùng hàm chuyển epoch (a.outputdate / 1000 - 25200). Kiểm tra múi giờ/format timestamp trong hệ trước khi chạy.
   - Một số truy vấn dùng HAVING / window functions — chạy trên engine phân tán có thể tốn tài nguyên; test trên subset dữ liệu trước khi chạy toàn bộ.
   - Các file chứa nhiều đoạn thử nghiệm (SELECT *, debug) — nên đọc comment trong file và chỉ chạy đoạn cần thiết.

## Công nghệ / Dữ liệu yêu cầu
- Ngôn ngữ: SQL (dạng tương thích với Presto/Trino-style functions: FROM_UNIXTIME, DATE_TRUNC, date_diff, LEAD, window functions).
- Catalogs / Data sources: Apache Pinot (ví dụ `pinot-group01` / `pinot`), Kudu (ví dụ `kudu-datasale`), bảng masterdata nội bộ BHX.
- Dữ liệu chính:
  - Hóa đơn & chi tiết hóa đơn: bhx_inventory_inv_outputvoucher, bhx_inventory_inv_outputvoucherdetail
  - Thông tin sản phẩm/nhóm: bhx_bhx_masterdata_pm_product, pm_subgroup, pm_promotion...
  - Bảng bổ trợ: rcm_khachhang_coappbhx (dùng để gán flag có cài app)
- Công cụ gợi ý: Trino/Presto/Pinot SQL UI, Jupyter / Zeppelin (nếu muốn automation + viz), export CSV -> BI tool.

## Cải tiến trong tương lai (gợi ý)
- Chuyển các truy vấn thành các notebook (Jupyter/Zeppelin) có parameter (date_from, date_to, product_list, store_list) để dễ tái sử dụng.
- Thêm file metadata: mô tả schema (cột chính) cho các bảng dùng nhiều nhất (`bhx_inventory_*`, `pm_product`, `promotion`).
- Chuẩn hóa và parameter hóa product/store/promotion IDs thành một file config (JSON/YAML) để tránh sửa thủ công trong SQL.
- Viết script xuất tệp khách hàng (CSV) và tự động upload vào hệ thống marketing/Campaign Manager.
- Thêm kiểm soát tài nguyên: chạy trước trên sample (LIMIT) rồi scale up.
- Thêm test/CI cho các truy vấn quan trọng (ví dụ validate result count > 0, check ngày hợp lệ).
- Thêm tài liệu ER-diagram & flow chart (có image) để người mới nhanh hiểu data flow.



