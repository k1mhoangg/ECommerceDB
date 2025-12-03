-- 3. Product, Variant, Category, CategoryHierarchy, Address, SellerModeration, ProductModeration
--CREATE DATABASE ECommerceDB

--CATEGORY
CREATE TABLE Category (
	CategoryID INT PRIMARY KEY IDENTITY (1,1),

	CategoryName NVARCHAR(100) NOT NULL,
	CategoryDescription NVARCHAR(100) NOT NULL,
);

--PRODUCT
CREATE TABLE Products (
	ProductID INT PRIMARY KEY IDENTITY (1,1),
	SellerID INT NOT NULL, --FK

	ProductName NVARCHAR(100) NOT NULL,
	ProductDescription NVARCHAR(4000) NOT NULL,
	PriceRangeTop INT,
	PriceRangeBot INT,
	PictureURL NVARCHAR(100) NOT NULL,

	CategoryID INT NOT NULL, -- FK
	
	--Tuy theo Seller, cate ma sua
	--CONSTRAINT FK_SellerInProd FOREIGN KEY (SellerID) REFERENCES Seller(SellerID),
	--CONSTRAINT FK_ChildCate FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
);


--CateHierarchy
CREATE TABLE CategoryParent (
	ChildCateID INT PRIMARY KEY,
	ParentCateID INT NOT NULL,

	CONSTRAINT FK_ChildCate FOREIGN KEY (ChildCateID) REFERENCES Category(CategoryID),
	CONSTRAINT FK_ParentCate FOREIGN KEY (ParentCateID) REFERENCES Category(CategoryID),
);

--VARIANT
CREATE TABLE Variant (
	VariantID INT Primary key IDENTITY(1,1),

	ProductID INT NOT NULL, -- FK

	PictureURL NVARCHAR(100) NOT NULL,
	VarColor NVARCHAR(10),
	VarWeight DECIMAL(10,2),
	VarSize NVARCHAR(20),
	CurrentPrice DECIMAL(18,2) NOT NULL,
	SalesPrice DECIMAL(18,2) NOT NULL,
	RemainingUnit INT NOT NULL, 

	CONSTRAINT FK_VarInProd FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
);

--ADRESS
CREATE TABLE Address (
	AddressNo INT Primary key IDENTITY(1,1),

	BuyerID INT NOT NULL, --FK

	PhoneNum NVARCHAR(10) NOT NULL,
	BuyerName NVARCHAR(20) NOT NULL,
	DetailsAddress NVARCHAR(255) NOT NULL,

	--Tuy theo table Buyer thi sua lai
	--CONSTRAINT FK_AddressOfBuyer FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID)
);

--SELLER MOD
CREATE TABLE AdminModSeller (
	SellerID INT PRIMARY KEY, --FK

	AdminID INT NOT NULL, --FK

	--Tuy theo table Seller, Admin thi sua lai
	--CONSTRAINT FK_SellerMod FOREIGN KEY (SellerID) REFERENCES Seller(SellerID), 
	--CONSTRAINT FK_AdminMod FOREIGN KEY (AdminID) REFERENCES Admin(AdminID),
);

--PROD MOD
CREATE TABLE AdminModProduct (
	ProductID INT PRIMARY KEY, --FK

	AdminID INT NOT NULL, --FK

	--Tuy theo table Product, Admin thi sua lai
	--CONSTRAINT FK_ProductMod FOREIGN KEY (ProductID) REFERENCES Product(ProductID), 
	--CONSTRAINT FK_AdminMod FOREIGN KEY (AdminID) REFERENCES Admin(AdminID),
);
