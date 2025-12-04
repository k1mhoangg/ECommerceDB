IF OBJECT_ID('sp_TraCuuDonHangTheoDVVC', 'P') IS NOT NULL 
    DROP PROCEDURE sp_TraCuuDonHangTheoDVVC;

-- 2. Tạo thủ tục mới
CREATE PROCEDURE sp_TraCuuDonHangTheoDVVC
    @TenDVVC NVARCHAR(50),
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SELECT 
        O.MaDonHang,
        O.NgayDatHang,
        O.TongTien,
        O.TrangThaiDonHang,
        C.Ten AS TenDonViVanChuyen,
        S.MaVanDon
    FROM Orders O
    JOIN Shipment S ON O.MaDonHang = S.MaDonHang
    JOIN Carrier C ON S.MaDVVC = C.MaDVVC
    WHERE 
        C.Ten LIKE N'%' + @TenDVVC + N'%'
        AND O.NgayDatHang BETWEEN @TuNgay AND @DenNgay
    ORDER BY 
        O.NgayDatHang DESC;
END;

-- Xóa thủ tục cũ nếu có
IF OBJECT_ID('sp_ThongKeDoanhThuSanPham', 'P') IS NOT NULL 
    DROP PROCEDURE sp_ThongKeDoanhThuSanPham;

-- Tạo thủ tục
CREATE PROCEDURE sp_ThongKeDoanhThuSanPham
    @Thang INT,                 -- Tháng cần xem báo cáo
    @Nam INT,                   -- Năm cần xem báo cáo
    @SoLuongToiThieu INT        -- Chỉ hiện sản phẩm bán được nhiều hơn số này
AS
BEGIN
    SELECT 
        P.MaSP,
        P.TenSP,
        SUM(C.SoLuong) AS TongSoLuongBan,
        SUM(C.SoLuong * C.Gia) AS TongDoanhThu -- Giả sử bảng Contain lưu giá bán tại thời điểm mua
    FROM Product P
    JOIN Contain C ON P.MaSP = C.MaSP
    JOIN Orders O ON C.MaDonHang = O.MaDonHang
    WHERE 
        MONTH(O.NgayDatHang) = @Thang 
        AND YEAR(O.NgayDatHang) = @Nam
    GROUP BY 
        P.MaSP, P.TenSP
    HAVING 
        SUM(C.SoLuong) >= @SoLuongToiThieu
    ORDER BY 
        TongDoanhThu DESC; -- Sản phẩm đem lại nhiều tiền nhất lên đầu
END;

