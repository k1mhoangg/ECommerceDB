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
