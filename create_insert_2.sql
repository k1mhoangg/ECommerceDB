-- Kiểm tra nếu database đã tồn tại thì xóa (tùy chọn)
IF DB_ID('ECommerceDB') IS NOT NULL
BEGIN
    DROP DATABASE ECommerceDB;
END;
GO

-- Tạo database
CREATE DATABASE ECommerceDB;
GO

-- Sử dụng database vừa tạo
USE ECommerceDB;
GO

-- Drop tables if they exist (in reverse order of dependencies)
IF OBJECT_ID('AppliedVoucher', 'U') IS NOT NULL DROP TABLE AppliedVoucher;
IF OBJECT_ID('VoucherOwnership', 'U') IS NOT NULL DROP TABLE VoucherOwnership;
IF OBJECT_ID('AppliedProductType', 'U') IS NOT NULL DROP TABLE AppliedProductType;
IF OBJECT_ID('AppliedSubject', 'U') IS NOT NULL DROP TABLE AppliedSubject;
IF OBJECT_ID('ProductVoucher', 'U') IS NOT NULL DROP TABLE ProductVoucher;
IF OBJECT_ID('GlobalVoucher', 'U') IS NOT NULL DROP TABLE GlobalVoucher;
IF OBJECT_ID('Voucher', 'U') IS NOT NULL DROP TABLE Voucher;

-- =============================================
-- 1. VOUCHER TABLE (Main Voucher Table)
-- =============================================
CREATE TABLE Voucher (
    VoucherCode NVARCHAR(50) PRIMARY KEY,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    MinimumOrderValue DECIMAL(18,2),
    MaximumDiscountUsed DECIMAL(18,2),
    DiscountValue DECIMAL(18,2),
);

-- =============================================
-- 2. GLOBAL VOUCHER TABLE
-- =============================================
CREATE TABLE GlobalVoucher (
    VoucherCode NVARCHAR(50) PRIMARY KEY,
    AdminCode NVARCHAR(50) NOT NULL,
    MaximumProducts DECIMAL(10,2),
    -- FOREIGN KEY (VoucherCode) REFERENCES Voucher(VoucherCode) ON DELETE CASCADE,
    -- FOREIGN KEY (AdminCode) REFERENCES Admin(AdminCode) ON DELETE CASCADE
);

-- =============================================
-- 3. PRODUCT VOUCHER TABLE
-- =============================================
CREATE TABLE ProductVoucher (
    VoucherCode NVARCHAR(50) PRIMARY KEY,
    SellerCode NVARCHAR(50) NOT NULL,
    ShopName NVARCHAR(200),
    -- FOREIGN KEY (VoucherCode) REFERENCES Voucher(VoucherCode) ON DELETE CASCADE,
    -- FOREIGN KEY (SellerCode) REFERENCES Seller(SellerCode) ON DELETE CASCADE
);

-- =============================================
-- 4. APPLIED SUBJECT TABLE
-- =============================================
CREATE TABLE AppliedSubject (
    VoucherCode NVARCHAR(50) PRIMARY KEY,
    SubjectCode NVARCHAR(50) NOT NULL,
    -- FOREIGN KEY (VoucherCode) REFERENCES Voucher(VoucherCode) ON DELETE CASCADE
);

-- =============================================
-- 5. APPLIED PRODUCT TYPE TABLE
-- =============================================
CREATE TABLE AppliedProductType (
    VoucherCode NVARCHAR(50) PRIMARY KEY,
    ProductCode NVARCHAR(50) NOT NULL,
    -- FOREIGN KEY (VoucherCode) REFERENCES Voucher(VoucherCode) ON DELETE CASCADE
);

-- =============================================
-- 6. VOUCHER OWNERSHIP TABLE
-- =============================================
CREATE TABLE VoucherOwnership (
    BuyerCode NVARCHAR(50) PRIMARY KEY,
    VoucherCode NVARCHAR(50) NOT NULL,
    -- FOREIGN KEY (VoucherCode) REFERENCES Voucher(VoucherCode) ON DELETE CASCADE,
    -- FOREIGN KEY (BuyerCode) REFERENCES Buyer(BuyerCode) ON DELETE CASCADE
);

-- =============================================
-- 7. APPLIED VOUCHER TABLE (Order Usage)
-- =============================================
CREATE TABLE AppliedVoucher (
    OrderCode NVARCHAR(50) PRIMARY KEY,
    VoucherCode NVARCHAR(50) NOT NULL,
    -- TODO: Later assign foreign key
    -- FOREIGN KEY (VoucherCode) REFERENCES Voucher(VoucherCode) ON DELETE CASCADE
    -- FOREIGN KEY (VoucherCode) REFERENCES Voucher(VoucherCode) ON DELETE CASCADE
);

GO

-- =============================================
-- INSERT SAMPLE DATA
-- =============================================

-- =============================================
-- INSERT DATA FOR VOUCHER TABLE
-- =============================================
INSERT INTO Voucher (VoucherCode, StartTime, EndTime, MinimumOrderValue, MaximumDiscountUsed, DiscountValue)
VALUES 
    ('VOUCHER001', '2024-01-01 00:00:00', '2024-12-31 23:59:59', 100000, 50000, 10000),
    ('VOUCHER002', '2024-02-01 00:00:00', '2024-12-31 23:59:59', 200000, 100000, 20000),
    ('VOUCHER003', '2024-03-01 00:00:00', '2024-12-31 23:59:59', 500000, 200000, 50000),
    ('VOUCHER004', '2024-04-01 00:00:00', '2024-12-31 23:59:59', 300000, 150000, 30000),
    ('VOUCHER005', '2024-05-01 00:00:00', '2024-12-31 23:59:59', 150000, 75000, 15000);

-- =============================================
-- INSERT DATA FOR GLOBAL VOUCHER TABLE
-- =============================================
-- Giả định bảng Admin đã tồn tại với các AdminCode
INSERT INTO GlobalVoucher (VoucherCode, AdminCode, MaximumProducts)
VALUES 
    ('VOUCHER001', 'ADMIN001', 100),
    ('VOUCHER002', 'ADMIN002', 150),
    ('VOUCHER003', 'ADMIN001', 200),
    ('VOUCHER004', 'ADMIN003', 120),
    ('VOUCHER005', 'ADMIN002', 180);

-- =============================================
-- INSERT DATA FOR PRODUCT VOUCHER TABLE
-- =============================================
-- Giả định bảng Seller đã tồn tại với các SellerCode
INSERT INTO ProductVoucher (VoucherCode, SellerCode, ShopName)
VALUES 
    ('VOUCHER001', 'SELLER001', N'Shop Điện Tử ABC'),
    ('VOUCHER002', 'SELLER002', N'Shop Thời Trang XYZ'),
    ('VOUCHER003', 'SELLER003', N'Shop Mỹ Phẩm DEF'),
    ('VOUCHER004', 'SELLER001', N'Shop Gia Dụng GHI'),
    ('VOUCHER005', 'SELLER004', N'Shop Sách JKL');

-- =============================================
-- INSERT DATA FOR APPLIED SUBJECT TABLE
-- =============================================
INSERT INTO AppliedSubject (VoucherCode, SubjectCode)
VALUES 
    ('VOUCHER001', 'SUBJECT001'),
    ('VOUCHER002', 'SUBJECT002'),
    ('VOUCHER003', 'SUBJECT003'),
    ('VOUCHER004', 'SUBJECT004'),
    ('VOUCHER005', 'SUBJECT005');

-- =============================================
-- INSERT DATA FOR APPLIED PRODUCT TYPE TABLE
-- =============================================
INSERT INTO AppliedProductType (VoucherCode, ProductCode)
VALUES 
    ('VOUCHER001', 'PRODUCT001'),
    ('VOUCHER002', 'PRODUCT002'),
    ('VOUCHER003', 'PRODUCT003'),
    ('VOUCHER004', 'PRODUCT004'),
    ('VOUCHER005', 'PRODUCT005');

-- =============================================
-- INSERT DATA FOR VOUCHER OWNERSHIP TABLE
-- =============================================
-- Giả định bảng Buyer đã tồn tại với các BuyerCode
INSERT INTO VoucherOwnership (BuyerCode, VoucherCode)
VALUES 
    ('BUYER001', 'VOUCHER001'),
    ('BUYER002', 'VOUCHER002'),
    ('BUYER003', 'VOUCHER003'),
    ('BUYER004', 'VOUCHER004'),
    ('BUYER005', 'VOUCHER005');

-- =============================================
-- INSERT DATA FOR APPLIED VOUCHER TABLE
-- =============================================
INSERT INTO AppliedVoucher (OrderCode, VoucherCode)
VALUES 
    ('ORDER001', 'VOUCHER001'),
    ('ORDER002', 'VOUCHER002'),
    ('ORDER003', 'VOUCHER003'),
    ('ORDER004', 'VOUCHER004'),
    ('ORDER005', 'VOUCHER005');

GO
-- =============================================
-- VERIFICATION QUERIES
-- =============================================
SELECT 'Vouchers' AS TableName, COUNT(*) AS RecordCount FROM Voucher
UNION ALL
SELECT 'GlobalVoucher', COUNT(*) FROM GlobalVoucher
UNION ALL
SELECT 'ProductVoucher', COUNT(*) FROM ProductVoucher
UNION ALL
SELECT 'AppliedSubject', COUNT(*) FROM AppliedSubject
UNION ALL
SELECT 'AppliedProductType', COUNT(*) FROM AppliedProductType
UNION ALL
SELECT 'VoucherOwnership', COUNT(*) FROM VoucherOwnership
UNION ALL
SELECT 'AppliedVoucher', COUNT(*) FROM AppliedVoucher;
