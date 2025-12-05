-- Logic Xóa: Không nên xóa vật lý tài khoản nếu họ đã có lịch sử giao dịch (Đơn hàng).
-- Thay vào đó, chúng ta sẽ vô hiệu hóa tài khoản.
-- Mục đích: Đảm bảo tính toàn vẹn dữ liệu cho các bảng dat_hang, theo_doi, danh_gia.


-- 2.1.3 Thủ tục Xóa (DELETE) Người Mua (Thực hiện Vô hiệu hóa)
CREATE OR ALTER PROCEDURE sp_XoaNguoiMua
    @ma_nguoi_mua NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- kiểm tra 1: tài khoản có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM nguoi_mua WHERE ma_nguoi_mua = @ma_nguoi_mua)
    BEGIN
        THROW 50008, N'Lỗi: Không tìm thấy Mã người mua cần xử lý.', 16;
        RETURN;
    END

    -- kiểm tra 2: người mua đã có đơn hàng chưa (đã tồn tại trong bảng dat_hang)
    IF EXISTS (SELECT 1 FROM dat_hang WHERE ma_nguoi_mua = @ma_nguoi_mua)
    BEGIN
        -- THỰC HIỆN VÔ HIỆU HÓA (Soft Delete)
        UPDATE nguoi_mua 
        SET trang_thai_tai_khoan = N'Vô hiệu hóa'
        WHERE ma_nguoi_mua = @ma_nguoi_mua;

        PRINT N'Thông báo: Không thể xóa tài khoản có lịch sử giao dịch. Tài khoản đã được chuyển sang trạng thái "Vô hiệu hóa".';
        RETURN;
    END
    ELSE
    BEGIN
        -- THỰC HIỆN XÓA VẬT LÝ (Hard Delete) - YÊU CẦU TRANSACTION
        
        BEGIN TRANSACTION; -- Bắt đầu giao dịch
        
        BEGIN TRY
            -- Xóa các bảng phụ thuộc trước
            DELETE FROM tai_khoan_ngan_hang WHERE ma_nguoi_mua = @ma_nguoi_mua;
            DELETE FROM dia_chi WHERE ma_nguoi_mua = @ma_nguoi_mua;
            DELETE FROM so_huu_voucher WHERE ma_nguoi_mua = @ma_nguoi_mua;
            DELETE FROM theo_doi WHERE ma_nguoi_mua = @ma_nguoi_mua;

            -- Xóa bản ghi chính
            DELETE FROM nguoi_mua WHERE ma_nguoi_mua = @ma_nguoi_mua;
            
            COMMIT TRANSACTION; -- Hoàn tất giao dịch nếu tất cả DELETE thành công
            PRINT N'Xóa người mua thành công (Không có lịch sử giao dịch).';
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION; -- hoàn tác nếu có bất kì lỗi nào
            THROW 50010, N'Lỗi: Xóa vật lý thất bại do lỗi hệ thống hoặc ràng buộc khác.', 16;
            RETURN;
        END CATCH
    END
END
