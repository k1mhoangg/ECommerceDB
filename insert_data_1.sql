-- Dữ liệu mẫu cho Buyer (Người mua)
INSERT INTO Buyer (MaNguoiMua, TenHienThi, MatKhau, TrangThaiTaiKhoan, GioiTinh, NgaySinh, Email, SoDienThoai) VALUES
('M001', N'Hoàng Anh', 'hashed_pass_1', N'Hoạt động', N'Nam', '1995-05-10', 'hoanganh@email.com', '0912345678'),
('M002', N'Thu Trang', 'hashed_pass_2', N'Hoạt động', N'Nữ', '1998-11-20', 'thutrang@email.com', '0987654321'),
('M003', N'Đức Mạnh', 'hashed_pass_3', N'Đã khóa', N'Nam', '2000-01-05', 'ducmamh@email.com', '0901234567');

-- Dữ liệu mẫu cho Seller (Người bán)
INSERT INTO Seller (MaNguoiBan, TenCuaHang, NgayThamGia, MaCuaHang, DiaChi, DanhGia, MoTa, CCCD, MaSoKinhDoanh, TenToChuc, MaSoThue) VALUES
('B001', N'Shop Quần Áo Xịn', '2023-01-15', 'SHOPQA1', N'123 Đường A, TP.HCM', 4.8, N'Chuyên cung cấp quần áo thời trang cao cấp.', '012345678901', 'MSKD12345', N'Công ty TNHH QAX', 'MST111'),
('B002', N'Cửa Hàng Đồ Điện Tử', '2022-10-20', 'CHDT2', N'456 Đường B, Hà Nội', 4.5, N'Thiết bị điện tử, phụ kiện.', '023456789012', 'MSKD67890', N'Cty CP Điện Tử HN', 'MST222');

-- Dữ liệu mẫu cho Shipper
INSERT INTO Shipper (MaShipper, CCCD, Ngaysinh, Gioitinh, Sodienthoai, Ten) VALUES
('S001', '034567890123', '1990-03-15', N'Nam', '0888123456', N'Văn An'),
('S002', '045678901234', '1993-07-22', N'Nam', '0888654321', N'Thị Hằng');

-- Dữ liệu mẫu cho Admin
INSERT INTO Admin (MaAdmin, HoTen, MatKhau, NgayThamGia) VALUES
('A001', N'Nguyễn Trưởng', 'admin_pass_1', '2023-01-01 10:00:00'),
('A002', N'Lê Quản Lý', 'admin_pass_2', '2023-05-20 15:30:00');

-- Dữ liệu mẫu cho Contact (Liên hệ giữa Người mua và Người bán)
INSERT INTO Contact (MaNguoiBan, MaNguoiMua, NoiDung, ThoiGianGui, ThoiGianNhan) VALUES
('B001', 'M001', N'Tôi muốn hỏi về sản phẩm áo khoác.', '2024-06-01 09:00:00', '2024-06-01 10:00:00'),
('B002', 'M002', N'Bạn có hàng điện thoại Samsung không?', '2024-06-02 14:30:00', '2024-06-02 15:00:00');

-- Dữ liệu mẫu cho BankAccount (Tài khoản ngân hàng)
INSERT INTO BankAccout (MaTaiKhoan, MaNguoiDung, TenNganHang, SoTaiKhoan, LoaiTaiKhoan) VALUES
('TK001', 'M001', N'Ngân hàng A', '1234567890', N'Người mua'),
('TK002', 'B001', N'Ngân hàng B', '0987654321', N'Người bán');

-- Lưu ý: cần tạo bảng Cart trước khi chèn PaymentSection (để đảm bảo FK: MaGioHang)
-- TẠM THỜI BỎ QUA FK CHO PaymentSection ĐỂ CHÈN DỮ LIỆU MẪU ĐƯỢC THUẬN TIỆN
-- (Trong thực tế, cần INSERT Cart trước)

-- Dữ liệu mẫu cho PaymentSection (Phiên thanh toán)
INSERT INTO PaymentSection (MaPhienThanhToan, MaNguoiMua, MaGioHang, TongGiaTriSanPham, TongSanPham, GiaDuKien) VALUES
('PS001', 'M001', 'GH001', 550000.00, 3, 560000.00), --  vd MaGioHang GH001 tồn tại
('PS002', 'M002', 'GH002', 1200000.00, 1, 1200000.00); -- vd MaGioHang GH002 tồn tại