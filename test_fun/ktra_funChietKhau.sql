USE ECommerceDB;
GO

-- =========================================================
-- KHAI BÁO BIẾN VÀ DỌN DẸP
-- =========================================================
DECLARE @NM_ID_TEST NVARCHAR(50) = 'NM_TEST_CKHAU';
DECLARE @NM_ID_INVALID NVARCHAR(50) = 'NM_INVALID_ID';
DECLARE @V_50K NVARCHAR(50) = 'VOU_50K';
DECLARE @V_20K NVARCHAR(50) = 'VOU_20K';
DECLARE @V_ZERO NVARCHAR(50) = 'VOU_ZERO';
DECLARE @DH_OK1 NVARCHAR(50) = 'DH_CK_OK1';
DECLARE @DH_OK2 NVARCHAR(50) = 'DH_CK_OK2';
DECLARE @DH_PENDING NVARCHAR(50) = 'DH_CK_PENDING';
DECLARE @GH_ID NVARCHAR(50) = 'GH_CK_TEST';
DECLARE @PH_ID NVARCHAR(50) = 'PH_CK_TEST';

-- Dọn dẹp dữ liệu cũ
DELETE FROM ap_dung_voucher WHERE ma_don_hang IN (@DH_OK1, @DH_OK2, @DH_PENDING);
DELETE FROM dat_hang WHERE ma_don_hang IN (@DH_OK1, @DH_OK2, @DH_PENDING);
DELETE FROM don_hang WHERE ma_don_hang IN (@DH_OK1, @DH_OK2, @DH_PENDING);
DELETE FROM phien_thanh_toan WHERE ma_phien_thanh_toan = @PH_ID;
DELETE FROM gio_hang WHERE ma_gio_hang = @GH_ID;
DELETE FROM voucher WHERE ma_voucher IN (@V_50K, @V_20K, @V_ZERO);
DELETE FROM nguoi_mua WHERE ma_nguoi_mua = @NM_ID_TEST;


-- =========================================================
-- TẠO DỮ LIỆU MẪU ĐỂ TEST
-- =========================================================

-- 1. CHÈN NGUOI_MUA
INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
VALUES (@NM_ID_TEST, N'Test Chiết Khấu', 'hash', '1990-01-01', 'ckhau@test.com', '1234', N'Hoạt động');

-- 2. CHÈN VOUCHER
INSERT INTO voucher (ma_voucher, thoi_gian_bat_dau, thoi_gian_ket_thuc, gia_tri_giam_gia) 
VALUES 
(@V_50K, GETDATE(), DATEADD(year, 1, GETDATE()), 50.00),   -- Giá trị: 50.00
(@V_20K, GETDATE(), DATEADD(year, 1, GETDATE()), 20.00),   -- Giá trị: 20.00
(@V_ZERO, GETDATE(), DATEADD(year, 1, GETDATE()), 0.00);   -- Giá trị: 0.00 (Bị bỏ qua bởi IF > 0)

-- 3. TẠO CÁC BẢNG TRUNG GIAN
INSERT INTO gio_hang (ma_gio_hang, ma_nguoi_mua) VALUES (@GH_ID, @NM_ID_TEST);
INSERT INTO phien_thanh_toan (ma_phien_thanh_toan, ma_gio_hang) VALUES (@PH_ID, @GH_ID);

-- 4. CHÈN ĐƠN HÀNG VÀ AP_DUNG_VOUCHER

-- Đơn 1 (DH_OK1): HOÀN THÀNH. Áp dụng V_50K (50.00) + V_20K (20.00)
-- Tổng chiết khấu tính toán: 70.00
INSERT INTO don_hang (ma_don_hang, ma_phien, ngay_dat_hang, trang_thai_don_hang, tong_tien, tong_so_luong) 
VALUES (@DH_OK1, @PH_ID, GETDATE(), N'Hoàn thành', 1000, 1);
INSERT INTO dat_hang (ma_don_hang, ma_nguoi_mua) VALUES (@DH_OK1, @NM_ID_TEST);
INSERT INTO ap_dung_voucher (ma_voucher, ma_don_hang) VALUES (@V_50K, @DH_OK1);
INSERT INTO ap_dung_voucher (ma_voucher, ma_don_hang) VALUES (@V_20K, @DH_OK1);

-- Đơn 2 (DH_OK2): HOÀN THÀNH. Áp dụng V_ZERO (0.00)
-- Tổng chiết khấu tính toán: 0.00 (Bị bỏ qua)
INSERT INTO don_hang (ma_don_hang, ma_phien, ngay_dat_hang, trang_thai_don_hang, tong_tien, tong_so_luong) 
VALUES (@DH_OK2, @PH_ID, GETDATE(), N'Hoàn thành', 200, 1);
INSERT INTO dat_hang (ma_don_hang, ma_nguoi_mua) VALUES (@DH_OK2, @NM_ID_TEST);
INSERT INTO ap_dung_voucher (ma_voucher, ma_don_hang) VALUES (@V_ZERO, @DH_OK2);

-- Đơn 3 (DH_PENDING): ĐANG CHỜ. Áp dụng V_50K (50.00)
-- Tổng chiết khấu tính toán: 0.00 (Bị bỏ qua do trạng thái khác 'Hoàn thành')
INSERT INTO don_hang (ma_don_hang, ma_phien, ngay_dat_hang, trang_thai_don_hang, tong_tien, tong_so_luong) 
VALUES (@DH_PENDING, @PH_ID, GETDATE(), N'Đang chờ', 500, 1);
INSERT INTO dat_hang (ma_don_hang, ma_nguoi_mua) VALUES (@DH_PENDING, @NM_ID_TEST);
INSERT INTO ap_dung_voucher (ma_voucher, ma_don_hang) VALUES (@V_50K, @DH_PENDING);


-- =========================================================
-- KIỂM TRA HÀM
-- =========================================================
PRINT '==================================================';
PRINT N'BẮT ĐẦU KIỂM TRA HÀM fn_TinhTongGiaTriChietKhau';
PRINT '==================================================';

-- Kịch bản 1: Mã Người mua Tồn tại (Tính tổng)
-- Dự kiến: 50.00 + 20.00 = 70.00
SELECT 
    N'F1 (Tồn tại, OK)' AS KichBan,
    @NM_ID_TEST AS MaNguoiMua,
    dbo.fn_TinhTongGiaTriChietKhau(@NM_ID_TEST) AS Tong_Chiet_Khau_ThucTe,
    70.00 AS KetQua_DuKien;


-- Kịch bản 2: Mã Người mua Không tồn tại
-- Dự kiến: -1 (Logic kiểm tra tham số)
SELECT 
    N'F2 (Không tồn tại)' AS KichBan,
    @NM_ID_INVALID AS MaNguoiMua,
    dbo.fn_TinhTongGiaTriChietKhau(@NM_ID_INVALID) AS Tong_Chiet_Khau_ThucTe,
    -1 AS KetQua_DuKien;

-- =========================================================
-- DỌN DẸP CUỐI CÙNG
-- =========================================================
DELETE FROM ap_dung_voucher WHERE ma_don_hang IN (@DH_OK1, @DH_OK2, @DH_PENDING);
DELETE FROM dat_hang WHERE ma_don_hang IN (@DH_OK1, @DH_OK2, @DH_PENDING);
DELETE FROM don_hang WHERE ma_don_hang IN (@DH_OK1, @DH_OK2, @DH_PENDING);
DELETE FROM phien_thanh_toan WHERE ma_phien_thanh_toan = @PH_ID;
DELETE FROM gio_hang WHERE ma_gio_hang = @GH_ID;

DELETE FROM voucher WHERE ma_voucher IN (@V_50K, @V_20K, @V_ZERO);
DELETE FROM nguoi_mua WHERE ma_nguoi_mua = @NM_ID_TEST;