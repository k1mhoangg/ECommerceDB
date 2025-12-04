USE ECommerceDB;
GO

CREATE TRIGGER trg_KiemTraTuMuaHangCuaMinh --Nguoi ban khong tu mua hang cua minh bang acc nguoi mua
ON san_pham_trong_gio --Luc them san pham vao gio thi kiem tra => flow la them san pham vao gio trc roi moi tao phien thanh toan
AFTER INSERT, UPDATE -- DML la insert hoac update
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
