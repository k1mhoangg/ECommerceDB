-- 1. ORDERS
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
CREATE TABLE Orders (
	MaDonHang VARCHAR(50) PRIMARY KEY,
	NgayDatHang DATE,
	NgayNhanDuKien DATE,
	
	PhiVanChuyen DECIMAL(18, 2),
	TongTien DECIMAL(18, 2),
	
	ThongTinNguoiGiao NVARCHAR(50),
	ThongTinNguoiNhan NVARCHAR(50),
	
	TongSoLuong INT,
	
	PhuongThucVanChuyen NVARCHAR(100),
	TrangThaiDonHang NVARCHAR(50),
	
	MaPhienThanhToan VARCHAR(50) NOT NULL,
	SoTaiKhoan VARCHAR(50),
	TenNganHang VARCHAR(50),
	
	--FK:
	CONSTRAINT FK_DonHang_PhienThanhToan 
	FOREIGN KEY (MaPhienThanhToan) REFERENCES PaymentSection(MaPhienThanhToan)
);

-- 2. PLACEORDER
CREATE TABLE PlaceOrder (
	MaDonHang VARCHAR(50) PRIMARY KEY,
	MaVoucher VARCHAR(50),
	SoThuTu INT,
	MaNguoiMua VARCHAR(50),
	
	--FK:
	CONSTRAINT FK_PlaceOrder_MaVoucher 
	FOREIGN KEY (MaVoucher) REFERENCES Voucher(MaVoucher),
	
	CONSTRAINT FK_PlaceOrder_MaNguoiMua 
	FOREIGN KEY (MaNguoiMua) REFERENCES Buyer(MaNguoiMua),
	
	CONSTRAINT FK_PlaceOrder_SoThuTu 
	FOREIGN KEY (SoThuTu) REFERENCES Adress(SoThuTu)
);


-- 3. ORDERITEM
CREATE TABLE OrderItem (
	MaDonHang VARCHAR(50) NOT NULL,
	SoThuTuDong VARCHAR(50) NOT NULL,
	SoLuong INT,
	
	MaSanPham VARCHAR(50),
	MaBienThe VARCHAR(50),
	
	PRIMARY KEY (MaDonHang, SoThuTuDong),
	
	--FK:
	CONSTRAINT FK_OrderItem_Variant
	FOREIGN KEY (MaSanPham, MaBienThe) REFERENCES Variant(MaSanPham, MaBienThe)
);


-- 4.SHIPMENT
IF OBJECT_ID('Shipment', 'U') IS NOT NULL DROP TABLE Shipment;
CREATE TABLE Shipment (
	MaVanDon VARCHAR(50) NOT NULL,
	MaDonHang VARCHAR(50) NOT NULL,
	MaDVVC VARCHAR(50),
	
	PRIMARY KEY (MaVanDon, MaDonHang),
	
	--FK:
	CONSTRAINT FK_Shipment_MaVanDon 
	FOREIGN KEY (MaDonHang) REFERENCES Orders(MaDonHang),
	
	CONSTRAINT FK_Shipment_MaDVVC 
	FOREIGN KEY (MaDVVC) REFERENCES Carrier(MaDVVC)
);

-- 5. CARRIER
IF OBJECT_ID('Carrier', 'U') IS NOT NULL DROP TABLE Carrier;
CREATE TABLE Carrier (
	MaDVVC VARCHAR(50) PRIMARY KEY,
	Ten NVARCHAR(50),
);

-- 6. WAREHOUSE
IF OBJECT_ID('WareHouse', 'U') IS NOT NULL DROP TABLE WareHouse;
CREATE TABLE WareHouse (
	MaKho VARCHAR(50) PRIMARY KEY NOT NULL,
	TinhTrang NVARCHAR(100),
	SucChua VARCHAR(50),
	DiaChi NVARCHAR(100),
);

-- 7. SHIPMENTTRANSIT
IF OBJECT_ID('ShipmentTransit', 'U') IS NOT NULL DROP TABLE ShipmentTransit;
CREATE TABLE ShipmentTransit(
    MaVanDon VARCHAR(50) NOT NULL,
    MaDonHang VARCHAR(50) NOT NULL,
    
    MaKho VARCHAR(50) NOT NULL,
    
    ThoiGianVanChuyen DATETIME,
    
    VaiTro NVARCHAR(100), 
    
    PRIMARY KEY (MaVanDon, MaDonHang),
    
    --FK:
    CONSTRAINT FK_ShipmentTransit_Shipment
    FOREIGN KEY (MaVanDon, MaDonHang) REFERENCES Shipment(MaVanDon, MaDonHang),
    
    CONSTRAINT FK_ShipmentTransit_MaKho
    FOREIGN KEY (MaKho) REFERENCES WareHouse(MaKho)
);

-- 8. SHIPMENTDELIVERY
IF OBJECT_ID('ShipmentDelivery', 'U') IS NOT NULL DROP TABLE ShipmentDelivery;
CREATE TABLE ShipmentDelivery(
    MaVanDon VARCHAR(50) NOT NULL,
    MaDonHang VARCHAR(50) NOT NULL,
    MaDinhDanhShipper VARCHAR(50) NOT NULL,
    
    ThoiGianVanChuyen DATETIME,
    
    VaiTro NVARCHAR(100),
    
    PRIMARY KEY (MaVanDon, MaDonHang),
    
    --FK:
    CONSTRAINT FK_ShipmentDelivery_Shipment
    FOREIGN KEY (MaVanDon, MaDonHang) REFERENCES Shipment(MaVanDon, MaDonHang),
    
    CONSTRAINT FK_ShipmentDelivery_MaDinhDanhShipper
    FOREIGN KEY (MaDinhDanhShipper) REFERENCES Shipper(MaDinhDanhShipper)
);
