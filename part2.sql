CREATE TRIGGER trg_TinhTongTienDonHang
ON san_pham_trong_don
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Xác định danh sách các đơn hàng bị ảnh hưởng
    DECLARE @DonHangBiAnhHuong TABLE (ma_don_hang NVARCHAR(50));

    INSERT INTO @DonHangBiAnhHuong (ma_don_hang)
    SELECT DISTINCT ma_don_hang FROM inserted
    UNION
    SELECT DISTINCT ma_don_hang FROM deleted;

    -- 2. Tính toán và cập nhật lại don_hang
    UPDATE dh
    SET 
        dh.tong_so_luong = ISNULL(TinhToan.TongSL, 0),
        dh.tong_tien = ISNULL(TinhToan.TongTien, 0)
    FROM don_hang dh
    LEFT JOIN (
        SELECT 
            ct.ma_don_hang,
            SUM(ct.so_luong) AS TongSL,
            -- Tính tổng tiền = Số lượng * Giá hiện hành của biến thể
            SUM(ct.so_luong * bt.gia_hien_hanh) AS TongTien
        FROM san_pham_trong_don ct
        JOIN bien_the bt ON ct.ma_bien_the = bt.ma_bien_the AND ct.ma_san_pham = bt.ma_san_pham
        WHERE ct.ma_don_hang IN (SELECT ma_don_hang FROM @DonHangBiAnhHuong)
        GROUP BY ct.ma_don_hang
    ) TinhToan ON dh.ma_don_hang = TinhToan.ma_don_hang
    WHERE dh.ma_don_hang IN (SELECT ma_don_hang FROM @DonHangBiAnhHuong);

    PRINT N'Đã cập nhật lại tổng tiền và tổng số lượng cho đơn hàng.';
END;
GO

CREATE TRIGGER trg_CapNhatTonKho
ON san_pham_trong_don
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Xử lý hoàn trả kho (khi XÓA hoặc CẬP NHẬT giảm số lượng)
    -- Cộng lại số lượng từ bảng 'deleted' vào kho
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE bt
        SET bt.so_luong_con_lai = bt.so_luong_con_lai + d.so_luong
        FROM bien_the bt
        JOIN deleted d ON bt.ma_bien_the = d.ma_bien_the AND bt.ma_san_pham = d.ma_san_pham;
    END

    -- 2. Xử lý trừ kho (khi THÊM MỚI hoặc CẬP NHẬT tăng số lượng)
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Kiểm tra xem có đủ hàng trong kho không (Validate)
        IF EXISTS (
            SELECT 1 
            FROM bien_the bt
            JOIN inserted i ON bt.ma_bien_the = i.ma_bien_the AND bt.ma_san_pham = i.ma_san_pham
            WHERE bt.so_luong_con_lai < i.so_luong
        )
        BEGIN
            RAISERROR(N'Lỗi: Số lượng tồn kho không đủ để thực hiện đơn hàng này.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Thực hiện trừ kho từ bảng 'inserted'
        UPDATE bt
        SET bt.so_luong_con_lai = bt.so_luong_con_lai - i.so_luong
        FROM bien_the bt
        JOIN inserted i ON bt.ma_bien_the = i.ma_bien_the AND bt.ma_san_pham = i.ma_san_pham;
    END

    PRINT N'Đã cập nhật số lượng tồn kho trong bảng biến thể.';
END;
GO