-- File: create-tables.sql
-- Tạo các bảng theo thứ tự từ 1-35

USE master;
GO

-- Tạo database nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ECommerceDB')
BEGIN
    CREATE DATABASE ECommerceDB;
END
GO

USE ECommerceDB;
GO

-- Bảng 1: Danh mục hàng hóa
CREATE TABLE danh_muc_hang_hoa (
    ma_danh_muc NVARCHAR(50) PRIMARY KEY,
    ten_danh_muc NVARCHAR(200) NOT NULL,
    mo_ta NVARCHAR(MAX)
);
GO

-- Bảng 2: Kiểm duyệt người bán
CREATE TABLE kiem_duyet_nguoi_ban (
    ma_admin NVARCHAR(50) NOT NULL,
    ma_nguoi_ban NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_admin, ma_nguoi_ban)
);
GO

-- Bảng 3: Kiểm duyệt sản phẩm
CREATE TABLE kiem_duyet_san_pham (
    ma_admin NVARCHAR(50) NOT NULL,
    ma_san_pham NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_admin, ma_san_pham)
);
GO

-- Bảng 4: Voucher tùng sản phẩm
CREATE TABLE voucher_tung_san_pham (
    ma_voucher NVARCHAR(50) PRIMARY KEY,
    ma_nguoi_ban NVARCHAR(50) NOT NULL,
    ten_shop NVARCHAR(200)
);
GO

-- Bảng 5: Voucher toàn đơn
CREATE TABLE voucher_toan_don (
    ma_voucher NVARCHAR(50) PRIMARY KEY,
    ma_admin NVARCHAR(50) NOT NULL,
    so_luong_san_pham_toi_da INT
);
GO

-- Bảng 6: Sản phẩm
CREATE TABLE san_pham (
    ma_san_pham NVARCHAR(50) PRIMARY KEY,
    ma_nguoi_ban NVARCHAR(50) NOT NULL,
    ten NVARCHAR(200) NOT NULL,
    mo_ta NVARCHAR(MAX),
    khoang_gia NVARCHAR(100),
    hinh_anh NVARCHAR(MAX),
    ma_danh_muc NVARCHAR(50) NOT NULL
);
GO

-- Bảng 7: Admin
CREATE TABLE admin (
    ma_admin NVARCHAR(50) PRIMARY KEY,
    ngay_tham_gia DATE,
    ho_ten NVARCHAR(200),
    mat_khau NVARCHAR(200)
);
GO

-- Bảng 8: Giỏ hàng
CREATE TABLE gio_hang (
    ma_gio_hang NVARCHAR(50) PRIMARY KEY,
    ma_nguoi_mua NVARCHAR(50) NOT NULL,
    tong_gia_tri_san_pham DECIMAL(18,2),
    tong_san_pham INT
);
GO

-- Bảng 9: Sản phẩm trong giỏ
CREATE TABLE san_pham_trong_gio (
    ma_gio_hang NVARCHAR(50) NOT NULL,
    so_thu_tu INT NOT NULL,
    ma_bien_the NVARCHAR(50) NOT NULL,
    ma_san_pham NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_gio_hang, so_thu_tu)
);
GO

-- Bảng 10: Đánh giá
CREATE TABLE danh_gia (
    ma_danh_gia NVARCHAR(50) PRIMARY KEY,
    so_sao INT,
    hinh_anh NVARCHAR(MAX),
    video NVARCHAR(MAX),
    binh_luan NVARCHAR(MAX),
    thoi_gian DATETIME,
    chi_tiet NVARCHAR(MAX),
    ma_don_hang NVARCHAR(50),
    so_thu_tu_dong INT,
    ma_bien_the NVARCHAR(50) NOT NULL,
    ma_san_pham NVARCHAR(50) NOT NULL
);
GO

-- Bảng 11: Sản phẩm trong đơn
CREATE TABLE san_pham_trong_don (
    ma_don_hang NVARCHAR(50) NOT NULL,
    so_thu_tu_dong INT NOT NULL,
    so_luong INT,
    ma_san_pham NVARCHAR(50) NOT NULL,
    ma_bien_the NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_don_hang, so_thu_tu_dong)
);
GO

-- Bảng 12: Biến thể
CREATE TABLE bien_the (
    ma_bien_the NVARCHAR(50) NOT NULL,
    ma_san_pham NVARCHAR(50) NOT NULL,
    hinh_anh NVARCHAR(MAX),
    mau_sac NVARCHAR(50),
    can_nang DECIMAL(10,2),
    gia_hien_hanh DECIMAL(18,2),
    so_luong_con_lai INT,
    size NVARCHAR(20),
    gia_khuyen_mai DECIMAL(18,2),
    PRIMARY KEY(ma_bien_the, ma_san_pham)
);
GO

-- Bảng 13: Đơn hàng
CREATE TABLE don_hang (
    ma_don_hang NVARCHAR(50) PRIMARY KEY,
    ngay_nhan_du_kien DATE,
    phi_van_chuyen DECIMAL(18,2),
    thong_tin_nguoi_giao NVARCHAR(500),
    tien_mat BIT,
    phuong_thuc_van_chuyen NVARCHAR(200),
    thong_tin_nguoi_nhan NVARCHAR(500),
    ngay_dat_hang DATETIME,
    trang_thai_don_hang NVARCHAR(100),
    tong_tien DECIMAL(18,2),
    tong_so_luong INT,
    ma_phien NVARCHAR(50) NOT NULL,
    so_tai_khoan NVARCHAR(50),
    ten_ngan_hang NVARCHAR(200)
);
GO

-- Bảng 14: Đặt hàng
CREATE TABLE dat_hang (
    ma_don_hang NVARCHAR(50) PRIMARY KEY,
    ma_voucher NVARCHAR(50),
    so_thu_tu INT,
    ma_nguoi_mua NVARCHAR(50) NOT NULL
);
GO

-- Bảng 15: Phiên thanh toán
CREATE TABLE phien_thanh_toan (
    ma_phien_thanh_toan NVARCHAR(50) PRIMARY KEY,
    tong_san_pham INT,
    gia_du_kien DECIMAL(18,2),
    ma_gio_hang NVARCHAR(50) NOT NULL
);
GO

-- Bảng 16: Địa chỉ
CREATE TABLE dia_chi (
    so_thu_tu INT NOT NULL,
    ma_nguoi_mua NVARCHAR(50) NOT NULL,
    so_dien_thoai NVARCHAR(20),
    ten_nguoi_nhan NVARCHAR(200),
    dia_chi_chi_tiet NVARCHAR(500),
    PRIMARY KEY (so_thu_tu, ma_nguoi_mua)
);
GO

-- Bảng 17: Người mua
CREATE TABLE nguoi_mua (
    ma_nguoi_mua NVARCHAR(50) PRIMARY KEY,
    ten_hien_thi NVARCHAR(200),
    mat_khau NVARCHAR(200),
    trang_thai_tai_khoan NVARCHAR(50),
    gioi_tinh NVARCHAR(20),
    ngay_sinh DATE,
    email NVARCHAR(200),
    so_dien_thoai NVARCHAR(20)
);
GO

-- Bảng 18: Tài khoản ngân hàng
CREATE TABLE tai_khoan_ngan_hang (
    so_tai_khoan NVARCHAR(50) PRIMARY KEY,
    ten_ngan_hang NVARCHAR(200) NOT NULL,
    ten_nguoi_mua NVARCHAR(200),
    ma_nguoi_mua NVARCHAR(50)
);
GO

-- Bảng 19: Voucher
CREATE TABLE voucher (
    ma_voucher NVARCHAR(50) PRIMARY KEY,
    thoi_gian_bat_dau DATETIME,
    thoi_gian_ket_thuc DATETIME,
    gia_tri_don_hang_toi_thieu DECIMAL(18,2),
    gia_tri_su_dung_toi_da DECIMAL(18,2),
    gia_tri_giam_gia DECIMAL(18,2)
);
GO

-- Bảng 20: Người bán
CREATE TABLE nguoi_ban (
    ma_nguoi_ban NVARCHAR(50) PRIMARY KEY,
    ten_cua_hang NVARCHAR(200),
    ngay_tham_gia DATE,
    ma_cua_hang NVARCHAR(50),
    dia_chi NVARCHAR(500),
    danh_gia DECIMAL(3,2),
    mo_ta NVARCHAR(MAX),
    cccd NVARCHAR(20),
    ma_so_kinh_doanh NVARCHAR(50),
    ten_to_chuc NVARCHAR(200),
    ma_so_thue NVARCHAR(50),
    ma_nguoi_mua NVARCHAR(50) NOT NULL
);
GO

-- Bảng 21: Thuộc danh mục
CREATE TABLE thuoc_danh_muc (
    ma_danh_muc_cha NVARCHAR(50) NOT NULL,
    ma_danh_muc_con NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_danh_muc_cha, ma_danh_muc_con)
);
GO

-- Bảng 22: Đối tượng áp dụng
CREATE TABLE doi_tuong_ap_dung (
    ma_voucher NVARCHAR(50) NOT NULL,
    ma_doi_tuong NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_voucher, ma_doi_tuong)
);
GO

-- Bảng 23: Loại sản phẩm áp dụng
CREATE TABLE loai_san_pham_ap_dung (
    ma_voucher NVARCHAR(50) NOT NULL,
    ma_san_pham NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_voucher, ma_san_pham)
);
GO

-- Bảng 24: Sở hữu voucher
CREATE TABLE so_huu_voucher (
    ma_voucher NVARCHAR(50) NOT NULL,
    ma_nguoi_mua NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_voucher, ma_nguoi_mua)
);
GO

-- Bảng 25: Theo dõi
CREATE TABLE theo_doi (
    ma_nguoi_mua NVARCHAR(50) NOT NULL,
    ma_nguoi_ban NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_nguoi_mua, ma_nguoi_ban)
);
GO

-- Bảng 26: Áp dụng voucher
CREATE TABLE ap_dung_voucher (
    ma_voucher NVARCHAR(50) NOT NULL,
    ma_don_hang NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_voucher, ma_don_hang)
);
GO

-- Bảng 27: Viết đánh giá
CREATE TABLE viet_danh_gia (
    ma_danh_gia NVARCHAR(50) PRIMARY KEY,
    ma_nguoi_mua NVARCHAR(50) NOT NULL
);
GO

-- Bảng 28: Vận chuyển kiện gửi qua kho
CREATE TABLE van_chuyen_kien_gui_qua_kho (
    ma_van_don NVARCHAR(50) NOT NULL,
    ma_don_hang NVARCHAR(50) NOT NULL,
    ma_kho NVARCHAR(50) NOT NULL,
    thoi_gian_van_chuyen DATETIME,
    vai_tro NVARCHAR(100),
    PRIMARY KEY (ma_van_don, ma_don_hang, ma_kho)
);
GO

-- Bảng 29: Shipper
CREATE TABLE shipper (
    ma_shipper NVARCHAR(50) PRIMARY KEY,
    cccd NVARCHAR(20),
    ngay_sinh DATE,
    gioi_tinh NVARCHAR(20),
    so_dien_thoai NVARCHAR(20),
    ten NVARCHAR(200)
);
GO

-- Bảng 30: Kiện gửi
CREATE TABLE kien_gui (
    ma_van_don NVARCHAR(50) NOT NULL,
    ma_don_hang NVARCHAR(50) NOT NULL,
    ma_dvvc NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_van_don, ma_don_hang)
);
GO

-- Bảng 31: Kho
CREATE TABLE kho (
    ma_kho NVARCHAR(50) PRIMARY KEY,
    tinh_trang NVARCHAR(100),
    suc_chua INT,
    dia_chi NVARCHAR(500)
);
GO

-- Bảng 32: Đơn vị vận chuyển
CREATE TABLE don_vi_van_chuyen (
    ma_dvvc NVARCHAR(50) PRIMARY KEY,
    ten NVARCHAR(200)
);
GO

-- Bảng 33: Liên hệ
CREATE TABLE lien_he (
    ma_nguoi_ban NVARCHAR(50) NOT NULL,
    ma_nguoi_mua NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ma_nguoi_ban, ma_nguoi_mua)
);
GO

-- Bảng 34: Vận chuyển của kiện hàng bởi shipper
CREATE TABLE van_chuyen_cua_kien_hang_boi_shipper (
    ma_van_don NVARCHAR(50) NOT NULL,
    ma_don_hang NVARCHAR(50) NOT NULL,
    ma_dinh_danh_shipper NVARCHAR(50),
    thoi_gian_van_chuyen DATETIME,
    vai_tro NVARCHAR(100),
    PRIMARY KEY (ma_van_don, ma_don_hang)
);
GO

-- Bảng 35: Thông tin liên hệ
CREATE TABLE thong_tin_lien_he (
    ma_nguoi_ban NVARCHAR(50) NOT NULL,
    ma_nguoi_mua NVARCHAR(50) NOT NULL,
    noi_dung NVARCHAR(300),
    thoi_gian_gui NVARCHAR(50),
    thoi_gian_nhan NVARCHAR(50),
    PRIMARY KEY (ma_nguoi_ban, ma_nguoi_mua, noi_dung, thoi_gian_gui, thoi_gian_nhan)
);
GO

-- ===== THÊM KHÓA NGOẠI =====
-- Bảng 1: Danh mục hàng hóa DONE
-- Không có khóa ngoại

-- Bảng 2: Kiểm duyệt người bán DONE
ALTER TABLE kiem_duyet_nguoi_ban
ADD CONSTRAINT FK_kiem_duyet_nguoi_ban_admin FOREIGN KEY (ma_admin) REFERENCES admin(ma_admin);
ALTER TABLE kiem_duyet_nguoi_ban
ADD CONSTRAINT FK_kiem_duyet_nguoi_ban_nguoi_ban FOREIGN KEY (ma_nguoi_ban) REFERENCES nguoi_ban(ma_nguoi_ban);
GO

-- Bảng 3: Kiểm duyệt sản phẩm DONE
ALTER TABLE kiem_duyet_san_pham
ADD CONSTRAINT FK_kiem_duyet_san_pham_admin FOREIGN KEY (ma_admin) REFERENCES admin(ma_admin);
ALTER TABLE kiem_duyet_san_pham
ADD CONSTRAINT FK_kiem_duyet_san_pham_san_pham FOREIGN KEY (ma_san_pham) REFERENCES san_pham(ma_san_pham);
GO

-- Bảng 4: Voucher tùng sản phẩm DONE
ALTER TABLE voucher_tung_san_pham
ADD CONSTRAINT FK_voucher_tung_san_pham_voucher FOREIGN KEY (ma_voucher) REFERENCES voucher(ma_voucher);
ALTER TABLE voucher_tung_san_pham
ADD CONSTRAINT FK_voucher_tung_san_pham_nguoi_ban FOREIGN KEY (ma_nguoi_ban) REFERENCES nguoi_ban(ma_nguoi_ban);
GO

-- Bảng 5: Voucher toàn đơn DONE
ALTER TABLE voucher_toan_don
ADD CONSTRAINT FK_voucher_toan_don_voucher FOREIGN KEY (ma_voucher) REFERENCES voucher(ma_voucher);
ALTER TABLE voucher_toan_don
ADD CONSTRAINT FK_voucher_toan_don_admin FOREIGN KEY (ma_admin) REFERENCES admin(ma_admin);
GO

-- Bảng 6: Sản phẩm DONE
ALTER TABLE san_pham
ADD CONSTRAINT FK_san_pham_nguoi_ban FOREIGN KEY (ma_nguoi_ban) REFERENCES nguoi_ban(ma_nguoi_ban);
ALTER TABLE san_pham
ADD CONSTRAINT FK_san_pham_danh_muc FOREIGN KEY (ma_danh_muc) REFERENCES danh_muc_hang_hoa(ma_danh_muc);
GO

-- Bảng 7: Admin DONE
-- Không có khóa ngoại

-- Bảng 8: Giỏ hàng DONE
ALTER TABLE gio_hang
ADD CONSTRAINT FK_gio_hang_nguoi_mua FOREIGN KEY (ma_nguoi_mua) REFERENCES nguoi_mua(ma_nguoi_mua);
GO

-- Bảng 9: Sản phẩm trong giỏ DONE
ALTER TABLE san_pham_trong_gio
ADD CONSTRAINT FK_san_pham_trong_gio_gio_hang FOREIGN KEY (ma_gio_hang) REFERENCES gio_hang(ma_gio_hang);
ALTER TABLE san_pham_trong_gio
ADD CONSTRAINT FK_san_pham_trong_gio_bien_the
FOREIGN KEY (ma_bien_the, ma_san_pham)
REFERENCES bien_the(ma_bien_the, ma_san_pham);
GO

-- Bảng 10: Đánh giá DONE
ALTER TABLE danh_gia
ADD CONSTRAINT FK_danh_gia_bien_the FOREIGN KEY (ma_bien_the, ma_san_pham) REFERENCES bien_the(ma_bien_the, ma_san_pham);
ALTER TABLE danh_gia
ADD CONSTRAINT FK_danh_gia_don_hang FOREIGN KEY (ma_don_hang, so_thu_tu_dong) REFERENCES san_pham_trong_don(ma_don_hang, so_thu_tu_dong);
GO

-- Bảng 11: Sản phẩm trong đơn DONE
ALTER TABLE san_pham_trong_don
ADD CONSTRAINT FK_san_pham_trong_don_don_hang FOREIGN KEY (ma_don_hang) REFERENCES don_hang(ma_don_hang);
ALTER TABLE san_pham_trong_don
ADD CONSTRAINT FK_san_pham_trong_don_bien_the FOREIGN KEY (ma_bien_the, ma_san_pham) REFERENCES bien_the(ma_bien_the, ma_san_pham);
GO

-- Bảng 12: Biến thể DONE
ALTER TABLE bien_the
ADD CONSTRAINT FK_bien_the_san_pham FOREIGN KEY (ma_san_pham) REFERENCES san_pham(ma_san_pham) ON DELETE CASCADE;
GO

-- Bảng 13: Đơn hàng DONE
ALTER TABLE don_hang
ADD CONSTRAINT FK_don_hang_phien_thanh_toan FOREIGN KEY (ma_phien) REFERENCES phien_thanh_toan(ma_phien_thanh_toan);
GO

-- Bảng 14: Đặt hàng DONE
ALTER TABLE dat_hang
ADD CONSTRAINT FK_dat_hang_don_hang FOREIGN KEY (ma_don_hang) REFERENCES don_hang(ma_don_hang);
ALTER TABLE dat_hang
ADD CONSTRAINT FK_dat_hang_voucher FOREIGN KEY (ma_voucher) REFERENCES voucher(ma_voucher);
ALTER TABLE dat_hang
ADD CONSTRAINT FK_dat_hang_dia_chi FOREIGN KEY (so_thu_tu, ma_nguoi_mua) REFERENCES dia_chi(so_thu_tu, ma_nguoi_mua);
GO

-- Bảng 15: Phiên thanh toán DONE
ALTER TABLE phien_thanh_toan
ADD CONSTRAINT FK_phien_thanh_toan_gio_hang FOREIGN KEY (ma_gio_hang) REFERENCES gio_hang(ma_gio_hang);
GO

-- Bảng 16: Địa chỉ DONE
ALTER TABLE dia_chi
ADD CONSTRAINT FK_dia_chi_nguoi_mua FOREIGN KEY (ma_nguoi_mua) REFERENCES nguoi_mua(ma_nguoi_mua);
GO

-- Bảng 17: Người mua DONE
-- Không có khóa ngoại

-- Bảng 18: Tài khoản ngân hàng DONE
ALTER TABLE tai_khoan_ngan_hang
ADD CONSTRAINT FK_tai_khoan_ngan_hang_nguoi_mua FOREIGN KEY (ma_nguoi_mua) REFERENCES nguoi_mua(ma_nguoi_mua);
GO

-- Bảng 19: Voucher DONE
-- Không có khóa ngoại

-- Bảng 20: Người bán DONE
ALTER TABLE nguoi_ban
ADD CONSTRAINT FK_nguoi_ban_nguoi_mua FOREIGN KEY (ma_nguoi_mua) REFERENCES nguoi_mua(ma_nguoi_mua);
GO

-- Bảng 21: Thuộc danh mục DONE
ALTER TABLE thuoc_danh_muc
ADD CONSTRAINT FK_thuoc_danh_muc_cha FOREIGN KEY (ma_danh_muc_cha) REFERENCES danh_muc_hang_hoa(ma_danh_muc);
ALTER TABLE thuoc_danh_muc
ADD CONSTRAINT FK_thuoc_danh_muc_con FOREIGN KEY (ma_danh_muc_con) REFERENCES danh_muc_hang_hoa(ma_danh_muc);
GO

-- Bảng 22: Đối tượng áp dụng DONE
ALTER TABLE doi_tuong_ap_dung
ADD CONSTRAINT FK_doi_tuong_ap_dung_voucher FOREIGN KEY (ma_voucher) REFERENCES voucher(ma_voucher);
GO

-- Bảng 23: Loại sản phẩm áp dụng DONE
ALTER TABLE loai_san_pham_ap_dung
ADD CONSTRAINT FK_loai_san_pham_ap_dung_voucher FOREIGN KEY (ma_voucher) REFERENCES voucher(ma_voucher);
GO

-- Bảng 24: Sở hữu voucher DONE
ALTER TABLE so_huu_voucher
ADD CONSTRAINT FK_so_huu_voucher_voucher FOREIGN KEY (ma_voucher) REFERENCES voucher(ma_voucher);
ALTER TABLE so_huu_voucher
ADD CONSTRAINT FK_so_huu_voucher_nguoi_mua FOREIGN KEY (ma_nguoi_mua) REFERENCES nguoi_mua(ma_nguoi_mua);
GO

-- Bảng 25: Theo dõi DONE
ALTER TABLE theo_doi
ADD CONSTRAINT FK_theo_doi_nguoi_mua FOREIGN KEY (ma_nguoi_mua) REFERENCES nguoi_mua(ma_nguoi_mua);
ALTER TABLE theo_doi
ADD CONSTRAINT FK_theo_doi_nguoi_ban FOREIGN KEY (ma_nguoi_ban) REFERENCES nguoi_ban(ma_nguoi_ban);
GO

-- Bảng 26: Áp dụng voucher DONE
ALTER TABLE ap_dung_voucher
ADD CONSTRAINT FK_ap_dung_voucher_voucher FOREIGN KEY (ma_voucher) REFERENCES voucher(ma_voucher);
ALTER TABLE ap_dung_voucher
ADD CONSTRAINT FK_ap_dung_voucher_don_hang FOREIGN KEY (ma_don_hang) REFERENCES don_hang(ma_don_hang);
GO

-- Bảng 27: Viết đánh giá DONE
ALTER TABLE viet_danh_gia
ADD CONSTRAINT FK_viet_danh_gia_danh_gia FOREIGN KEY (ma_danh_gia) REFERENCES danh_gia(ma_danh_gia);
ALTER TABLE viet_danh_gia
ADD CONSTRAINT FK_viet_danh_gia_nguoi_mua FOREIGN KEY (ma_nguoi_mua) REFERENCES nguoi_mua(ma_nguoi_mua);
GO

-- Bảng 28: Vận chuyển kiện gửi qua kho DONE
ALTER TABLE van_chuyen_kien_gui_qua_kho
ADD CONSTRAINT FK_van_chuyen_kien_gui_van_don FOREIGN KEY (ma_van_don, ma_don_hang) REFERENCES kien_gui(ma_van_don, ma_don_hang);
ALTER TABLE van_chuyen_kien_gui_qua_kho
ADD CONSTRAINT FK_van_chuyen_kien_gui_kho FOREIGN KEY (ma_kho) REFERENCES kho(ma_kho);
GO

-- Bảng 29: Shipper DONE
-- Không có khóa ngoại

-- Bảng 30: Kiện gửi DONE
ALTER TABLE kien_gui
ADD CONSTRAINT FK_kien_gui_don_hang FOREIGN KEY (ma_don_hang) REFERENCES don_hang(ma_don_hang);
ALTER TABLE kien_gui
ADD CONSTRAINT FK_kien_gui_dvvc FOREIGN KEY (ma_dvvc) REFERENCES don_vi_van_chuyen(ma_dvvc);
GO

-- Bảng 31: Kho DONE
-- Không có khóa ngoại

-- Bảng 32: Đơn vị vận chuyển DONE
-- Không có khóa ngoại

-- Bảng 33: Liên hệ
ALTER TABLE lien_he
ADD CONSTRAINT FK_lien_he_nguoi_ban FOREIGN KEY (ma_nguoi_ban) REFERENCES nguoi_ban(ma_nguoi_ban);
ALTER TABLE lien_he
ADD CONSTRAINT FK_lien_he_nguoi_mua FOREIGN KEY (ma_nguoi_mua) REFERENCES nguoi_mua(ma_nguoi_mua);
GO

-- Bảng 34: Vận chuyển của kiện hàng bởi shipper
ALTER TABLE van_chuyen_cua_kien_hang_boi_shipper
ADD CONSTRAINT FK_van_chuyen_shipper_van_don FOREIGN KEY (ma_van_don, ma_don_hang) REFERENCES kien_gui(ma_van_don, ma_don_hang);
ALTER TABLE van_chuyen_cua_kien_hang_boi_shipper
ADD CONSTRAINT FK_van_chuyen_shipper_shipper FOREIGN KEY (ma_dinh_danh_shipper) REFERENCES shipper(ma_shipper);
GO

-- Bảng 35: Vận chuyển kiện gửi qua kho
ALTER TABLE thong_tin_lien_he
ADD CONSTRAINT FK_thong_tin_lien_he_nguoi_ban FOREIGN KEY (ma_nguoi_ban, ma_nguoi_mua) REFERENCES lien_he(ma_nguoi_ban, ma_nguoi_mua);
GO

PRINT 'Đã tạo thành công tất cả các bảng và khóa ngoại!';
GO