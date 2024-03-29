USE [bikes]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_String_Splitter]    Script Date: 14/05/2022 7:25:43 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_String_Splitter]
(
    @String NVARCHAR(MAX),
    @Delimeter NVARCHAR(1)
)
RETURNS @RetVal TABLE(Tuple VARCHAR(100))
AS
BEGIN

	DECLARE @sql_xml XML = Cast('<root><U>'+ Replace(@String, @Delimeter, '</U><U>')+ '</U></root>' AS XML)
    
    INSERT INTO @RetVal(Tuple)
    SELECT f.x.value('.', 'VARCHAR(100)') AS tuple FROM @sql_xml.nodes('/root/U') f(x) WHERE f.x.value('.', 'BIGINT') <> 0
    
    RETURN 
END
GO
/****** Object:  Table [dbo].[CRM_Rentals]    Script Date: 14/05/2022 7:25:43 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Rentals](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Rental_Date] [varchar](25) NULL,
	[Customer] [varchar](80) NULL,
	[Customer_Mobile] [varchar](10) NULL,
	[Customer_Address] [varchar](300) NULL,
	[Hourly_Rate] [decimal](18, 2) NULL,
	[Hourly_Usage] [int] NULL,
	[Rental_Start] [varchar](10) NULL,
	[Status] [varchar](15) NULL,
	[Processor_ID] [int] NULL,
	[Bike_ID] [int] NULL,
 CONSTRAINT [PK_CRM_Rentals_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_Bikes]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Bikes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Category_ID] [int] NULL,
	[Name] [varchar](60) NULL,
	[Hourly_Rate] [decimal](18, 2) NULL,
	[Stock] [int] NULL,
	[Photo] [varchar](120) NULL,
	[Frame] [varchar](50) NULL,
	[Color] [varchar](50) NULL,
	[Size] [varchar](50) NULL,
	[Brakes] [varchar](50) NULL,
	[Wieght] [varchar](50) NULL,
	[Damage_Bike] [varchar](50) NULL,
	[Used_Bike] [varchar](50) NULL,
 CONSTRAINT [PK_INV_Bikes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_Sales]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Sales](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Rental_ID] [int] NULL,
	[Type_ID] [int] NULL,
	[Rental_Date] [varchar](25) NULL,
	[Amount] [decimal](18, 0) NULL,
	[Penalty] [decimal](18, 0) NULL,
	[Total] [decimal](18, 0) NULL,
 CONSTRAINT [PK_CRM_Sales] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_CRM_Sales]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CRM_Sales]
AS
SELECT        TS.Rental_ID, TS.Rental_Date, TS.Rent, TS.Penalty, TS.Rent + TS.Penalty AS Total, dbo.CRM_Rentals.Customer, dbo.CRM_Rentals.Customer_Mobile, dbo.CRM_Rentals.Customer_Address, dbo.CRM_Rentals.Hourly_Rate, 
                         dbo.CRM_Rentals.Hourly_Usage, dbo.CRM_Rentals.Rental_Start, dbo.CRM_Rentals.Bike_ID, dbo.CRM_Bikes.Name AS Bike
FROM            dbo.CRM_Bikes RIGHT OUTER JOIN
                         dbo.CRM_Rentals ON dbo.CRM_Bikes.ID = dbo.CRM_Rentals.Bike_ID RIGHT OUTER JOIN
                             (SELECT        Rental_ID, Rental_Date, SUM((CASE WHEN Type_ID = 5 THEN Amount ELSE 0 END)) AS Rent, SUM((CASE WHEN Type_ID = 6 THEN Amount ELSE 0 END)) AS Penalty
                               FROM            dbo.CRM_Sales
                               GROUP BY Rental_ID, Rental_Date) AS TS ON dbo.CRM_Rentals.ID = TS.Rental_ID
GO
/****** Object:  Table [dbo].[TYP_Categories]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TYP_Categories](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](80) NULL,
 CONSTRAINT [PK_TYP_Models] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_Bikes_Collection]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Bikes_Collection](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Bike_ID] [int] NULL,
	[Mobile_GPS] [varchar](10) NULL,
	[Status] [varchar](1) NULL,
	[GPS_URL] [varchar](300) NULL,
 CONSTRAINT [PK_INV_Bikes_Collection] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_CRM_Bikes_Collections]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CRM_Bikes_Collections]
AS
SELECT        dbo.CRM_Bikes_Collection.ID, dbo.CRM_Bikes_Collection.Bike_ID, dbo.CRM_Bikes.Name AS Bike, dbo.CRM_Bikes.Category_ID, dbo.TYP_Categories.Name AS Category, dbo.CRM_Bikes.Hourly_Rate, dbo.CRM_Bikes.Photo, 
                         dbo.CRM_Bikes_Collection.Mobile_GPS, dbo.CRM_Bikes_Collection.Status, dbo.CRM_Bikes_Collection.GPS_URL
FROM            dbo.CRM_Bikes_Collection INNER JOIN
                         dbo.CRM_Bikes ON dbo.CRM_Bikes_Collection.Bike_ID = dbo.CRM_Bikes.ID INNER JOIN
                         dbo.TYP_Categories ON dbo.CRM_Bikes.Category_ID = dbo.TYP_Categories.ID
GO
/****** Object:  View [dbo].[VW_CRM_Bikes]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CRM_Bikes]
AS
SELECT dbo.CRM_Bikes.ID, dbo.CRM_Bikes.Category_ID, dbo.TYP_Categories.Name AS Category, dbo.CRM_Bikes.Name, dbo.CRM_Bikes.Hourly_Rate, dbo.CRM_Bikes.Stock, dbo.CRM_Bikes.Photo, dbo.CRM_Bikes.Color, dbo.CRM_Bikes.Frame, 
                  dbo.CRM_Bikes.Size, dbo.CRM_Bikes.Brakes, dbo.CRM_Bikes.Wieght
FROM     dbo.CRM_Bikes LEFT OUTER JOIN
                  dbo.TYP_Categories ON dbo.CRM_Bikes.Category_ID = dbo.TYP_Categories.ID
GO
/****** Object:  Table [dbo].[SYS_Users]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Role_ID] [int] NULL,
	[Username] [varchar](80) NULL,
	[Password] [varchar](130) NULL,
	[Name] [varchar](80) NULL,
	[Status] [varchar](1) NULL,
 CONSTRAINT [PK_SYS_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_Customers]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Customers](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NULL,
	[Name_First] [varchar](30) NULL,
	[Name_Middle] [varchar](30) NULL,
	[Name_Last] [varchar](30) NULL,
	[Gender] [varchar](1) NULL,
	[Birth_Date] [varchar](12) NULL,
	[Address] [varchar](300) NULL,
	[Contact_No] [varchar](10) NULL,
	[Email] [varchar](150) NULL,
	[Photo] [varchar](300) NULL,
 CONSTRAINT [PK_CRM_Customers] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SYS_Roles]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_Roles](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](30) NULL,
 CONSTRAINT [PK_SYS_Roles_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SYS_Users_Profile]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_Users_Profile](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NULL,
	[Name_First] [varchar](30) NULL,
	[Name_Middle] [varchar](30) NULL,
	[Name_Last] [varchar](30) NULL,
	[Gender] [varchar](1) NULL,
	[Birth_Date] [varchar](12) NULL,
	[Contact_No] [varchar](30) NULL,
	[Email] [varchar](150) NULL,
	[Address] [varchar](300) NULL,
	[Photo] [varchar](300) NULL,
 CONSTRAINT [PK_SYS_Users_Profile] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_SYS_Users]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_SYS_Users]
AS
SELECT UL.*, R.Name AS Role
FROM
(
SELECT	U.ID, U.Role_ID, 
		U.Username, U.Password, 
		U.Name AS Fullname, 
		U.Status,
		U.Name,
		UP.Gender,
		UP.Birth_Date, 
		UP.Contact_No, 
		UP.Email, 
		UP.Address, 
		UP.Photo, 
		UP.Name_First, 
		UP.Name_Middle, 
		UP.Name_Last
FROM   SYS_Users AS U 
		LEFT OUTER JOIN SYS_Users_Profile UP ON U.ID = UP.User_ID
WHERE U.Role_ID = 2

UNION ALL

SELECT	U.ID, U.Role_ID, 
		U.Username, U.Password, 
		U.Name AS Fullname, 
		U.Status,
		U.Name,
		UP.Gender,
		UP.Birth_Date, 
		UP.Contact_No, 
		UP.Email, 
		UP.Address, 
		UP.Photo, 
		UP.Name_First, 
		UP.Name_Middle, 
		UP.Name_Last
FROM   SYS_Users AS U 
		LEFT OUTER JOIN CRM_Customers UP ON U.ID = UP.User_ID
WHERE U.Role_ID = 1
) UL LEFT OUTER JOIN SYS_Roles R ON R.ID = UL.Role_ID
GO
/****** Object:  View [dbo].[VW_CRM_Rentals]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CRM_Rentals]
AS
SELECT        dbo.CRM_Rentals.ID, dbo.CRM_Rentals.Rental_Date, dbo.CRM_Rentals.Customer, dbo.CRM_Rentals.Customer_Mobile, dbo.CRM_Rentals.Customer_Address, dbo.CRM_Rentals.Hourly_Rate, dbo.CRM_Rentals.Hourly_Usage, 
                         dbo.CRM_Rentals.Rental_Start, dbo.CRM_Rentals.Status, dbo.CRM_Rentals.Processor_ID, ISNULL(dbo.VW_SYS_Users.Name, '') AS Processor, dbo.CRM_Rentals.Bike_ID, dbo.CRM_Bikes.Name AS Bike, 
                         dbo.CRM_Bikes.Category_ID, dbo.TYP_Categories.Name AS Category, dbo.CRM_Bikes.Photo, dbo.CRM_Bikes.Stock
FROM            dbo.TYP_Categories RIGHT OUTER JOIN
                         dbo.CRM_Bikes ON dbo.TYP_Categories.ID = dbo.CRM_Bikes.Category_ID RIGHT OUTER JOIN
                         dbo.CRM_Rentals ON dbo.CRM_Bikes.ID = dbo.CRM_Rentals.Bike_ID LEFT OUTER JOIN
                         dbo.VW_SYS_Users ON dbo.CRM_Rentals.Processor_ID = dbo.VW_SYS_Users.ID
GO
/****** Object:  Table [dbo].[TYP_Rentals]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TYP_Rentals](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](30) NULL,
 CONSTRAINT [PK_TYP_Rental] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_Rentals_Detail]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Rentals_Detail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Rental_ID] [int] NULL,
	[Rental_Type_ID] [int] NULL,
	[Collection_ID] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[Stamp] [varchar](25) NULL,
	[Remarks] [varchar](300) NULL,
	[Processor_ID] [int] NULL,
 CONSTRAINT [PK_CRM_Rentals_Detail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_CRM_Rentals_Collection]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CRM_Rentals_Collection]
AS
SELECT        dbo.CRM_Rentals_Detail.ID, dbo.CRM_Rentals_Detail.Rental_ID, dbo.CRM_Rentals_Detail.Rental_Type_ID, dbo.TYP_Rentals.Name AS Rental_Type, dbo.CRM_Rentals_Detail.Collection_ID, 
                         dbo.CRM_Bikes_Collection.Mobile_GPS, dbo.CRM_Bikes_Collection.GPS_URL, dbo.CRM_Bikes_Collection.Bike_ID, dbo.CRM_Rentals_Detail.Amount, dbo.CRM_Rentals_Detail.Stamp, dbo.CRM_Rentals_Detail.Remarks, 
                         dbo.CRM_Rentals_Detail.Processor_ID
FROM            dbo.CRM_Rentals_Detail LEFT OUTER JOIN
                         dbo.SYS_Users_Profile ON dbo.CRM_Rentals_Detail.Processor_ID = dbo.SYS_Users_Profile.User_ID LEFT OUTER JOIN
                         dbo.CRM_Bikes_Collection ON dbo.CRM_Rentals_Detail.Collection_ID = dbo.CRM_Bikes_Collection.ID LEFT OUTER JOIN
                         dbo.TYP_Rentals ON dbo.CRM_Rentals_Detail.Rental_Type_ID = dbo.TYP_Rentals.ID
GO
/****** Object:  Table [dbo].[STG_Rentals]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STG_Rentals](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Value] [varchar](50) NULL,
	[Description] [varchar](300) NULL,
 CONSTRAINT [PK_STG_Rentals] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CRM_Bikes] ON 

INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (1, 1, N'RB - Bike In Mode', CAST(20.00 AS Decimal(18, 2)), 6, N'Col3.jpg', N'Hi-Mod Carbon', N'Yellow/Black', N'48cm-62cm', N'Disc brake', N'7.3 kg', N'2', N'1')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (2, 2, N'MB - Adventure Degree', CAST(50.00 AS Decimal(18, 2)), 5, N'Col1.jpg', N'Rhino-rack', N'Blue/Black', N'40cm-60cm', N'Rubber brake', N'9 kg', N'3', N'1')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (3, 3, N'GA - Marksman', CAST(100.00 AS Decimal(18, 2)), 3, N'Col2.jpg', N'Mercedes bench', N'Black/Red', N'40cm-50cm', N'Disc brake', N'10 kg', N'1', N'1')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (4, 1, N'RB - Hamps Adventure', CAST(20.00 AS Decimal(18, 2)), 5, N'img4.jpg', N'Carbon', N'Yellow', N'40cm-60cm', N'Disc brake', N'7.3 kg', N'3', N'1')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (5, 1, N'RB - BMX', CAST(10.00 AS Decimal(18, 2)), 7, N'img5.jpeg', N'Rhino-rack', N'Yellow', N'35cm-50cm', N'Rubber brake', N'7.3 kg', N'3', N'1')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (6, 2, N'MB - Off Road bike', CAST(50.00 AS Decimal(18, 2)), 2, N'img6.jpg', N'Mercedes bench', N'Blue', N'40cm-60cm', N'Disc brake', N'9 kg', N'1', N'1')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (7, 3, N'GA - Catchiest Bike', CAST(50.00 AS Decimal(18, 2)), 4, N'img7.jpg', N'Mercedes bench', N'Black', N'40cm-60cm', N'Disc brake', N'10 kg', N'1', N'2')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (8, 3, N'GA - Bulldog Bike', CAST(100.00 AS Decimal(18, 2)), 8, N'img8.jpg', N'Rhino-rack', N'Black', N'40cm-60cm', N'Disc brake', N'10 kg', N'3', N'3')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (9, 3, N'GA - Couples Bike', CAST(100.00 AS Decimal(18, 2)), 10, N'img8.jpg', N'Rhino-rack', N'Black', N'60cm-80cm', N'Disc brake', N'10 kg', N'4', N'2')
INSERT [dbo].[CRM_Bikes] ([ID], [Category_ID], [Name], [Hourly_Rate], [Stock], [Photo], [Frame], [Color], [Size], [Brakes], [Wieght], [Damage_Bike], [Used_Bike]) VALUES (10, 3, N'GA - Specialized Road Bike', CAST(100.00 AS Decimal(18, 2)), 9, N'img10.jpeg', N'Rhino-rack', N'Black', N'40cm-60cm', N'Disc brake', N'10 kg', N'5', N'2')
SET IDENTITY_INSERT [dbo].[CRM_Bikes] OFF
GO
SET IDENTITY_INSERT [dbo].[CRM_Bikes_Collection] ON 

INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (1, 1, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (2, 1, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (3, 4, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (4, 4, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (5, 1, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (6, 5, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (7, 1, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (8, 6, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (9, 1, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (10, 1, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (11, 2, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (12, 2, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (13, 7, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (14, 7, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (15, 2, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (16, 3, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (17, 3, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (18, 3, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (19, 8, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (20, 8, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (21, 8, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (22, 8, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (23, 9, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (24, 9, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (25, 10, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
INSERT [dbo].[CRM_Bikes_Collection] ([ID], [Bike_ID], [Mobile_GPS], [Status], [GPS_URL]) VALUES (26, 10, N'9263808203', N'A', N'http://www.fcstgps.com/u/tkb8')
SET IDENTITY_INSERT [dbo].[CRM_Bikes_Collection] OFF
GO
SET IDENTITY_INSERT [dbo].[CRM_Customers] ON 

INSERT [dbo].[CRM_Customers] ([ID], [User_ID], [Name_First], [Name_Middle], [Name_Last], [Gender], [Birth_Date], [Address], [Contact_No], [Email], [Photo]) VALUES (1, 5, N'', N'', N'', N'M', N'', N'', N'', N'mik', N'')
INSERT [dbo].[CRM_Customers] ([ID], [User_ID], [Name_First], [Name_Middle], [Name_Last], [Gender], [Birth_Date], [Address], [Contact_No], [Email], [Photo]) VALUES (2, 2, N'', N'', N'', N'M', N'', N'', N'', N'mike@yahoo.com', N'')
SET IDENTITY_INSERT [dbo].[CRM_Customers] OFF
GO
SET IDENTITY_INSERT [dbo].[CRM_Rentals] ON 

INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (1, N'2021-12-14', N'Juan Dela Cruz', N'9123456789', N'Calbayog City', CAST(20.00 AS Decimal(18, 2)), 1, N'14:05', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (2, N'2021-12-15', N'danica josie roque', N'9368390554', N'brgy.trinidad calbayog city', CAST(20.00 AS Decimal(18, 2)), 2, N'16:24', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (3, N'2021-12-14', N'tedy dela cruz', N'9066584748', N'quezon', CAST(20.00 AS Decimal(18, 2)), 2, N'10:37', N'X', 2, 3)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (4, N'2021-12-15', N'renato solitarios', N'912345678', N'cogon', CAST(20.00 AS Decimal(18, 2)), 1, N'12:00', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (5, N'2021-12-16', N'pedro pindoko', N'9066584748', N'brgy. SanPolicarpo', CAST(20.00 AS Decimal(18, 2)), 1, N'07:00', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (6, N'2021-12-17', N'lee', N'912345678', N'awang east', CAST(20.00 AS Decimal(18, 2)), 2, N'09:13', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (7, N'2021-12-16', N'me', N'912345678', N'valenzuela', CAST(20.00 AS Decimal(18, 2)), 1, N'18:22', N'H', 2, 2)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (8, N'2021-12-16', N'try', N'912345678', N'quezon', CAST(20.00 AS Decimal(18, 2)), 3, N'22:00', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (9, N'2021-12-16', N'leni', N'9066584748', N'cogon', CAST(20.00 AS Decimal(18, 2)), 4, N'20:00', N'H', 2, 3)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (10, N'2021-12-16', N'bbm', N'9066584748', N'cogon', CAST(20.00 AS Decimal(18, 2)), 2, N'12:00', N'H', 2, 3)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (11, N'2021-12-16', N'last', N'9066584748', N'cogon', CAST(20.00 AS Decimal(18, 2)), 3, N'12:00', N'H', 2, 3)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (12, N'2021-12-16', N'jhan', N'912345678', N'ipao', CAST(20.00 AS Decimal(18, 2)), 3, N'22:00', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (13, N'2021-12-16', N'EVELYN MOBERA', N'9368390554', N'quezon', CAST(20.00 AS Decimal(18, 2)), 4, N'12:41', N'H', 2, 2)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (14, N'2021-12-16', N'trial', N'9368390554', N'quezon', CAST(20.00 AS Decimal(18, 2)), 5, N'01:00', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (15, N'2021-12-17', N'juan cardo', N'9066584748', N'negros', CAST(20.00 AS Decimal(18, 2)), 1, N'16:00', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (16, N'2021-12-21', N'carl bato', N'9066584748', N'dawis', CAST(20.00 AS Decimal(18, 2)), 1, N'10:00', N'H', 2, 3)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (17, N'2021-12-21', N'carl bato', N'9066584748', N'dawis', CAST(20.00 AS Decimal(18, 2)), 1, N'10:00', N'H', 1, 3)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (18, N'2021-12-21', N'carl bato', N'9066584748', N'dawis', CAST(20.00 AS Decimal(18, 2)), 1, N'10:00', N'L', 1, 3)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (19, N'2021-12-21', N'jhan', N'912345678', N'quezon', CAST(20.00 AS Decimal(18, 2)), 4, N'12:00', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (20, N'2021-12-21', N'EVELYN MOBERA', N'9066584748', N'cogon', CAST(20.00 AS Decimal(18, 2)), 1, N'03:40', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (21, N'2021-12-21', N'eries', N'0975427219', N'fairview', CAST(20.00 AS Decimal(18, 2)), 3, N'13:00', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (22, N'2021-12-21', N'jaymark', N'0975427219', N'carayman', CAST(20.00 AS Decimal(18, 2)), 2, N'21:50', N'H', 2, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (23, N'2021-12-23', N'Eries John', N'912345678', N'fairview', CAST(20.00 AS Decimal(18, 2)), 3, N'09:00', N'H', 1, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (24, N'2021-12-22', N'trial', N'9368390554', N'CARAYMAN', CAST(20.00 AS Decimal(18, 2)), 1, N'01:00', N'H', 1, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (25, N'2021-12-22', N'EVELYN MOBERA', N'9368390554', N'CARAYMAN', CAST(20.00 AS Decimal(18, 2)), 4, N'11:00', N'L', 1, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (26, N'2021-12-22', N'joel', N'912345678', N'balud', CAST(20.00 AS Decimal(18, 2)), 1, N'18:28', N'H', 1, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (27, N'2021-12-22', N'carlo', N'9066584748', N'awang east', CAST(20.00 AS Decimal(18, 2)), 3, N'08:54', N'L', 1, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (28, N'2021-12-22', N'Bacamante', N'9066584748', N'awang east', CAST(20.00 AS Decimal(18, 2)), 1, N'17:58', N'L', 1, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (29, N'2022-03-23', N'joel', N'9066584748', N'awang east', CAST(20.00 AS Decimal(18, 2)), 3, N'14:02', N'P', 0, 2)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (30, N'2022-04-04', N'carl bato', N'9066584748', N'awang east', CAST(20.00 AS Decimal(18, 2)), 1, N'18:40', N'L', 1, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (31, N'2022-04-29', N'juan', N'0000000', N'umn', CAST(20.00 AS Decimal(18, 2)), 1, N'21:04', N'P', 0, 2)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (32, N'2022-04-30', N'fgdgd', N'0919999999', N'ttrt', CAST(20.00 AS Decimal(18, 2)), 1, N'21:57', N'P', 0, 1)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (33, N'2022-05-03', N'juan', N'0919999999', N'ipao calbayog city', CAST(20.00 AS Decimal(18, 2)), 3, N'07:00', N'P', 0, 3)
INSERT [dbo].[CRM_Rentals] ([ID], [Rental_Date], [Customer], [Customer_Mobile], [Customer_Address], [Hourly_Rate], [Hourly_Usage], [Rental_Start], [Status], [Processor_ID], [Bike_ID]) VALUES (34, N'2022-05-04', N'kevin', N'9971920573', N'ipao', CAST(20.00 AS Decimal(18, 2)), 1, N'08:14', N'P', 0, 1)
SET IDENTITY_INSERT [dbo].[CRM_Rentals] OFF
GO
SET IDENTITY_INSERT [dbo].[CRM_Rentals_Detail] ON 

INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (1, 1, 1, 1, CAST(20.00 AS Decimal(18, 2)), N'2021-12-13 14:06:13', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (2, 2, 1, 1, CAST(40.00 AS Decimal(18, 2)), N'2021-12-13 15:26:06', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (3, 4, 1, 1, CAST(20.00 AS Decimal(18, 2)), N'2021-12-14 09:05:17', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (4, 6, 1, 2, CAST(40.00 AS Decimal(18, 2)), N'2021-12-15 18:14:01', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (5, 7, 1, 11, CAST(20.00 AS Decimal(18, 2)), N'2021-12-15 18:24:45', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (6, 8, 1, 1, CAST(60.00 AS Decimal(18, 2)), N'2021-12-15 18:42:52', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (7, 9, 1, 16, CAST(80.00 AS Decimal(18, 2)), N'2021-12-15 18:53:33', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (8, 10, 1, 16, CAST(40.00 AS Decimal(18, 2)), N'2021-12-15 18:55:16', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (9, 11, 1, 16, CAST(60.00 AS Decimal(18, 2)), N'2021-12-15 18:58:01', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (10, 12, 1, 1, CAST(60.00 AS Decimal(18, 2)), N'2021-12-15 19:16:39', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (11, 5, 1, 1, CAST(20.00 AS Decimal(18, 2)), N'2021-12-15 19:24:56', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (12, 13, 1, 11, CAST(80.00 AS Decimal(18, 2)), N'2021-12-15 19:35:34', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (13, 14, 1, 1, CAST(100.00 AS Decimal(18, 2)), N'2021-12-15 19:39:58', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (14, 15, 1, 1, CAST(20.00 AS Decimal(18, 2)), N'2021-12-16 01:46:26', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (15, 19, 1, 1, CAST(80.00 AS Decimal(18, 2)), N'2021-12-20 10:20:16', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (16, 20, 1, 1, CAST(20.00 AS Decimal(18, 2)), N'2021-12-20 10:50:46', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (17, 16, 1, 16, CAST(20.00 AS Decimal(18, 2)), N'2021-12-20 11:59:00', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (18, 21, 1, 1, CAST(60.00 AS Decimal(18, 2)), N'2021-12-20 13:36:10', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (19, 22, 1, 1, CAST(40.00 AS Decimal(18, 2)), N'2021-12-20 14:52:09', N'Accepted', 2)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (20, 23, 1, 1, CAST(60.00 AS Decimal(18, 2)), N'2021-12-21 09:55:17', N'Accepted', 1)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (21, 24, 1, 1, CAST(20.00 AS Decimal(18, 2)), N'2021-12-21 10:06:18', N'Accepted', 1)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (22, 17, 1, 16, CAST(20.00 AS Decimal(18, 2)), N'2021-12-21 10:17:34', N'Accepted', 1)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (23, 25, 1, 1, CAST(80.00 AS Decimal(18, 2)), N'2021-12-21 10:20:17', N'Accepted', 1)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (24, 26, 1, 2, CAST(20.00 AS Decimal(18, 2)), N'2021-12-21 17:28:40', N'Accepted', 1)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (25, 27, 1, 1, CAST(60.00 AS Decimal(18, 2)), N'2021-12-21 17:53:33', N'Accepted', 1)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (26, 28, 1, 1, CAST(20.00 AS Decimal(18, 2)), N'2021-12-21 18:01:28', N'Accepted', 1)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (27, 18, 1, 16, CAST(20.00 AS Decimal(18, 2)), N'2022-03-22 13:59:38', N'Accepted', 1)
INSERT [dbo].[CRM_Rentals_Detail] ([ID], [Rental_ID], [Rental_Type_ID], [Collection_ID], [Amount], [Stamp], [Remarks], [Processor_ID]) VALUES (28, 30, 1, 1, CAST(20.00 AS Decimal(18, 2)), N'2022-04-28 15:59:07', N'Accepted', 1)
SET IDENTITY_INSERT [dbo].[CRM_Rentals_Detail] OFF
GO
SET IDENTITY_INSERT [dbo].[CRM_Sales] ON 

INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (1, 1, 6, N'2021-12-14', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (2, 2, 6, N'2021-12-15', CAST(40 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (3, 2, 5, N'2021-12-15', CAST(40 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (4, 1, 5, N'2021-12-14', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (5, 4, 6, N'2021-12-15', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (6, 6, 6, N'2021-12-17', CAST(40 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (7, 7, 6, N'2021-12-16', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (8, 8, 6, N'2021-12-16', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(60 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (9, 7, 5, N'2021-12-16', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (10, 9, 6, N'2021-12-16', CAST(80 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(80 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (11, 10, 6, N'2021-12-16', CAST(40 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (12, 11, 6, N'2021-12-16', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(60 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (13, 12, 6, N'2021-12-16', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(60 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (14, 12, 5, N'2021-12-16', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (15, 5, 6, N'2021-12-16', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (16, 5, 5, N'2021-12-16', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (17, 13, 6, N'2021-12-16', CAST(80 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(80 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (18, 13, 5, N'2021-12-16', CAST(80 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (19, 14, 6, N'2021-12-16', CAST(100 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(100 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (20, 14, 5, N'2021-12-16', CAST(100 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (21, 6, 5, N'2021-12-17', CAST(40 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (22, 8, 5, N'2021-12-16', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (23, 9, 5, N'2021-12-16', CAST(80 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (24, 10, 5, N'2021-12-16', CAST(40 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (25, 11, 5, N'2021-12-16', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (26, 15, 6, N'2021-12-17', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (27, 15, 5, N'2021-12-17', CAST(20 AS Decimal(18, 0)), CAST(230 AS Decimal(18, 0)), CAST(230 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (28, 19, 6, N'2021-12-21', CAST(80 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(80 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (29, 19, 5, N'2021-12-21', CAST(80 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (30, 20, 6, N'2021-12-21', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (31, 16, 6, N'2021-12-21', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (32, 21, 6, N'2021-12-21', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(60 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (33, 22, 6, N'2021-12-21', CAST(40 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(40 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (34, 22, 5, N'2021-12-21', CAST(40 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (35, 16, 5, N'2021-12-21', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (36, 20, 5, N'2021-12-21', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (37, 21, 5, N'2021-12-21', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (38, 4, 5, N'2021-12-15', CAST(20 AS Decimal(18, 0)), CAST(610 AS Decimal(18, 0)), CAST(610 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (39, 23, 6, N'2021-12-23', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(60 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (40, 23, 5, N'2021-12-23', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (41, 24, 6, N'2021-12-22', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (42, 17, 6, N'2021-12-21', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (43, 24, 5, N'2021-12-22', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (44, 17, 5, N'2021-12-21', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (45, 25, 6, N'2021-12-22', CAST(80 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(80 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (46, 26, 6, N'2021-12-22', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (47, 27, 6, N'2021-12-22', CAST(60 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(60 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (48, 26, 5, N'2021-12-22', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (49, 28, 6, N'2021-12-22', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (50, 18, 6, N'2021-12-21', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
INSERT [dbo].[CRM_Sales] ([ID], [Rental_ID], [Type_ID], [Rental_Date], [Amount], [Penalty], [Total]) VALUES (51, 30, 6, N'2022-04-04', CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)))
SET IDENTITY_INSERT [dbo].[CRM_Sales] OFF
GO
SET IDENTITY_INSERT [dbo].[STG_Rentals] ON 

INSERT [dbo].[STG_Rentals] ([ID], [Name], [Value], [Description]) VALUES (1, N'PENALTY', N'5', N'Penalty Rate Per Hour')
SET IDENTITY_INSERT [dbo].[STG_Rentals] OFF
GO
SET IDENTITY_INSERT [dbo].[SYS_Roles] ON 

INSERT [dbo].[SYS_Roles] ([ID], [Name]) VALUES (1, N'Customer')
INSERT [dbo].[SYS_Roles] ([ID], [Name]) VALUES (2, N'Owner')
SET IDENTITY_INSERT [dbo].[SYS_Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[SYS_Users] ON 

INSERT [dbo].[SYS_Users] ([ID], [Role_ID], [Username], [Password], [Name], [Status]) VALUES (1, 2, N'admin@gmail.com', N'admin', N'Administrator', N'A')
INSERT [dbo].[SYS_Users] ([ID], [Role_ID], [Username], [Password], [Name], [Status]) VALUES (2, 1, N'mike@yahoo.com', N'888888', N'Juan Dela Cruz', N'A')
SET IDENTITY_INSERT [dbo].[SYS_Users] OFF
GO
SET IDENTITY_INSERT [dbo].[SYS_Users_Profile] ON 

INSERT [dbo].[SYS_Users_Profile] ([ID], [User_ID], [Name_First], [Name_Middle], [Name_Last], [Gender], [Birth_Date], [Contact_No], [Email], [Address], [Photo]) VALUES (1, 1, N'Web', N'X', N'Admin', N'M', N'', N'', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[SYS_Users_Profile] OFF
GO
SET IDENTITY_INSERT [dbo].[TYP_Categories] ON 

INSERT [dbo].[TYP_Categories] ([ID], [Name]) VALUES (1, N'Road Bikes ')
INSERT [dbo].[TYP_Categories] ([ID], [Name]) VALUES (2, N'Mountain Bikes ')
INSERT [dbo].[TYP_Categories] ([ID], [Name]) VALUES (3, N'Gravel/Adventure Bikes')
SET IDENTITY_INSERT [dbo].[TYP_Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[TYP_Rentals] ON 

INSERT [dbo].[TYP_Rentals] ([ID], [Name]) VALUES (1, N'LEASE')
INSERT [dbo].[TYP_Rentals] ([ID], [Name]) VALUES (2, N'RETURN')
INSERT [dbo].[TYP_Rentals] ([ID], [Name]) VALUES (3, N'HOLD')
INSERT [dbo].[TYP_Rentals] ([ID], [Name]) VALUES (4, N'DENIED')
INSERT [dbo].[TYP_Rentals] ([ID], [Name]) VALUES (5, N'PENALTY')
INSERT [dbo].[TYP_Rentals] ([ID], [Name]) VALUES (6, N'SALES')
SET IDENTITY_INSERT [dbo].[TYP_Rentals] OFF
GO
ALTER TABLE [dbo].[CRM_Bikes] ADD  CONSTRAINT [DF_INV_Bikes_Name]  DEFAULT (N'') FOR [Name]
GO
ALTER TABLE [dbo].[CRM_Bikes] ADD  CONSTRAINT [DF_INV_Bikes_Hourly_Rate]  DEFAULT ((0)) FOR [Hourly_Rate]
GO
ALTER TABLE [dbo].[CRM_Bikes] ADD  CONSTRAINT [DF_INV_Bikes_Stock]  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[CRM_Bikes] ADD  CONSTRAINT [DF_CRM_Bikes_Photo]  DEFAULT (N'') FOR [Photo]
GO
ALTER TABLE [dbo].[CRM_Bikes_Collection] ADD  CONSTRAINT [DF_CRM_Bikes_Collection_Bike_ID]  DEFAULT ((0)) FOR [Bike_ID]
GO
ALTER TABLE [dbo].[CRM_Bikes_Collection] ADD  CONSTRAINT [DF_CRM_Bikes_Collection_Mobile_GPS]  DEFAULT (N'') FOR [Mobile_GPS]
GO
ALTER TABLE [dbo].[CRM_Bikes_Collection] ADD  CONSTRAINT [DF_CRM_Bikes_Collection_Status]  DEFAULT (N'') FOR [Status]
GO
ALTER TABLE [dbo].[CRM_Bikes_Collection] ADD  CONSTRAINT [DF_CRM_Bikes_Collection_Map_URL]  DEFAULT (N'') FOR [GPS_URL]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Name_First]  DEFAULT (N'') FOR [Name_First]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Name_Middle]  DEFAULT (N'') FOR [Name_Middle]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Name_Last]  DEFAULT (N'') FOR [Name_Last]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Gender]  DEFAULT (N'') FOR [Gender]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Birth_Date]  DEFAULT (N'') FOR [Birth_Date]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Address]  DEFAULT (N'') FOR [Address]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Contact]  DEFAULT (N'') FOR [Contact_No]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Email]  DEFAULT (N'') FOR [Email]
GO
ALTER TABLE [dbo].[CRM_Customers] ADD  CONSTRAINT [DF_CRM_Customers_Photo]  DEFAULT (N'') FOR [Photo]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Rental_Date]  DEFAULT (N'') FOR [Rental_Date]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Customer]  DEFAULT (N'') FOR [Customer]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Customer_Mobile]  DEFAULT (N'') FOR [Customer_Mobile]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Customer_Address]  DEFAULT (N'') FOR [Customer_Address]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Amount]  DEFAULT ((0)) FOR [Hourly_Rate]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Hourly_Usage]  DEFAULT (N'') FOR [Hourly_Usage]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Rental_Start]  DEFAULT (N'') FOR [Rental_Start]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Status]  DEFAULT (N'') FOR [Status]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Processor_ID]  DEFAULT ((0)) FOR [Processor_ID]
GO
ALTER TABLE [dbo].[CRM_Rentals] ADD  CONSTRAINT [DF_CRM_Rentals_Bike_ID]  DEFAULT ((0)) FOR [Bike_ID]
GO
ALTER TABLE [dbo].[CRM_Rentals_Detail] ADD  CONSTRAINT [DF_CRM_Rentals_Detail_Penalty]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[CRM_Rentals_Detail] ADD  CONSTRAINT [DF_CRM_Rentals_Detail_Processor_ID]  DEFAULT ((0)) FOR [Processor_ID]
GO
ALTER TABLE [dbo].[CRM_Sales] ADD  CONSTRAINT [DF_CRM_Sales_Amount]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[CRM_Sales] ADD  CONSTRAINT [DF_CRM_Sales_Penalty]  DEFAULT ((0)) FOR [Penalty]
GO
ALTER TABLE [dbo].[CRM_Sales] ADD  CONSTRAINT [DF_CRM_Sales_Total]  DEFAULT ((0)) FOR [Total]
GO
ALTER TABLE [dbo].[SYS_Users] ADD  CONSTRAINT [DF_SYS_Users_User_Type]  DEFAULT (N'') FOR [Role_ID]
GO
ALTER TABLE [dbo].[SYS_Users] ADD  CONSTRAINT [DF_SYS_Users_Username]  DEFAULT (N'') FOR [Username]
GO
ALTER TABLE [dbo].[SYS_Users] ADD  CONSTRAINT [DF_SYS_Users_Password]  DEFAULT (N'') FOR [Password]
GO
ALTER TABLE [dbo].[SYS_Users] ADD  CONSTRAINT [DF_SYS_Users_Name]  DEFAULT (N'') FOR [Name]
GO
ALTER TABLE [dbo].[SYS_Users] ADD  CONSTRAINT [DF_SYS_Users_Status]  DEFAULT (N'X') FOR [Status]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Name_First]  DEFAULT (N'') FOR [Name_First]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Name_Middle]  DEFAULT (N'') FOR [Name_Middle]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Name_Last]  DEFAULT (N'') FOR [Name_Last]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Gender]  DEFAULT (N'') FOR [Gender]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Birth_Date]  DEFAULT (N'') FOR [Birth_Date]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Contact_No]  DEFAULT (N'') FOR [Contact_No]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Email]  DEFAULT (N'') FOR [Email]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Address]  DEFAULT (N'') FOR [Address]
GO
ALTER TABLE [dbo].[SYS_Users_Profile] ADD  CONSTRAINT [DF_SYS_Users_Profile_Photo]  DEFAULT (N'') FOR [Photo]
GO
/****** Object:  StoredProcedure [dbo].[SP_CAL_Rentals_Return]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CAL_Rentals_Return]
@Rental_ID INT
AS
BEGIN
	SELECT *, Total = Z.Penalty 
	FROM
	(
		SELECT	Y.ID, Y.Customer, Y.Customer_Address, Y.Rental_Date, Y.Rent, 
				(CASE WHEN Y.Lapse <= 0 THEN 0 ELSE Y.Lapse END) AS Lapse,
				(CASE WHEN Y.Penalty <= 0 THEN 0 ELSE Y.Penalty END) AS Penalty,
				CAST(Rental_Date + ' ' + Rental_Start AS DATETIME) AS Rental_Start, 
				Y.Rental_End
		FROM
		(
			SELECT X.ID, X.Customer, X.Customer_Address, X.Rental_Date, (X.Hourly_Usage * X.Hourly_Rate) AS Rent, 
				DATEDIFF(HOUR, Rental_End, GETDATE()) AS Lapse, 
				(DATEDIFF(HOUR, Rental_End, GETDATE()) * CAST(S.Value AS INT))  AS Penalty,
				X.Rental_Start, X.Rental_End
			FROM
			(
				SELECT *, 
					ISNULL(DATEADD(HOUR, Hourly_Usage, CAST(Rental_Date + ' ' + Rental_Start AS DATETIME)), 0) AS Rental_End 
				FROM CRM_Rentals
				WHERE ID = @Rental_ID
			) AS X
			LEFT OUTER JOIN STG_Rentals S ON S.Name = 'PENALTY'
		) Y
	) Z
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CRM_GetList_Collection_Available]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CRM_GetList_Collection_Available]
@ID INT
AS
BEGIN

	SELECT * FROM VW_CRM_Bikes_Collections
	WHERE Bike_ID = @ID AND Status = 'A'

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CRM_GetList_Rentals_By_Status]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CRM_GetList_Rentals_By_Status]
@Status VARCHAR(1)
AS
BEGIN

	SELECT * FROM VW_CRM_Rentals
	WHERE Status = @Status
	ORDER BY Rental_Date DESC

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CRM_GetList_Rentals_Collection]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CRM_GetList_Rentals_Collection]
@Rental_ID INT
AS
BEGIN

	SELECT * FROM VW_CRM_Rentals_Collection
	WHERE Rental_ID = @Rental_ID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CRM_Rentals]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CRM_Rentals]
@Code VARCHAR(50) OUTPUT,
@Rental_Date VARCHAR(25),
@Bike_ID INT,
@Customer VARCHAR(80),
@Customer_Mobile VARCHAR(10),
@Customer_Address VARCHAR(300),
@Hourly_Usage INT,
@Rental_Start VARCHAR(25)
AS
BEGIN

	DECLARE @Hourly_Rate DECIMAL(18, 0)

	SET @Hourly_Rate = ISNULL((SELECT Hourly_Rate FROM VW_CRM_Bikes_Collections WHERE ID = 1), 0)

	INSERT INTO CRM_Rentals (Rental_Date, Bike_ID, Customer, Customer_Mobile, Customer_Address, Hourly_Rate, Hourly_Usage, Rental_Start, Status) 
	VALUES (@Rental_Date, @Bike_ID, @Customer, @Customer_Mobile, @Customer_Address, @Hourly_Rate, @Hourly_Usage, @Rental_Start, 'P')

	SET @Code = 'BRN' + FORMAT(SCOPE_IDENTITY(), '00000')

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CRM_Rentals_Accept]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CRM_Rentals_Accept]
@Rental_ID INT,
@Collection_ID INT,
@Processor_ID int
AS
BEGIN

	DECLARE @Stamp VARCHAR(25), @Amount DECIMAL(18, 2), @Rental_Date VARCHAR(25)

	SET @Stamp = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss')
	SET @Amount = ISNULL((SELECT Hourly_Rate * Hourly_Usage FROM CRM_Rentals WHERE ID = @Rental_ID), 0)
	SET @Rental_Date = ISNULL((SELECT Rental_Date FROM CRM_Rentals WHERE ID = @Rental_ID), '')


	UPDATE	CRM_Rentals 
	SET		Status = 'L', Processor_ID = @Processor_ID 
	WHERE	ID = @Rental_ID

	INSERT INTO CRM_Rentals_Detail
	(
	Rental_ID, Rental_Type_ID, Amount, Stamp, Remarks, Processor_ID, Collection_ID
	)
	VALUES
	(
	@Rental_ID, 1, @Amount, @Stamp, 'Accepted', @Processor_ID, @Collection_ID
	)

	INSERT INTO CRM_Sales (Rental_ID, Type_ID,  Rental_Date, Amount, Penalty, Total)
	SELECT @Rental_ID, 6, @Rental_Date, @Amount, 0, @Amount

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CRM_Rentals_Denied]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CRM_Rentals_Denied]
@Rental_ID INT,
@Processor_ID int
AS
BEGIN

	DECLARE @Stamp VARCHAR(25), @Amount DECIMAL(18, 2)

	SET @Stamp = FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss')
	SET @Amount = ISNULL((SELECT Hourly_Rate * Hourly_Usage FROM CRM_Rentals WHERE ID = @Rental_ID), 0)

	UPDATE	CRM_Rentals 
	SET		Status = 'X', Processor_ID = @Processor_ID 
	WHERE	ID = @Rental_ID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_INF_Bikes]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INF_Bikes]
@Bike_ID INT
AS
BEGIN

	SELECT *, (Stock - Leased) AS Available FROM
	(
		SELECT B.*,
		Leased = (SELECT COUNT(*) AS N
					FROM CRM_Rentals_Detail RD
						LEFT OUTER JOIN CRM_Rentals R ON  R.ID = RD.Rental_ID
					WHERE R.Bike_ID = B.ID AND R.Status = 'L')
		FROM VW_CRM_Bikes B
	) AS Bikes
	WHERE ID = @Bike_ID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_INF_User]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INF_User]
@ID int
AS
BEGIN

	SELECT TOP 1 * FROM VW_SYS_Users WHERE ID = @ID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_Login]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SYS_Login]
@Username varchar(100),
@Password varchar(100),
@Err varchar(300) output
AS
BEGIN

	DECLARE @ID int, @Status varchar(1), @Stamp varchar(25), @Role_ID INT

	SET @Err = ''

	--> Check Email
	SELECT @ID = ID, @Status = Status FROM SYS_Users WHERE Username = @Username AND Password = @Password

	SET @ID = ISNULL(@ID, 0)

	IF @ID = 0 BEGIN
		SET @Err = 'Invalid username/password'
		RETURN
	END

	IF @Status = '' OR @Status = 'X' BEGIN
		SET @Err = 'User account is not active'
		RETURN
	END

	IF @Status = 'L' BEGIN
		SET @Err = 'User account is locked'
		RETURN
	END

	SET @Role_ID = ISNULL((SELECT Role_ID FROM SYS_Users WHERE ID = @ID), 0)

	SELECT TOP 1 * FROM VW_SYS_Users WHERE ID = @ID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_SYS_Register]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SYS_Register]
@Name varchar(80),
@Username varchar(100),
@Password varchar(100),
@Err varchar(300) output
AS
BEGIN

	DECLARE @ID int, @Status varchar(1), @Stamp varchar(25)

	SET @Err = ''

	IF EXISTS(SELECT Username FROM SYS_Users WHERE Username = @Username) BEGIN
		SET @Err = 'Email is already in used.'
		RETURN
	END

	INSERT INTO SYS_Users (Role_ID, Username, Password, Status, Name)
	SELECT 1, @Username, @Password, 'A', @Name

	SET @ID = SCOPE_IDENTITY()

	INSERT INTO CRM_Customers (User_ID, Gender, Address, Contact_No, Email)
	SELECT @ID, 'M', '', '', @Username

END
GO
/****** Object:  StoredProcedure [dbo].[SP_TRN_Sales_Save]    Script Date: 14/05/2022 7:25:44 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TRN_Sales_Save]
@Rental_ID INT,
@Rental_Date VARCHAR(25),
@Rent DECIMAL(18, 2),
@Penalty DECIMAL(18, 2),
@Total DECIMAL(18, 2),
@Stamper_ID INT
AS
BEGIN

	DECLARE @Bike_ID INT

	SET @Bike_ID = ISNULL((SELECT ID FROM CRM_Rentals WHERE ID = @Rental_ID), 0)

	UPDATE CRM_Rentals SET Status = 'H' WHERE ID = @Rental_ID
	UPDATE CRM_Bikes_Collection SET Status = 'A' WHERE Bike_ID = @Bike_ID

	INSERT INTO CRM_Sales (Rental_ID, Type_ID,  Rental_Date, Amount, Penalty, Total)
	SELECT @Rental_ID, 5, @Rental_Date, @Rent, @Penalty, @Total

END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CRM_Bikes"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 310
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "TYP_Categories"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Bikes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Bikes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CRM_Bikes_Collection"
            Begin Extent = 
               Top = 23
               Left = 54
               Bottom = 256
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CRM_Bikes"
            Begin Extent = 
               Top = 12
               Left = 409
               Bottom = 200
               Right = 579
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TYP_Categories"
            Begin Extent = 
               Top = 99
               Left = 684
               Bottom = 195
               Right = 854
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2040
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Bikes_Collections'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Bikes_Collections'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[28] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VW_SYS_Users"
            Begin Extent = 
               Top = 93
               Left = 497
               Bottom = 324
               Right = 667
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CRM_Rentals"
            Begin Extent = 
               Top = 10
               Left = 67
               Bottom = 306
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CRM_Bikes"
            Begin Extent = 
               Top = 6
               Left = 293
               Bottom = 218
               Right = 463
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TYP_Categories"
            Begin Extent = 
               Top = 6
               Left = 711
               Bottom = 128
               Right = 881
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 18
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3105
         Alias = 990
         Table = 1170
         Output = 720
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Rentals'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Rentals'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Rentals'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CRM_Rentals_Detail"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 272
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TYP_Rentals"
            Begin Extent = 
               Top = 7
               Left = 283
               Bottom = 119
               Right = 453
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CRM_Bikes_Collection"
            Begin Extent = 
               Top = 73
               Left = 629
               Bottom = 278
               Right = 799
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SYS_Users_Profile"
            Begin Extent = 
               Top = 6
               Left = 837
               Bottom = 136
               Right = 1007
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Rentals_Collection'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'= 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Rentals_Collection'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Rentals_Collection'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 205
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CRM_Rentals"
            Begin Extent = 
               Top = 0
               Left = 336
               Bottom = 251
               Right = 524
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CRM_Bikes"
            Begin Extent = 
               Top = 6
               Left = 562
               Bottom = 136
               Right = 732
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 14
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Sales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CRM_Sales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "U"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 180
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SYS_Users_Profile"
            Begin Extent = 
               Top = 19
               Left = 595
               Bottom = 223
               Right = 765
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SYS_Roles"
            Begin Extent = 
               Top = 168
               Left = 270
               Bottom = 264
               Right = 440
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 18
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5370
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_SYS_Users'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_SYS_Users'
GO
