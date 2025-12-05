-- 2.1.1 Thủ tục Thêm (INSERT) Người Mua
ALTER PROCEDURE sp_ThemNguoiMua
    @ma_nguoi_mua NVARCHAR(50),
    @ten_hien_thi NVARCHAR(200),
    @mat_khau NVARCHAR(200),
    @ngay_sinh DATE,
    @email NVARCHAR(200),
    @so_dien_thoai NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- [KIỂM TRA 1] Bắt buộc/NULL/Rỗng
    IF @ten_hien_thi IS NULL OR @ten_hien_thi = '' OR @mat_khau IS NULL OR @mat_khau = ''
    BEGIN
        THROW 50001, N'Lỗi: Tên hiển thị và Mật khẩu không được để trống.', 16;
        RETURN;
    END

    -- [KIỂM TRA 2] Mã người mua đã tồn tại
    IF EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @ma_nguoi_mua)
    BEGIN
        THROW 50002, N'Lỗi: Mã người mua đã tồn tại trong hệ thống. Vui lòng sử dụng mã khác.', 16;
        RETURN;
    END

    -- [KIỂM TRA 3] Email
    IF @email NOT LIKE '%@%.%'
    BEGIN
        THROW 50003, N'Lỗi: Định dạng Email không hợp lệ (Phải chứa "@" và ".").', 16;
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM nguoi_mua WHERE email = @email)
    BEGIN
        THROW 50004, N'Lỗi: Email này đã được đăng ký cho tài khoản khác.', 16;
        RETURN;
    END

    -- [KIỂM TRA 4] Tuổi (Phải trên 18 tuổi, chính xác theo ngày)
    IF DATEADD(year, 18, @ngay_sinh) > GETDATE()
    BEGIN
        THROW 50005, N'Lỗi: Người mua phải đủ 18 tuổi trở lên để đăng ký tài khoản.', 16;
        RETURN;
    END

    -- [BƯỚC BẢO MẬT] Băm mật khẩu (Giả định cột mat_khau là VARBINARY(256) hoặc VARCHAR)
    -- Nếu cột mat_khau là VARCHAR, bạn có thể lưu chuỗi băm
    DECLARE @MatKhauBam NVARCHAR(256);
    SET @MatKhauBam = CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', @mat_khau), 2);
    
    BEGIN TRY
        INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
        VALUES (@ma_nguoi_mua, @ten_hien_thi, @MatKhauBam, @ngay_sinh, @email, @so_dien_thoai, N'Hoạt động');
        
        PRINT N'Thêm người mua thành công.';
    END TRY
    BEGIN CATCH
        -- Ném lại lỗi nếu có lỗi SQL khác xảy ra (ví dụ: lỗi khóa ngoại)
        THROW;
    END CATCH
END
GO