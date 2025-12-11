USE ECommerceDB;
GO

-- 1) danh_muc_hang_hoa (5)
INSERT INTO danh_muc_hang_hoa (ma_danh_muc, ten_danh_muc, mo_ta) VALUES
('DM1',N'Điện tử',N'Thiết bị điện tử'),
('DM2',N'Thời trang',N'Quần áo và phụ kiện'),
('DM3',N'Gia dụng',N'Đồ dùng gia đình'),
('DM4',N'Sách',N'Sách và văn phòng phẩm'),
('DM5',N'Làm đẹp',N'Mỹ phẩm và chăm sóc');
GO

-- 7) admin (5)
INSERT INTO admin (ma_admin, ngay_tham_gia, ho_ten, mat_khau) VALUES
('AD1','2020-01-10','Admin One','pw1'),
('AD2','2020-02-15','Admin Two','pw2'),
('AD3','2020-03-20','Admin Three','pw3'),
('AD4','2020-04-25','Admin Four','pw4'),
('AD5','2020-05-30','Admin Five','pw5');
GO

-- 17) nguoi_mua (5)
INSERT INTO nguoi_mua (ma_nguoi_mua, ten_hien_thi, mat_khau, trang_thai_tai_khoan, gioi_tinh, ngay_sinh, email, so_dien_thoai) VALUES
('NM1','Buyer One','bpw1','active',N'Nam','1990-01-01','b1@example.com','0123456781'),
('NM2','Buyer Two','bpw2','active',N'Nữ','1991-02-02','b2@example.com','0123456782'),
('NM3','Buyer Three','bpw3','active',N'Nam','1992-03-03','b3@example.com','0123456783'),
('NM4','Buyer Four','bpw4','active',N'Nữ','1993-04-04','b4@example.com','0123456784'),
('NM5','Buyer Five','bpw5','active',N'Nam','1994-05-05','b5@example.com','0123456785');
GO

-- 20) nguoi_ban (5) each references a nguoi_mua
INSERT INTO nguoi_ban (ma_nguoi_ban, ten_cua_hang, ngay_tham_gia, ma_cua_hang, dia_chi, danh_gia, mo_ta, cccd, ma_so_kinh_doanh, ten_to_chuc, ma_so_thue, ma_nguoi_mua) VALUES
('NB1','Shop One','2019-01-01','C1','Address 1',4.5,'Shop A','111111111','MK1','Org1','TAX1','NM1'),
('NB2','Shop Two','2019-02-01','C2','Address 2',4.0,'Shop B','222222222','MK2','Org2','TAX2','NM2'),
('NB3','Shop Three','2019-03-01','C3','Address 3',3.8,'Shop C','333333333','MK3','Org3','TAX3','NM3'),
('NB4','Shop Four','2019-04-01','C4','Address 4',4.2,'Shop D','444444444','MK4','Org4','TAX4','NM4'),
('NB5','Shop Five','2019-05-01','C5','Address 5',4.7,'Shop E','555555555','MK5','Org5','TAX5','NM5');
GO

-- 6) san_pham (5)
INSERT INTO san_pham (ma_san_pham, ma_nguoi_ban, ten, mo_ta, khoang_gia, hinh_anh, ma_danh_muc) VALUES
('SP1','NB1',N'Điện thoại A',N'Smartphone A','5M-7M','img1.jpg','DM1'),
('SP2','NB2',N'Áo thun B',N'Áo cotton','199K-399K','img2.jpg','DM2'),
('SP3','NB3',N'Ấm siêu tốc C',N'Ấm điện','200K-500K','img3.jpg','DM3'),
('SP4','NB4',N'Sách D',N'Tiểu thuyết','50K-150K','img4.jpg','DM4'),
('SP5','NB5','Son E',N'Son môi','100K-300K','img5.jpg','DM5');
GO

-- 12) bien_the (5) composite PK (ma_bien_the, ma_san_pham)
INSERT INTO bien_the (ma_bien_the, ma_san_pham, hinh_anh, mau_sac, can_nang, gia_hien_hanh, so_luong_con_lai, size, gia_khuyen_mai) VALUES
('BT1','SP1','bt1.jpg',N'Đen',0.18,5000.00,10,'N/A',4500.00),
('BT2','SP2','bt2.jpg',N'Trắng',0.12,200.00,50,'M',180.00),
('BT3','SP3','bt3.jpg',N'Xám',0.80,300.00,20,'N/A',270.00),
('BT4','SP4','bt4.jpg','N/A',0.35,120.00,100,'N/A',110.00),
('BT5','SP5','bt5.jpg',N'Đỏ',0.02,150.00,40,'N/A',130.00);
GO

-- 31) kho (5)
INSERT INTO kho (ma_kho, tinh_trang, suc_chua, dia_chi) VALUES
('KHO1',N'Sẵn sàng',1000,N'Kho A'),
('KHO2',N'Sẵn sàng',800,N'Kho B'),
('KHO3',N'Bảo trì',500,N'Kho C'),
('KHO4',N'Sẵn sàng',1200,N'Kho D'),
('KHO5',N'Sẵn sàng',600,N'Kho E');
GO

-- 32) don_vi_van_chuyen (5)
INSERT INTO don_vi_van_chuyen (ma_dvvc, ten) VALUES
('DV1',N'Giao hàng A'),
('DV2',N'Giao hàng B'),
('DV3',N'Giao nhanh C'),
('DV4',N'Giao tiết kiệm D'),
('DV5',N'Giao Express E');
GO

-- 29) shipper (5)
INSERT INTO shipper (ma_shipper, cccd, ngay_sinh, gioi_tinh, so_dien_thoai, ten) VALUES
('SH1','900000001','1990-06-01',N'Nam','0987000001','Shipper One'),
('SH2','900000002','1991-07-02',N'Nữ','0987000002','Shipper Two'),
('SH3','900000003','1992-08-03',N'Nam','0987000003','Shipper Three'),
('SH4','900000004','1993-09-04',N'Nữ','0987000004','Shipper Four'),
('SH5','900000005','1994-10-05',N'Nam','0987000005','Shipper Five');
GO

-- 19) voucher (5)
INSERT INTO voucher (ma_voucher, thoi_gian_bat_dau, thoi_gian_ket_thuc, gia_tri_don_hang_toi_thieu, gia_tri_su_dung_toi_da, gia_tri_giam_gia) VALUES
('VOU1','2025-01-01','2025-12-31',100000.00,50000.00,10000.00),
('VOU2','2025-02-01','2025-12-31',200000.00,100000.00,20000.00),
('VOU3','2025-03-01','2025-12-31',50000.00,30000.00,5000.00),
('VOU4','2025-04-01','2025-12-31',150000.00,80000.00,15000.00),
('VOU5','2025-05-01','2025-12-31',250000.00,120000.00,25000.00);
GO

-- 4) voucher_tung_san_pham (5)
INSERT INTO voucher_tung_san_pham (ma_voucher, ma_nguoi_ban, ten_shop) VALUES
('VOU1','NB1','Shop One'),
('VOU2','NB2','Shop Two'),
('VOU3','NB3','Shop Three'),
('VOU4','NB4','Shop Four'),
('VOU5','NB5','Shop Five');
GO

-- 5) voucher_toan_don (5)
INSERT INTO voucher_toan_don (ma_voucher, ma_admin, so_luong_san_pham_toi_da) VALUES
('VOU1','AD1',1),
('VOU2','AD2',2),
('VOU3','AD3',1),
('VOU4','AD4',3),
('VOU5','AD5',2);
GO

-- 24) so_huu_voucher (5)
INSERT INTO so_huu_voucher (ma_voucher, ma_nguoi_mua) VALUES
('VOU1','NM1'),
('VOU2','NM2'),
('VOU3','NM3'),
('VOU4','NM4'),
('VOU5','NM5');
GO

-- 22) doi_tuong_ap_dung (5) (simple object ids)
INSERT INTO doi_tuong_ap_dung (ma_voucher, ma_doi_tuong) VALUES
('VOU1','OBJ1'),
('VOU2','OBJ2'),
('VOU3','OBJ3'),
('VOU4','OBJ4'),
('VOU5','OBJ5');
GO

-- 23) loai_san_pham_ap_dung (5)
INSERT INTO loai_san_pham_ap_dung (ma_voucher, ma_san_pham) VALUES
('VOU1','SP1'),
('VOU2','SP2'),
('VOU3','SP3'),
('VOU4','SP4'),
('VOU5','SP5');
GO

-- 8) gio_hang (5)
INSERT INTO gio_hang (ma_gio_hang, ma_nguoi_mua, tong_gia_tri_san_pham, tong_san_pham) VALUES
('GH1','NM1',5000.00,1),
('GH2','NM2',200.00,2),
('GH3','NM3',300.00,1),
('GH4','NM4',120.00,3),
('GH5','NM5',150.00,1);
GO

-- 15) phien_thanh_toan (5)
INSERT INTO phien_thanh_toan (ma_phien_thanh_toan, tong_san_pham, gia_du_kien, ma_gio_hang) VALUES
('PT1',1,5000.00,'GH1'),
('PT2',2,400.00,'GH2'),
('PT3',1,300.00,'GH3'),
('PT4',3,360.00,'GH4'),
('PT5',1,150.00,'GH5');
GO

-- 13) don_hang (5)
INSERT INTO don_hang (ma_don_hang, ngay_nhan_du_kien, phi_van_chuyen, thong_tin_nguoi_giao, tien_mat, phuong_thuc_van_chuyen, thong_tin_nguoi_nhan, ngay_dat_hang, trang_thai_don_hang, tong_tien, tong_so_luong, ma_phien, so_tai_khoan, ten_ngan_hang) VALUES
('DH1','2025-06-01',3000.00,N'Giao viên A',1,N'Giao tiêu chuẩn',N'Người nhận 1','2025-05-01 10:00:00',N'Đang xử lý',5000.00,1,'PT1','AC1','Bank A'),
('DH2','2025-06-02',2000.00,N'Giao viên B',0,N'Thanh toán online',N'Người nhận 2','2025-05-02 11:00:00',N'Đang xử lý',400.00,2,'PT2','AC2','Bank B'),
('DH3','2025-06-03',2500.00,N'Giao viên C',1,N'Giao nhanh',N'Người nhận 3','2025-05-03 12:00:00',N'Hoàn thành',300.00,1,'PT3','AC3','Bank C'),
('DH4','2025-06-04',1500.00,N'Giao viên D',0,N'Giao tiết kiệm',N'Người nhận 4','2025-05-04 13:00:00',N'Đang giao',360.00,3,'PT4','AC4','Bank D'),
('DH5','2025-06-05',1000.00,N'Giao viên E',1,N'Giao tối ưu',N'Người nhận 5','2025-05-05 14:00:00',N'Đã giao',150.00,1,'PT5','AC5','Bank E');
GO

-- 30) kien_gui (5)
INSERT INTO kien_gui (ma_van_don, ma_don_hang, ma_dvvc) VALUES
('KG1','DH1','DV1'),
('KG2','DH2','DV2'),
('KG3','DH3','DV3'),
('KG4','DH4','DV4'),
('KG5','DH5','DV5');
GO

-- 28) van_chuyen_kien_gui_qua_kho (5)
INSERT INTO van_chuyen_kien_gui_qua_kho (ma_van_don, ma_don_hang, ma_kho, thoi_gian_van_chuyen, vai_tro) VALUES
('KG1','DH1','KHO1','2025-05-02 09:00:00',N'Nhận'),
('KG2','DH2','KHO2','2025-05-03 10:00:00',N'Xếp'),
('KG3','DH3','KHO3','2025-05-04 11:00:00',N'Gửi'),
('KG4','DH4','KHO4','2025-05-05 12:00:00',N'Nhận'),
('KG5','DH5','KHO5','2025-05-06 13:00:00',N'Gửi');
GO

-- 34) van_chuyen_cua_kien_hang_boi_shipper (5)
INSERT INTO van_chuyen_cua_kien_hang_boi_shipper (ma_van_don, ma_don_hang, ma_dinh_danh_shipper, thoi_gian_van_chuyen, vai_tro) VALUES
('KG1','DH1','SH1','2025-05-02 14:00:00',N'Giao'),
('KG2','DH2','SH2','2025-05-03 15:00:00',N'Giao'),
('KG3','DH3','SH3','2025-05-04 16:00:00',N'Giao'),
('KG4','DH4','SH4','2025-05-05 17:00:00',N'Giao'),
('KG5','DH5','SH5','2025-05-06 18:00:00',N'Giao');
GO

-- 11) san_pham_trong_don (5) (ma_don_hang, so_thu_tu_dong)
INSERT INTO san_pham_trong_don (ma_don_hang, so_thu_tu_dong, so_luong, ma_san_pham, ma_bien_the) VALUES
('DH1',1,1,'SP1','BT1'),
('DH2',1,2,'SP2','BT2'),
('DH3',1,1,'SP3','BT3'),
('DH4',1,3,'SP4','BT4'),
('DH5',1,1,'SP5','BT5');
GO

-- 10) danh_gia (5) (references bien_the and san_pham_trong_don via ma_don_hang, so_thu_tu_dong)
INSERT INTO danh_gia (ma_danh_gia, so_sao, hinh_anh, video, binh_luan, thoi_gian, chi_tiet, ma_don_hang, so_thu_tu_dong, ma_bien_the, ma_san_pham) VALUES
('DG1',5,'dg1.jpg',NULL,N'Tuyệt vời','2025-05-10 10:00:00',N'Chi tiết 1','DH1',1,'BT1','SP1'),
('DG2',4,'dg2.jpg',NULL,'Ok','2025-05-11 11:00:00',N'Chi tiết 2','DH2',1,'BT2','SP2'),
('DG3',3,'dg3.jpg',NULL,N'Bình thường','2025-05-12 12:00:00',N'Chi tiết 3','DH3',1,'BT3','SP3'),
('DG4',5,'dg4.jpg',NULL,N'Rất tốt','2025-05-13 13:00:00',N'Chi tiết 4','DH4',1,'BT4','SP4'),
('DG5',4,'dg5.jpg',NULL,N'Hài lòng','2025-05-14 14:00:00',N'Chi tiết 5','DH5',1,'BT5','SP5');
GO

-- 27) viet_danh_gia (5) (references danh_gia and nguoi_mua)
INSERT INTO viet_danh_gia (ma_danh_gia, ma_nguoi_mua) VALUES
('DG1','NM1'),
('DG2','NM2'),
('DG3','NM3'),
('DG4','NM4'),
('DG5','NM5');
GO

-- 9) san_pham_trong_gio (5) (references gio_hang and bien_the)
INSERT INTO san_pham_trong_gio (ma_gio_hang, so_thu_tu, ma_bien_the, ma_san_pham) VALUES
('GH1',1,'BT1','SP1'),
('GH2',1,'BT2','SP2'),
('GH3',1,'BT3','SP3'),
('GH4',1,'BT4','SP4'),
('GH5',1,'BT5','SP5');
GO

-- 16) dia_chi (5)
INSERT INTO dia_chi (so_thu_tu, ma_nguoi_mua, so_dien_thoai, ten_nguoi_nhan, dia_chi_chi_tiet) VALUES
(1,'NM1','0123456781',N'Người nhận 1',N'Địa chỉ 1'),
(1,'NM2','0123456782',N'Người nhận 2',N'Địa chỉ 2'),
(1,'NM3','0123456783',N'Người nhận 3',N'Địa chỉ 3'),
(1,'NM4','0123456784',N'Người nhận 4',N'Địa chỉ 4'),
(1,'NM5','0123456785',N'Người nhận 5',N'Địa chỉ 5');
GO

-- 14) dat_hang (5) (references don_hang, voucher, dia_chi)
INSERT INTO dat_hang (ma_don_hang, ma_voucher, so_thu_tu, ma_nguoi_mua) VALUES
('DH1','VOU1',1,'NM1'),
('DH2','VOU2',1,'NM2'),
('DH3','VOU3',1,'NM3'),
('DH4','VOU4',1,'NM4'),
('DH5','VOU5',1,'NM5');
GO

-- 18) tai_khoan_ngan_hang (5)
INSERT INTO tai_khoan_ngan_hang (so_tai_khoan, ten_ngan_hang, ten_nguoi_mua, ma_nguoi_mua) VALUES
('AC1','Bank A','Buyer One','NM1'),
('AC2','Bank B','Buyer Two','NM2'),
('AC3','Bank C','Buyer Three','NM3'),
('AC4','Bank D','Buyer Four','NM4'),
('AC5','Bank E','Buyer Five','NM5');
GO

-- 21) thuoc_danh_muc (5)
INSERT INTO thuoc_danh_muc (ma_danh_muc_cha, ma_danh_muc_con) VALUES
('DM1','DM2'),
('DM1','DM3'),
('DM2','DM4'),
('DM3','DM5'),
('DM4','DM5');
GO

-- 25) theo_doi (5)
INSERT INTO theo_doi (ma_nguoi_mua, ma_nguoi_ban) VALUES
('NM1','NB1'),
('NM2','NB2'),
('NM3','NB3'),
('NM4','NB4'),
('NM5','NB5');
GO

-- 33) lien_he (5)
INSERT INTO lien_he (ma_nguoi_ban, ma_nguoi_mua) VALUES
('NB1','NM1'),
('NB2','NM2'),
('NB3','NM3'),
('NB4','NM4'),
('NB5','NM5');
GO

-- 35) thong_tin_lien_he (5) (references lien_he)
INSERT INTO thong_tin_lien_he (ma_nguoi_ban, ma_nguoi_mua, noi_dung, thoi_gian_gui, thoi_gian_nhan) VALUES
('NB1','NM1',N'Hỏi về sản phẩm','2025-05-01 09:00','2025-05-01 09:05'),
('NB2','NM2',N'Chưa nhận hàng','2025-05-02 10:00','2025-05-02 10:10'),
('NB3','NM3',N'Đổi trả','2025-05-03 11:00','2025-05-03 11:15'),
('NB4','NM4',N'Yêu cầu bảo hành','2025-05-04 12:00','2025-05-04 12:20'),
('NB5','NM5','Feedback','2025-05-05 13:00','2025-05-05 13:10');
GO

-- 2) kiem_duyet_nguoi_ban (5)
INSERT INTO kiem_duyet_nguoi_ban (ma_admin, ma_nguoi_ban) VALUES
('AD1','NB1'),
('AD2','NB2'),
('AD3','NB3'),
('AD4','NB4'),
('AD5','NB5');
GO

-- 3) kiem_duyet_san_pham (5)
INSERT INTO kiem_duyet_san_pham (ma_admin, ma_san_pham) VALUES
('AD1','SP1'),
('AD2','SP2'),
('AD3','SP3'),
('AD4','SP4'),
('AD5','SP5');
GO

-- 26) ap_dung_voucher (5)
INSERT INTO ap_dung_voucher (ma_voucher, ma_don_hang) VALUES
('VOU1','DH1'),
('VOU2','DH2'),
('VOU3','DH3'),
('VOU4','DH4'),
('VOU5','DH5');
GO

PRINT N'Đã chèn 5 dòng cho mỗi bảng (1..35).';
GO