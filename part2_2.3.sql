-- Tra cuu lich su mua hang
IF OBJECT_ID('sp_TraCuuLichSuMuaHang', 'P') IS NOT NULL 
    DROP PROCEDURE sp_TraCuuLichSuMuaHang;

CREATE PROCEDURE sp_TraCuuLichSuMuaHang
    @tu_khoa_ten NVARCHAR(200) -- Tìm kiếm theo tên người mua (gần đúng)
AS
BEGIN
    SELECT 
        NM.ma_nguoi_mua,
        NM.ten_hien_thi,
        NM.so_dien_thoai,
        DH.ma_don_hang,
        DH.ngay_dat,
        DH.tong_tien
    FROM nguoi_mua NM
    JOIN DonHang DH ON NM.ma_nguoi_mua = DH.ma_nguoi_mua
    WHERE 
        NM.ten_hien_thi LIKE '%' + @tu_khoa_ten + '%' -- Lọc theo tên
    ORDER BY 
        DH.ngay_dat DESC; -- Sắp xếp đơn hàng mới nhất lên đầu
END;

-- Xóa thủ tục cũ nếu có
IF OBJECT_ID('sp_ThongKeDoanhThuSanPham', 'P') IS NOT NULL 
    DROP PROCEDURE sp_ThongKeDoanhThuSanPham;

-- Tạo thủ tục thống kê doanh thu sản phẩm
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

