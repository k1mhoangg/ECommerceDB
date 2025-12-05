CREATE PROCEDURE sp_SuaNguoiMua
    @ma_nguoi_mua NVARCHAR(50),
    @ten_hien_thi_moi NVARCHAR(200),
    @email_moi NVARCHAR(200),
    @so_dien_thoai_moi NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- [KIỂM TRA A] Kiểm tra các trường bắt buộc cập nhật (ví dụ: không NULL/Rỗng)
    IF @ten_hien_thi_moi IS NULL OR @ten_hien_thi_moi = '' 
    BEGIN
        THROW 50000, N'Lỗi: Tên hiển thị không được để trống.', 16; 
        RETURN;
    END

    -- Kiểm tra 1: Tài khoản có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @ma_nguoi_mua)
    BEGIN
        THROW 50005, N'Lỗi: Không tìm thấy Mã người mua cần cập nhật.', 16;
        RETURN;
    END
    
    -- [KIỂM TRA B] Định dạng Email mới
    IF @email_moi NOT LIKE '%@%.%'
    BEGIN
        THROW 50006, N'Lỗi: Định dạng Email mới không hợp lệ.', 16; 
        RETURN;
    END

    -- Kiểm tra 2: Email mới đã được sử dụng bởi người khác chưa
    -- (Sử dụng lại mã 50007 để thống nhất việc kiểm tra trùng lặp email)
    IF EXISTS (SELECT 1 FROM nguoi_mua WHERE email = @email_moi AND ma_nguoi_mua <> @ma_nguoi_mua)
    BEGIN
        THROW 50007, N'Lỗi: Email mới đã được đăng ký cho tài khoản khác.', 16;
        RETURN;
    END
    
    -- Kiểm tra 3: Số điện thoại mới đã được sử dụng bởi người khác chưa
    -- (Sử dụng mã mới 50008 cho lỗi trùng lặp SĐT)
    IF EXISTS (SELECT 1 FROM nguoi_mua WHERE so_dien_thoai = @so_dien_thoai_moi AND ma_nguoi_mua <> @ma_nguoi_mua)
    BEGIN
        THROW 50008, N'Lỗi: Số điện thoại mới đã được đăng ký cho tài khoản khác.', 16;
        RETURN;
    END

    BEGIN TRY
        UPDATE nguoi_mua
        SET
            ten_hien_thi = @ten_hien_thi_moi,
            email = @email_moi,
            so_dien_thoai = @so_dien_thoai_moi
        WHERE ma_nguoi_mua = @ma_nguoi_mua;

        PRINT N'Cập nhật thông tin người mua thành công.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO