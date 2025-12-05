-- Hàm 2: Phân loại Hiệu suất Người bán dựa trên Đánh giá 5 sao
-- Yêu cầu: IF, LOOP, Cursor, Truy vấn, Kiểm tra tham số
CREATE OR ALTER FUNCTION fn_PhanLoaiHieuSuatNguoiBan (@Ma_nguoi_ban NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @TongDanhGia5Sao INT = 0;
    DECLARE @MaDonHang NVARCHAR(50);
    DECLARE @SoSao INT;
    DECLARE @PhanLoai NVARCHAR(50);

    -- 1. Kiểm tra tham số đầu vào (Kiểm tra sự tồn tại của Người bán)
    IF NOT EXISTS (SELECT 1 FROM nguoi_ban WHERE ma_nguoi_ban = @Ma_nguoi_ban)
        RETURN N'Không tìm thấy Người bán';

    -- 2. Khai báo Con trỏ (Cursor)
    -- Duyệt qua tất cả các đánh giá liên quan đến các đơn hàng có sản phẩm của người bán này
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

    -- 3. LOOP để duyệt qua các đánh giá
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- 4. IF/Tính toán: Kiểm tra và cộng dồn số lượng đánh giá 5 sao
        IF @SoSao = 5
        BEGIN
            SET @TongDanhGia5Sao = @TongDanhGia5Sao + 1;
        END

        FETCH NEXT FROM ReviewCursor INTO @MaDonHang, @SoSao;
    END

    CLOSE ReviewCursor;
    DEALLOCATE ReviewCursor;

    -- 5. Logic phân loại (IF ELSE IF)
    IF @TongDanhGia5Sao >= 100
        SET @PhanLoai = N'Kim cương';
    ELSE IF @TongDanhGia5Sao >= 50
        SET @PhanLoai = N'Vàng';
    ELSE IF @TongDanhGia5Sao >= 10
        SET @PhanLoai = N'Bạc';
    ELSE
        SET @PhanLoai = N'Đồng';

    RETURN @PhanLoai;
END
GO


-- Hàm 2: Phân loại Hiệu suất Người bán dựa trên Đánh giá 5 sao
ALTER FUNCTION fn_PhanLoaiHieuSuatNguoiBan (@Ma_nguoi_ban NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @TongDanhGia5Sao INT = 0;
    DECLARE @MaDonHang NVARCHAR(50);
    DECLARE @SoSao INT;
    DECLARE @PhanLoai NVARCHAR(50);

    -- 1. Kiểm tra tham số đầu vào (Kiểm tra sự tồn tại của Người bán)
    IF NOT EXISTS (SELECT 1 FROM nguoi_ban WHERE ma_nguoi_ban = @Ma_nguoi_ban)
        RETURN N'Không tìm thấy Người bán';

    -- 2. Khai báo Con trỏ (Cursor)
    DECLARE ReviewCursor CURSOR LOCAL FAST_FORWARD FOR 
    SELECT 
        dg.ma_don_hang,
        dg.so_sao
    FROM danh_gia dg
    -- Nối đến SP trong Đơn để tìm sản phẩm thuộc đơn hàng này
    INNER JOIN san_pham_trong_don spd ON dg.ma_don_hang = spd.ma_don_hang AND dg.so_thu_tu_dong = spd.so_thu_tu_dong
    -- Nối đến Sản phẩm để lọc theo Người bán
    INNER JOIN san_pham sp ON spd.ma_san_pham = sp.ma_san_pham 
    WHERE sp.ma_nguoi_ban = @Ma_nguoi_ban;

    OPEN ReviewCursor;
    FETCH NEXT FROM ReviewCursor INTO @MaDonHang, @SoSao;

    -- 3. LOOP để duyệt qua các đánh giá
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- 4. IF/Tính toán: Kiểm tra và cộng dồn số lượng đánh giá 5 sao
        IF @SoSao = 5
        BEGIN
            SET @TongDanhGia5Sao = @TongDanhGia5Sao + 1;
        END

        FETCH NEXT FROM ReviewCursor INTO @MaDonHang, @SoSao;
    END

    CLOSE ReviewCursor;
    DEALLOCATE ReviewCursor;

    -- 5. Logic phân loại (IF ELSE IF)
    IF @TongDanhGia5Sao >= 100
        SET @PhanLoai = N'Kim cương';
    ELSE IF @TongDanhGia5Sao >= 50
        SET @PhanLoai = N'Vàng';
    ELSE IF @TongDanhGia5Sao >= 10
        SET @PhanLoai = N'Bạc';
    ELSE
        SET @PhanLoai = N'Đồng';

    RETURN @PhanLoai;
END
GO