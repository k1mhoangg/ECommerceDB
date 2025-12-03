USE eCommerceDB;

-- 1. INSERT DATA: Carrier (Đơn vị vận chuyển)

INSERT INTO Carrier (MaDVVC, Ten) VALUES
('DVVC01', N'Giao Hàng Tiết Kiệm'),
('DVVC02', N'Viettel Post'),
('DVVC03', N'GrabExpress');

-- 2. INSERT DATA: Warehouse (Kho hàng)

INSERT INTO Warehouse (MaKho, TinhTrang, SucChua, DiaChi) VALUES
('KHO01', N'Hoạt động', 5000, N'12 Cộng Hòa, Tân Bình, TP.HCM'),
('KHO02', N'Đang bảo trì', 1200, N'45 Lê Duẩn, Quận 1, TP.HCM'),
('KHO03', N'Đầy hàng', 3000, N'78 Giải Phóng, Hà Nội');

-- 3. INSERT ORDERS (Đơn hàng)

INSERT INTO Orders (
    MaDonHang, NgayDatHang, NgayNhanDuKien, PhiVanChuyen, TongTien, 
    ThongTinNguoiGiao, ThongTinNguoiNhan, TongSoLuong, PhuongThucVanChuyen, 
    TrangThaiDonHang, MaPhienThanhToan, SoTaiKhoan, TenNganHang
) VALUES
('DH001', '2024-06-01', '2024-06-05', 30000, 530000, N'Shop ABC', N'Nguyễn Văn A', 2, N'Nhanh', N'Đang giao', 'PS001', '123456', 'Vietcombank'),
('DH002', '2024-06-02', '2024-06-06', 15000, 1215000, N'Shop XYZ', N'Trần Thị B', 1, N'Tiết kiệm', N'Chờ lấy hàng', 'PS002', '654321', 'Techcombank');

-- 4. INSERT PLACEORDER (Thông tin đặt hàng mở rộng)

INSERT INTO PlaceOrder (MaDonHang, MaVoucher, SoThuTu, MaNguoiMua) VALUES
('DH001', 'VOUCHER50K', 1, 'M001'); 


-- 5. INSERT ORDERITEM (Chi tiết sản phẩm)
INSERT INTO OrderItem (MaDonHang, SoThuTuDong, SoLuong, MaSanPham, MaBienThe) VALUES
('DH001', 'Line1', 2, 'SP01', 'SIZE_M');

-- 6. INSERT SHIPMENT (Vận đơn)

INSERT INTO Shipment (MaVanDon, MaDonHang, MaDVVC) VALUES
('VD555', 'DH001', 'DVVC01'), -- Đơn 1 đi GHTK
('VD888', 'DH002', 'DVVC02'); -- Đơn 2 đi Viettel Post

-- 7. INSERT SHIPMENTTRANSIT (Lịch sử trung chuyển qua kho)

INSERT INTO ShipmentTransit (MaVanDon, MaDonHang, MaKho, ThoiGianVanChuyen, VaiTro) VALUES
('VD555', 'DH001', 'KHO01', '2024-06-01 10:00:00', N'Nhập kho đầu vào'),
('VD888', 'DH002', 'KHO02', '2024-06-02 14:00:00', N'Lưu kho chờ xử lý');

-- 8. INSERT SHIPMENTDELIVERY (Giao cho Shipper)

INSERT INTO ShipmentDelivery (MaVanDon, MaDonHang, MaDinhDanhShipper, ThoiGianVanChuyen, VaiTro) VALUES
('VD555', 'DH001', 'SHIPPER01', '2024-06-03 08:00:00', N'Shipper đang đi giao');

