USE ECommerceDB;
GO


-- 1. Cart (Giỏ hàng)
IF OBJECT_ID('Cart', 'U') IS NOT NULL DROP TABLE Cart;
CREATE TABLE Cart (
    MaGioHang VARCHAR(50) PRIMARY KEY,
    MaNguoiMua VARCHAR(50) NOT NULL UNIQUE, 
    TongSoSanPham INT DEFAULT 0 CHECK (TongSoSanPham >= 0),
    TongGiaTriSanPham DECIMAL(18, 2) DEFAULT 0 CHECK (TongGiaTriSanPham >= 0),
    
    CONSTRAINT FK_Cart_Buyer FOREIGN KEY (MaNguoiMua) REFERENCES Buyer(MaNguoiMua) ON DELETE CASCADE
);
GO

-- 2. CartItem (Sản phẩm trong giỏ)
IF OBJECT_ID('CartItem', 'U') IS NOT NULL DROP TABLE CartItem;
CREATE TABLE CartItem (
    MaGioHang VARCHAR(50),
    MaBienThe VARCHAR(50), 
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(18, 2) CHECK (DonGia >= 0), 
    
    PRIMARY KEY (MaGioHang, MaBienThe),
    
    CONSTRAINT FK_CartItem_Cart FOREIGN KEY (MaGioHang) REFERENCES Cart(MaGioHang) ON DELETE CASCADE,
    CONSTRAINT FK_CartItem_Variant FOREIGN KEY (MaBienThe) REFERENCES ProductVariant(MaBienThe)
);
GO

-- 3. Follow (Theo dõi)
IF OBJECT_ID('Follow', 'U') IS NOT NULL DROP TABLE Follow;
CREATE TABLE Follow (
    MaNguoiMua VARCHAR(50),
    MaNguoiBan VARCHAR(50),
    ThoiGianTheoDoi DATETIME DEFAULT GETDATE(),
    
    PRIMARY KEY (MaNguoiMua, MaNguoiBan),
    
    CONSTRAINT FK_Follow_Buyer FOREIGN KEY (MaNguoiMua) REFERENCES Buyer(MaNguoiMua),
    CONSTRAINT FK_Follow_Seller FOREIGN KEY (MaNguoiBan) REFERENCES Seller(MaNguoiBan)
);
GO

-- 4. Message (Liên hệ)
IF OBJECT_ID('Message', 'U') IS NOT NULL DROP TABLE Message;
CREATE TABLE Message (
    MaNguoiMua VARCHAR(50),
    MaNguoiBan VARCHAR(50),
    ThoiGianGui DATETIME,
    NoiDung NVARCHAR(MAX) NOT NULL,
    ThoiGianNhan DATETIME, 
    
    PRIMARY KEY (MaNguoiMua, MaNguoiBan, ThoiGianGui),
    
    CONSTRAINT FK_Message_Buyer FOREIGN KEY (MaNguoiMua) REFERENCES Buyer(MaNguoiMua),
    CONSTRAINT FK_Message_Seller FOREIGN KEY (MaNguoiBan) REFERENCES Seller(MaNguoiBan)
);
GO

-- 5. Review (Đánh giá)
IF OBJECT_ID('WriteReview', 'U') IS NOT NULL DROP TABLE WriteReview; 
IF OBJECT_ID('Review', 'U') IS NOT NULL DROP TABLE Review;

CREATE TABLE Review (
    MaDanhGia VARCHAR(50) PRIMARY KEY,
    SoSao INT NOT NULL CHECK (SoSao >= 1 AND SoSao <= 5), 
    NoiDung NVARCHAR(MAX),
    HinhAnh NVARCHAR(MAX),
    Video NVARCHAR(MAX),
    ThoiGian DATETIME DEFAULT GETDATE(),
    BinhLuan NVARCHAR(MAX) 
);
GO

-- 6. WriteReview (Viết đánh giá)
IF OBJECT_ID('WriteReview', 'U') IS NOT NULL DROP TABLE WriteReview;
CREATE TABLE WriteReview (
    MaDanhGia VARCHAR(50) PRIMARY KEY,
    MaNguoiMua VARCHAR(50) NOT NULL,
    MaBienThe VARCHAR(50) NOT NULL, 
    
    CONSTRAINT FK_WriteReview_Review FOREIGN KEY (MaDanhGia) REFERENCES Review(MaDanhGia) ON DELETE CASCADE,
    CONSTRAINT FK_WriteReview_Buyer FOREIGN KEY (MaNguoiMua) REFERENCES Buyer(MaNguoiMua),
    CONSTRAINT FK_WriteReview_Variant FOREIGN KEY (MaBienThe) REFERENCES ProductVariant(MaBienThe)
);
GO