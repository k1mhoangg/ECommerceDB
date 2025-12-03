USE ECommerceDB;
GO

-- 1. Cart (Giỏ hàng)
INSERT INTO Cart (MaGioHang, MaNguoiMua, TongSoSanPham, TongGiaTriSanPham) VALUES
('CART001', 'BUYER001', 3, 29700000), 
('CART002', 'BUYER002', 1, 120000),   
('CART003', 'BUYER003', 0, 0),        
('CART004', 'BUYER004', 5, 400000),   
('CART005', 'BUYER005', 2, 60000000); 
GO

-- 2. CartItem (Sản phẩm trong giỏ)
INSERT INTO CartItem (MaGioHang, MaBienThe, SoLuong, DonGia) VALUES
('CART001', 'SKU001', 1, 29500000), -- iPhone trong giỏ của Buyer 1
('CART001', 'SKU003', 2, 100000),   -- 2 Áo thun trong giỏ của Buyer 1
('CART002', 'SKU004', 1, 120000),   -- Áo thun đen trong giỏ của Buyer 2
('CART004', 'SKU005', 5, 80000),    -- 5 Sách trong giỏ của Buyer 4
('CART005', 'SKU001', 2, 30000000); -- 2 iPhone trong giỏ của Buyer 5
GO

-- 3. Follow (Theo dõi)
INSERT INTO Follow (MaNguoiMua, MaNguoiBan, ThoiGianTheoDoi) VALUES
('BUYER001', 'SELLER001', '2024-01-15 08:30:00'),
('BUYER001', 'SELLER002', '2024-02-20 09:45:00'),
('BUYER002', 'SELLER003', '2024-03-10 14:00:00'),
('BUYER003', 'SELLER001', '2024-04-05 16:20:00'),
('BUYER005', 'SELLER004', '2024-05-12 10:15:00');
GO

-- 4. Message (Liên hệ/Tin nhắn)
INSERT INTO Message (MaNguoiMua, MaNguoiBan, ThoiGianGui, NoiDung, ThoiGianNhan) VALUES
('BUYER001', 'SELLER001', '2024-06-01 09:00:00', N'Sản phẩm này còn hàng không shop?', '2024-06-01 09:05:00'),
('BUYER001', 'SELLER001', '2024-06-01 09:10:00', N'Có hỗ trợ ship hỏa tốc không?', '2024-06-01 09:12:00'),
('BUYER002', 'SELLER002', '2024-06-02 14:30:00', N'Áo này form rộng hay vừa vậy ạ?', NULL), -- Chưa đọc
('BUYER003', 'SELLER003', '2024-06-03 10:00:00', N'Sách có bọc plastic không shop?', '2024-06-03 10:15:00'),
('BUYER005', 'SELLER001', '2024-06-04 20:00:00', N'Bảo hành bao lâu vậy?', '2024-06-04 20:30:00');
GO

-- 5. Review (Đánh giá - Nội dung)
INSERT INTO Review (MaDanhGia, SoSao, NoiDung, HinhAnh, Video, ThoiGian, BinhLuan) VALUES
('REV001', 5, N'Hàng chất lượng, đóng gói kỹ.', 'img/rev1.jpg', NULL, '2024-05-20 10:00:00', N'Cảm ơn bạn đã ủng hộ!'),
('REV002', 4, N'Giao hàng hơi chậm nhưng áo đẹp.', NULL, NULL, '2024-05-21 11:30:00', N'Xin lỗi bạn vì sự chậm trễ.'),
('REV003', 5, N'Sách hay, giấy đẹp, rất hài lòng.', 'img/rev3.jpg', 'vid/rev3.mp4', '2024-05-22 09:15:00', NULL),
('REV004', 1, N'Giao sai màu, shop làm ăn chán.', 'img/rev4.jpg', NULL, '2024-05-23 15:00:00', N'Shop xin lỗi, sẽ đổi lại ngay ạ.'),
('REV005', 5, N'Tuyệt vời, sẽ quay lại ủng hộ tiếp.', NULL, NULL, '2024-05-24 18:45:00', N'Cảm ơn bạn nhiều!');
GO

-- 6. WriteReview (Viết đánh giá - Liên kết)
INSERT INTO WriteReview (MaDanhGia, MaNguoiMua, MaBienThe) VALUES
('REV001', 'BUYER001', 'SKU001'), -- Buyer 1 đánh giá iPhone
('REV002', 'BUYER002', 'SKU003'), -- Buyer 2 đánh giá Áo thun
('REV003', 'BUYER003', 'SKU005'), -- Buyer 3 đánh giá Sách
('REV004', 'BUYER004', 'SKU004'), -- Buyer 4 đánh giá Áo thun (bị sai)
('REV005', 'BUYER005', 'SKU001'); -- Buyer 5 cũng đánh giá iPhone
GO