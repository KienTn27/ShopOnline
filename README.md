USE [master]
GO
/****** Object:  Database [Shop]    Script Date: 26/07/2025 4:17:39 CH ******/
CREATE DATABASE [Shop]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Shop', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Shop.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Shop_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Shop_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Shop] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Shop].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Shop] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Shop] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Shop] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Shop] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Shop] SET ARITHABORT OFF 
GO
ALTER DATABASE [Shop] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Shop] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Shop] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Shop] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Shop] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Shop] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Shop] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Shop] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Shop] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Shop] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Shop] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Shop] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Shop] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Shop] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Shop] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Shop] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Shop] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Shop] SET RECOVERY FULL 
GO
ALTER DATABASE [Shop] SET  MULTI_USER 
GO
ALTER DATABASE [Shop] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Shop] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Shop] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Shop] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Shop] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Shop] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Shop', N'ON'
GO
ALTER DATABASE [Shop] SET QUERY_STORE = ON
GO
ALTER DATABASE [Shop] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Shop]
GO
/****** Object:  Table [dbo].[Carts]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carts](
	[CartID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[ProductID] [int] NULL,
	[Quantity] [int] NOT NULL,
	[CreatedAt] [datetime] NULL,
	[Size] [nvarchar](10) NULL,
	[Color] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[CartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inventory_Logs]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventory_Logs](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[ChangeType] [nvarchar](20) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Note] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NULL,
	[CreatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[NotificationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[Message] [nvarchar](max) NOT NULL,
	[IsRead] [bit] NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[ProductID] [int] NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[TotalPrice] [decimal](10, 2) NOT NULL,
	[Size] [nvarchar](10) NULL,
	[Color] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[Status] [nvarchar](20) NULL,
	[TotalAmount] [decimal](10, 2) NOT NULL,
	[ShippingAddress] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[password_reset_tokens]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[password_reset_tokens](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[token] [nvarchar](255) NOT NULL,
	[expiry] [datetime] NOT NULL,
	[is_used] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductDetail]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductDetail](
	[ProductDetailID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[Size] [nvarchar](20) NOT NULL,
	[Color] [nvarchar](30) NOT NULL,
	[Quantity] [int] NOT NULL,
	[ImageURL] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[CategoryID] [int] NULL,
	[Description] [nvarchar](max) NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[ImageURL] [nvarchar](255) NULL,
	[IsActive] [bit] NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductVariants]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductVariants](
	[VariantID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[Size] [nvarchar](50) NOT NULL,
	[Color] [nvarchar](50) NOT NULL,
	[SKU] [nvarchar](100) NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[VariantImageURL] [nvarchar](255) NULL,
	[IsActive] [bit] NULL,
	[CreatedAt] [datetime] NULL,
 CONSTRAINT [PK_ProductVariants] PRIMARY KEY CLUSTERED 
(
	[VariantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[ProductID] [int] NULL,
	[Rating] [int] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingStatusHistory]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingStatusHistory](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[UpdatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Phone] [nvarchar](20) NULL,
	[Role] [nvarchar](20) NULL,
	[CreatedAt] [datetime] NULL,
	[IsActive] [bit] NULL,
	[is_deleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Carts] ON 

INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (20, 4015, NULL, 2, CAST(N'2025-06-28T00:46:02.103' AS DateTime), NULL, NULL)
INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (21, 4015, NULL, 1, CAST(N'2025-06-28T01:01:07.373' AS DateTime), NULL, NULL)
INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (22, 4015, NULL, 1, CAST(N'2025-06-28T01:09:24.463' AS DateTime), NULL, NULL)
INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (23, 4015, NULL, 1, CAST(N'2025-06-28T01:22:48.747' AS DateTime), NULL, NULL)
INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (1012, 4015, NULL, 7, CAST(N'2025-06-28T07:43:38.283' AS DateTime), NULL, NULL)
INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (1013, 4015, NULL, 1, CAST(N'2025-06-28T08:04:12.127' AS DateTime), NULL, NULL)
INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (1014, 4015, NULL, 1, CAST(N'2025-06-28T08:06:59.920' AS DateTime), NULL, NULL)
INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (4069, 4014, NULL, 1, CAST(N'2025-07-01T00:05:29.897' AS DateTime), N'S', N'Đen')
INSERT [dbo].[Carts] ([CartID], [UserID], [ProductID], [Quantity], [CreatedAt], [Size], [Color]) VALUES (5097, 5020, NULL, 1, CAST(N'2025-07-22T21:19:29.730' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Carts] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([CategoryID], [Name], [Description]) VALUES (1, N'Áo Khoác', N'Dành cho dịp trang trọng, công sở hoặc sự kiện. Tạo phong thái lịch lãm, chuyên nghiệp cho phái mạnh.')
INSERT [dbo].[Categories] ([CategoryID], [Name], [Description]) VALUES (5, N'Quần Jean', N'Quần jean trẻ trung, năng động, dễ phối với nhiều loại áo. Có kiểu dáng slim fit, straight, rách nhẹ hoặc wash cá tính.')
INSERT [dbo].[Categories] ([CategoryID], [Name], [Description]) VALUES (6, N'Áo Thun', N'Áo thun cổ bẻ mang lại vẻ ngoài gọn gàng, lịch sự nhưng vẫn năng động. Dễ phối với quần jean, kaki hay short.')
INSERT [dbo].[Categories] ([CategoryID], [Name], [Description]) VALUES (7, N'Áo Sơ Mi', N'Áo sơ mi nam trắng là lựa chọn không thể thiếu trong tủ đồ của phái mạnh. Với thiết kế đơn giản, tinh tế cùng chất liệu vải cotton cao cấp hoặc pha sợi tổng hợp, sản phẩm mang lại cảm giác thoáng mát, mềm mại và dễ chịu khi mặc.')
INSERT [dbo].[Categories] ([CategoryID], [Name], [Description]) VALUES (8, N'Quần Kaki', N'Lựa chọn thoải mái và thanh lịch cho đi làm hay đi chơi. Chất liệu nhẹ, thoáng, bền.')
INSERT [dbo].[Categories] ([CategoryID], [Name], [Description]) VALUES (10, N'Quần Short', N'Thoáng mát, thoải mái cho các hoạt động ngoài trời hoặc mùa hè. Gồm short jean, kaki, thể thao...')
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Inventory_Logs] ON 

INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (1, NULL, N'Add', 50, N'Qu?n lý nh?p thêm áo thun', CAST(N'2025-05-20T11:23:04.677' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (2, NULL, N'Add', 30, N'Qu?n lý nh?p thêm qu?n jeans', CAST(N'2025-05-20T11:23:04.677' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (3, NULL, N'Remove', 10, N'Qu?n lý xóa áo so mi do l?i', CAST(N'2025-05-20T11:23:04.680' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (4, NULL, N'Update', 100, N'Qu?n lý c?p nh?t s? lu?ng váy', CAST(N'2025-05-20T11:23:04.680' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (5, NULL, N'Add', 20, N'Qu?n lý nh?p thêm hoodie', CAST(N'2025-05-20T11:23:04.680' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (6, NULL, N'Remove', 5, N'Qu?n lý xóa th?t lung l?i', CAST(N'2025-05-20T11:23:04.680' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (7, NULL, N'Add', 25, N'Qu?n lý nh?p thêm legging', CAST(N'2025-05-20T11:23:04.680' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (8, NULL, N'Update', 50, N'Qu?n lý c?p nh?t s? lu?ng áo khoác', CAST(N'2025-05-20T11:23:04.680' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (9, NULL, N'Remove', 1, N'Removed due to order #3', CAST(N'2025-06-28T19:53:06.283' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (10, NULL, N'Remove', 2, N'Removed due to order #3', CAST(N'2025-06-28T19:53:06.283' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (11, NULL, N'Remove', 1, N'Removed due to order #2', CAST(N'2025-06-28T19:53:06.283' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (12, NULL, N'Remove', 3, N'Removed due to order #2', CAST(N'2025-06-28T19:53:06.283' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (13, NULL, N'Remove', 1, N'Removed due to order #1', CAST(N'2025-06-28T19:53:06.283' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (14, NULL, N'Remove', 2, N'Removed due to order #1', CAST(N'2025-06-28T19:53:06.283' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (15, NULL, N'Remove', 1, N'Removed due to order #1033', CAST(N'2025-06-28T20:17:32.683' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (16, NULL, N'Remove', 20, N'Removed due to order #1034', CAST(N'2025-06-28T20:20:23.330' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (17, NULL, N'Remove', 20, N'Removed due to order #1035', CAST(N'2025-06-28T20:21:49.643' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (18, NULL, N'Remove', 10, N'Removed due to order #1036', CAST(N'2025-06-28T20:29:19.460' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (19, NULL, N'Remove', 10, N'Removed due to order #1037', CAST(N'2025-06-28T20:31:42.667' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (20, NULL, N'Remove', 10, N'Removed due to order #1038', CAST(N'2025-06-28T20:36:41.760' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (21, NULL, N'Remove', 10, N'Removed due to order #1039', CAST(N'2025-06-28T20:38:20.273' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (22, NULL, N'Remove', 10, N'Removed due to order #1040', CAST(N'2025-06-28T20:41:02.920' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (23, NULL, N'Remove', 10, N'Removed due to order #1041', CAST(N'2025-06-28T20:41:18.160' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (24, NULL, N'Remove', 10, N'Removed due to order #1042', CAST(N'2025-06-28T20:41:54.770' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (25, NULL, N'Remove', 10, N'Removed due to order #1043', CAST(N'2025-06-28T23:59:37.910' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (1025, NULL, N'Remove', 20, N'Removed due to order #2043', CAST(N'2025-06-29T11:49:03.500' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (1026, NULL, N'Remove', 10, N'Removed due to order #2044', CAST(N'2025-06-29T11:49:46.690' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (2025, NULL, N'Remove', 10, N'Removed due to order #3043', CAST(N'2025-07-01T00:03:01.353' AS DateTime), NULL)
INSERT [dbo].[Inventory_Logs] ([LogID], [ProductID], [ChangeType], [Quantity], [Note], [CreatedAt], [CreatedBy]) VALUES (2026, NULL, N'Remove', 10, N'Removed due to order #3044', CAST(N'2025-07-01T00:04:20.590' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Inventory_Logs] OFF
GO
SET IDENTITY_INSERT [dbo].[Notifications] ON 

INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1, NULL, N'Đơn hàng #1 của áo thun đã được xác nhận.', 1, CAST(N'2025-05-10T10:30:00.000' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (2, NULL, N'Bộ sưu tập quần áo hè mới đã có!', 1, CAST(N'2025-05-11T11:00:00.000' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3, NULL, N'Đơn hàng #3 của áo sơ mi đã được giao.', 0, CAST(N'2025-05-12T14:30:00.000' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4, NULL, N'Hãy đánh giá váy bạn vừa mua!', 0, CAST(N'2025-05-13T15:00:00.000' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (5, NULL, N'Đơn hàng #5 của hoodie đang được xử lý.', 0, CAST(N'2025-05-14T08:30:00.000' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (6, NULL, N'Bộ sưu tập phụ kiện mới đã có!', 1, CAST(N'2025-05-15T09:30:00.000' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (7, NULL, N'Đơn hàng #7 của legging đã được giao.', 0, CAST(N'2025-05-16T11:30:00.000' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (8, NULL, N'Cảm ơn bạn đã mua áo khoác mùa đông!', 1, CAST(N'2025-05-17T13:30:00.000' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1009, NULL, N'Đơn hàng của bạn với sản phẩm Sản phẩm đã được cập nhật trạng thái: Shipped', 1, CAST(N'2025-06-27T10:50:28.257' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1010, NULL, N'Đơn hàng của bạn với sản phẩm Sản phẩm đã được cập nhật trạng thái: Shipped', 1, CAST(N'2025-06-27T10:52:48.353' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1011, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Processing', 0, CAST(N'2025-07-13T14:43:42.500' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1012, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-13T14:45:10.253' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1013, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-13T14:45:25.373' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1014, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-13T14:45:32.640' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1015, 3013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-16T17:38:14.473' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1016, 4014, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-16T17:38:14.490' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1017, 4015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-16T17:38:14.503' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1018, 5013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-16T17:38:14.520' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1019, 5015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-16T17:38:14.533' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1020, 5018, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-16T17:38:14.550' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1021, 3013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:08:49.497' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1022, 4014, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:08:49.527' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1023, 4015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:08:49.560' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1024, 5013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:08:49.590' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1025, 5015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:08:49.620' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1026, 5018, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:08:49.653' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1027, 3013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:11:45.217' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1028, 4014, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:11:45.253' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1029, 4015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:11:45.283' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1030, 5013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:11:45.313' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1031, 5015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:11:45.343' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1032, 5018, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:11:45.373' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1033, 3013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:14:01.820' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1034, 4014, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:14:01.853' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1035, 4015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:14:01.890' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1036, 5013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:14:01.923' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1037, 5015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:14:01.957' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1038, 5018, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:14:01.987' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1039, 3013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:21:54.610' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1040, 4014, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:21:54.650' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1041, 4015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:21:54.693' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1042, 5013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:21:54.727' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1043, 5015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:21:54.770' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1044, 5018, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:21:54.800' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1045, 3013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:24:44.280' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1046, 4014, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:24:44.303' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1047, 4015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:24:44.323' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1048, 5013, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:24:44.347' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1049, 5015, N'Có đơn hàng mới từ Kiênn', 0, CAST(N'2025-07-17T22:24:44.370' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (1050, 5018, N'Có đơn hàng mới từ Kiênn', 1, CAST(N'2025-07-17T22:24:44.390' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (2027, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Processing', 0, CAST(N'2025-07-18T11:45:37.513' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (2028, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-18T11:46:30.217' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (2029, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-18T11:46:58.900' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (2030, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Processing', 0, CAST(N'2025-07-22T21:14:22.190' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (2031, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Đang giao hàng', 1, CAST(N'2025-07-22T21:16:05.900' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (2032, 5020, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam Trắng  đã được cập nhật trạng thái: Đã giao', 1, CAST(N'2025-07-22T21:16:36.607' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (2033, 5023, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Nam  đã được cập nhật trạng thái: Processing', 0, CAST(N'2025-07-22T22:21:07.927' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3033, 5023, N'Đơn hàng của bạn với sản phẩm Áo Khoác Dù Chống Nước Basic đã được cập nhật trạng thái: Chờ lấy hàng', 0, CAST(N'2025-07-25T10:34:40.487' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3036, 5023, N'Đơn hàng của bạn với sản phẩm Áo Khoác Dù Chống Nước Basic đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-25T10:35:41.523' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3037, 5023, N'Đơn hàng của bạn với sản phẩm Áo Khoác Dù Chống Nước Basic đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-25T10:36:05.117' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3038, 5023, N'Đơn hàng của bạn với sản phẩm Áo Khoác Dù Chống Nước Basic đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-25T10:36:12.320' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3039, 5023, N'Đơn hàng của bạn với sản phẩm Áo Khoác Dù Chống Nước Basic đã được cập nhật trạng thái: Chờ lấy hàng', 0, CAST(N'2025-07-25T17:24:20.103' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3040, 5023, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Tay Ngắn Họa Tiết Caro Basic đã được cập nhật trạng thái: Chờ lấy hàng', 0, CAST(N'2025-07-26T00:39:06.553' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3041, 5023, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Tay Ngắn Họa Tiết Caro Basic đã được cập nhật trạng thái: Đang giao hàng', 1, CAST(N'2025-07-26T00:39:37.897' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3042, 5023, N'Đơn hàng của bạn với sản phẩm Áo Sơ Mi Tay Ngắn Họa Tiết Caro Basic đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-26T00:40:03.017' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3043, 5023, N'Đơn hàng của bạn với sản phẩm Quần Short Thể Thao đã được cập nhật trạng thái: Chờ lấy hàng', 0, CAST(N'2025-07-26T11:27:32.263' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3044, 5023, N'Đơn hàng của bạn với sản phẩm Quần Short Thể Thao đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-26T11:28:06.210' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3045, 5023, N'Đơn hàng của bạn với sản phẩm Quần Short Thể Thao đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-26T11:28:28.663' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3046, 5023, N'Đơn hàng của bạn với sản phẩm Quần Short Jean Rách Nhẹ Cá Tính đã được cập nhật trạng thái: Chờ lấy hàng', 0, CAST(N'2025-07-26T14:13:27.730' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3047, 5023, N'Đơn hàng của bạn với sản phẩm Quần Short Kaki Lưng Thun Co Giãn đã được cập nhật trạng thái: Chờ lấy hàng', 0, CAST(N'2025-07-26T14:15:59.723' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3048, 5023, N'Đơn hàng của bạn với sản phẩm Quần Short Kaki Lưng Thun Co Giãn đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-26T14:16:14.573' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (3049, 5023, N'Đơn hàng của bạn với sản phẩm Quần Short Kaki Lưng Thun Co Giãn đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-26T14:16:51.967' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4046, 5023, N'Đơn hàng của bạn với sản phẩm Quần Kaki Nam Dáng Jogger Thời Trang đã được cập nhật trạng thái: Chờ lấy hàng', 0, CAST(N'2025-07-26T14:56:06.760' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4047, 5023, N'Đơn hàng của bạn với sản phẩm Quần Kaki Nam Dáng Jogger Thời Trang đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-26T14:56:40.017' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4048, 5023, N'Đơn hàng của bạn với sản phẩm Quần Kaki Nam Dáng Jogger Thời Trang đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-26T14:57:33.117' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4049, 5023, N'Đơn hàng của bạn với sản phẩm Quần Kaki Nam Co Giãn Slim Fit đã được cập nhật trạng thái: Chờ xác nhận', 0, CAST(N'2025-07-26T15:41:37.930' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4050, 5023, N'Đơn hàng của bạn với sản phẩm Quần Kaki Nam Co Giãn Slim Fit đã được cập nhật trạng thái: Chờ lấy hàng', 0, CAST(N'2025-07-26T15:41:44.757' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4051, 5023, N'Đơn hàng của bạn với sản phẩm Quần Kaki Nam Co Giãn Slim Fit đã được cập nhật trạng thái: Đang giao hàng', 0, CAST(N'2025-07-26T15:42:00.283' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4052, 5023, N'Đơn hàng của bạn với sản phẩm Áo Khoác Dù Chống Nước Basic đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-26T15:42:09.560' AS DateTime))
INSERT [dbo].[Notifications] ([NotificationID], [UserID], [Message], [IsRead], [CreatedAt]) VALUES (4053, 5023, N'Đơn hàng của bạn với sản phẩm Quần Kaki Nam Co Giãn Slim Fit đã được cập nhật trạng thái: Đã giao', 0, CAST(N'2025-07-26T15:42:29.883' AS DateTime))
SET IDENTITY_INSERT [dbo].[Notifications] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 

INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1266, 1033, NULL, 1, CAST(300000.00 AS Decimal(10, 2)), CAST(300000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1267, 1034, NULL, 20, CAST(250000.00 AS Decimal(10, 2)), CAST(5000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1268, 1035, NULL, 20, CAST(250000.00 AS Decimal(10, 2)), CAST(5000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1269, 1036, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1270, 1037, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1271, 1038, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1272, 1039, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1273, 1040, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1274, 1041, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'L', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1275, 1042, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (1276, 1043, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (2276, 2043, NULL, 20, CAST(250000.00 AS Decimal(10, 2)), CAST(5000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (2277, 2044, NULL, 10, CAST(250000.00 AS Decimal(10, 2)), CAST(2500000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3276, 3043, NULL, 10, CAST(250000.00 AS Decimal(10, 2)), CAST(2500000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3277, 3044, NULL, 10, CAST(300000.00 AS Decimal(10, 2)), CAST(3000000.00 AS Decimal(10, 2)), N'S', N'Đen')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3294, 3059, NULL, 5, CAST(100000.00 AS Decimal(10, 2)), CAST(500000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3295, 3060, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3296, 3061, NULL, 2, CAST(100000.00 AS Decimal(10, 2)), CAST(200000.00 AS Decimal(10, 2)), N'XXL', N'White')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3297, 3062, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'XXL', N'White')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3298, 3063, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3299, 3064, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'White')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3300, 3065, NULL, 201, CAST(100000.00 AS Decimal(10, 2)), CAST(20100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3301, 3066, NULL, 2, CAST(100000.00 AS Decimal(10, 2)), CAST(200000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3302, 3067, NULL, 2, CAST(100000.00 AS Decimal(10, 2)), CAST(200000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3303, 3068, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3304, 3069, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (3305, 3070, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4302, 4067, NULL, 2, CAST(100000.00 AS Decimal(10, 2)), CAST(200000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4303, 4068, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4304, 4069, NULL, 2, CAST(100000.00 AS Decimal(10, 2)), CAST(200000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4305, 4070, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4306, 4071, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4307, 4072, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4308, 4073, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4309, 4074, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4310, 4075, NULL, 10, CAST(100000.00 AS Decimal(10, 2)), CAST(1000000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4311, 4076, NULL, 2, CAST(100000.00 AS Decimal(10, 2)), CAST(200000.00 AS Decimal(10, 2)), N'S', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (4312, 4077, NULL, 1, CAST(100000.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), N'S', N'White')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (5312, 5077, 1039, 1, CAST(549000.00 AS Decimal(10, 2)), CAST(549000.00 AS Decimal(10, 2)), N'XS', N'Blue')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (6312, 6077, 1038, 1, CAST(399000.00 AS Decimal(10, 2)), CAST(399000.00 AS Decimal(10, 2)), N'L', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (6313, 6078, 1038, 1, CAST(399000.00 AS Decimal(10, 2)), CAST(399000.00 AS Decimal(10, 2)), N'M', N'White')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (6314, 6079, 1038, 2, CAST(399000.00 AS Decimal(10, 2)), CAST(798000.00 AS Decimal(10, 2)), N'L', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (6315, 6080, 1038, 1, CAST(399000.00 AS Decimal(10, 2)), CAST(399000.00 AS Decimal(10, 2)), N'L', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (6316, 6081, 1042, 1, CAST(259000.00 AS Decimal(10, 2)), CAST(259000.00 AS Decimal(10, 2)), N'L', N'White')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (6317, 6082, 1055, 1, CAST(199000.00 AS Decimal(10, 2)), CAST(199000.00 AS Decimal(10, 2)), N'L', N'White')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (6318, 6083, 1054, 1, CAST(289000.00 AS Decimal(10, 2)), CAST(289000.00 AS Decimal(10, 2)), N'L', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (6319, 6084, 1053, 1, CAST(249000.00 AS Decimal(10, 2)), CAST(249000.00 AS Decimal(10, 2)), N'L', N'Blue')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (7318, 7083, 1052, 1, CAST(319000.00 AS Decimal(10, 2)), CAST(319000.00 AS Decimal(10, 2)), N'L', N'Black')
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [TotalPrice], [Size], [Color]) VALUES (7319, 7084, 1051, 1, CAST(389000.00 AS Decimal(10, 2)), CAST(389000.00 AS Decimal(10, 2)), N'L', N'Red')
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1, NULL, CAST(N'2025-05-10T10:00:00.000' AS DateTime), N'Processing', CAST(700000.00 AS Decimal(10, 2)), N'123 Đường Láng, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (2, NULL, CAST(N'2025-05-11T12:00:00.000' AS DateTime), N'Processing', CAST(1000000.00 AS Decimal(10, 2)), N'456 Cầu Giấy, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3, NULL, CAST(N'2025-05-12T14:00:00.000' AS DateTime), N'Delivered', CAST(600000.00 AS Decimal(10, 2)), N'789 Nguyễn Trãi, TP.HCM')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4, NULL, CAST(N'2025-05-13T16:00:00.000' AS DateTime), N'Delivered', CAST(250000.00 AS Decimal(10, 2)), N'101 Lý Thường Kiệt, Đà Nẵng')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (5, NULL, CAST(N'2025-05-14T08:00:00.000' AS DateTime), N'Pending', CAST(350000.00 AS Decimal(10, 2)), N'202 Trần Phú, Huế')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6, NULL, CAST(N'2025-05-15T09:00:00.000' AS DateTime), N'Shipped', CAST(800000.00 AS Decimal(10, 2)), N'303 Lê Lợi, Cần Thơ')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (7, NULL, CAST(N'2025-05-16T11:00:00.000' AS DateTime), N'Delivered', CAST(900000.00 AS Decimal(10, 2)), N'404 Trần Hưng Đạo, Nha Trang')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (8, NULL, CAST(N'2025-05-17T13:00:00.000' AS DateTime), N'Delivered', CAST(2000000.00 AS Decimal(10, 2)), N'505 Võ Văn Tần, Vũng Tàu')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (9, NULL, CAST(N'2025-06-11T00:00:00.000' AS DateTime), N'Pending', CAST(1800000.00 AS Decimal(10, 2)), N'thai binh, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (10, NULL, CAST(N'2025-06-27T00:00:00.000' AS DateTime), N'Cancelled', CAST(350000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (11, NULL, CAST(N'2025-06-27T00:00:00.000' AS DateTime), N'Shipped', CAST(500000.00 AS Decimal(10, 2)), N'1334, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (12, 4015, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(250000.00 AS Decimal(10, 2)), N'444, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1012, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(5550000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1013, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(5550000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1014, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(5550000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1015, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(250000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1016, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(500000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1017, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(680000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1018, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(750000.00 AS Decimal(10, 2)), N'13, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1019, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(2750000.00 AS Decimal(10, 2)), N'456, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1020, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(2000000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1021, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(250000.00 AS Decimal(10, 2)), N'1313, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1022, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(1250000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1023, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(1250000.00 AS Decimal(10, 2)), N'23, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1024, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(2500000.00 AS Decimal(10, 2)), N'13, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1025, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(250000.00 AS Decimal(10, 2)), N'53464, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1026, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(750000.00 AS Decimal(10, 2)), N'122, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1027, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(2250000.00 AS Decimal(10, 2)), N'424, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1028, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(250000.00 AS Decimal(10, 2)), N'124, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1029, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(2250000.00 AS Decimal(10, 2)), N'1412, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1030, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(250000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1031, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(250000.00 AS Decimal(10, 2)), N'13123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1032, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(250000.00 AS Decimal(10, 2)), N'13, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1033, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(300000.00 AS Decimal(10, 2)), N'3213, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1034, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(5000000.00 AS Decimal(10, 2)), N'1232, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1035, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(5000000.00 AS Decimal(10, 2)), N'123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1036, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'1123, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1037, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'cz, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1038, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'đá, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1039, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'sfdfs, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1040, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'dá, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1041, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'dsa, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1042, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'vxcv, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (1043, 14, CAST(N'2025-06-28T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'xzx, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (2043, 4014, CAST(N'2025-06-29T00:00:00.000' AS DateTime), N'Cancelled', CAST(5000000.00 AS Decimal(10, 2)), N'788, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (2044, 4014, CAST(N'2025-06-29T00:00:00.000' AS DateTime), N'Cancelled', CAST(2500000.00 AS Decimal(10, 2)), N'bhj, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3043, 4014, CAST(N'2025-07-01T00:00:00.000' AS DateTime), N'Cancelled', CAST(2500000.00 AS Decimal(10, 2)), N'đâsdas, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3044, 4014, CAST(N'2025-07-01T00:00:00.000' AS DateTime), N'Cancelled', CAST(3000000.00 AS Decimal(10, 2)), N'rfsdf, thai binh, thai binh, thai binh')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3045, 5020, CAST(N'2025-07-12T00:00:00.000' AS DateTime), N'Cancelled', CAST(200000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3046, 5020, CAST(N'2025-07-12T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3047, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(200000.00 AS Decimal(10, 2)), N'345, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3048, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(300000.00 AS Decimal(10, 2)), N'567, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3049, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(500000.00 AS Decimal(10, 2)), N'111, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3050, 5020, CAST(N'2025-07-13T02:00:58.513' AS DateTime), N'Pending', CAST(500000.00 AS Decimal(10, 2)), N'111, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3052, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(600000.00 AS Decimal(10, 2)), N'123, Trung Văn, Quận 1, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3053, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(200000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3054, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Cancelled', CAST(200000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3055, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Cancelled', CAST(200000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3056, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Cancelled', CAST(300000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3057, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(400000.00 AS Decimal(10, 2)), N'666, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3058, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(500000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3059, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(500000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3060, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Delivered', CAST(100000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3061, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(200000.00 AS Decimal(10, 2)), N'999, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3062, 5020, CAST(N'2025-07-13T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'456, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3063, 5020, CAST(N'2025-07-16T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'333, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3064, 5020, CAST(N'2025-07-16T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'555, Trung Văn, bình chánh, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3065, 5020, CAST(N'2025-07-16T00:00:00.000' AS DateTime), N'Pending', CAST(20100000.00 AS Decimal(10, 2)), N'12345, Trung Văn, Quận 1, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3066, 5020, CAST(N'2025-07-17T00:00:00.000' AS DateTime), N'Pending', CAST(200000.00 AS Decimal(10, 2)), N'123, Trung Văn, bình chánh, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3067, 5020, CAST(N'2025-07-17T00:00:00.000' AS DateTime), N'Pending', CAST(200000.00 AS Decimal(10, 2)), N'123, Trung Văn, bình chánh, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3068, 5020, CAST(N'2025-07-17T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'666, Trung Văn, bình chánh, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3069, 5020, CAST(N'2025-07-17T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'777, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (3070, 5020, CAST(N'2025-07-17T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'222, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4067, 5020, CAST(N'2025-07-17T00:00:00.000' AS DateTime), N'Pending', CAST(200000.00 AS Decimal(10, 2)), N'123, Trung Văn, Quận 1, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4068, 5020, CAST(N'2025-07-17T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'789, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4069, 5020, CAST(N'2025-07-18T00:00:00.000' AS DateTime), N'Pending', CAST(200000.00 AS Decimal(10, 2)), N'444, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4070, 5020, CAST(N'2025-07-18T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'333, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4071, 5020, CAST(N'2025-07-18T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'567, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4072, 5020, CAST(N'2025-07-18T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'777, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4073, 5020, CAST(N'2025-07-18T00:00:00.000' AS DateTime), N'Pending', CAST(100000.00 AS Decimal(10, 2)), N'898, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4074, 5020, CAST(N'2025-07-18T00:00:00.000' AS DateTime), N'Delivered', CAST(100000.00 AS Decimal(10, 2)), N'111, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4075, 5020, CAST(N'2025-07-18T00:00:00.000' AS DateTime), N'Pending', CAST(1000000.00 AS Decimal(10, 2)), N'444, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4076, 5020, CAST(N'2025-07-22T00:00:00.000' AS DateTime), N'Delivered', CAST(200000.00 AS Decimal(10, 2)), N'246, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (4077, 5023, CAST(N'2025-07-22T00:00:00.000' AS DateTime), N'Cancelled', CAST(100000.00 AS Decimal(10, 2)), N'666, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (5077, 5023, CAST(N'2025-07-23T00:00:00.000' AS DateTime), N'Pending', CAST(549000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6077, 5023, CAST(N'2025-07-24T00:00:00.000' AS DateTime), N'Pending', CAST(399000.00 AS Decimal(10, 2)), N'123, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6078, 5023, CAST(N'2025-07-24T00:00:00.000' AS DateTime), N'Pending', CAST(399000.00 AS Decimal(10, 2)), N'333, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6079, 5023, CAST(N'2025-07-25T00:00:00.000' AS DateTime), N'Delivered', CAST(798000.00 AS Decimal(10, 2)), N'12, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6080, 5023, CAST(N'2025-07-25T00:00:00.000' AS DateTime), N'Delivered', CAST(399000.00 AS Decimal(10, 2)), N'13, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6081, 5023, CAST(N'2025-07-26T00:00:00.000' AS DateTime), N'Delivered', CAST(259000.00 AS Decimal(10, 2)), N'14, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6082, 5023, CAST(N'2025-07-26T00:00:00.000' AS DateTime), N'Delivered', CAST(199000.00 AS Decimal(10, 2)), N'555, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6083, 5023, CAST(N'2025-07-26T00:00:00.000' AS DateTime), N'Delivered', CAST(289000.00 AS Decimal(10, 2)), N'212, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (6084, 5023, CAST(N'2025-07-26T00:00:00.000' AS DateTime), N'Delivered', CAST(249000.00 AS Decimal(10, 2)), N'215, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (7083, 5023, CAST(N'2025-07-26T00:00:00.000' AS DateTime), N'Delivered', CAST(319000.00 AS Decimal(10, 2)), N'255, Phú Lãm, Hà Đông, Hà Nội')
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [Status], [TotalAmount], [ShippingAddress]) VALUES (7084, 5023, CAST(N'2025-07-26T00:00:00.000' AS DateTime), N'Delivered', CAST(389000.00 AS Decimal(10, 2)), N'340, Phú Lãm, Hà Đông, Hà Nội')
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[password_reset_tokens] ON 

INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (1, 14, N'bdb88c83-58d0-4071-bc6e-b7fd27c9e4c5', CAST(N'2025-06-05T23:43:30.287' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (2, 14, N'ccc189de-0e91-499a-981c-60347f64f79d', CAST(N'2025-06-05T23:45:08.737' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (3, 14, N'53e8d0c3-f1ad-4b4d-b295-4afdf2c40350', CAST(N'2025-06-05T23:47:51.847' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4, 14, N'f37e2490-6eeb-4376-8b82-4f3104bd7cab', CAST(N'2025-06-05T23:52:46.240' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5, 14, N'617fecbb-babd-40af-a43c-4bc4a88fcb21', CAST(N'2025-06-06T00:28:08.427' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (1002, 14, N'6e439953-4559-4a8c-a0a5-ba5628b4fa42', CAST(N'2025-06-06T02:48:42.980' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (2002, 14, N'499ddc41-91a3-4657-b63b-19ea47d3ec2e', CAST(N'2025-06-08T21:21:48.937' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (2003, 14, N'7cf8ea7b-fe1f-4bc5-9f30-86b7208e0b30', CAST(N'2025-06-08T22:01:23.407' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (2004, 14, N'aa415f13-48eb-405b-8694-4e9f144c0f96', CAST(N'2025-06-08T22:16:49.827' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (2005, 14, N'58fa76cc-422b-4b16-82a9-4d5f880f9e2d', CAST(N'2025-06-08T22:17:55.857' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (3002, 14, N'49f308e0-8954-4359-8b4b-0a79932582e5', CAST(N'2025-06-13T10:50:49.677' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (3003, 14, N'4923d24a-725e-4aa1-8adb-77065f10b2bd', CAST(N'2025-06-13T10:57:01.697' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (3004, 14, N'f8502f85-7f11-4bbc-9a53-21baf3d82d9e', CAST(N'2025-06-13T20:34:59.227' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4002, 14, N'f6855aff-eb2e-4c48-bac5-b631737e5224', CAST(N'2025-06-27T11:45:56.723' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4003, 14, N'395c328e-604a-4633-9058-1547bc4ec3fa', CAST(N'2025-06-27T11:46:03.517' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4004, 14, N'b6e22154-9786-4667-8b58-fe40e7db011e', CAST(N'2025-06-27T11:46:52.883' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4005, 14, N'62d33383-be46-47c5-a329-fad4879b9752', CAST(N'2025-06-27T11:46:58.213' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4006, 14, N'194047f2-f2d2-4676-9f19-a771529f75ce', CAST(N'2025-06-27T11:51:08.367' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4007, 14, N'bc94de8f-597f-4abb-abfc-b344413b411c', CAST(N'2025-06-27T11:51:24.700' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4008, 14, N'80520992-e611-4044-bc00-501f9943c8de', CAST(N'2025-06-27T11:51:54.520' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4009, 14, N'30515f58-38e3-4695-bc0b-82096a919455', CAST(N'2025-06-27T11:53:27.940' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4010, 14, N'd7929f53-f58c-420f-8753-ff9d9851d4bd', CAST(N'2025-06-27T11:54:57.437' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4011, 14, N'53ccbaf0-4393-47bc-ab62-99da26f4e432', CAST(N'2025-06-27T11:56:41.363' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4012, 14, N'c87d6e8a-b3ac-4511-9b0f-7d067bf67d1e', CAST(N'2025-06-27T11:59:33.063' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4013, 14, N'b7eb420f-6840-4d54-96d1-a4f3fb45a5b3', CAST(N'2025-06-27T12:00:11.493' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4014, 14, N'4263053f-0bf6-4adb-8396-55ffa66d5e84', CAST(N'2025-06-27T12:02:26.377' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4015, 14, N'01df4539-0e4c-466d-ba75-e8b1e77e84ad', CAST(N'2025-06-27T12:09:20.127' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4016, 14, N'9b9c8996-76d1-4a18-98e3-88961a7fbd14', CAST(N'2025-06-27T23:24:59.860' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4017, 14, N'ee354e4d-1ead-4597-aacf-834e058a91fb', CAST(N'2025-06-27T23:25:00.120' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (4018, 14, N'0afb0606-0fd9-4d14-acc4-fbd1cbcf314b', CAST(N'2025-06-27T23:49:54.167' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5016, 14, N'26e30c53-da73-42ff-80c4-374735858ba8', CAST(N'2025-06-28T17:46:12.897' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5017, 14, N'f51706b7-4d72-4f76-838a-a4bf0a2b278a', CAST(N'2025-06-28T17:49:09.860' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5018, 14, N'0de05e77-b407-4ec9-b477-41e8b4534a9f', CAST(N'2025-06-28T17:49:55.797' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5019, 14, N'd0904aad-2c29-4e05-b7f3-388c386c527a', CAST(N'2025-06-28T17:50:52.150' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5020, 14, N'b8c1bf1a-17e7-4ee5-9563-c79a03317555', CAST(N'2025-06-28T17:51:04.377' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5021, 5023, N'1d05e07f-30aa-41aa-9c6d-ec52fece8e7d', CAST(N'2025-07-22T21:55:00.183' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5022, 5023, N'7e141578-99b6-4c46-b5da-c7d987976b6f', CAST(N'2025-07-22T21:58:28.133' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5023, 5023, N'a491ced7-8292-405c-8535-6ff8faf8d933', CAST(N'2025-07-22T22:01:21.393' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5024, 5023, N'8e382d5e-db22-4666-bf79-1a14441f3ee9', CAST(N'2025-07-22T22:03:47.243' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5025, 5023, N'36528b4e-2783-47dd-8ca7-96189bd1c10b', CAST(N'2025-07-22T22:10:46.647' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5026, 5023, N'ab4c7a69-b160-4a00-855c-8dc4e36d336c', CAST(N'2025-07-22T22:11:40.933' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (5027, 5023, N'3f43d773-516c-4246-9ebb-ca5a3813cd0f', CAST(N'2025-07-22T22:36:23.293' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (6025, 5023, N'a7eb86e7-48fc-4857-98f7-12b1a39580fd', CAST(N'2025-07-26T11:40:15.310' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (6026, 5023, N'8123ec2b-c614-4c25-96ad-918f2652a2df', CAST(N'2025-07-26T11:40:26.110' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (6027, 5023, N'7528c3e1-f9fb-42e6-a7ba-8ebf93243540', CAST(N'2025-07-26T11:42:28.873' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (6028, 5023, N'a54f43b7-af0b-47e2-8d95-39a248160196', CAST(N'2025-07-26T11:46:13.357' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (6029, 5023, N'3b24d2ab-3790-4e99-aeef-06bf5ec3630d', CAST(N'2025-07-26T11:47:23.960' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (6030, 5026, N'f79e014a-ba03-4d81-8fe5-2af0c508d910', CAST(N'2025-07-26T11:53:20.900' AS DateTime), 0)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (6031, 5023, N'0aa7368d-7084-46a8-938e-0f980f4c84dd', CAST(N'2025-07-26T11:53:59.833' AS DateTime), 1)
INSERT [dbo].[password_reset_tokens] ([id], [user_id], [token], [expiry], [is_used]) VALUES (6032, 5023, N'9c3047de-eda0-4df1-ab3c-7ee46f36889d', CAST(N'2025-07-26T16:09:23.893' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[password_reset_tokens] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1038, N'Áo Khoác Dù Chống Nước Basic', 1, N'Áo khoác dù thiết kế đơn giản, chất liệu chống nước, chống gió nhẹ. Phù hợp để mặc hằng ngày hoặc đi phượt. Có mũ trùm đầu, dây rút điều chỉnh và khóa kéo bền.', CAST(399000.00 AS Decimal(10, 2)), 115, N'uploads/products/137d1b3c-e6c9-4c22-be8d-ba1c4e7f8feb.jpg', 1, CAST(N'2025-07-22T22:41:00.887' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1039, N' Áo Khoác Jean Form Rộng Vintage', 1, N'Áo khoác jean phong cách cổ điển, form rộng dễ phối đồ. Chất liệu denim dày dặn, bền màu. Có túi trước ngực và cúc kim loại chắc chắn.', CAST(549000.00 AS Decimal(10, 2)), 87, N'uploads/products/fbd82744-0cea-4f7a-80b6-55751540ce9a.jpg', 1, CAST(N'2025-07-22T22:42:37.327' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1040, N'Áo Khoác Bomber Trơn Cao Cấp', 1, N'Áo bomber kiểu dáng hiện đại, chất vải dày dặn giữ ấm tốt. Bo tay và bo gấu co giãn, cổ đứng vừa vặn. Thích hợp mặc đi học, đi làm, đi chơi.
', CAST(475000.00 AS Decimal(10, 2)), 97, N'uploads/products/8e0e089b-50b8-496d-9be5-adc66a073187.jpg', 1, CAST(N'2025-07-22T22:43:57.330' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1041, N'Áo Sơ Mi Basic', 7, N'Áo sơ mi nam cổ bẻ, thiết kế trơn lịch sự, chất vải cotton pha mềm mại, thấm hút mồ hôi tốt. Phù hợp mặc đi làm, đi học, hoặc dự tiệc.', CAST(300000.00 AS Decimal(10, 2)), 200, N'uploads/products/1264cba9-f83a-48aa-9904-4cdc8959544a.jpg', 1, CAST(N'2025-07-22T22:45:22.383' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1042, N'Áo Sơ Mi Tay Ngắn Họa Tiết Caro Basic', 7, N'Áo sơ mi họa tiết caro cổ điển, form regular fit dễ mặc. Chất vải thoáng mát, ít nhăn, thích hợp mặc mùa hè hoặc đi chơi.', CAST(259000.00 AS Decimal(10, 2)), 99, N'uploads/products/4eaaa6d7-d5ca-4086-9c75-307126f9e7b8.jpg', 1, CAST(N'2025-07-22T22:46:43.853' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1043, N'Áo Sơ Mi Denim Cổ Trụ', 7, N'Áo sơ mi chất liệu denim dày nhẹ, màu xanh đậm cá tính. Thiết kế cổ trụ độc đáo, phối được nhiều phong cách thời trang từ năng động đến lịch lãm.', CAST(379000.00 AS Decimal(10, 2)), 70, N'uploads/products/127ac78a-b842-4884-b271-b9ee803cb682.jpg', 1, CAST(N'2025-07-22T22:48:20.433' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1044, N'Áo Thun Trơn Cổ Tròn Cotton', 6, N'Áo thun cổ tròn basic, chất liệu cotton 100% co giãn 4 chiều, thấm hút mồ hôi tốt. Phù hợp mặc hằng ngày, dễ phối đồ với quần jeans, quần short.', CAST(199000.00 AS Decimal(10, 2)), 150, N'uploads/products/0ed8e877-75be-4f1e-bbda-c690a6925b5c.jpg', 1, CAST(N'2025-07-22T22:50:17.840' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1045, N'Áo Thun In Hình Graphic Streetwear', 6, N'Áo thun nam in hình phong cách đường phố, form rộng trẻ trung. Vải cotton pha co giãn, hình in sắc nét, bền màu sau nhiều lần giặt.', CAST(229000.00 AS Decimal(10, 2)), 120, N'uploads/products/1b85e163-52f4-4280-8f15-3bc0423c5cc1.jpg', 1, CAST(N'2025-07-22T22:51:21.437' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1046, N'Áo Thun Nam Polo Cổ Bẻ Thanh Lịch', 6, N'Áo polo nam cổ bẻ, chất liệu thun cá sấu co giãn nhẹ. Thiết kế thanh lịch, thích hợp mặc đi chơi, đi làm hoặc dạo phố cuối tuần.', CAST(279000.00 AS Decimal(10, 2)), 100, N'uploads/products/1d079ba6-2669-4c5b-a281-6f5783b7ff61.jpg', 1, CAST(N'2025-07-22T22:52:57.133' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1047, N'Quần Jean Ống Suông Cổ Điển', 5, N'Quần jean nam form ống suông truyền thống, chất liệu denim dày, không co giãn. Kiểu dáng đơn giản, dễ phối đồ, phù hợp mặc đi học, đi làm hoặc dạo phố.', CAST(399000.00 AS Decimal(10, 2)), 95, N'uploads/products/96be9ca0-fc97-488b-9797-09086bd8af22.jpg', 1, CAST(N'2025-07-22T22:54:54.390' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1048, N'Quần Jean Co Giãn Skinny Fit', 5, N'Quần jean skinny ôm dáng, làm từ chất liệu denim pha spandex co giãn tốt, giúp di chuyển thoải mái. Phù hợp với phong cách hiện đại, trẻ trung.', CAST(459000.00 AS Decimal(10, 2)), 105, N'uploads/products/dc2dbdf1-71db-4cd3-a705-6576ab0ab8a7.jpg', 1, CAST(N'2025-07-22T22:55:53.257' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1049, N'Quần Jean Rách Gối Cá Tính', 5, N'Quần jean nam phong cách streetwear, có chi tiết rách nhẹ ở hai đầu gối. Chất denim mềm, bền màu, mang lại vẻ ngoài năng động, cá tính.', CAST(429000.00 AS Decimal(10, 2)), 75, N'uploads/products/b451495f-0723-4ead-8c70-ad7d40165779.jpg', 1, CAST(N'2025-07-22T22:57:02.260' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1050, N'Quần Kaki Ống Đứng Công Sở', 8, N'Quần kaki nam form ống đứng lịch sự, chất vải kaki mềm, không nhăn. Phù hợp mặc đi làm, đi học hoặc đi sự kiện cần sự chỉnh chu.', CAST(349000.00 AS Decimal(10, 2)), 120, N'uploads/products/77883050-5569-47a9-8687-64e1070a52d8.jpg', 1, CAST(N'2025-07-22T22:59:28.213' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1051, N'Quần Kaki Nam Co Giãn Slim Fit', 8, N'Quần kaki form slim ôm nhẹ, chất vải có độ co giãn tạo cảm giác thoải mái khi vận động. Thiết kế đơn giản, dễ phối với áo thun, áo sơ mi.', CAST(389000.00 AS Decimal(10, 2)), 104, N'uploads/products/5da3523d-c325-402c-ac8b-f60d3f9dd3f5.jpg', 1, CAST(N'2025-07-22T23:01:04.040' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1052, N'Quần Kaki Nam Dáng Jogger Thời Trang', 8, N'Quần kaki nam kiểu jogger năng động, bo gấu, lưng thun co giãn. Phù hợp mặc đi chơi, dạo phố hoặc vận động nhẹ.', CAST(319000.00 AS Decimal(10, 2)), 109, N'uploads/products/514268b7-5205-4202-8ae1-7b646f32e1ab.jpg', 1, CAST(N'2025-07-22T23:02:12.183' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1053, N'Quần Short Kaki Lưng Thun Co Giãn', 10, N'Quần short kaki nam dáng basic, lưng thun co giãn, chất vải mềm mịn, thoáng mát. Phù hợp mặc đi chơi, ở nhà hoặc dạo phố ngày hè.', CAST(249000.00 AS Decimal(10, 2)), 149, N'uploads/products/d99ca177-8222-4c40-9927-d46dee2278d1.jpg', 1, CAST(N'2025-07-22T23:05:09.163' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1054, N'Quần Short Jean Rách Nhẹ Cá Tính', 10, N'Quần short chất liệu denim, thiết kế rách nhẹ ở ống tạo điểm nhấn trẻ trung. Dáng regular fit, thích hợp cho phong cách năng động, đường phố.', CAST(289000.00 AS Decimal(10, 2)), 84, N'uploads/products/4d9968a4-eade-4f1b-bd51-f1d3141ff08f.jpg', 1, CAST(N'2025-07-22T23:06:41.707' AS DateTime))
INSERT [dbo].[Products] ([ProductID], [Name], [CategoryID], [Description], [Price], [Quantity], [ImageURL], [IsActive], [CreatedAt]) VALUES (1055, N'Quần Short Thể Thao', 10, N'Quần short nam thể thao chất liệu poly mỏng nhẹ, thoáng khí và khô nhanh. Phù hợp cho các hoạt động vận động như chạy bộ, tập gym, chơi thể thao.', CAST(199000.00 AS Decimal(10, 2)), 159, N'uploads/products/5cb603ae-517f-47b9-a89a-27de58b378b6.jpg', 1, CAST(N'2025-07-22T23:08:58.600' AS DateTime))
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductVariants] ON 

INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (1, 1037, N'XL', N'Red', N'1037-M-WHITE-4D6', 196, CAST(100000.00 AS Decimal(10, 2)), N'uploads/1753197970959_đỏ.jpg', 1, CAST(N'2025-07-02T12:23:22.257' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (2, 1037, N'XL', N'Blue', N'1037-XL-BLUE-A2A', 100, CAST(100000.00 AS Decimal(10, 2)), N'uploads/1753198004598_xanh.jpg', 1, CAST(N'2025-07-03T22:08:46.870' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (3, 1037, N'XXL', N'White', N'1037-XXL-WHITE-E85', 150, CAST(100000.00 AS Decimal(10, 2)), N'uploads/1753198011446_trắng.jpg', 1, CAST(N'2025-07-03T22:20:21.913' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (4, 1037, N'S', N'Black', N'1037-S-BLACK-72A', 88, CAST(100000.00 AS Decimal(10, 2)), N'uploads/1753197981110_đen.jpg', 1, CAST(N'2025-07-03T22:30:35.523' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (5, 1037, N'S', N'White', N'1037-S-WHITE-579', 98, CAST(100000.00 AS Decimal(10, 2)), N'uploads/1753197996479_trắng.jpg', 1, CAST(N'2025-07-07T22:01:15.637' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (6, 1036, N'XL', N'Black', N'1036-XL-BLACK-137', 150, CAST(250000.00 AS Decimal(10, 2)), NULL, 1, CAST(N'2025-07-07T22:52:33.847' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (7, 1036, N'XXL', N'White', N'1036-XXL-WHITE-05C', 200, CAST(250000.00 AS Decimal(10, 2)), NULL, 1, CAST(N'2025-07-07T22:54:44.057' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (8, 1038, N'S', N'Black', N'1038-S-BLACK-429', 30, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753509265664_đen.jpg', 1, CAST(N'2025-07-22T23:14:34.550' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (9, 1038, N'M', N'White', N'1038-M-WHITE-D1F', 29, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753509260831_trắng.jpg', 1, CAST(N'2025-07-22T23:15:01.363' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (10, 1038, N'L', N'Black', N'1038-L-BLACK-6C6', 26, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753509255326_đen.jpg', 1, CAST(N'2025-07-22T23:15:14.810' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (11, 1038, N'XL', N'White', N'1038-XL-WHITE-D1C', 30, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753509280989_trắng.jpg', 1, CAST(N'2025-07-22T23:15:29.427' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (12, 1039, N'S', N'Black', N'1039-S-BLACK-712', 17, CAST(549000.00 AS Decimal(10, 2)), N'uploads/1753509213286_đen.jpg', 1, CAST(N'2025-07-22T23:17:31.567' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (13, 1039, N'XL', N'White', N'1039-XL-WHITE-860', 17, CAST(549000.00 AS Decimal(10, 2)), N'uploads/1753509224982_trắng.jpg', 1, CAST(N'2025-07-22T23:18:15.713' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (14, 1039, N'L', N'Red', N'1039-L-RED-EDD', 17, CAST(549000.00 AS Decimal(10, 2)), N'uploads/1753509208382_đỏ.jpg', 1, CAST(N'2025-07-22T23:19:10.167' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (15, 1039, N'S', N'White', N'1039-S-WHITE-540', 17, CAST(549000.00 AS Decimal(10, 2)), N'uploads/1753509219280_trắng.jpg', 1, CAST(N'2025-07-22T23:19:25.710' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (16, 1039, N'XS', N'Blue', N'1039-XS-BLUE-CE1', 19, CAST(549000.00 AS Decimal(10, 2)), N'uploads/1753509230364_xanh.jpg', 1, CAST(N'2025-07-22T23:20:10.240' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (17, 1040, N'S', N'Green', N'1040-S-GREEN-241', 32, CAST(475000.00 AS Decimal(10, 2)), N'uploads/1753509157080_xanh lá.jpg', 1, CAST(N'2025-07-22T23:24:22.857' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (18, 1040, N'L', N'White', N'1040-L-WHITE-BFD', 32, CAST(475000.00 AS Decimal(10, 2)), N'uploads/1753509151222_trắng.jpg', 1, CAST(N'2025-07-22T23:24:53.663' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (19, 1040, N'XXL', N'Red', N'1040-XXL-RED-BB5', 33, CAST(475000.00 AS Decimal(10, 2)), N'uploads/1753509161833_đỏ.jpg', 1, CAST(N'2025-07-22T23:25:18.793' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (20, 1041, N'S', N'White', N'1041-S-WHITE-95C', 25, CAST(300000.00 AS Decimal(10, 2)), N'uploads/1753509099720_trắng.jpg', 1, CAST(N'2025-07-22T23:27:09.077' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (21, 1041, N'L', N'White', N'1041-L-WHITE-CAD', 25, CAST(300000.00 AS Decimal(10, 2)), N'uploads/1753509086027_trắng.jpg', 1, CAST(N'2025-07-22T23:27:21.960' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (22, 1041, N'L', N'Black', N'1041-L-BLACK-7F1', 25, CAST(300000.00 AS Decimal(10, 2)), N'uploads/1753509074771_đen.jpg', 1, CAST(N'2025-07-22T23:27:36.750' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (23, 1041, N'XL', N'Black', N'1041-XL-BLACK-40B', 25, CAST(300000.00 AS Decimal(10, 2)), N'uploads/1753509105085_đen.jpg', 1, CAST(N'2025-07-22T23:27:46.613' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (24, 1041, N'XS', N'Blue', N'1041-XS-BLUE-E60', 25, CAST(300000.00 AS Decimal(10, 2)), N'uploads/1753509110658_xanh.jpg', 1, CAST(N'2025-07-22T23:27:58.130' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (25, 1041, N'XXL', N'Blue', N'1041-XXL-BLUE-AFB', 25, CAST(300000.00 AS Decimal(10, 2)), N'uploads/1753509116037_xanh.jpg', 1, CAST(N'2025-07-22T23:28:12.903' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (26, 1041, N'L', N'Red', N'1041-L-RED-264', 25, CAST(300000.00 AS Decimal(10, 2)), N'uploads/1753509080433_đỏ.jpg', 1, CAST(N'2025-07-22T23:28:25.837' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (27, 1041, N'M', N'Red', N'1041-M-RED-559', 25, CAST(300000.00 AS Decimal(10, 2)), N'uploads/1753509094034_đỏ.jpg', 1, CAST(N'2025-07-22T23:28:39.427' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (28, 1042, N'L', N'White', N'1042-L-WHITE-A9F', 29, CAST(259000.00 AS Decimal(10, 2)), N'uploads/1753509037406_z6831450906627_a07417a90efab36ffe2c7b8e8c984e01.jpg', 1, CAST(N'2025-07-22T23:30:49.857' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (29, 1042, N'XL', N'Red', N'1042-XL-RED-0C9', 30, CAST(259000.00 AS Decimal(10, 2)), N'uploads/1753509047240_đỏ.jpg', 1, CAST(N'2025-07-22T23:31:11.263' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (30, 1042, N'S', N'Blue', N'1042-S-BLUE-C25', 40, CAST(259000.00 AS Decimal(10, 2)), N'uploads/1753509042333_z6831452741050_71137644c461c195ee6338d8e465c3d3.jpg', 1, CAST(N'2025-07-22T23:31:40.853' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (31, 1043, N'M', N'Black', N'1043-M-BLACK-43B', 14, CAST(379000.00 AS Decimal(10, 2)), N'uploads/1753508872949_z6831455036054_6f15e5567ba66e53140518bc746d1e58.jpg', 1, CAST(N'2025-07-22T23:33:25.390' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (32, 1043, N'L', N'Black', N'1043-L-BLACK-121', 14, CAST(379000.00 AS Decimal(10, 2)), N'uploads/1753508866076_z6831455036054_6f15e5567ba66e53140518bc746d1e58.jpg', 1, CAST(N'2025-07-22T23:33:38.937' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (33, 1043, N'XL', N'Blue', N'1043-XL-BLUE-B52', 14, CAST(379000.00 AS Decimal(10, 2)), N'uploads/1753508878002_xanh.jpg', 1, CAST(N'2025-07-22T23:34:05.670' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (34, 1043, N'XS', N'Blue', N'1043-XS-BLUE-DBA', 14, CAST(379000.00 AS Decimal(10, 2)), N'uploads/1753508888922_xanh.jpg', 1, CAST(N'2025-07-22T23:34:17.303' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (35, 1043, N'XXL', N'White', N'1043-XXL-WHITE-CDA', 14, CAST(379000.00 AS Decimal(10, 2)), N'uploads/1753508883409_trắng.jpg', 1, CAST(N'2025-07-22T23:34:39.840' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (36, 1044, N'L', N'White', N'1044-L-WHITE-510', 30, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753508810208_trắng.jpg', 1, CAST(N'2025-07-22T23:35:59.813' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (37, 1044, N'XL', N'White', N'1044-XL-WHITE-FEC', 30, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753508827917_trắng.jpg', 1, CAST(N'2025-07-22T23:36:12.780' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (38, 1044, N'M', N'Black', N'1044-M-BLACK-EA1', 30, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753508816192_đen.jpg', 1, CAST(N'2025-07-22T23:36:37.890' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (39, 1044, N'S', N'Black', N'1044-S-BLACK-4FC', 30, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753508821748_đen.jpg', 1, CAST(N'2025-07-22T23:37:00.707' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (40, 1044, N'XXL', N'Blue', N'1044-XXL-BLUE-9BB', 30, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753508832711_xanh.jpg', 1, CAST(N'2025-07-22T23:37:20.017' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (41, 1045, N'M', N'Yellow', N'1045-M-YELLO-7D4', 20, CAST(229000.00 AS Decimal(10, 2)), N'uploads/1753508725582_vàng.jpg', 1, CAST(N'2025-07-22T23:38:43.903' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (42, 1045, N'L', N'Yellow', N'1045-L-YELLO-C90', 20, CAST(229000.00 AS Decimal(10, 2)), N'uploads/1753508719445_vàng.jpg', 1, CAST(N'2025-07-22T23:38:55.213' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (43, 1045, N'XL', N'Yellow', N'1045-XL-YELLO-D79', 20, CAST(229000.00 AS Decimal(10, 2)), N'uploads/1753508731008_vàng.jpg', 1, CAST(N'2025-07-22T23:39:07.107' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (44, 1045, N'XS', N'Green', N'1045-XS-GREEN-05A', 20, CAST(229000.00 AS Decimal(10, 2)), N'uploads/1753508736459_xanh lá.jpg', 1, CAST(N'2025-07-22T23:39:35.357' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (45, 1045, N'XXL', N'Green', N'1045-XXL-GREEN-F8B', 20, CAST(229000.00 AS Decimal(10, 2)), N'uploads/1753508741544_xanh lá.jpg', 1, CAST(N'2025-07-22T23:39:50.013' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (46, 1045, N'FreeSize', N'Black', N'1045-FreeSize-BLACK-7AB', 20, CAST(229000.00 AS Decimal(10, 2)), N'uploads/1753508694661_đen.jpg', 1, CAST(N'2025-07-22T23:40:01.383' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (47, 1046, N'L', N'White', N'1046-L-WHITE-806', 20, CAST(279000.00 AS Decimal(10, 2)), N'uploads/1753508598740_trắng.jpg', 1, CAST(N'2025-07-22T23:41:16.893' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (48, 1046, N'L', N'Black', N'1046-L-BLACK-C86', 20, CAST(279000.00 AS Decimal(10, 2)), N'uploads/1753508579969_đen.jpg', 1, CAST(N'2025-07-22T23:41:34.277' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (49, 1046, N'XL', N'White', N'1046-XL-WHITE-CDA', 20, CAST(279000.00 AS Decimal(10, 2)), N'uploads/1753508612554_trắng.jpg', 1, CAST(N'2025-07-22T23:41:46.027' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (50, 1046, N'S', N'Black', N'1046-S-BLACK-71D', 20, CAST(279000.00 AS Decimal(10, 2)), N'uploads/1753508605820_đen.jpg', 1, CAST(N'2025-07-22T23:41:56.640' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (51, 1046, N'XL', N'Blue', N'1046-XL-RED-6E8', 20, CAST(279000.00 AS Decimal(10, 2)), N'uploads/1753508618784_xanhduong.jpg', 1, CAST(N'2025-07-22T23:42:20.597' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (52, 1047, N'L', N'Blue', N'1047-L-BLUE-ABC', 15, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753508487237_xanhduong.jpg', 1, CAST(N'2025-07-22T23:43:24.167' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (53, 1047, N'XL', N'Black', N'1047-XL-BLACK-F62', 15, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753508507755_đen.jpg', 1, CAST(N'2025-07-22T23:43:45.593' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (54, 1047, N'M', N'Blue', N'1047-M-BLUE-96D', 20, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753508498348_xanhduong.jpg', 1, CAST(N'2025-07-22T23:43:59.840' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (55, 1047, N'S', N'Black', N'1047-S-BLACK-1D0', 25, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753508502638_đen.jpg', 1, CAST(N'2025-07-22T23:44:18.153' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (56, 1047, N'L', N'White', N'1047-L-WHITE-540', 20, CAST(399000.00 AS Decimal(10, 2)), N'uploads/1753508492252_trắng.jpg', 1, CAST(N'2025-07-22T23:44:39.803' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (57, 1048, N'L', N'Brown', N'1048-L-BROWN-74D', 20, CAST(459000.00 AS Decimal(10, 2)), N'uploads/1753508437069_z6831472707027_10f4417c2d36132539fe5409ab80a0ee.jpg', 1, CAST(N'2025-07-22T23:46:51.043' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (58, 1048, N'L', N'Black', N'1048-L-BLACK-19D', 15, CAST(459000.00 AS Decimal(10, 2)), N'uploads/1753508429943_đen.jpg', 1, CAST(N'2025-07-22T23:47:24.820' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (59, 1048, N'XL', N'Blue', N'1048-XL-BLUE-588', 20, CAST(459000.00 AS Decimal(10, 2)), N'uploads/1753508449215_xanhduong.jpg', 1, CAST(N'2025-07-22T23:47:40.130' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (60, 1048, N'S', N'Black', N'1048-S-BLACK-F99', 30, CAST(459000.00 AS Decimal(10, 2)), N'uploads/1753508443891_đen.jpg', 1, CAST(N'2025-07-22T23:47:54.820' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (61, 1048, N'XXL', N'Blue', N'1048-XXL-BLUE-666', 20, CAST(459000.00 AS Decimal(10, 2)), N'uploads/1753508454101_xanhduong.jpg', 1, CAST(N'2025-07-22T23:48:10.290' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (62, 1049, N'L', N'Blue', N'1049-L-BLUE-314', 15, CAST(429000.00 AS Decimal(10, 2)), N'uploads/1753508361672_xanh dương.jpg', 1, CAST(N'2025-07-22T23:49:20.140' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (63, 1049, N'XXL', N'Blue', N'1049-XXL-BLUE-CCB', 15, CAST(429000.00 AS Decimal(10, 2)), N'uploads/1753508387822_xanh dương.jpg', 1, CAST(N'2025-07-22T23:49:30.063' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (64, 1049, N'S', N'Black', N'1049-S-BLACK-436', 15, CAST(429000.00 AS Decimal(10, 2)), N'uploads/1753508369594_đen.jpg', 1, CAST(N'2025-07-22T23:49:55.993' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (65, 1049, N'L', N'Black', N'1049-L-BLACK-545', 15, CAST(429000.00 AS Decimal(10, 2)), N'uploads/1753508356414_đen.jpg', 1, CAST(N'2025-07-22T23:50:07.527' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (66, 1049, N'XL', N'White', N'1049-XL-WHITE-011', 15, CAST(429000.00 AS Decimal(10, 2)), N'uploads/1753508380526_trắng.jpg', 1, CAST(N'2025-07-22T23:50:23.240' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (67, 1050, N'L', N'Gray', N'1050-L-GRAY-F85', 20, CAST(349000.00 AS Decimal(10, 2)), N'uploads/1753508282239_xám.jpg', 1, CAST(N'2025-07-22T23:51:46.670' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (68, 1050, N'XL', N'Gray', N'1050-XL-GRAY-E4D', 20, CAST(349000.00 AS Decimal(10, 2)), N'uploads/1753508304585_xám.jpg', 1, CAST(N'2025-07-22T23:52:01.700' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (69, 1050, N'S', N'Black', N'1050-S-BLACK-41E', 20, CAST(349000.00 AS Decimal(10, 2)), N'uploads/1753508294682_đen.jpg', 1, CAST(N'2025-07-22T23:52:10.467' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (70, 1050, N'M', N'Black', N'1050-M-BLACK-34E', 20, CAST(349000.00 AS Decimal(10, 2)), N'uploads/1753508287771_đen.jpg', 1, CAST(N'2025-07-22T23:52:22.417' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (71, 1050, N'XXL', N'Blue', N'1050-XXL-BLUE-3EA', 20, CAST(349000.00 AS Decimal(10, 2)), N'uploads/1753508319569_xanh dương.jpg', 1, CAST(N'2025-07-22T23:52:42.190' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (72, 1050, N'XS', N'Blue', N'1050-XS-BLUE-116', 20, CAST(349000.00 AS Decimal(10, 2)), N'uploads/1753508312650_xanh dương.jpg', 1, CAST(N'2025-07-22T23:52:53.560' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (73, 1051, N'L', N'Red', N'1051-L-RED-CEA', 20, CAST(389000.00 AS Decimal(10, 2)), N'uploads/1753508216992_đỏ.jpg', 1, CAST(N'2025-07-22T23:54:05.890' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (74, 1051, N'XL', N'Red', N'1051-XL-RED-BF5', 21, CAST(389000.00 AS Decimal(10, 2)), N'uploads/1753508247769_đỏ.jpg', 1, CAST(N'2025-07-22T23:54:18.197' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (75, 1051, N'M', N'Brown', N'1051-M-BROWN-9E4', 21, CAST(389000.00 AS Decimal(10, 2)), N'uploads/1753508235209_nâu.jpg', 1, CAST(N'2025-07-22T23:54:46.930' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (76, 1051, N'XL', N'Brown', N'1051-XL-BROWN-259', 21, CAST(389000.00 AS Decimal(10, 2)), N'uploads/1753508242101_nâu.jpg', 1, CAST(N'2025-07-22T23:54:58.650' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (77, 1051, N'L', N'White', N'1051-L-WHITE-3A2', 21, CAST(389000.00 AS Decimal(10, 2)), N'uploads/1753508228991_trắng.jpg', 1, CAST(N'2025-07-22T23:55:08.633' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (78, 1052, N'M', N'Black', N'1052-M-BLACK-C86', 20, CAST(319000.00 AS Decimal(10, 2)), N'uploads/1753508145105_đen.jpg', 1, CAST(N'2025-07-22T23:56:23.980' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (79, 1052, N'L', N'Black', N'1052-L-BLACK-A5E', 19, CAST(319000.00 AS Decimal(10, 2)), N'uploads/1753508134452_đen.jpg', 1, CAST(N'2025-07-22T23:56:38.097' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (80, 1052, N'XL', N'White', N'1052-XL-WHITE-CDE', 25, CAST(319000.00 AS Decimal(10, 2)), N'uploads/1753508156620_trắng.jpg', 1, CAST(N'2025-07-22T23:57:04.950' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (81, 1052, N'XS', N'White', N'1052-XS-WHITE-DC4', 15, CAST(319000.00 AS Decimal(10, 2)), N'uploads/1753508164369_trắng.jpg', 1, CAST(N'2025-07-22T23:57:23.753' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (82, 1052, N'M', N'Brown', N'1052-M-BROWN-E19', 15, CAST(319000.00 AS Decimal(10, 2)), N'uploads/1753501853183_nâu.jpg', 1, CAST(N'2025-07-22T23:57:38.580' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (83, 1052, N'L', N'Brown', N'1052-L-BROWN-DB0', 15, CAST(319000.00 AS Decimal(10, 2)), N'uploads/1753508139056_nâu.jpg', 1, CAST(N'2025-07-22T23:57:53.690' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (84, 1053, N'L', N'Blue', N'1053-L-BLUE-8DD', 19, CAST(249000.00 AS Decimal(10, 2)), N'uploads/1753507987873_xanh dương.jpg', 1, CAST(N'2025-07-23T00:00:37.163' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (85, 1053, N'M', N'Blue', N'1053-M-BLUE-DBE', 20, CAST(249000.00 AS Decimal(10, 2)), N'uploads/1753508028707_xanh dương.jpg', 1, CAST(N'2025-07-23T00:00:46.850' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (86, 1053, N'XL', N'Green', N'1053-XL-GREEN-011', 20, CAST(249000.00 AS Decimal(10, 2)), N'uploads/1753508051104_xanh lá.jpg', 1, CAST(N'2025-07-23T00:00:58.307' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (87, 1053, N'M', N'Green', N'1053-M-GREEN-7A5', 20, CAST(249000.00 AS Decimal(10, 2)), N'uploads/1753508037011_xanh lá.jpg', 1, CAST(N'2025-07-23T00:01:24.647' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (88, 1053, N'S', N'White', N'1053-S-WHITE-102', 20, CAST(249000.00 AS Decimal(10, 2)), N'uploads/1753508043318_trắng.jpg', 1, CAST(N'2025-07-23T00:01:37.783' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (89, 1053, N'L', N'White', N'1053-L-WHITE-23C', 20, CAST(249000.00 AS Decimal(10, 2)), N'uploads/1753507996491_trắng.jpg', 1, CAST(N'2025-07-23T00:01:47.623' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (90, 1053, N'XS', N'Black', N'1053-XS-BLACK-4E1', 15, CAST(249000.00 AS Decimal(10, 2)), N'uploads/1753508059845_đen.jpg', 1, CAST(N'2025-07-23T00:01:59.490' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (91, 1053, N'XXL', N'Black', N'1053-XXL-BLACK-BDD', 15, CAST(249000.00 AS Decimal(10, 2)), N'uploads/1753508065661_đen.jpg', 1, CAST(N'2025-07-23T00:02:07.903' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (92, 1054, N'M', N'Black', N'1054-M-BLACK-D20', 17, CAST(289000.00 AS Decimal(10, 2)), N'uploads/1753507867801_đen.jpg', 1, CAST(N'2025-07-23T00:03:26.117' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (93, 1054, N'L', N'Black', N'1054-L-BLACK-82C', 16, CAST(289000.00 AS Decimal(10, 2)), N'uploads/1753507857134_đen.jpg', 1, CAST(N'2025-07-23T00:03:36.107' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (94, 1054, N'XL', N'Black', N'1054-XL-BLACK-114', 17, CAST(289000.00 AS Decimal(10, 2)), N'uploads/1753507881373_đen.jpg', 1, CAST(N'2025-07-23T00:03:45.847' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (95, 1054, N'L', N'Blue', N'1054-L-BLUE-6F6', 17, CAST(289000.00 AS Decimal(10, 2)), N'uploads/1753507862325_xanh dương.jpg', 1, CAST(N'2025-07-23T00:03:58.580' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (96, 1054, N'S', N'Blue', N'1054-S-BLUE-273', 17, CAST(289000.00 AS Decimal(10, 2)), N'uploads/1753507875125_xanh dương.jpg', 1, CAST(N'2025-07-23T00:04:09.763' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (97, 1055, N'XS', N'Blue', N'1055-XS-BLUE-537', 20, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753503743242_xanhduong.jpg', 1, CAST(N'2025-07-23T00:06:28.903' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (98, 1055, N'S', N'Blue', N'1055-S-BLUE-93B', 20, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753503728404_xanhduong.jpg', 1, CAST(N'2025-07-23T00:06:40.050' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (99, 1055, N'S', N'Red', N'1055-S-RED-5DB', 20, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753503733172_đỏ.jpg', 1, CAST(N'2025-07-23T00:06:49.987' AS DateTime))
GO
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (100, 1055, N'M', N'Red', N'1055-M-RED-8EB', 20, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753503723095_đỏ.jpg', 1, CAST(N'2025-07-23T00:07:00.080' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (101, 1055, N'M', N'Black', N'1055-M-BLACK-515', 20, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753503716788_đen.jpg', 1, CAST(N'2025-07-23T00:07:12.203' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (102, 1055, N'L', N'Black', N'1055-L-BLACK-0E4', 20, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753503706651_đen.jpg', 1, CAST(N'2025-07-23T00:07:22.723' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (103, 1055, N'L', N'White', N'1055-L-WHITE-B05', 19, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753503711321_trắng.jpg', 1, CAST(N'2025-07-23T00:07:33.400' AS DateTime))
INSERT [dbo].[ProductVariants] ([VariantID], [ProductID], [Size], [Color], [SKU], [Quantity], [Price], [VariantImageURL], [IsActive], [CreatedAt]) VALUES (104, 1055, N'XL', N'White', N'1055-XL-WHITE-4D0', 20, CAST(199000.00 AS Decimal(10, 2)), N'uploads/1753503738317_trắng.jpg', 1, CAST(N'2025-07-23T00:07:44.253' AS DateTime))
SET IDENTITY_INSERT [dbo].[ProductVariants] OFF
GO
SET IDENTITY_INSERT [dbo].[Reviews] ON 

INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (1, NULL, NULL, 5, N'Áo thun rất thoải mái, chất vải tốt!', CAST(N'2025-05-10T00:00:00.000' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (2, NULL, NULL, 4, N'Quần jeans đẹp nhưng hơi chật.', CAST(N'2025-05-11T00:00:00.000' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (3, NULL, NULL, 3, N'Áo sơ mi bình thường, vải hơi mỏng.', CAST(N'2025-05-12T00:00:00.000' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (4, NULL, NULL, 5, N'Váy hoa rất đẹp, đúng như hình!', CAST(N'2025-05-13T00:00:00.000' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (5, NULL, NULL, 4, N'Hoodie trẻ em ấm, bé nhà mình thích.', CAST(N'2025-05-14T00:00:00.000' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (6, NULL, NULL, 5, N'Thắt lưng da chất lượng, rất bền!', CAST(N'2025-05-15T00:00:00.000' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (7, NULL, NULL, 3, N'Quần legging đẹp nhưng dễ phai màu.', CAST(N'2025-05-16T00:00:00.000' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (8, NULL, NULL, 4, N'Áo khoác mùa đông đẹp, hơi nặng.', CAST(N'2025-05-17T00:00:00.000' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (9, 5020, NULL, 5, N'rất tốt', CAST(N'2025-07-13T19:18:46.317' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (10, 5023, 1038, 5, N'sản phẩm rất tốt, tôi rất thích', CAST(N'2025-07-25T10:36:57.763' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (11, 5023, 1042, 5, N'đơn hàng tuyệt vời', CAST(N'2025-07-26T00:40:43.327' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (12, 5023, 1055, 5, N'sản phẩm ok', CAST(N'2025-07-26T11:28:56.140' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (13, 5023, 1053, 5, N'sản phẩm ok', CAST(N'2025-07-26T14:17:07.037' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (1013, 5023, 1052, 3, N'sản phẩm không đúng mong đợi', CAST(N'2025-07-26T14:57:55.887' AS DateTime))
INSERT [dbo].[Reviews] ([ReviewID], [UserID], [ProductID], [Rating], [Comment], [CreatedAt]) VALUES (1014, 5023, 1051, 2, N'xấu', CAST(N'2025-07-26T15:42:48.393' AS DateTime))
SET IDENTITY_INSERT [dbo].[Reviews] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (14, N'abc12545', N'$2a$10$9GOYzUOtT5VchnKquYs/KOq2dfo4/R7gVhUq07vV8WQfHJ9c1LvXy', N'hieu vu', N'hieuvdhe182125@fpt.edu.vn', N'0983455881', N'Customer', CAST(N'2025-06-04T13:03:48.320' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (3013, N'newuser', N'$2a$10$w1e14V2LfnLuZaj/ERJTeepzBG6FC6GgAcySQPIRx2UQuoDtFC2MS', N'hieu', N'test@example.com', N'0123456789', N'Admin', CAST(N'2025-06-18T23:39:25.577' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (4014, N'admin12', N'$2a$10$PHYOrgZ43524sAYFg5B/I.Q6O/2W8R//kgAnASThSfwqUaYORQeWm', N'vu duc hieu', N'abc1223@gmail.comsaS', N'0983455886', N'SuperAdmin', CAST(N'2025-06-19T22:01:57.997' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (4015, N'admin123', N'$2a$10$iLa6cInOzaAQxkEIxHykAemxT.54u1BL7QxBrdpjtRy5gJscRhCYy', N'admin1', N'abc12223@gmail.com', N'0983458832', N'Admin', CAST(N'2025-06-19T22:02:41.123' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (4017, N'admin123da', N'$2a$10$UFUSuwtOwb4XTmmmp57Zw.wtlrkCut0vMdKeS/1Hvx.g2hk9jBVU2', N'Nguyen Hoang Longdá', N'zenzipxx1fad@gmail.com', N'0946737174', N'Customer', CAST(N'2025-06-19T22:40:56.327' AS DateTime), 1, 1)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5013, N'admin123sd', N'$2a$10$wxxcjKRehT0YW8JgAixJrOPfA9X.84qvbRcU3o5PwyB.BHGseQNFq', N'hieu vu', N'hieuvdhe1s82125@fpt.edu.vn', N'0943455881', N'Admin', CAST(N'2025-06-25T08:48:44.597' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5014, N'admin123ds', N'$2a$10$1q/Bd/lGp/BwFhjmzQuOcO9XiV7WVZ6Q/iW5OUGx3ImUUDAEIs66K', N'hieu vu', N'hieuvdhe1182125@fpt.edu.vn', N'0947455881', N'Customer', CAST(N'2025-06-25T08:49:34.853' AS DateTime), 1, 1)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5015, N'long2005', N'$2a$10$zcRiY1kZuAD5mI.k4.7xmuGiQ2J83OAp3aGCRsKxFH9YFmWFSRMLi', N'nguyen sy long', N'caigiday1234@gmail.com', N'09373162718', N'Admin', CAST(N'2025-07-03T21:58:32.230' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5016, N'longsy16022005', N'$2a$10$xK0ILVoT4i5mar0XHNCz4OPxjwSaYRbAKo3ZYLGrLmfeC6l9L7rmW', N'nguyen sy long', N'caigiday123@gmail.com', N'09373162713', N'Customer', CAST(N'2025-07-03T22:03:08.407' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5018, N'nkt123', N'$2a$10$aelFm/RDLvEh3HGD5dVY0uKC05jNZhC6XvB.dcO1M0tSC0T5Nx5Ii', N'Kiên', N'kien123@gmail.com', N'0123456700', N'Admin', CAST(N'2025-07-12T18:40:17.653' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5019, N'Shipper', N'$2a$10$LVthyIGOmQY4IyfgfGTt/uRzzXoMxHjrsYvXn7olRQ0EE5QoQhA46', N'Shipper', N'shipper123@gmail.com', N'123456777', N'Shipper', CAST(N'2025-07-12T18:40:47.557' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5020, N'nkt1234', N'$2a$10$C8v6kmP.wm5ooThmNblnp.b8XQH0UBzj.0zUwlhuFNe1uxEnBc5aC', N'Kiênn', N'kien1234@gmail.com', N'0123456888', N'Customer', CAST(N'2025-07-12T18:42:03.030' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5023, N'NKT', N'$2a$10$GLf1cXZseDwIxwB4aETEL.8rstMl9/0pogkodvwVbm31dsQ0s80KG', N'NKT', N'tngoc6196@gmail.com', N'0123455555', N'Customer', CAST(N'2025-07-22T21:24:07.877' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5025, N'NKTT', N'$2a$10$pNavUlf6E22A6GG0s5BzYeOzOGs1SbJA1hqyJT.NGJ1V1/DXJHgYS', N'NKTT', N'tngoc61@gmail.com', N'0123444444', N'Customer', CAST(N'2025-07-26T11:08:34.877' AS DateTime), 1, 0)
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [Phone], [Role], [CreatedAt], [IsActive], [is_deleted]) VALUES (5026, N'hieu999', N'$2a$10$xw9Zxga.hN.w.OCSuJf3w.JbOMr92GAooTmdfLILMw4tjQd3vJqyq', N'hieu999', N'zenzipxx1@gmail.com', N'0123444443', N'Customer', CAST(N'2025-07-26T11:23:09.687' AS DateTime), 1, 0)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__ProductV__CA1ECF0D00995AD2]    Script Date: 26/07/2025 4:17:39 CH ******/
ALTER TABLE [dbo].[ProductVariants] ADD UNIQUE NONCLUSTERED 
(
	[SKU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__536C85E421C91E14]    Script Date: 26/07/2025 4:17:39 CH ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D10534C78A308A]    Script Date: 26/07/2025 4:17:39 CH ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Carts] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Inventory_Logs] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[password_reset_tokens] ADD  DEFAULT ((0)) FOR [is_used]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ProductVariants] ADD  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[ProductVariants] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ProductVariants] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Reviews] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ('Customer') FOR [Role]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD  CONSTRAINT [FK_Carts_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Carts] CHECK CONSTRAINT [FK_Carts_Products]
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD  CONSTRAINT [FK_Carts_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Carts] CHECK CONSTRAINT [FK_Carts_Users]
GO
ALTER TABLE [dbo].[Inventory_Logs]  WITH CHECK ADD  CONSTRAINT [FK_InventoryLogs_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Inventory_Logs] CHECK CONSTRAINT [FK_InventoryLogs_Products]
GO
ALTER TABLE [dbo].[Inventory_Logs]  WITH CHECK ADD  CONSTRAINT [FK_InventoryLogs_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Inventory_Logs] CHECK CONSTRAINT [FK_InventoryLogs_Users]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_Users]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_OrderID] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_OrderID]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Products]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Users]
GO
ALTER TABLE [dbo].[password_reset_tokens]  WITH CHECK ADD  CONSTRAINT [FK_User_PasswordReset] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[password_reset_tokens] CHECK CONSTRAINT [FK_User_PasswordReset]
GO
ALTER TABLE [dbo].[ProductDetail]  WITH CHECK ADD  CONSTRAINT [FK_ProductDetail_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductDetail] CHECK CONSTRAINT [FK_ProductDetail_Products]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Categories] ([CategoryID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Products]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Users]
GO
ALTER TABLE [dbo].[ShippingStatusHistory]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[Inventory_Logs]  WITH CHECK ADD CHECK  (([ChangeType]='Update' OR [ChangeType]='Remove' OR [ChangeType]='Add'))
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD CHECK  (([Status]='Cancelled' OR [Status]='Delivered' OR [Status]='Shipped' OR [Status]='Processing' OR [Status]='Pending'))
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
/****** Object:  StoredProcedure [dbo].[AddInventoryLog]    Script Date: 26/07/2025 4:17:39 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[AddInventoryLog]
    @ProductID INT,
    @ChangeType NVARCHAR(20),
    @Quantity INT,
    @Note NVARCHAR(MAX),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra vai trò của người dùng
    IF NOT EXISTS (SELECT 1 FROM Users WHERE UserID = @CreatedBy AND Role = 'Admin')
    BEGIN
        RAISERROR ('Only users with Admin role can add inventory logs.', 16, 1);
        RETURN;
    END

    -- Kiểm tra ProductID tồn tại
    IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID)
    BEGIN
        RAISERROR ('Invalid ProductID.', 16, 1);
        RETURN;
    END

    -- Kiểm tra ChangeType hợp lệ
    IF @ChangeType NOT IN ('Add', 'Remove', 'Update')
    BEGIN
        RAISERROR ('Invalid ChangeType. Must be Add, Remove, or Update.', 16, 1);
        RETURN;
    END

    -- Kiểm tra Quantity không âm
    IF @Quantity < 0
    BEGIN
        RAISERROR ('Quantity cannot be negative.', 16, 1);
        RETURN;
    END

    -- Kiểm tra số lượng tồn kho khi Remove
    IF @ChangeType = 'Remove' AND EXISTS (
        SELECT 1 FROM Products WHERE ProductID = @ProductID AND Quantity < @Quantity
    )
    BEGIN
        RAISERROR ('Insufficient stock for removal.', 16, 1);
        RETURN;
    END

    -- Bắt đầu giao dịch
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Cập nhật số lượng trong bảng Products
        IF @ChangeType = 'Add'
            UPDATE Products SET Quantity = Quantity + @Quantity WHERE ProductID = @ProductID;
        ELSE IF @ChangeType = 'Remove'
            UPDATE Products SET Quantity = Quantity - @Quantity WHERE ProductID = @ProductID;
        ELSE IF @ChangeType = 'Update'
            UPDATE Products SET Quantity = @Quantity WHERE ProductID = @ProductID;

        -- Thêm bản ghi vào Inventory_Logs
        INSERT INTO Inventory_Logs (ProductID, ChangeType, Quantity, Note, CreatedBy, CreatedAt)
        VALUES (@ProductID, @ChangeType, @Quantity, ISNULL(@Note, ''), @CreatedBy, GETDATE());

        -- Hoàn tất giao dịch
        COMMIT TRANSACTION;
        SELECT 'Success: Log added successfully.' AS Result;
    END TRY
    BEGIN CATCH
        -- Hủy giao dịch nếu có lỗi
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
USE [master]
GO
ALTER DATABASE [Shop] SET  READ_WRITE 
GO
