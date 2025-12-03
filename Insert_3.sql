--USE ECommerceDB;
--GO

-- 1. INSERT DATA: Category
-- Tạo danh mục cha và con
INSERT INTO Category (CategoryName, CategoryDescription) VALUES 
(N'Thời trang nam', N'Quần áo, giày dép cho nam giới'),       -- ID: 1
(N'Thiết bị điện tử', N'Điện thoại, Laptop, Tablet'),          -- ID: 2
(N'Nhà cửa & Đời sống', N'Đồ gia dụng, trang trí nhà cửa'),    -- ID: 3
(N'Áo thun nam', N'Các loại áo thun, áo phông nam'),           -- ID: 4 (Con của 1)
(N'Điện thoại di động', N'Smartphone các hãng'),               -- ID: 5 (Con của 2)
(N'Laptop', N'Máy tính xách tay văn phòng, gaming');           -- ID: 6 (Con của 2)

-- 2. INSERT DATA:  (Cấu trúc phân cấp)
-- Giả sử: Áo thun (4) thuộc Thời trang nam (1), Đt (5) thuộc Điện tử (2)...
INSERT INTO CategoryParent (ChildCateID, ParentCateID) VALUES 
(4, 1), -- Áo thun nam thuộc Thời trang nam
(5, 2), -- Điện thoại thuộc Thiết bị điện tử
(6, 2); -- Laptop thuộc Thiết bị điện tử

-- 3. INSERT DATA: Products
-- Giả định SellerID là 100, 101...
INSERT INTO Products (SellerID, ProductName, ProductDescription, PriceRangeTop, PriceRangeBot, PictureURL, CategoryID) VALUES 
(100, N'Áo thun Cotton Basic', N'Áo thun 100% cotton thấm hút mồ hôi, form rộng', 150000, 100000, N'url_ao_thun.jpg', 4),
(100, N'Quần Jean Slimfit', N'Quần Jean co giãn, màu xanh đậm', 350000, 300000, N'url_quan_jean.jpg', 1),
(101, N'iPhone 15 Pro Max', N'Titan tự nhiên, 256GB, hàng chính hãng VNA', 30000000, 28000000, N'url_iphone.jpg', 5),
(102, N'Samsung Galaxy S24', N'AI Phone, Camera mắt thần bóng đêm', 20000000, 18000000, N'url_samsung.jpg', 5),
(103, N'Laptop Gaming Asus', N'RTX 4060, Ram 16GB, Màn hình 144Hz', 25000000, 22000000, N'url_asus.jpg', 6);

-- 4. INSERT DATA: Variant
-- Lưu ý: ID Product tham chiếu từ bước 3 (1,2,3,4,5)
INSERT INTO Variant (ProductID, PictureURL, VarColor, VarWeight, VarSize, CurrentPrice, SalesPrice, RemainingUnit) VALUES 
-- Áo thun (ID 1)
(1, N'ao_trang.jpg', N'Trắng', 0.2, 38.00, 120000, 100000, 50), -- Size 38 coi như M
(1, N'ao_den.jpg', N'Đen', 0.2, 40.00, 120000, 100000, 45),    -- Size 40 coi như L

-- iPhone (ID 3)
(3, N'ip_titan.jpg', N'Titan', 0.5, 0.00, 29000000, 28500000, 10),
(3, N'ip_blue.jpg', N'Blue', 0.5, 0.00, 29000000, 28000000, 5),

-- Laptop (ID 5)
(5, N'asus_grey.jpg', N'Xám', 2.5, 15.60, 23000000, 22500000, 12); -- Size 15.6 inch

-- 5. INSERT DATA: Address
-- Giả định BuyerID là 200, 201...
INSERT INTO Address (BuyerID, PhoneNum, BuyerName, DetailsAddress) VALUES 
(200, N'0901234567', N'Nguyễn Văn A', N'123 Đường Lê Lợi, Quận 1, TP.HCM'),
(200, N'0901234567', N'Nguyễn Văn A', N'Tòa nhà Bitexco, Quận 1, TP.HCM'),
(201, N'0912345678', N'Trần Thị B', N'456 Đường Nguyễn Huệ, Quận 1, TP.HCM'),
(202, N'0987654321', N'Lê Văn C', N'789 Đường Cầu Giấy, Hà Nội'),
(203, N'0998877665', N'Phạm Thị D', N'Số 10, Ngõ 5, Đường Láng, Hà Nội');

-- 6. INSERT DATA: AdminModSeller
-- Giả định AdminID là 999
INSERT INTO AdminModSeller (SellerID, AdminID) VALUES 
(100, 999), -- Seller 100 được duyệt bởi Admin 999
(101, 999),
(102, 888), -- Admin khác
(103, 999),
(104, 888); -- Seller giả định chưa có products

-- 7. INSERT DATA: AdminModProduct
INSERT INTO AdminModProduct (ProductID, AdminID) VALUES 
(1, 999), -- Sản phẩm 1 đã được duyệt
(2, 999),
(3, 888),
(4, 888),
(5, 999);