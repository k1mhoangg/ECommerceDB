USE ECommerceDB;
GO

-- =========================================================
-- KHAI BÁO BIẾN CHUNG VÀ DỌN DẸP (PHẢI TRONG CÙNG 1 BATCH)
-- =========================================================

-- Khai báo tất cả các biến CSDL cần thiết để tránh lỗi scope
DECLARE @NB_ID_TEST NVARCHAR(50) = 'NB_HIEU_SUAT';
DECLARE @NM_ID_TEMP NVARCHAR(50) = 'NM_TEMP_R';
DECLARE @SP_ID NVARCHAR(50) = 'SP_R_TEST';
DECLARE @DM_ID NVARCHAR(50) = 'DM_TEST_R';
DECLARE @BT_ID NVARCHAR(50) = 'BT_TEST_R';
DECLARE @AD_ID NVARCHAR(50) = 'AD_TEST_R';
DECLARE @PH_ID NVARCHAR(50) = 'PH_R_TEST';
DECLARE @GH_ID NVARCHAR(50) = 'GH_R_TEST';

DELETE FROM danh_gia WHERE ma_san_pham = @SP_ID;
DELETE FROM san_pham_trong_don WHERE ma_san_pham = @SP_ID;
DELETE FROM don_hang WHERE ma_phien = @PH_ID;
DELETE FROM phien_thanh_toan WHERE ma_phien_thanh_toan = @PH_ID;
DELETE FROM gio_hang WHERE ma_gio_hang = @GH_ID;
DELETE FROM bien_the WHERE ma_san_pham = @SP_ID;
DELETE FROM san_pham WHERE ma_san_pham = @SP_ID;
DELETE FROM nguoi_ban WHERE ma_nguoi_ban = @NB_ID_TEST;
DELETE FROM nguoi_mua WHERE ma_nguoi_mua = @NM_ID_TEMP;
DELETE FROM danh_muc_hang_hoa WHERE ma_danh_muc = @DM_ID;
DELETE FROM admin WHERE ma_admin = @AD_ID;

-- 1. sp_TaoDanhGia

DROP PROCEDURE IF EXISTS sp_TaoDanhGia;
GO
CREATE PROCEDURE sp_TaoDanhGia (@SoLuong INT, @SoSao INT, @MaNguoiBan NVARCHAR(50), @MaSanPham NVARCHAR(50), @MaBienThe NVARCHAR(50), @BaseDHID NVARCHAR(50), @MaPhienTT NVARCHAR(50))
AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= @SoLuong
    BEGIN
        DECLARE @MaDonHang NVARCHAR(50) = @BaseDHID + CAST(@i AS NVARCHAR(10));
        
        INSERT INTO don_hang (ma_don_hang, ma_phien, ngay_dat_hang, trang_thai_don_hang, tong_tien, tong_so_luong) 
        VALUES (@MaDonHang, @MaPhienTT, GETDATE(), N'Hoàn thành', 1, 1);
        
        INSERT INTO san_pham_trong_don (ma_don_hang, so_thu_tu_dong, ma_san_pham, ma_bien_the)
        VALUES (@MaDonHang, 1, @MaSanPham, @MaBienThe);
        
        -- Chèn Đánh giá (DG)
        INSERT INTO danh_gia (ma_danh_gia, so_sao, thoi_gian, ma_don_hang, so_thu_tu_dong, ma_bien_the, ma_san_pham)
        VALUES (N'DG_' + @BaseDHID + CAST(@i AS NVARCHAR(10)), @SoSao, GETDATE(), @MaDonHang, 1, @MaBienThe, @MaSanPham);
        
        SET @i = @i + 1;
    END
END
GO


-- 2. BASE DATA

BEGIN
    -- [RE-DECLARE CÁC BIẾN CSDL]
    DECLARE @NB_ID_TEST NVARCHAR(50) = 'NB_HIEU_SUAT';
    DECLARE @NM_ID_TEMP NVARCHAR(50) = 'NM_TEMP_R';
    DECLARE @SP_ID NVARCHAR(50) = 'SP_R_TEST';
    DECLARE @DM_ID NVARCHAR(50) = 'DM_TEST_R';
    DECLARE @BT_ID NVARCHAR(50) = 'BT_TEST_R';
    DECLARE @AD_ID NVARCHAR(50) = 'AD_TEST_R';
    DECLARE @PH_ID NVARCHAR(50) = 'PH_R_TEST';
    DECLARE @GH_ID NVARCHAR(50) = 'GH_R_TEST';

    INSERT INTO danh_muc_hang_hoa (ma_danh_muc, ten_danh_muc) VALUES (@DM_ID, N'Test Danh Mục');
    INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
    VALUES (@NM_ID_TEMP, N'User Review', 'hash', '1990-01-01', 'review@test.com', '123', N'Hoạt động');
    INSERT INTO admin (ma_admin, mat_khau) VALUES (@AD_ID, 'admhash');
    INSERT INTO nguoi_ban (ma_nguoi_ban, ma_nguoi_mua, ten_cua_hang, cccd) VALUES (@NB_ID_TEST, @NM_ID_TEMP, N'Shop Test', '1111');
    INSERT INTO san_pham (ma_san_pham, ma_nguoi_ban, ten, ma_danh_muc) VALUES (@SP_ID, @NB_ID_TEST, N'Sản phẩm A', @DM_ID);
    INSERT INTO bien_the (ma_bien_the, ma_san_pham, gia_hien_hanh) VALUES (@BT_ID, @SP_ID, 100);
    
    -- các đối tượng phụ thuộc FK cho đơn hàng
    INSERT INTO gio_hang (ma_gio_hang, ma_nguoi_mua) VALUES (@GH_ID, @NM_ID_TEMP);
    INSERT INTO phien_thanh_toan (ma_phien_thanh_toan, ma_gio_hang) VALUES (@PH_ID, @GH_ID);
END
GO


-- 3. THỰC HIỆN CÁC KỊCH BẢN KIỂM TRA PHÂN LOẠI
PRINT '==================================================';
PRINT N'BẮT ĐẦU KIỂM TRA HÀM PHÂN LOẠI HIỆU SUẤT';
PRINT '==================================================';

-- Khai báo biến CSDL cần thiết cho EXEC
DECLARE @NB_ID_TEST NVARCHAR(50) = 'NB_HIEU_SUAT';
DECLARE @SP_ID NVARCHAR(50) = 'SP_R_TEST';
DECLARE @BT_ID NVARCHAR(50) = 'BT_TEST_R';
DECLARE @PH_ID NVARCHAR(50) = 'PH_R_TEST';


-- KỊCH BẢN F1: Người bán không tồn tại 
SELECT 
    N'F1 (Không tồn tại)' AS KichBan,
    dbo.fn_PhanLoaiHieuSuatNguoiBan('NB_KHONG_CO_TRONG_DB') AS PhanLoai_ThucTe;


-- KỊCH BẢN F2: Cấp ĐỒNG (5 đánh giá 5 sao)
EXEC sp_TaoDanhGia @SoLuong = 5, @SoSao = 5, @MaNguoiBan = @NB_ID_TEST, @MaSanPham = @SP_ID, @MaBienThe = @BT_ID, @BaseDHID = 'DH_DONG_', @MaPhienTT = @PH_ID;
SELECT 
    N'F2 (Cấp ĐỒNG)' AS KichBan,
    dbo.fn_PhanLoaiHieuSuatNguoiBan(@NB_ID_TEST) AS PhanLoai_ThucTe;

-- DỌN DẸP DỮ LIỆU ĐỂ CHUYỂN CẤP
DELETE FROM danh_gia WHERE ma_don_hang LIKE 'DH_DONG_%';
DELETE FROM san_pham_trong_don WHERE ma_don_hang LIKE 'DH_DONG_%';
DELETE FROM don_hang WHERE ma_don_hang LIKE 'DH_DONG_%';


-- KỊCH BẢN F3: Cấp BẠC (15 đánh giá 5 sao)
EXEC sp_TaoDanhGia @SoLuong = 15, @SoSao = 5, @MaNguoiBan = @NB_ID_TEST, @MaSanPham = @SP_ID, @MaBienThe = @BT_ID, @BaseDHID = 'DH_BAC_', @MaPhienTT = @PH_ID;
SELECT 
    N'F3 (Cấp BẠC)' AS KichBan,
    dbo.fn_PhanLoaiHieuSuatNguoiBan(@NB_ID_TEST) AS PhanLoai_ThucTe;

-- DỌN DẸP DỮ LIỆU ĐỂ CHUYỂN CẤP
DELETE FROM danh_gia WHERE ma_don_hang LIKE 'DH_BAC_%';
DELETE FROM san_pham_trong_don WHERE ma_don_hang LIKE 'DH_BAC_%';
DELETE FROM don_hang WHERE ma_don_hang LIKE 'DH_BAC_%';


-- KỊCH BẢN F4: Cấp VÀNG (60 đánh giá 5 sao)
EXEC sp_TaoDanhGia @SoLuong = 60, @SoSao = 5, @MaNguoiBan = @NB_ID_TEST, @MaSanPham = @SP_ID, @MaBienThe = @BT_ID, @BaseDHID = 'DH_VANG_', @MaPhienTT = @PH_ID;
SELECT 
    N'F4 (Cấp VÀNG)' AS KichBan,
    dbo.fn_PhanLoaiHieuSuatNguoiBan(@NB_ID_TEST) AS PhanLoai_ThucTe;

-- DỌN DẸP DỮ LIỆU ĐỂ CHUYỂN CẤP
DELETE FROM danh_gia WHERE ma_don_hang LIKE 'DH_VANG_%';
DELETE FROM san_pham_trong_don WHERE ma_don_hang LIKE 'DH_VANG_%';
DELETE FROM don_hang WHERE ma_don_hang LIKE 'DH_VANG_%';


-- KỊCH BẢN F5:  Cấp KIM CƯƠNG (105 đánh giá 5 sao)
EXEC sp_TaoDanhGia @SoLuong = 105, @SoSao = 5, @MaNguoiBan = @NB_ID_TEST, @MaSanPham = @SP_ID, @MaBienThe = @BT_ID, @BaseDHID = 'DH_KC_', @MaPhienTT = @PH_ID;
SELECT 
    N'F5 (Cấp KIM CƯƠNG)' AS KichBan,
    dbo.fn_PhanLoaiHieuSuatNguoiBan(@NB_ID_TEST) AS PhanLoai_ThucTe;


-- 4. DỌN DẸP CUỐI CÙNG
BEGIN
    DECLARE @NM_ID_TEMP NVARCHAR(50) = 'NM_TEMP_R';
    DECLARE @DM_ID NVARCHAR(50) = 'DM_TEST_R';
    DECLARE @AD_ID NVARCHAR(50) = 'AD_TEST_R';
    DECLARE @GH_ID NVARCHAR(50) = 'GH_R_TEST';

    -- Xóa dữ liệu cuối cùng
    DELETE FROM danh_gia WHERE ma_don_hang LIKE 'DH_KC_%';
    DELETE FROM san_pham_trong_don WHERE ma_don_hang LIKE 'DH_KC_%';
    DELETE FROM don_hang WHERE ma_don_hang LIKE 'DH_KC_%';

    DROP PROCEDURE IF EXISTS sp_TaoDanhGia;
    DELETE FROM phien_thanh_toan WHERE ma_phien_thanh_toan = @PH_ID;
    DELETE FROM gio_hang WHERE ma_gio_hang = @GH_ID;
    DELETE FROM bien_the WHERE ma_san_pham = @SP_ID;
    DELETE FROM san_pham WHERE ma_san_pham = @SP_ID;
    DELETE FROM nguoi_ban WHERE ma_nguoi_ban = @NB_ID_TEST;
    DELETE FROM nguoi_mua WHERE ma_nguoi_mua = @NM_ID_TEMP;
    DELETE FROM danh_muc_hang_hoa WHERE ma_danh_muc = @DM_ID;
    DELETE FROM admin WHERE ma_admin = @AD_ID;
END
GO