-- 1. Seller
CREATE TABLE Buyer (
    MaNguoiMua VARCHAR(50) PRIMARY KEY,
    TenHienThi NVARCHAR(100) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    TrangThaiTaiKhoan NVARCHAR(50),
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    Email VARCHAR(100) UNIQUE,
    SoDienThoai VARCHAR(20) UNIQUE,
    CHECK (Email LIKE '%@%[.]%') 
);
-- 2. Buyer
CREATE TABLE Seller (
    MaNguoiBan VARCHAR(50) PRIMARY KEY,
    TenCuaHang NVARCHAR(255) NOT NULL,
    NgayThamGia DATE,
    MaCuaHang VARCHAR(50) UNIQUE,
    DiaChi NVARCHAR(255),
    DanhGia FLOAT,
    MoTa NVARCHAR(MAX),
    CCCD VARCHAR(20) UNIQUE,
    MaSoKinhDoanh VARCHAR(50),
    TenToChuc NVARCHAR,
    MaSoThue VARCHAR

);

-- 3. Shipper
CREATE TABLE Shipper (
    MaShipper VARCHAR PRIMARY KEY,
    CCCD VARCHAR,
    Ngaysinh DATE,
    Gioitinh NVARCHAR,
    Sodienthoai VARCHAR,
    Ten NVARCHAR(100)
);

-- 4. Admin 
CREATE TABLE Admin (
    MaAdmin VARCHAR(50) PRIMARY KEY,     
    HoTen NVARCHAR(255),                 
    MatKhau VARCHAR(255),                
    NgayThamGia DATETIME                 
);

-- 5. Contact
CREATE TABLE Contact (
    MaNguoiBan VARCHAR(50),
    MaNguoiMua VARCHAR(50),
    NoiDung NVARCHAR(MAX),
    ThoiGianGui DATETIME,
    ThoiGianNhan DATETIME,
    PRIMARY KEY (MaNguoiBan, MaNguoiMua, ThoiGianGui),
    FOREIGN KEY (MaNguoiBan) REFERENCES Seller(MaNguoiBan),
    FOREIGN KEY (MaNguoiMua) REFERENCES Buyer(MaNguoiMua)
);

-- 6. BankAccount
CREATE TABLE BankAccout (
    SoTaiKhoan VARCHAR(50),              
    TenNganHang NVARCHAR(255),          
    MaNguoiMua VARCHAR(50),             
    TenNguoiMua NVARCHAR(255),           
    PRIMARY KEY (SoTaiKhoan, TenNganHang),
    FOREIGN KEY (MaNguoiMua) REFERENCES Buyer(MaNguoiMua)
);

-- 7. PaymentSection
CREATE TABLE PaymentSection (
    MaPhienThanhToan VARCHAR(50) PRIMARY KEY, 
    MaNguoiMua VARCHAR(50),                 
    MaGioHang VARCHAR(50),                   
    TongGiaTriSanPham DECIMAL(18, 2),       
    TongSanPham INT,                        
    GiaDuKien DECIMAL(18, 2),               
    FOREIGN KEY (MaNguoiMua) REFERENCES Buyer(MaNguoiMua) -- FK to Cart will be added after Cart table is created
);
