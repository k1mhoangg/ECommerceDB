

IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = 'NM_DUP_ID')
BEGIN
    INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
    VALUES ('NM_DUP_ID', N'Duplicate Data', 'hash', '1980-01-01', 'duplicate@example.com', '123456789', N'Hoạt động');
END

PRINT '==================================================';
PRINT N'BẮT ĐẦU KIỂM TRA THỦ TỤC sp_ThemNguoiMua';
PRINT '==================================================';

-- 1. kiem tra loi 

-- kịch bản 1.1: lỗi bắt buộc / rỗng ( dự kiến: lỗi 50001)
BEGIN TRY
    EXEC sp_ThemNguoiMua 
        @ma_nguoi_mua = 'NM_FAIL_01', 
        @ten_hien_thi = NULL, -- gây lỗi bắt buộc/rỗng
        @mat_khau = 'pass', @ngay_sinh = '1990-01-01', 
        @email = 'fail_01@test.com', @so_dien_thoai = '123';
    PRINT N'LỖI KIỂM TRA 1.1: Không bắt được lỗi Bắt buộc/Rỗng.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50001
        PRINT N'TEST 1.1 (Bắt buộc/rỗng): PASS. Bắt được lỗi 50001: Tên hiển thị/Mật khẩu bị trống.';
    ELSE
        PRINT N'TEST 1.1 (Bắt buộc/Rỗng): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- kịch bản 1.2: lỗi trùng aã người mua (dự kiến: lỗi 50002)
BEGIN TRY
    EXEC sp_ThemNguoiMua 
        @ma_nguoi_mua = 'NM_DUP_ID', -- trùng với mã đã tạo
        @ten_hien_thi = N'Test ID Dup', @mat_khau = 'pass', @ngay_sinh = '1990-01-01', 
        @email = 'test_id_dup@test.com', @so_dien_thoai = '123';
    PRINT N'LỖI KIỂM TRA 1.2: Không bắt được lỗi Trùng ID.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50002
        PRINT N'TEST 1.2 (Trùng Mã ID): PASS. Bắt được lỗi 50002: Mã người mua đã tồn tại.';
    ELSE
        PRINT N'TEST 1.2 (Trùng Mã ID): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- kịch bản 1.3: lỗi dịnh dạng email (dự kiến: lỗi 50003)
BEGIN TRY
    EXEC sp_ThemNguoiMua 
        @ma_nguoi_mua = 'NM_FAIL_03', 
        @ten_hien_thi = N'Test Email Format', @mat_khau = 'pass', @ngay_sinh = '1990-01-01', 
        @email = 'email_sai_dinh_dang', -- thiếu "@%.%"
        @so_dien_thoai = '123';
    PRINT N'LỖI KIỂM TRA 1.3: Không bắt được lỗi Định dạng Email.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50003
        PRINT N'TEST 1.3 (Định dạng Email): PASS. Bắt được lỗi 50003: Định dạng Email không hợp lệ.';
    ELSE
        PRINT N'TEST 1.3 (Định dạng Email): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- kịch bản 1.4: lỗi trùng lặp email (dự kiến: lỗi 50004)
BEGIN TRY
    EXEC sp_ThemNguoiMua 
        @ma_nguoi_mua = 'NM_FAIL_04', 
        @ten_hien_thi = N'Test Email Dup', @mat_khau = 'pass', @ngay_sinh = '1990-01-01', 
        @email = 'duplicate@test.com', -- trùng email với dữ liệu mẫu
        @so_dien_thoai = '123';
    PRINT N'LỖI KIỂM TRA 1.4: Không bắt được lỗi Trùng Email.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50004
        PRINT N'TEST 1.4 (Trùng Email): PASS. Bắt được lỗi 50004: Email đã được đăng ký.';
    ELSE
        PRINT N'TEST 1.4 (Trùng Email): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- kịch bản 1.5: lỗi tuổi chưa đủ 18 (dự kiến: lỗi 50005)
DECLARE @NgaySinhChuaDuTuoi DATE = DATEADD(year, -17, GETDATE());
BEGIN TRY
    EXEC sp_ThemNguoiMua 
        @ma_nguoi_mua = 'NM_FAIL_05', 
        @ten_hien_thi = N'Test Age', @mat_khau = 'pass', @ngay_sinh = @NgaySinhChuaDuTuoi, 
        @email = 'test_age_fail@test.com', 
        @so_dien_thoai = '123';
    PRINT N'LỖI KIỂM TRA 1.5: Không bắt được lỗi Tuổi.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50005
        PRINT N'TEST 1.5 (Tuổi): PASS. Bắt được lỗi 50005: Chưa đủ 18 tuổi.';
    ELSE
        PRINT N'TEST 1.5 (Tuổi): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH

-----------------------------------------------------------
-- 2. KIỂM TRA THÀNH CÔNG (SUCCESS TEST)
-----------------------------------------------------------

DECLARE @MaThanhCong NVARCHAR(50) = 'NM_SUCCESS_FINAL_01';
DECLARE @EmailThanhCong NVARCHAR(200) = 'success_final_01@test.com';

EXEC sp_ThemNguoiMua 
    @ma_nguoi_mua = @MaThanhCong, 
    @ten_hien_thi = N'Người Mua Thành Công', 
    @mat_khau = 'Password123!', 
    @ngay_sinh = '1990-01-01', 
    @email = @EmailThanhCong, 
    @so_dien_thoai = '999999';

-- Bước xác minh dữ liệu đã chèn (Kiểm tra logic DML)
IF EXISTS(SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @MaThanhCong AND email = @EmailThanhCong AND trang_thai_tai_khoan = N'Hoạt động')
    PRINT N'TEST 2.1 (Thành công): PASS. Dữ liệu được chèn và trạng thái đúng.';
ELSE
    PRINT N'TEST 2.1 (Thành công): FAIL. Dữ liệu không được chèn hoặc chèn sai.';

PRINT '==================================================';
PRINT N'KẾT THÚC KIỂM TRA THỦ TỤC';
PRINT '==================================================';


-- xoa du lieu 
DELETE FROM nguoi_mua WHERE ma_nguoi_mua IN ('NM_DUP_ID', 'NM_SUCCESS_FINAL_01', 'NM_FAIL_03', 'NM_FAIL_04', 'NM_FAIL_05');