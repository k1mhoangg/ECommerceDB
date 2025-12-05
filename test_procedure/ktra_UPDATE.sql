
-- chuẩn bị dữ liệu mẫu cho việc kiểm tra
-- dữ liệu sẽ được cập nhật
IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = 'NM_UPDATE_TEST')
BEGIN
    INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
    VALUES ('NM_UPDATE_TEST', N'Người Dùng Cũ', 'hash_old', '1990-01-01', 'old@test.com', '10000', N'Hoạt động');
END
-- dữ liệu trùng (để ktra lỗi 50007/50008)
IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = 'NM_DUP_DATA')
BEGIN
    INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
    VALUES ('NM_DUP_DATA', N'Dữ liệu Trùng', 'hash_dup', '1985-01-01', 'dup@test.com', '20000', N'Hoạt động');
END

PRINT '==================================================';
PRINT N'BẮT ĐẦU KIỂM TRA THỦ TỤC sp_SuaNguoiMua';
PRINT '==================================================';

-- kịch bản 1.1: Lỗi Bắt buộc/Rỗng (Dự kiến: Lỗi 50000)
BEGIN TRY
    EXEC sp_SuaNguoiMua 
        @ma_nguoi_mua = 'NM_UPDATE_TEST', 
        @ten_hien_thi_moi = '', -- Lỗi rỗng
        @email_moi = 'fail@test.com', @so_dien_thoai_moi = '10000';
    PRINT N'LỖI KIỂM TRA 1.1: Không bắt được lỗi 50000.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50000
        PRINT N'TEST 1.1 (Bắt buộc/Rỗng): PASS. Bắt được lỗi 50000.';
    ELSE
        PRINT N'TEST 1.1 (Bắt buộc/Rỗng): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- kịch bản 1.2: ỗi tài khoản không tồn tại (dự kiến: lỗi 50005)
BEGIN TRY
    EXEC sp_SuaNguoiMua 
        @ma_nguoi_mua = 'MA_KHONG_CO', -- Mã không tồn tại
        @ten_hien_thi_moi = N'Tên Mới', @email_moi = 'new@test.com', @so_dien_thoai_moi = '30000';
    PRINT N'LỖI KIỂM TRA 1.2: Không bắt được lỗi 50005.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50005
        PRINT N'TEST 1.2 (Không Tồn tại): PASS. Bắt được lỗi 50005.';
    ELSE
        PRINT N'TEST 1.2 (Không Tồn tại): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- kịch bản 1.3: lỗi định dạng Email sai (dự kiến: lỗi 50006)
BEGIN TRY
    EXEC sp_SuaNguoiMua 
        @ma_nguoi_mua = 'NM_UPDATE_TEST', 
        @ten_hien_thi_moi = N'Tên Mới', @email_moi = 'email_sai_dinh_dang', -- Lỗi định dạng
        @so_dien_thoai_moi = '10000';
    PRINT N'LỖI KIỂM TRA 1.3: Không bắt được lỗi 50006.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50006
        PRINT N'TEST 1.3 (Định dạng Email): PASS. Bắt được lỗi 50006.';
    ELSE
        PRINT N'TEST 1.3 (Định dạng Email): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- kịch bản 1.4: lỗi trùng email với người khác (dự kiến: Lỗi 50007)
BEGIN TRY
    EXEC sp_SuaNguoiMua 
        @ma_nguoi_mua = 'NM_UPDATE_TEST', 
        @ten_hien_thi_moi = N'Tên Mới', 
        @email_moi = 'dup@test.com', -- TRÙNG với NM_DUP_DATA
        @so_dien_thoai_moi = '10000';
    PRINT N'LỖI KIỂM TRA 1.4: Không bắt được lỗi 50007.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50007
        PRINT N'TEST 1.4 (Trùng Email): PASS. Bắt được lỗi 50007.';
    ELSE
        PRINT N'TEST 1.4 (Trùng Email): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH


-- kịch bản 1.5: lỗi trùng SĐT với người khác (dự kiến: lỗi 50008)
BEGIN TRY
    EXEC sp_SuaNguoiMua 
        @ma_nguoi_mua = 'NM_UPDATE_TEST', 
        @ten_hien_thi_moi = N'Tên Mới', 
        @email_moi = 'new_unique@test.com', 
        @so_dien_thoai_moi = '20000'; -- TRÙNG với SĐT của NM_DUP_DATA
    PRINT N'LỖI KIỂM TRA 1.5: Không bắt được lỗi 50008.';
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50008
        PRINT N'TEST 1.5 (Trùng SĐT): PASS. Bắt được lỗi 50008.';
    ELSE
        PRINT N'TEST 1.5 (Trùng SĐT): FAIL. Bắt được lỗi khác (Msg: ' + ERROR_MESSAGE() + ')';
END CATCH

-- kịch bản 2.1: cập nhật thành công
DECLARE @EmailMoi NVARCHAR(200) = 'update_success@test.com';
DECLARE @TenMoi NVARCHAR(200) = N'Tên đã Cập nhật';

EXEC sp_SuaNguoiMua 
    @ma_nguoi_mua = 'NM_UPDATE_TEST', 
    @ten_hien_thi_moi = @TenMoi, 
    @email_moi = @EmailMoi, 
    @so_dien_thoai_moi = '55555'; -- Giá trị hoàn toàn mới

-- Bước xác minh dữ liệu đã cập nhật
IF EXISTS(SELECT 1 FROM nguoi_mua 
          WHERE ma_nguoi_mua = 'NM_UPDATE_TEST' 
            AND ten_hien_thi = @TenMoi
            AND email = @EmailMoi
            AND so_dien_thoai = '55555')
    PRINT N'TEST 2.1 (Thành công): PASS. Cập nhật dữ liệu chính xác.';
ELSE
    PRINT N'TEST 2.1 (Thành công): FAIL. Dữ liệu không được cập nhật hoặc cập nhật sai.';

PRINT '==================================================';
PRINT N'KẾT THÚC KIỂM TRA THỦ TỤC SỬA';
PRINT '==================================================';

-- DỌN DẸP DỮ LIỆU
DELETE FROM nguoi_mua WHERE ma_nguoi_mua IN ('NM_UPDATE_TEST', 'NM_DUP_DATA');