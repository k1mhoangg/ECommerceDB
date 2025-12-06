USE ECommerceDB;
GO

-- =============================================
-- 1. THỦ TỤC: THÊM NGƯỜI MUA
-- =============================================
CREATE OR ALTER PROCEDURE sp_ThemNguoiMua
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
        ;THROW 50001, N'Lỗi: Tên hiển thị và Mật khẩu không được để trống.', 16;
        RETURN;
    END

    -- [KIỂM TRA 2] Mã người mua đã tồn tại
    IF EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @ma_nguoi_mua)
    BEGIN
        ;THROW 50002, N'Lỗi: Mã người mua đã tồn tại trong hệ thống.', 16;
        RETURN;
    END

    -- [KIỂM TRA 3] Email
    IF @email NOT LIKE '%@%.%'
    BEGIN
        ;THROW 50003, N'Lỗi: Định dạng Email không hợp lệ.', 16;
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM nguoi_mua WHERE email = @email)
    BEGIN
        ;THROW 50004, N'Lỗi: Email này đã được đăng ký.', 16;
        RETURN;
    END

    -- [KIỂM TRA 4] Tuổi > 18
    IF DATEADD(year, 18, @ngay_sinh) > GETDATE()
    BEGIN
        ;THROW 50005, N'Lỗi: Người mua phải đủ 18 tuổi.', 16;
        RETURN;
    END

    -- Insert
    BEGIN TRY
        -- Giả lập băm mật khẩu đơn giản để demo
        INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, ngay_sinh, email, so_dien_thoai, trang_thai_tai_khoan)
        VALUES (@ma_nguoi_mua, @ten_hien_thi, @mat_khau, @ngay_sinh, @email, @so_dien_thoai, N'Hoạt động');
        
        PRINT N'Thêm người mua thành công.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- =============================================
-- 2. THỦ TỤC: SỬA NGƯỜI MUA
-- =============================================
CREATE OR ALTER PROCEDURE sp_SuaNguoiMua
    @ma_nguoi_mua NVARCHAR(50),
    @ten_hien_thi_moi NVARCHAR(200),
    @email_moi NVARCHAR(200),
    @so_dien_thoai_moi NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF @ten_hien_thi_moi IS NULL OR @ten_hien_thi_moi = '' 
    BEGIN
        ;THROW 50000, N'Lỗi: Tên hiển thị không được để trống.', 16; 
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @ma_nguoi_mua)
    BEGIN
        ;THROW 50005, N'Lỗi: Không tìm thấy Mã người mua.', 16;
        RETURN;
    END
    
    -- Check trùng Email (trừ chính mình)
    IF EXISTS (SELECT 1 FROM nguoi_mua WHERE email = @email_moi AND ma_nguoi_mua <> @ma_nguoi_mua)
    BEGIN
        ;THROW 50007, N'Lỗi: Email mới đã được sử dụng.', 16;
        RETURN;
    END
    
    BEGIN TRY
        UPDATE nguoi_mua
        SET ten_hien_thi = @ten_hien_thi_moi,
            email = @email_moi,
            so_dien_thoai = @so_dien_thoai_moi
        WHERE ma_nguoi_mua = @ma_nguoi_mua;
        PRINT N'Cập nhật thành công.';
    END TRY
    BEGIN CATCH
        ;THROW;
    END CATCH
END
GO

-- =============================================
-- 3. THỦ TỤC: XÓA NGƯỜI MUA (Đã sửa logic FK)
-- =============================================
CREATE OR ALTER PROCEDURE sp_XoaNguoiMua
    @ma_nguoi_mua NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @ma_nguoi_mua)
    BEGIN
        ;THROW 50008, N'Lỗi: Không tìm thấy Mã người mua.', 16;
        RETURN;
    END

    -- Kiểm tra xem đã mua hàng bao giờ chưa (dựa vào bảng don_hang và dat_hang)
    -- Nếu DB của bạn dùng bảng 'dat_hang' để nối User-Order:
    IF EXISTS (SELECT 1 FROM dat_hang WHERE ma_nguoi_mua = @ma_nguoi_mua)
    BEGIN
        UPDATE nguoi_mua 
        SET trang_thai_tai_khoan = N'Vô hiệu hóa'
        WHERE ma_nguoi_mua = @ma_nguoi_mua;

        PRINT N'Tài khoản có lịch sử giao dịch. Đã chuyển sang trạng thái "Vô hiệu hóa".';
        RETURN;
    END
    ELSE
    BEGIN
        -- XÓA VẬT LÝ (Xóa dữ liệu liên quan trước)
        BEGIN TRANSACTION;
        BEGIN TRY
            DELETE FROM tai_khoan_ngan_hang WHERE ma_nguoi_mua = @ma_nguoi_mua;
            DELETE FROM dia_chi WHERE ma_nguoi_mua = @ma_nguoi_mua;
            DELETE FROM so_huu_voucher WHERE ma_nguoi_mua = @ma_nguoi_mua;
            DELETE FROM theo_doi WHERE ma_nguoi_mua = @ma_nguoi_mua;
            DELETE FROM viet_danh_gia WHERE ma_nguoi_mua = @ma_nguoi_mua;
            DELETE FROM lien_he WHERE ma_nguoi_mua = @ma_nguoi_mua;
            
            -- Xóa giỏ hàng (phải xóa item trong giỏ trước)
            DELETE FROM san_pham_trong_gio WHERE ma_gio_hang IN (SELECT ma_gio_hang FROM gio_hang WHERE ma_nguoi_mua = @ma_nguoi_mua);
            DELETE FROM gio_hang WHERE ma_nguoi_mua = @ma_nguoi_mua;
            

            DELETE FROM san_pham WHERE ma_nguoi_ban IN (SELECT ma_nguoi_ban FROM nguoi_ban WHERE ma_nguoi_mua = @ma_nguoi_mua);
            DELETE FROM nguoi_ban WHERE ma_nguoi_mua = @ma_nguoi_mua;
            -- Cuối cùng xóa User
            DELETE FROM nguoi_mua WHERE ma_nguoi_mua = @ma_nguoi_mua;
            
            COMMIT TRANSACTION;
            PRINT N'Xóa người mua vĩnh viễn thành công.';
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            THROW;
        END CATCH
    END
END
GO

-- =============================================
-- 4. TRIGGER: NGƯỜI BÁN KHÔNG TỰ MUA HÀNG
-- =============================================
-- Xóa trigger cũ nếu tồn tại để tránh lỗi 'Already exists'
IF OBJECT_ID('trg_KiemTraTuMuaHangCuaMinh', 'TR') IS NOT NULL 
    DROP TRIGGER trg_KiemTraTuMuaHangCuaMinh;
GO

CREATE TRIGGER trg_KiemTraTuMuaHangCuaMinh
ON san_pham_trong_gio
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inserted i
            JOIN gio_hang gh ON i.ma_gio_hang = gh.ma_gio_hang
            JOIN san_pham sp ON i.ma_san_pham = sp.ma_san_pham
            JOIN nguoi_ban nb ON sp.ma_nguoi_ban = nb.ma_nguoi_ban
        WHERE gh.ma_nguoi_mua = nb.ma_nguoi_mua
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR(N'Lỗi: Người bán không thể tự thêm sản phẩm của chính mình vào giỏ.', 16, 1);
    END
END;
GO

-- =============================================
-- 5. TRIGGER: CẬP NHẬT TỔNG TIỀN ĐƠN HÀNG
-- =============================================
IF OBJECT_ID('trg_TinhTongTienDonHang', 'TR') IS NOT NULL 
    DROP TRIGGER trg_TinhTongTienDonHang;
GO

CREATE TRIGGER trg_TinhTongTienDonHang
ON san_pham_trong_don
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DonHangBiAnhHuong TABLE (ma_don_hang NVARCHAR(50));

    INSERT INTO @DonHangBiAnhHuong (ma_don_hang)
    SELECT DISTINCT ma_don_hang FROM inserted
    UNION
    SELECT DISTINCT ma_don_hang FROM deleted;

    UPDATE dh
    SET 
        dh.tong_so_luong = ISNULL(TinhToan.TongSL, 0),
        dh.tong_tien = ISNULL(TinhToan.TongTien, 0)
    FROM don_hang dh
    LEFT JOIN (
        SELECT 
            ct.ma_don_hang,
            SUM(ct.so_luong) AS TongSL,
            -- Giả sử tính tiền theo giá hiện hành trong bảng bien_the
            SUM(ct.so_luong * bt.gia_hien_hanh) AS TongTien
        FROM san_pham_trong_don ct
        JOIN bien_the bt ON ct.ma_bien_the = bt.ma_bien_the AND ct.ma_san_pham = bt.ma_san_pham
        WHERE ct.ma_don_hang IN (SELECT ma_don_hang FROM @DonHangBiAnhHuong)
        GROUP BY ct.ma_don_hang
    ) TinhToan ON dh.ma_don_hang = TinhToan.ma_don_hang
    WHERE dh.ma_don_hang IN (SELECT ma_don_hang FROM @DonHangBiAnhHuong);
END;
GO

-- =============================================
-- 6. TRIGGER: TRỪ TỒN KHO
-- =============================================
IF OBJECT_ID('trg_CapNhatTonKho', 'TR') IS NOT NULL 
    DROP TRIGGER trg_CapNhatTonKho;
GO

CREATE TRIGGER trg_CapNhatTonKho
ON san_pham_trong_don
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Hoàn trả kho (khi XÓA khỏi đơn)
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE bt
        SET bt.so_luong_con_lai = bt.so_luong_con_lai + d.so_luong
        FROM bien_the bt
        JOIN deleted d ON bt.ma_bien_the = d.ma_bien_the AND bt.ma_san_pham = d.ma_san_pham;
    END

    -- Trừ kho (khi THÊM vào đơn)
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Validate tồn kho
        IF EXISTS (
            SELECT 1 
            FROM bien_the bt
            JOIN inserted i ON bt.ma_bien_the = i.ma_bien_the AND bt.ma_san_pham = i.ma_san_pham
            WHERE bt.so_luong_con_lai < i.so_luong
        )
        BEGIN
            RAISERROR(N'Lỗi: Số lượng tồn kho không đủ.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE bt
        SET bt.so_luong_con_lai = bt.so_luong_con_lai - i.so_luong
        FROM bien_the bt
        JOIN inserted i ON bt.ma_bien_the = i.ma_bien_the AND bt.ma_san_pham = i.ma_san_pham;
    END
END;
GO

-- =============================================
-- 7. THỦ TỤC: TRA CỨU LỊCH SỬ MUA HÀNG
-- =============================================
CREATE OR ALTER PROCEDURE sp_TraCuuLichSuMuaHang
    @tu_khoa_ten NVARCHAR(200)
AS
BEGIN
    SELECT 
        NM.ma_nguoi_mua,
        NM.ten_hien_thi,
        NM.so_dien_thoai,
        DH.ma_don_hang,
        DH.ngay_dat_hang,
        DH.tong_tien    
    FROM nguoi_mua NM
    
    JOIN dat_hang DAT ON NM.ma_nguoi_mua = DAT.ma_nguoi_mua
    JOIN don_hang DH ON DAT.ma_don_hang = DH.ma_don_hang
    WHERE 
        NM.ten_hien_thi LIKE '%' + @tu_khoa_ten + '%'
    ORDER BY 
        DH.ngay_dat_hang DESC;
END;
GO

-- =============================================
-- 8. THỦ TỤC: THỐNG KÊ DOANH THU
-- =============================================
CREATE OR ALTER PROCEDURE sp_ThongKeDoanhThuSanPham
    @Thang INT,
    @Nam INT,
    @SoLuongToiThieu INT
AS
BEGIN
    SELECT 
        SP.ma_san_pham, 
        SP.ten,
        SUM(CT.so_luong) AS TongSoLuongBan,
        SUM(CT.so_luong * BT.gia_hien_hanh)  AS TongDoanhThu 
    FROM san_pham SP
    JOIN bien_the BT ON SP.ma_san_pham = BT.ma_san_pham
    JOIN san_pham_trong_don CT ON BT.ma_bien_the = CT.ma_bien_the AND BT.ma_san_pham = CT.ma_san_pham
    JOIN don_hang DH ON CT.ma_don_hang = DH.ma_don_hang
    WHERE 
        MONTH(DH.ngay_dat_hang) = @Thang 
        AND YEAR(DH.ngay_dat_hang) = @Nam
        -- AND DH.trang_thai_don_hang = N'Hoàn thành' (Bỏ comment nếu muốn lọc trạng thái)
    GROUP BY 
        SP.ma_san_pham, SP.ten
    HAVING 
        SUM(CT.so_luong) >= @SoLuongToiThieu
    ORDER BY 
        TongDoanhThu DESC;
END;
GO

-- =============================================
-- 9. HÀM: TÍNH TỔNG CHIẾT KHẤU
-- =============================================
CREATE OR ALTER FUNCTION fn_TinhTongGiaTriChietKhau (@Ma_nguoi_mua NVARCHAR(50))
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TongChietKhau DECIMAL(18,2) = 0;
    DECLARE @MaDonHang NVARCHAR(50);
    DECLARE @GiaTriGiam DECIMAL(18,2);

    -- Kiểm tra tồn tại
    IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @Ma_nguoi_mua)
        RETURN -1; 

    DECLARE VoucherCursor CURSOR FOR
    SELECT
        adv.ma_don_hang,
        v.gia_tri_giam_gia 
    FROM ap_dung_voucher adv
    INNER JOIN voucher v ON adv.ma_voucher = v.ma_voucher
    INNER JOIN don_hang od ON adv.ma_don_hang = od.ma_don_hang
    -- Cần join bảng đặt hàng để biết đơn của ai
    INNER JOIN dat_hang dh ON od.ma_don_hang = dh.ma_don_hang
    WHERE 
        dh.ma_nguoi_mua = @Ma_nguoi_mua 
        -- AND od.trang_thai_don_hang = N'Hoàn thành'
    
    OPEN VoucherCursor;
    FETCH NEXT FROM VoucherCursor INTO @MaDonHang, @GiaTriGiam;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @GiaTriGiam IS NOT NULL AND @GiaTriGiam > 0
        BEGIN
            SET @TongChietKhau = @TongChietKhau + @GiaTriGiam;
        END
        FETCH NEXT FROM VoucherCursor INTO @MaDonHang, @GiaTriGiam;
    END

    CLOSE VoucherCursor;
    DEALLOCATE VoucherCursor;

    RETURN @TongChietKhau;
END
GO

-- =============================================
-- 10. HÀM: PHÂN LOẠI NGƯỜI BÁN
-- =============================================
CREATE OR ALTER FUNCTION fn_PhanLoaiHieuSuatNguoiBan (@Ma_nguoi_ban NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @TongDanhGia5Sao INT = 0;
    DECLARE @MaDonHang NVARCHAR(50);
    DECLARE @SoSao INT;
    DECLARE @PhanLoai NVARCHAR(50);

    IF NOT EXISTS (SELECT 1 FROM nguoi_ban WHERE ma_nguoi_ban = @Ma_nguoi_ban)
        RETURN N'Không tìm thấy Người bán';

    DECLARE ReviewCursor CURSOR FOR 
    SELECT 
        dg.ma_don_hang,
        dg.so_sao
    FROM danh_gia dg
    INNER JOIN san_pham_trong_don spd ON dg.ma_don_hang = spd.ma_don_hang AND dg.so_thu_tu_dong = spd.so_thu_tu_dong
    INNER JOIN san_pham sp ON spd.ma_san_pham = sp.ma_san_pham 
    WHERE sp.ma_nguoi_ban = @Ma_nguoi_ban;

    OPEN ReviewCursor;
    FETCH NEXT FROM ReviewCursor INTO @MaDonHang, @SoSao;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @SoSao = 5
            SET @TongDanhGia5Sao = @TongDanhGia5Sao + 1;
            
        FETCH NEXT FROM ReviewCursor INTO @MaDonHang, @SoSao;
    END

    CLOSE ReviewCursor;
    DEALLOCATE ReviewCursor;

    IF @TongDanhGia5Sao >= 100 SET @PhanLoai = N'Kim cương';
    ELSE IF @TongDanhGia5Sao >= 50 SET @PhanLoai = N'Vàng';
    ELSE IF @TongDanhGia5Sao >= 10 SET @PhanLoai = N'Bạc';
    ELSE SET @PhanLoai = N'Đồng';

    RETURN @PhanLoai;
END
GO

CREATE OR ALTER PROCEDURE sp_LayTenNguoiMua
    @tu_khoa_ten NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ma_nguoi_mua, ten_hien_thi, email, so_dien_thoai
    FROM nguoi_mua NM
    WHERE NM.ten_hien_thi LIKE '%' + @tu_khoa_ten + '%';
END
GO

