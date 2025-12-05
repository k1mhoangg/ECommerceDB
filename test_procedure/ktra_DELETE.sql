-- Dữ liệu mẫu cần dùng đã được định nghĩa ở bước trước
DECLARE @MaNguoiMuaSoft NVARCHAR(50) = 'NM_SOFT_DEL';
DECLARE @MaNguoiMuaHard NVARCHAR(50) = 'NM_HARD_DEL';
DECLARE @MaGioHang NVARCHAR(50) = 'GH_SOFT_DEL';
DECLARE @MaPhien NVARCHAR(50) = 'PH_SOFT_DEL';
DECLARE @MaDonHang NVARCHAR(50) = 'DH_TEST_S1';
DECLARE @MaDiaChi INT = 1;

DELETE FROM dat_hang WHERE ma_don_hang = @MaDonHang
DELETE FROM don_hang WHERE ma_don_hang = @MaDonHang;
DELETE FROM nguoi_mua WHERE ma_nguoi_mua IN (@MaNguoiMuaSoft, @MaNguoiMuaHard);


-- 1. Dữ liệu SOFT DELETE (Có lịch sử giao dịch)
-- Chèn theo thứ tự CHA TRƯỚC -> CON SAU
INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
VALUES (@MaNguoiMuaSoft, N'Soft Delete', 'hash1', '1990-01-01', 'soft@del.com', '2222', N'Hoạt động');

INSERT INTO gio_hang (ma_gio_hang, ma_nguoi_mua) VALUES (@MaGioHang, @MaNguoiMuaSoft);
INSERT INTO phien_thanh_toan (ma_phien_thanh_toan, ma_gio_hang) VALUES (@MaPhien, @MaGioHang);
INSERT INTO don_hang (ma_don_hang, ma_phien) VALUES (@MaDonHang, @MaPhien);
INSERT INTO dat_hang (ma_don_hang, ma_nguoi_mua) VALUES (@MaDonHang, @MaNguoiMuaSoft);


-- 2. Dữ liệu HARD DELETE (Không có đơn hàng, có dữ liệu phụ thuộc cần xóa)
INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
VALUES (@MaNguoiMuaHard, N'Hard Delete', 'hash2', '1995-01-01', 'hard@del.com', '1111', N'Hoạt động');

-- Thêm dữ liệu phụ thuộc (Địa chỉ) để kiểm tra CASCADE
INSERT INTO dia_chi (so_thu_tu, ma_nguoi_mua, dia_chi_chi_tiet) 
VALUES (@MaDiaChi, @MaNguoiMuaHard, N'Địa chỉ cần xóa');


PRINT '==================================================';
PRINT N'BẮT ĐẦU KIỂM TRA THỦ TỤC sp_XoaNguoiMua';
PRINT '==================================================';

-- Kịch bản 1: Lỗi Không Tồn tại (Dự kiến: Lỗi 50008)
BEGIN TRY
    EXEC sp_XoaNguoiMua @ma_nguoi_mua = 'MA_KHONG_TON_TAI_000';
    PRINT N'TEST 1 (Không tồn tại): LỖI. Không bắt được lỗi 50008.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50008
        PRINT N'TEST 1 (Không tồn tại): PASS. Bắt được lỗi 50008: Mã không tồn tại.';
    ELSE
        PRINT N'TEST 1 (Không tồn tại): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- Kịch bản 2: Soft Delete (Vô hiệu hóa) - Có đơn hàng
BEGIN TRY
    EXEC sp_XoaNguoiMua @ma_nguoi_mua = @MaNguoiMuaSoft;
    
    -- Xác minh trạng thái sau Soft Delete
    IF EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @MaNguoiMuaSoft AND trang_thai_tai_khoan = N'Vô hiệu hóa')
        PRINT N'TEST 2 (Soft Delete): PASS. Trạng thái đã chuyển sang "Vô hiệu hóa".';
    ELSE
        PRINT N'TEST 2 (Soft Delete): FAIL. Tài khoản bị xóa vật lý hoặc trạng thái sai.';
END TRY
BEGIN CATCH
    -- Bắt lỗi hệ thống nếu lệnh UPDATE thất bại
    PRINT N'TEST 2 (Soft Delete): LỖI HỆ THỐNG khi vô hiệu hóa (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- Kịch bản 3: Hard Delete (Xóa Vật lý) - Không có đơn hàng
BEGIN TRY
    EXEC sp_XoaNguoiMua @ma_nguoi_mua = @MaNguoiMuaHard;
    
    -- Xác minh sau Hard Delete (Kiểm tra bảng chính và bảng phụ thuộc)
    IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @MaNguoiMuaHard)
        AND NOT EXISTS (SELECT 1 FROM dia_chi WHERE ma_nguoi_mua = @MaNguoiMuaHard)
        PRINT N'TEST 3 (Hard Delete): PASS. Bản ghi và dữ liệu phụ thuộc (Địa chỉ) đã được xóa vật lý.';
    ELSE
        PRINT N'TEST 3 (Hard Delete): FAIL. Bản ghi vẫn còn tồn tại.';
END TRY
BEGIN CATCH
    -- Bắt lỗi hệ thống trong nhánh Hard Delete
    PRINT N'TEST 3 (Hard Delete): FAIL. Bị lỗi hệ thống khi xóa (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH

----------------------------------------------------------------------------------------------------

-- 3. DỌN DẸP CUỐI CÙNG
DELETE FROM dat_hang WHERE ma_don_hang = @MaDonHang;
DELETE FROM don_hang WHERE ma_don_hang = @MaDonHang;
DELETE FROM nguoi_mua WHERE ma_nguoi_mua IN (@MaNguoiMuaSoft, @MaNguoiMuaHard); 
-- Các lệnh DELETE khác cho GH, PTT, v.v. không cần thiết nhờ ON DELETE CASCADE