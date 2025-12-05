-- Hàm 1: Tính tổng giá trị chiết khấu đã nhận của Người mua
-- Yêu cầu: IF, LOOP, Cursor, Truy vấn, Kiểm tra tham số
CREATE FUNCTION fn_TinhTongGiaTriChietKhau (@Ma_nguoi_mua NVARCHAR(50))
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TongChietKhau DECIMAL(18,2) = 0;
    DECLARE @MaDonHang NVARCHAR(50);
    DECLARE @GiaTriGiam DECIMAL(18,2);

    -- 1. Kiểm tra tham số đầu vào (Kiểm tra sự tồn tại của Người mua)
    IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @Ma_nguoi_mua)
        RETURN -1; -- Trả về -1 nếu mã người mua không tồn tại

    -- 2. Khai báo Con trỏ (Cursor)
    -- Lấy tất cả các đơn hàng đã hoàn thành và giá trị giảm từ bảng áp dụng voucher
    DECLARE VoucherCursor CURSOR FOR
    SELECT
        adv.ma_don_hang,
        -- Giả định giá trị giảm giá đã được tính và lưu trữ
        v.gia_tri_giam_gia 
    FROM ap_dung_voucher adv
    INNER JOIN voucher v ON adv.ma_voucher = v.ma_voucher
    INNER JOIN dat_hang dh ON adv.ma_don_hang = dh.ma_don_hang
    INNER JOIN don_hang od ON dh.ma_don_hang = od.ma_don_hang
    WHERE 
        dh.ma_nguoi_mua = @Ma_nguoi_mua AND od.trang_thai_don_hang = N'Hoàn thành';

    OPEN VoucherCursor;
    FETCH NEXT FROM VoucherCursor INTO @MaDonHang, @GiaTriGiam;

    -- 3. LOOP để duyệt qua các Voucher đã áp dụng
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- 4. IF/Tính toán: Cộng dồn giá trị giảm (Nếu giá trị giảm hợp lệ)
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

