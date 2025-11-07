USE [master]
GO
/****** Object:  Database [WorkConnectDB]    Script Date: 11/9/2024 7:23:37 PM ******/
CREATE DATABASE [WorkConnectDB]
GO
ALTER DATABASE [WorkConnectDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WorkConnectDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WorkConnectDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WorkConnectDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WorkConnectDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WorkConnectDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WorkConnectDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [WorkConnectDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WorkConnectDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WorkConnectDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WorkConnectDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WorkConnectDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WorkConnectDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WorkConnectDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WorkConnectDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WorkConnectDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WorkConnectDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WorkConnectDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WorkConnectDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WorkConnectDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WorkConnectDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WorkConnectDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WorkConnectDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WorkConnectDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WorkConnectDB] SET RECOVERY FULL 
GO
ALTER DATABASE [WorkConnectDB] SET  MULTI_USER 
GO
ALTER DATABASE [WorkConnectDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WorkConnectDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WorkConnectDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WorkConnectDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WorkConnectDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [WorkConnectDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'WorkConnectDB', N'ON'
GO
ALTER DATABASE [WorkConnectDB] SET QUERY_STORE = OFF
GO
USE [WorkConnectDB]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[email] [nvarchar](255) NULL,
	[phone] [nvarchar](20) NULL,
	[firstName] [nvarchar](50) NULL,
	[lastName] [nvarchar](50) NULL,
	[dob] [date] NULL,
	[address] [nvarchar](255) NULL,
	[avatar] [nvarchar](255) NULL,
	[roleId] [int] NULL,
	[isActive] [bit] NULL,
	[createAt] [date] NULL,
	[updatedAt] [date] NULL,
	[gender] [bit] NULL,
 CONSTRAINT [PK__Account__3213E83F7FC4AC05] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Applications]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Applications](
	[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[JobPostingID] [int] NULL,
	[JobSeekerID] [int] NULL,
	[CVID] [int] NULL,
	[Status] [int] NULL,
	[AppliedDate] [date] NULL,
 CONSTRAINT [PK__Applicat__C93A4F79B203A862] PRIMARY KEY CLUSTERED 
(
	[ApplicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[location] [nvarchar](255) NULL,
	[verificationStatus] [bit] NULL,
	[accountId] [int] NULL,
	[BusinessLicenseImage] [nvarchar](max) NULL,
	[BusinessCode] [nvarchar](50) NULL,
 CONSTRAINT [PK__Companie__2D971C4CD6A6A885] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CVs]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CVs](
	[CVID] [int] IDENTITY(1,1) NOT NULL,
	[JobSeekerID] [int] NULL,
	[FilePath] [nvarchar](255) NULL,
	[UploadDate] [datetime2](7) NULL,
	[LastUpdated] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[CVID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Education]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Education](
	[EducationID] [int] IDENTITY(1,1) NOT NULL,
	[JobSeekerID] [int] NULL,
	[Institution] [nvarchar](255) NULL,
	[Degree] [nvarchar](100) NULL,
	[FieldOfStudy] [nvarchar](100) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[DegreeImg] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[EducationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FavourJobPosting]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FavourJobPosting](
	[FavourJPID] [int] IDENTITY(1,1) NOT NULL,
	[JobSeekerID] [int] NULL,
	[JobPostingID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedback]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedback](
	[FeedbackID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NULL,
	[ContentFeedback] [nvarchar](max) NULL,
	[CreatedAt] [date] NULL,
	[Status] [int] NULL,
	[JobPostingID] [int] NULL,
 CONSTRAINT [PK__Feedback__6A4BEDF60AAD4713] PRIMARY KEY CLUSTERED 
(
	[FeedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Job_Posting_Category]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Job_Posting_Category](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_Job_Posting_category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobPostings]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobPostings](
	[JobPostingID] [int] IDENTITY(1,1) NOT NULL,
	[RecruiterID] [int] NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Requirements] [nvarchar](max) NULL,
	[MinSalary] [decimal](10, 2) NULL,
	[MaxSalary] [decimal](10, 2) NULL,
	[Location] [nvarchar](255) NULL,
	[PostedDate] [date] NULL,
	[ClosingDate] [date] NULL,
	[Job_Posting_CategoryID] [int] NULL,
	[Status] [nvarchar](20) NULL,
 CONSTRAINT [PK__JobPosti__350AABE90A500774] PRIMARY KEY CLUSTERED 
(
	[JobPostingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobSeekers]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobSeekers](
	[JobSeekerID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[JobSeekerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recruiters]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recruiters](
	[RecruiterID] [int] IDENTITY(1,1) NOT NULL,
	[isVerify] [bit] NULL,
	[AccountID] [int] NULL,
	[CompanyID] [int] NULL,
	[Position] [nvarchar](100) NULL,
	[FrontCitizenImage] [nvarchar](255) NULL,
	[BackCitizenImage] [nvarchar](255) NULL,
 CONSTRAINT [PK__Recruite__219CFF76A3451C8C] PRIMARY KEY CLUSTERED 
(
	[RecruiterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Work_Experience]    Script Date: 11/9/2024 7:23:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Work_Experience](
	[ExperienceID] [int] IDENTITY(1,1) NOT NULL,
	[JobSeekerID] [int] NULL,
	[CompanyName] [nvarchar](255) NULL,
	[JobTitle] [nvarchar](100) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ExperienceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Account] ON 

INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (4, N'admin', N'admin', N'vanctquantrivien@gmail.com', NULL, N'CT', N'Van', NULL, NULL, N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 1, 1, CAST(N'2024-10-16' AS Date), NULL, 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (5, N'john_doe', N'Pa$$word123', N'john.doe@example.com', N'0912345678', N'John', N'Doe', CAST(N'1990-05-15' AS Date), N'123 Main St, City A', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-01' AS Date), CAST(N'2024-11-08' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (6, N'jane_smith', N'Secure#45', N'jane.smith@example.com', N'0912345679', N'Jane', N'Smith', CAST(N'1992-08-21' AS Date), N'456 Elm St, City B', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-02' AS Date), CAST(N'2023-10-02' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (7, N'michael_brown', N'P@ssword78', N'michael.brown@example.com', N'0912345680', N'Michael', N'Brown', CAST(N'1988-03-10' AS Date), N'789 Maple St, City C', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-03' AS Date), CAST(N'2023-10-03' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (8, N'emily_davis', N'Em1ly@Pass!', N'emily.davis@example.com', N'0912345681', N'Emily', N'Davis', CAST(N'1995-11-27' AS Date), N'321 Oak St, City D', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-04' AS Date), CAST(N'2023-10-04' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (9, N'daniel_jones', N'Dan!el987', N'daniel.jones@example.com', N'0912345682', N'Daniel', N'Jones', CAST(N'1986-07-19' AS Date), N'654 Pine St, City E', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-05' AS Date), CAST(N'2023-10-05' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (10, N'laura_taylor', N'Tayl0r@123', N'laura.taylor@example.com', N'0912345683', N'Laura', N'Taylor', CAST(N'1993-12-09' AS Date), N'987 Cedar St, City F', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-06' AS Date), CAST(N'2023-10-06' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (11, N'robert_wilson', N'R0b#Wilson', N'robert.wilson@example.com', N'0912345684', N'Robert', N'Wilson', CAST(N'1989-01-15' AS Date), N'159 Birch St, City G', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-07' AS Date), CAST(N'2023-10-07' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (12, N'susan_moore', N'Moore!234', N'susan.moore@example.com', N'0912345685', N'Susan', N'Moore', CAST(N'1991-04-23' AS Date), N'753 Willow St, City H', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-08' AS Date), CAST(N'2023-10-08' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (13, N'kevin_lee', N'L33_Kevin$', N'kevin.lee@example.com', N'0912345686', N'Kevin', N'Lee', CAST(N'1985-02-14' AS Date), N'246 Spruce St, City I', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-09' AS Date), CAST(N'2023-10-09' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (14, N'carla_harris', N'C4rla@Harris', N'carla.harris@example.com', N'0912345687', N'Carla', N'Harris', CAST(N'1994-06-11' AS Date), N'369 Poplar St, City J', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-10' AS Date), CAST(N'2023-10-10' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (15, N'frank_martin', N'M@rtin2023', N'frank.martin@example.com', N'0912345688', N'Frank', N'Martin', CAST(N'1987-09-29' AS Date), N'951 Walnut St, City K', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-11' AS Date), CAST(N'2023-10-11' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (16, N'alice_jackson', N'Alic3@Jackson', N'alice.jackson@example.com', N'0912345689', N'Alice', N'Jackson', CAST(N'1996-03-08' AS Date), N'852 Fir St, City L', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2023-01-12' AS Date), CAST(N'2023-10-12' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (17, N'paul_white', N'Wh!te1234', N'paul.white@example.com', N'0912345690', N'Paul', N'White', CAST(N'1984-08-25' AS Date), N'147 Aspen St, City M', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 0, CAST(N'2023-01-13' AS Date), CAST(N'2023-10-13' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (18, N'nancy_clark', N'Clark@7890', N'nancy.clark@example.com', N'0912345691', N'Nancy', N'Clark', CAST(N'1991-10-10' AS Date), N'369 Cherry St, City N', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 0, CAST(N'2023-01-14' AS Date), CAST(N'2023-10-14' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (19, N'steve_martinez', N'Martinez$456', N'tuantvhe173048@fpt.edu.vn', N'0912345692', N'Steve', N'Martinez', CAST(N'1992-05-05' AS Date), N'852 Ash St, City O', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-15' AS Date), CAST(N'2023-10-15' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (20, N'linda_anderson', N'L!nda@Ander', N'linda.anderson@example.com', N'0912345693', N'Linda', N'Anderson', CAST(N'1983-12-12' AS Date), N'963 Oak St, City P', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-16' AS Date), CAST(N'2023-10-16' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (21, N'eric_thomas', N'Th0m@s!234', N'eric.thomas@example.com', N'0912345694', N'Eric', N'Thomas', CAST(N'1990-07-23' AS Date), N'174 Elm St, City Q', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-17' AS Date), CAST(N'2023-10-17' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (22, N'rachel_miller', N'M!ller@789', N'rachel.miller@example.com', N'0912345695', N'Rachel', N'Miller', CAST(N'1987-11-30' AS Date), N'285 Maple St, City R', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-18' AS Date), CAST(N'2023-10-18' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (23, N'timothy_evans', N'Evans#1234', N'timothy.evans@example.com', N'0912345696', N'Timothy', N'Evans', CAST(N'1985-02-06' AS Date), N'396 Pine St, City S', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-19' AS Date), CAST(N'2023-10-19' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (24, N'brenda_scott', N'Scott!4567', N'brenda.scott@example.com', N'0912345697', N'Brenda', N'Scott', CAST(N'1986-06-14' AS Date), N'497 Spruce St, City T', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-20' AS Date), CAST(N'2023-10-20' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (25, N'george_hall', N'H@ll7890', N'george.hall@example.com', N'0912345698', N'George', N'Hall', CAST(N'1989-04-19' AS Date), N'598 Fir St, City U', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-21' AS Date), CAST(N'2023-10-21' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (26, N'anna_kim', N'K!m234567', N'anna.kim@example.com', N'0912345699', N'Anna', N'Kim', CAST(N'1993-09-02' AS Date), N'159 Willow St, City V', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-22' AS Date), CAST(N'2023-10-22' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (27, N'mark_collins', N'Collins@123', N'mark.collins@example.com', N'0912345700', N'Mark', N'Collins', CAST(N'1982-03-18' AS Date), N'951 Cherry St, City W', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-23' AS Date), CAST(N'2023-10-23' AS Date), 1)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (28, N'sara_walker', N'Walker!890', N'sara.walker@example.com', N'0912345701', N'Sara', N'Walker', CAST(N'1988-10-07' AS Date), N'753 Birch St, City X', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 3, 1, CAST(N'2023-01-24' AS Date), CAST(N'2023-10-24' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (30, N'namcio', N'a123456789.', N'ninhnamhp@gmail.com', N'0987654321', N'ninh', N'nam', CAST(N'2004-09-15' AS Date), N'Hà Nội', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2024-11-07' AS Date), CAST(N'2024-11-07' AS Date), 0)
INSERT [dbo].[Account] ([id], [username], [password], [email], [phone], [firstName], [lastName], [dob], [address], [avatar], [roleId], [isActive], [createAt], [updatedAt], [gender]) VALUES (31, N're1', N'123', N'd@f.com', N'0123456789', N'Vu', N'Li', CAST(N'2000-02-03' AS Date), N'City', N'/JobSeeker/images/242185eaef43192fc3f9646932fe3b46.jpg', 2, 1, CAST(N'2024-11-08' AS Date), NULL, 1)
SET IDENTITY_INSERT [dbo].[Account] OFF
GO
SET IDENTITY_INSERT [dbo].[Applications] ON 

INSERT [dbo].[Applications] ([ApplicationID], [JobPostingID], [JobSeekerID], [CVID], [Status], [AppliedDate]) VALUES (1, 1096, 1, 1, 3, CAST(N'2024-11-08' AS Date))
INSERT [dbo].[Applications] ([ApplicationID], [JobPostingID], [JobSeekerID], [CVID], [Status], [AppliedDate]) VALUES (3, 1096, 2, 2, 2, CAST(N'2024-11-09' AS Date))
INSERT [dbo].[Applications] ([ApplicationID], [JobPostingID], [JobSeekerID], [CVID], [Status], [AppliedDate]) VALUES (4, 1096, 3, 3, 1, CAST(N'2024-11-09' AS Date))
INSERT [dbo].[Applications] ([ApplicationID], [JobPostingID], [JobSeekerID], [CVID], [Status], [AppliedDate]) VALUES (5, 1096, 4, 4, 0, CAST(N'2024-11-09' AS Date))
INSERT [dbo].[Applications] ([ApplicationID], [JobPostingID], [JobSeekerID], [CVID], [Status], [AppliedDate]) VALUES (6, 1104, 4, 4, 3, CAST(N'2024-11-09' AS Date))
SET IDENTITY_INSERT [dbo].[Applications] OFF
GO
SET IDENTITY_INSERT [dbo].[Company] ON 

INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1034, N'Tech Innovations Inc.', N'<p>A leading company in technology solutions and software development.</p>', N'New York, NY', 1, 5, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'09909')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1035, N'Green Earth LLC', N'Environmentally friendly products and sustainable solutions.', N'San Francisco, CA', 0, 6, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'09910')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1036, N'HealthFirst Medical', N'Healthcare services and medical products.', N'Chicago, IL', 1, 7, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'01190')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1037, N'EduPlus', N'Education and training services for professionals.', N'Boston, MA', 1, 8, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'09190')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1038, N'FinServe Corp', N'Financial services, investment solutions, and consulting.', N'New York, NY', 0, 9, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'11090')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1039, N'Foodies Delight', N'Gourmet food products and catering services.', N'Austin, TX', 1, 10, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'00900')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1040, N'QuickFix IT Solutions', N'IT support and cybersecurity services.', N'Seattle, WA', 1, 11, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'08980')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1041, N'Urban Apparel', N'Fashion and clothing retail for urban wear.', N'Los Angeles, CA', 0, 12, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'08910')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1042, N'AquaPure Water Co.', N'Water purification and supply services.', N'Phoenix, AZ', 1, 13, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'09180')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1043, N'Elite Fitness', N'Health and fitness centers with premium facilities.', N'Miami, FL', 0, 14, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'01119')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1044, N'HomeStyle Interiors', N'Interior design and home decor solutions.', N'Houston, TX', 1, 15, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'08181')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1045, N'Bright Future Solar', N'Renewable energy solutions with a focus on solar power.', N'Denver, CO', 1, 16, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'08790')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1046, N'FPT University', N'<p>Trường Đại Học FPT</p>', N'Thạch Thất/Hòa Lạc/Hà Nội ', 1, 30, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'99999')
INSERT [dbo].[Company] ([id], [name], [description], [location], [verificationStatus], [accountId], [BusinessLicenseImage], [BusinessCode]) VALUES (1047, N'Tech Nova', N'<p>Conduct research in AI technologies</p>', N'Big C Thang Long', 1, 31, N'/JobSeeker//images/Giayphepdkikinhdoanh.jpg', N'46289')
SET IDENTITY_INSERT [dbo].[Company] OFF
GO
SET IDENTITY_INSERT [dbo].[CVs] ON 

INSERT [dbo].[CVs] ([CVID], [JobSeekerID], [FilePath], [UploadDate], [LastUpdated]) VALUES (1, 1, N'/JobSeeker/cvFiles/Simple Professional CV Resume.pdf', CAST(N'2024-11-08T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-08T09:13:56.3933333' AS DateTime2))
INSERT [dbo].[CVs] ([CVID], [JobSeekerID], [FilePath], [UploadDate], [LastUpdated]) VALUES (2, 2, N'/JobSeeker/cvFiles/Simple Professional CV Resume.pdf', CAST(N'2024-11-08T09:18:50.5033333' AS DateTime2), CAST(N'2024-11-08T09:18:50.5033333' AS DateTime2))
INSERT [dbo].[CVs] ([CVID], [JobSeekerID], [FilePath], [UploadDate], [LastUpdated]) VALUES (3, 3, N'/JobSeeker/cvFiles/Simple Professional CV Resume.pdf', CAST(N'2024-11-08T09:19:16.2233333' AS DateTime2), CAST(N'2024-11-08T09:19:16.2233333' AS DateTime2))
INSERT [dbo].[CVs] ([CVID], [JobSeekerID], [FilePath], [UploadDate], [LastUpdated]) VALUES (4, 4, N'/JobSeeker/cvFiles/Simple Professional CV Resume.pdf', CAST(N'2024-11-08T09:19:20.3700000' AS DateTime2), CAST(N'2024-11-08T09:19:20.3700000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[CVs] OFF
GO
SET IDENTITY_INSERT [dbo].[Education] ON 

INSERT [dbo].[Education] ([EducationID], [JobSeekerID], [Institution], [Degree], [FieldOfStudy], [StartDate], [EndDate], [DegreeImg]) VALUES (2, 1, N'Hanoi University of Science and Technology', N'PhD', N'Information Technology', CAST(N'2018-09-01' AS Date), CAST(N'2021-06-01' AS Date), N'uploads/degreeImgs/BangTotNghiep.jpg')
INSERT [dbo].[Education] ([EducationID], [JobSeekerID], [Institution], [Degree], [FieldOfStudy], [StartDate], [EndDate], [DegreeImg]) VALUES (3, 1, N'University of Danang', N'Bachelor', N'Software Engineering', CAST(N'2015-09-01' AS Date), CAST(N'2019-06-01' AS Date), N'uploads/degreeImgs/BangTotNghiep.jpg')
INSERT [dbo].[Education] ([EducationID], [JobSeekerID], [Institution], [Degree], [FieldOfStudy], [StartDate], [EndDate], [DegreeImg]) VALUES (4, 2, N'University of Danang', N'PhD', N'Software Engineering', CAST(N'2015-09-01' AS Date), CAST(N'2019-06-01' AS Date), N'uploads/degreeImgs/BangTotNghiep.jpg')
INSERT [dbo].[Education] ([EducationID], [JobSeekerID], [Institution], [Degree], [FieldOfStudy], [StartDate], [EndDate], [DegreeImg]) VALUES (5, 3, N'University of Danang', N'PhD', N'Software Engineering', CAST(N'2015-09-01' AS Date), CAST(N'2019-06-01' AS Date), N'uploads/degreeImgs/BangTotNghiep.jpg')
INSERT [dbo].[Education] ([EducationID], [JobSeekerID], [Institution], [Degree], [FieldOfStudy], [StartDate], [EndDate], [DegreeImg]) VALUES (6, 4, N'University of Danang', N'PhD', N'Software Engineering', CAST(N'2015-09-01' AS Date), CAST(N'2019-06-01' AS Date), N'uploads/degreeImgs/BangTotNghiep.jpg')
SET IDENTITY_INSERT [dbo].[Education] OFF
GO
SET IDENTITY_INSERT [dbo].[FavourJobPosting] ON 

INSERT [dbo].[FavourJobPosting] ([FavourJPID], [JobSeekerID], [JobPostingID]) VALUES (1, 1, 1139)
INSERT [dbo].[FavourJobPosting] ([FavourJPID], [JobSeekerID], [JobPostingID]) VALUES (2, 1, 1096)
SET IDENTITY_INSERT [dbo].[FavourJobPosting] OFF
GO
SET IDENTITY_INSERT [dbo].[Feedback] ON 

INSERT [dbo].[Feedback] ([FeedbackID], [AccountID], [ContentFeedback], [CreatedAt], [Status], [JobPostingID]) VALUES (1, 19, N'While the duties are well-outlined, adding a few more details about the day-to-day tasks or specific projects the role will focus on could help applicants better understand what to expect.', CAST(N'2024-11-08' AS Date), 1, 1105)
INSERT [dbo].[Feedback] ([FeedbackID], [AccountID], [ContentFeedback], [CreatedAt], [Status], [JobPostingID]) VALUES (2, 19, N'pecifying whether certain skills are "required" or "preferred" could help attract candidates with the right qualifications. Additionally, detailing what levels of experience are sought in each skill area would guide applicants in assessing their fit.', CAST(N'2024-11-08' AS Date), 1, 1096)
INSERT [dbo].[Feedback] ([FeedbackID], [AccountID], [ContentFeedback], [CreatedAt], [Status], [JobPostingID]) VALUES (3, 19, N'pecifying whether certain skills are "required" or "preferred" could help attract candidates with the right qualifications. Additionally, detailing what levels of experience are sought in each skill area would guide applicants in assessing their fit.s', CAST(N'2024-11-08' AS Date), 1, 1098)
INSERT [dbo].[Feedback] ([FeedbackID], [AccountID], [ContentFeedback], [CreatedAt], [Status], [JobPostingID]) VALUES (4, 19, N'pecifying whether certain skills are "required" or "preferred" could help attract candidates with the right qualifications. Additionally, detailing what levels of experience are sought in each skill area would guide applicants in assessing their fit.', CAST(N'2024-11-08' AS Date), 1, 1103)
SET IDENTITY_INSERT [dbo].[Feedback] OFF
GO
SET IDENTITY_INSERT [dbo].[Job_Posting_Category] ON 

INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (12, N'Information Technology', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (13, N'Business & Finance', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (14, N'Healthcare', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (15, N'Education', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (16, N'Human Resources', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (17, N'Marketing & Sales', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (18, N'Operations & Logistics', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (19, N'Engineering', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (20, N'Research & Development', 1)
INSERT [dbo].[Job_Posting_Category] ([id], [name], [status]) VALUES (21, N'Creative & Design', 1)
SET IDENTITY_INSERT [dbo].[Job_Posting_Category] OFF
GO
SET IDENTITY_INSERT [dbo].[JobPostings] ON 

INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1096, 17, N'Software Engineer', N'Seeking a skilled Software Engineer to join our IT team.', N'Bachelor''s degree in Computer Science or related field. 3+ years of experience.', CAST(500.00 AS Decimal(10, 2)), CAST(1000.00 AS Decimal(10, 2)), N'San Francisco, CA', CAST(N'2023-01-15' AS Date), CAST(N'2023-05-15' AS Date), 12, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1097, 19, N'Data Analyst', N'Seeking a talented Data Analyst to join our Business Intelligence team.', N'Bachelor''s degree in Analytics, Statistics, or related field. 2+ years of experience.', CAST(200.00 AS Decimal(10, 2)), CAST(800.00 AS Decimal(10, 2)), N'New York City, NY', CAST(N'2023-01-01' AS Date), CAST(N'2023-06-01' AS Date), 12, N'Closed')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1098, 20, N'Marketing Manager', N'Seeking a creative Marketing Manager to lead our digital marketing efforts.', N'Bachelor''s degree in Marketing or related field. 5+ years of experience.', CAST(1000.00 AS Decimal(10, 2)), CAST(1500.00 AS Decimal(10, 2)), N'Chicago, IL', CAST(N'2023-02-01' AS Date), CAST(N'2023-07-01' AS Date), 17, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1099, 22, N'Project Manager', N'Seeking an experienced Project Manager to oversee our new software development project.', N'PMP certification preferred. 7+ years of project management experience.', CAST(1700.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), N'Seattle, WA', CAST(N'2023-03-01' AS Date), CAST(N'2023-08-01' AS Date), 12, N'Violate')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1100, 24, N'Graphic Designer', N'Seeking a talented Graphic Designer to join our creative team.', N'Bachelor''s degree in Graphic Design or related field. 3+ years of experience.', CAST(1000.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), N'Los Angeles, CA', CAST(N'2023-02-01' AS Date), CAST(N'2023-09-01' AS Date), 21, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1101, 25, N'HR Specialist', N'Seeking an HR Specialist to support our growing team.', N'Bachelor''s degree in Human Resources or related field. 2+ years of experience.', CAST(2000.00 AS Decimal(10, 2)), CAST(3000.00 AS Decimal(10, 2)), N'Miami, FL', CAST(N'2023-09-01' AS Date), CAST(N'2023-10-01' AS Date), 16, N'Violate')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1102, 27, N'Sales Representative', N'Seeking a driven Sales Representative to join our sales team.', N'Bachelor''s degree in Business or related field. 1+ years of sales experience.', CAST(40000.00 AS Decimal(10, 2)), CAST(60000.00 AS Decimal(10, 2)), N'Houston, TX', CAST(N'2023-09-01' AS Date), CAST(N'2023-11-01' AS Date), 13, N'Violate')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1103, 28, N'Operations Manager', N'Seeking an experienced Operations Manager to streamline our logistics processes.', N'Bachelor''s degree in Business or related field. 5+ years of operations experience.', CAST(45000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)), N'Atlanta, GA', CAST(N'2023-11-01' AS Date), CAST(N'2023-12-01' AS Date), 12, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1104, 17, N'Web Developer', N'Seeking a skilled Web Developer to join our IT team.', N'Bachelor''s degree in Computer Science or related field. 2+ years of experience.', CAST(55000.00 AS Decimal(10, 2)), CAST(6000.00 AS Decimal(10, 2)), N'San Francisco, CA', CAST(N'2023-12-01' AS Date), CAST(N'2024-01-01' AS Date), 12, N'Violate')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1105, 19, N'Financial Analyst', N'Seeking a detail-oriented Financial Analyst to join our Finance team.', N'Bachelor''s degree in Finance or Accounting. 3+ years of experience.', CAST(1200.00 AS Decimal(10, 2)), CAST(1800.00 AS Decimal(10, 2)), N'New York City, NY', CAST(N'2024-11-01' AS Date), CAST(N'2024-12-01' AS Date), 13, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1127, 17, N'Java Developer', N'Develop Java applications for various projects', N'Experience in Java, Spring Boot, SQL', CAST(700.00 AS Decimal(10, 2)), CAST(1500.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-01-01' AS Date), CAST(N'2024-03-01' AS Date), 12, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1128, 17, N'Front-End Developer', N'Design and develop front-end for web applications', N'Experience in HTML, CSS, JavaScript, React', CAST(600.00 AS Decimal(10, 2)), CAST(1400.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-01-03' AS Date), CAST(N'2024-03-15' AS Date), 21, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1129, 17, N'Project Manager', N'Lead software development projects', N'Project management experience, leadership skills', CAST(1200.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-01-05' AS Date), CAST(N'2024-03-30' AS Date), 13, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1130, 17, N'Data Analyst', N'Analyze data and generate reports', N'Experience with data analytics tools (SQL, Python)', CAST(800.00 AS Decimal(10, 2)), CAST(1600.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-01-07' AS Date), CAST(N'2024-04-10' AS Date), 14, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1131, 17, N'DevOps Engineer', N'Manage and automate software infrastructure', N'Experience with Docker, Kubernetes, CI/CD', CAST(1000.00 AS Decimal(10, 2)), CAST(1800.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-11-10' AS Date), CAST(N'2024-12-20' AS Date), 15, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1132, 17, N'QA Engineer', N'Test software applications to ensure quality', N'Experience in testing tools (Selenium, JIRA)', CAST(600.00 AS Decimal(10, 2)), CAST(1200.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-01-12' AS Date), CAST(N'2024-04-25' AS Date), 16, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1133, 17, N'Back-End Developer', N'Develop back-end services and APIs', N'Experience in Node.js, Express, SQL', CAST(750.00 AS Decimal(10, 2)), CAST(1600.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-01-15' AS Date), CAST(N'2024-05-01' AS Date), 17, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1134, 17, N'System Administrator', N'Maintain and manage server infrastructure', N'Experience in Linux, Network Configuration', CAST(900.00 AS Decimal(10, 2)), CAST(1500.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-01-18' AS Date), CAST(N'2024-05-10' AS Date), 18, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1135, 17, N'Business Analyst', N'Gather and analyze business requirements', N'Experience in requirement analysis and documentation', CAST(1000.00 AS Decimal(10, 2)), CAST(1700.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-01-20' AS Date), CAST(N'2024-05-20' AS Date), 19, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1136, 17, N'Mobile Developer', N'Develop mobile applications for Android/iOS', N'Experience in Kotlin/Swift, mobile UI/UX', CAST(800.00 AS Decimal(10, 2)), CAST(1400.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-01-22' AS Date), CAST(N'2024-05-30' AS Date), 12, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1137, 17, N'Network Engineer', N'Implement and manage company networks', N'Experience with network protocols and security', CAST(950.00 AS Decimal(10, 2)), CAST(1800.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-01-25' AS Date), CAST(N'2024-06-10' AS Date), 15, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1138, 17, N'IT Support Specialist', N'Provide IT support to staff and customers', N'Experience in hardware/software troubleshooting', CAST(500.00 AS Decimal(10, 2)), CAST(900.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-01-28' AS Date), CAST(N'2024-06-20' AS Date), 12, N'Closed')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1139, 17, N'Cloud Engineer', N'Manage and deploy cloud infrastructure', N'Experience in AWS/Azure, cloud architecture', CAST(1100.00 AS Decimal(10, 2)), CAST(1900.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-01-30' AS Date), CAST(N'2024-07-01' AS Date), 13, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1140, 17, N'Fullstack Developer', N'Develop both front-end and back-end components', N'Experience in JavaScript, Node.js, React', CAST(1000.00 AS Decimal(10, 2)), CAST(1700.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-02-01' AS Date), CAST(N'2024-07-10' AS Date), 14, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1141, 17, N'Cyber Security Analyst', N'Ensure system and data security', N'Experience in penetration testing, SIEM tools', CAST(1200.00 AS Decimal(10, 2)), CAST(2100.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-11-15' AS Date), CAST(N'2024-11-21' AS Date), 15, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1142, 17, N'Technical Writer', N'Create technical documentation and guides', N'Excellent writing skills, familiarity with technical topics', CAST(700.00 AS Decimal(10, 2)), CAST(1200.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-02-08' AS Date), CAST(N'2024-08-01' AS Date), 16, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1143, 17, N'Database Administrator', N'Maintain database systems', N'Experience in SQL, database optimization', CAST(1100.00 AS Decimal(10, 2)), CAST(1800.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-02-10' AS Date), CAST(N'2024-08-10' AS Date), 17, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1144, 17, N'UX/UI Designer', N'Design user-friendly interfaces', N'Experience in Figma, Adobe XD, prototyping', CAST(800.00 AS Decimal(10, 2)), CAST(1500.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-02-15' AS Date), CAST(N'2024-08-20' AS Date), 18, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1145, 17, N'Product Owner', N'Define product vision and manage the development backlog', N'Experience in product management, agile practices', CAST(1300.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-02-20' AS Date), CAST(N'2024-08-30' AS Date), 19, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1146, 17, N'IT Project Coordinator', N'Coordinate IT project tasks', N'Experience in project coordination, Gantt charts', CAST(900.00 AS Decimal(10, 2)), CAST(1400.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-02-25' AS Date), CAST(N'2024-09-10' AS Date), 20, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1147, 17, N'Software Architect', N'Define system architecture and design patterns', N'Experience in microservices, software architecture', CAST(1500.00 AS Decimal(10, 2)), CAST(2500.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-03-01' AS Date), CAST(N'2024-09-20' AS Date), 21, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1148, 17, N'Scrum Master', N'Facilitate Scrum ceremonies and processes', N'Experience with Scrum, agile project management', CAST(1100.00 AS Decimal(10, 2)), CAST(1900.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-03-05' AS Date), CAST(N'2024-10-01' AS Date), 14, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1149, 17, N'Machine Learning Engineer', N'Develop ML models and algorithms', N'Experience in Python, TensorFlow, ML algorithms', CAST(1300.00 AS Decimal(10, 2)), CAST(2200.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-03-10' AS Date), CAST(N'2024-10-10' AS Date), 20, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1150, 17, N'Help Desk Technician', N'Assist users with IT issues', N'Experience with IT support, problem-solving skills', CAST(500.00 AS Decimal(10, 2)), CAST(1000.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-03-15' AS Date), CAST(N'2024-10-20' AS Date), 20, N'Violate')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1151, 17, N'AI Developer', N'Develop AI-based features and tools', N'Experience in Python, AI frameworks', CAST(1200.00 AS Decimal(10, 2)), CAST(2000.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-03-20' AS Date), CAST(N'2024-10-30' AS Date), 20, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1152, 17, N'Game Developer', N'Develop gaming software and systems', N'Experience in Unity, C#, game development', CAST(900.00 AS Decimal(10, 2)), CAST(1700.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-03-25' AS Date), CAST(N'2024-11-01' AS Date), 18, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1153, 17, N'Technical Support Engineer', N'Provide technical support for software products', N'Experience in software troubleshooting', CAST(700.00 AS Decimal(10, 2)), CAST(1400.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-03-30' AS Date), CAST(N'2024-11-10' AS Date), 20, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1154, 17, N'Embedded Systems Developer', N'Develop software for embedded systems', N'Experience in C/C++, embedded hardware', CAST(1000.00 AS Decimal(10, 2)), CAST(1800.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-04-01' AS Date), CAST(N'2024-11-20' AS Date), 18, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1155, 17, N'Cloud Solutions Architect', N'Design cloud infrastructure solutions', N'Experience in AWS, cloud architecture', CAST(1500.00 AS Decimal(10, 2)), CAST(2500.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-04-05' AS Date), CAST(N'2024-12-01' AS Date), 19, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1156, 17, N'IT Manager', N'Manage IT operations and staff', N'Experience in IT management, leadership skills', CAST(1400.00 AS Decimal(10, 2)), CAST(2300.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-04-10' AS Date), CAST(N'2024-12-10' AS Date), 12, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1157, 17, N'Blockchain Developer', N'Develop blockchain-based applications', N'Experience in Solidity, Ethereum, smart contracts', CAST(1300.00 AS Decimal(10, 2)), CAST(2100.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-04-15' AS Date), CAST(N'2024-12-20' AS Date), 14, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1158, 17, N'E-Commerce Specialist', N'Manage e-commerce operations and strategies', N'Experience in digital marketing, e-commerce platforms', CAST(800.00 AS Decimal(10, 2)), CAST(1400.00 AS Decimal(10, 2)), N'Ho Chi Minh City', CAST(N'2024-11-12' AS Date), CAST(N'2025-11-27' AS Date), 13, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1159, 17, N'Salesforce Developer', N'Customize and maintain Salesforce applications', N'Experience in Salesforce, Apex', CAST(1000.00 AS Decimal(10, 2)), CAST(1900.00 AS Decimal(10, 2)), N'Hanoi', CAST(N'2024-04-25' AS Date), CAST(N'2025-01-10' AS Date), 13, N'Open')
INSERT [dbo].[JobPostings] ([JobPostingID], [RecruiterID], [Title], [Description], [Requirements], [MinSalary], [MaxSalary], [Location], [PostedDate], [ClosingDate], [Job_Posting_CategoryID], [Status]) VALUES (1160, 17, N'AI Research Scientist', N'Conduct research in AI technologies', N'Ph.D. in AI/ML, research experience', CAST(2000.00 AS Decimal(10, 2)), CAST(3000.00 AS Decimal(10, 2)), N'Da Nang', CAST(N'2024-05-01' AS Date), CAST(N'2025-01-20' AS Date), 15, N'Violate')
SET IDENTITY_INSERT [dbo].[JobPostings] OFF
GO
SET IDENTITY_INSERT [dbo].[JobSeekers] ON 

INSERT [dbo].[JobSeekers] ([JobSeekerID], [AccountID]) VALUES (2, 17)
INSERT [dbo].[JobSeekers] ([JobSeekerID], [AccountID]) VALUES (3, 18)
INSERT [dbo].[JobSeekers] ([JobSeekerID], [AccountID]) VALUES (1, 19)
INSERT [dbo].[JobSeekers] ([JobSeekerID], [AccountID]) VALUES (4, 20)
SET IDENTITY_INSERT [dbo].[JobSeekers] OFF
GO
SET IDENTITY_INSERT [dbo].[Recruiters] ON 

INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (17, 1, 5, 1034, N'Human Resources Manager', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (18, 1, 6, 1035, N'Recruitment Specialist', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (19, 1, 7, 1036, N'Talent Acquisition Lead', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (20, 1, 8, 1037, N'HR Business Partner', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (21, 0, 9, 1038, N'Hiring Coordinator', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (22, 1, 10, 1039, N'Staffing Manager', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (23, 0, 11, 1040, N'Recruitment Coordinator', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (24, 1, 12, 1041, N'Recruiting Administrator', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (25, 1, 13, 1042, N'Technical Recruiter', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (26, 0, 14, 1043, N'Sourcing Specialist', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (27, 1, 15, 1044, N'Senior Recruiter', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (28, 1, 16, 1045, N'Junior Recruiter', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
INSERT [dbo].[Recruiters] ([RecruiterID], [isVerify], [AccountID], [CompanyID], [Position], [FrontCitizenImage], [BackCitizenImage]) VALUES (29, 0, 30, 1046, N'Sinh Viên', N'uploads/citizen_ids/4.1.2.jpg', N'uploads/citizen_ids/7.109.png')
SET IDENTITY_INSERT [dbo].[Recruiters] OFF
GO
SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([id], [name]) VALUES (1, N'admin')
INSERT [dbo].[Role] ([id], [name]) VALUES (2, N'recruiter')
INSERT [dbo].[Role] ([id], [name]) VALUES (3, N'seeker')
SET IDENTITY_INSERT [dbo].[Role] OFF
GO
SET IDENTITY_INSERT [dbo].[Work_Experience] ON 

INSERT [dbo].[Work_Experience] ([ExperienceID], [JobSeekerID], [CompanyName], [JobTitle], [StartDate], [EndDate], [Description]) VALUES (1, 1, N'FPT Software', N'Dev Java', CAST(N'2020-11-08' AS Date), CAST(N'2024-11-08' AS Date), N'Developed and maintained web applications using Java, Spring Boot, and related technologies.')
INSERT [dbo].[Work_Experience] ([ExperienceID], [JobSeekerID], [CompanyName], [JobTitle], [StartDate], [EndDate], [Description]) VALUES (7, 1, N'Tech Innovators', N'Fullstack Developer', CAST(N'2018-06-10' AS Date), CAST(N'2021-12-20' AS Date), N'Developed both frontend and backend components for e-commerce applications.')
INSERT [dbo].[Work_Experience] ([ExperienceID], [JobSeekerID], [CompanyName], [JobTitle], [StartDate], [EndDate], [Description]) VALUES (8, 1, N'Global Tech', N'Junior Java Developer', CAST(N'2022-01-01' AS Date), CAST(N'2023-08-15' AS Date), N'Assisted in maintaining Java-based applications and improving code efficiency.')
INSERT [dbo].[Work_Experience] ([ExperienceID], [JobSeekerID], [CompanyName], [JobTitle], [StartDate], [EndDate], [Description]) VALUES (9, 2, N'Global Tech', N'Junior Java Developer', CAST(N'2022-01-01' AS Date), CAST(N'2023-08-15' AS Date), N'Assisted in maintaining Java-based applications and improving code efficiency.')
INSERT [dbo].[Work_Experience] ([ExperienceID], [JobSeekerID], [CompanyName], [JobTitle], [StartDate], [EndDate], [Description]) VALUES (10, 3, N'Global Tech', N'Junior Java Developer', CAST(N'2022-01-01' AS Date), CAST(N'2023-08-15' AS Date), N'Assisted in maintaining Java-based applications and improving code efficiency.')
INSERT [dbo].[Work_Experience] ([ExperienceID], [JobSeekerID], [CompanyName], [JobTitle], [StartDate], [EndDate], [Description]) VALUES (11, 4, N'Tech Innovators', N'Dev Java', CAST(N'2020-11-08' AS Date), CAST(N'2024-11-08' AS Date), N'Developed both frontend and backend components for e-commerce applications.')
SET IDENTITY_INSERT [dbo].[Work_Experience] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Account__F3DBC572418299EE]    Script Date: 11/9/2024 7:23:37 PM ******/
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [UQ__Account__F3DBC572418299EE] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_account_email]    Script Date: 11/9/2024 7:23:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_account_email] ON [dbo].[Account]
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_applications_jobposting]    Script Date: 11/9/2024 7:23:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_applications_jobposting] ON [dbo].[Applications]
(
	[JobPostingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_applications_jobseeker]    Script Date: 11/9/2024 7:23:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_applications_jobseeker] ON [dbo].[Applications]
(
	[JobSeekerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_companies_name]    Script Date: 11/9/2024 7:23:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_companies_name] ON [dbo].[Company]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_cvs_jobseeker]    Script Date: 11/9/2024 7:23:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_cvs_jobseeker] ON [dbo].[CVs]
(
	[JobSeekerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_education_jobseeker]    Script Date: 11/9/2024 7:23:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_education_jobseeker] ON [dbo].[Education]
(
	[JobSeekerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__JobSeeke__349DA587C3C20D4A]    Script Date: 11/9/2024 7:23:37 PM ******/
ALTER TABLE [dbo].[JobSeekers] ADD UNIQUE NONCLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Recruite__349DA587681A6B54]    Script Date: 11/9/2024 7:23:37 PM ******/
ALTER TABLE [dbo].[Recruiters] ADD  CONSTRAINT [UQ__Recruite__349DA587681A6B54] UNIQUE NONCLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_work_experience_jobseeker]    Script Date: 11/9/2024 7:23:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_work_experience_jobseeker] ON [dbo].[Work_Experience]
(
	[JobSeekerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF__Account__isActiv__286302EC]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF__Account__createA__29572725]  DEFAULT (getdate()) FOR [createAt]
GO
ALTER TABLE [dbo].[Applications] ADD  CONSTRAINT [DF__Applicati__Statu__4316F928]  DEFAULT ('Submitted') FOR [Status]
GO
ALTER TABLE [dbo].[Applications] ADD  CONSTRAINT [DF__Applicati__Appli__440B1D61]  DEFAULT (getdate()) FOR [AppliedDate]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_verificationStatus]  DEFAULT ((1)) FOR [verificationStatus]
GO
ALTER TABLE [dbo].[CVs] ADD  DEFAULT (getdate()) FOR [UploadDate]
GO
ALTER TABLE [dbo].[CVs] ADD  DEFAULT (getdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[Feedback] ADD  CONSTRAINT [DF__Feedback__Create__47DBAE45]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Feedback] ADD  CONSTRAINT [DF__Feedback__Status__48CFD27E]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Job_Posting_Category] ADD  CONSTRAINT [DF_Job_Posting_Category_status]  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Role] FOREIGN KEY([roleId])
REFERENCES [dbo].[Role] ([id])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_Role]
GO
ALTER TABLE [dbo].[Applications]  WITH CHECK ADD  CONSTRAINT [FK_Applications_CVs] FOREIGN KEY([CVID])
REFERENCES [dbo].[CVs] ([CVID])
GO
ALTER TABLE [dbo].[Applications] CHECK CONSTRAINT [FK_Applications_CVs]
GO
ALTER TABLE [dbo].[Applications]  WITH CHECK ADD  CONSTRAINT [FK_Applications_JobPostings] FOREIGN KEY([JobPostingID])
REFERENCES [dbo].[JobPostings] ([JobPostingID])
GO
ALTER TABLE [dbo].[Applications] CHECK CONSTRAINT [FK_Applications_JobPostings]
GO
ALTER TABLE [dbo].[Applications]  WITH CHECK ADD  CONSTRAINT [FK_Applications_JobSeekers] FOREIGN KEY([JobSeekerID])
REFERENCES [dbo].[JobSeekers] ([JobSeekerID])
GO
ALTER TABLE [dbo].[Applications] CHECK CONSTRAINT [FK_Applications_JobSeekers]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_Account] FOREIGN KEY([accountId])
REFERENCES [dbo].[Account] ([id])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_Account]
GO
ALTER TABLE [dbo].[CVs]  WITH CHECK ADD  CONSTRAINT [FK_CVs_JobSeekers] FOREIGN KEY([JobSeekerID])
REFERENCES [dbo].[JobSeekers] ([JobSeekerID])
GO
ALTER TABLE [dbo].[CVs] CHECK CONSTRAINT [FK_CVs_JobSeekers]
GO
ALTER TABLE [dbo].[Education]  WITH CHECK ADD  CONSTRAINT [FK_Education_JobSeekers] FOREIGN KEY([JobSeekerID])
REFERENCES [dbo].[JobSeekers] ([JobSeekerID])
GO
ALTER TABLE [dbo].[Education] CHECK CONSTRAINT [FK_Education_JobSeekers]
GO
ALTER TABLE [dbo].[FavourJobPosting]  WITH CHECK ADD  CONSTRAINT [FK_FavourJobPosting_JobPostings] FOREIGN KEY([JobPostingID])
REFERENCES [dbo].[JobPostings] ([JobPostingID])
GO
ALTER TABLE [dbo].[FavourJobPosting] CHECK CONSTRAINT [FK_FavourJobPosting_JobPostings]
GO
ALTER TABLE [dbo].[FavourJobPosting]  WITH CHECK ADD  CONSTRAINT [FK_FavourJobPosting_JobSeekers] FOREIGN KEY([JobSeekerID])
REFERENCES [dbo].[JobSeekers] ([JobSeekerID])
GO
ALTER TABLE [dbo].[FavourJobPosting] CHECK CONSTRAINT [FK_FavourJobPosting_JobSeekers]
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD  CONSTRAINT [FK_Feedback_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([id])
GO
ALTER TABLE [dbo].[Feedback] CHECK CONSTRAINT [FK_Feedback_Account]
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD  CONSTRAINT [FK_Feedback_JobPostings] FOREIGN KEY([JobPostingID])
REFERENCES [dbo].[JobPostings] ([JobPostingID])
GO
ALTER TABLE [dbo].[Feedback] CHECK CONSTRAINT [FK_Feedback_JobPostings]
GO
ALTER TABLE [dbo].[JobPostings]  WITH CHECK ADD  CONSTRAINT [FK_JobPostings_Job_Posting_Category] FOREIGN KEY([Job_Posting_CategoryID])
REFERENCES [dbo].[Job_Posting_Category] ([id])
GO
ALTER TABLE [dbo].[JobPostings] CHECK CONSTRAINT [FK_JobPostings_Job_Posting_Category]
GO
ALTER TABLE [dbo].[JobSeekers]  WITH CHECK ADD  CONSTRAINT [FK_JobSeekers_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([id])
GO
ALTER TABLE [dbo].[JobSeekers] CHECK CONSTRAINT [FK_JobSeekers_Account]
GO
ALTER TABLE [dbo].[Recruiters]  WITH CHECK ADD  CONSTRAINT [FK_Recruiters_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([id])
GO
ALTER TABLE [dbo].[Recruiters] CHECK CONSTRAINT [FK_Recruiters_Account]
GO
ALTER TABLE [dbo].[Recruiters]  WITH CHECK ADD  CONSTRAINT [FK_Recruiters_Companies] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[Company] ([id])
GO
ALTER TABLE [dbo].[Recruiters] CHECK CONSTRAINT [FK_Recruiters_Companies]
GO
ALTER TABLE [dbo].[Work_Experience]  WITH CHECK ADD  CONSTRAINT [FK_Work_Experience_JobSeekers] FOREIGN KEY([JobSeekerID])
REFERENCES [dbo].[JobSeekers] ([JobSeekerID])
GO
ALTER TABLE [dbo].[Work_Experience] CHECK CONSTRAINT [FK_Work_Experience_JobSeekers]
GO
ALTER TABLE [dbo].[Applications]  WITH CHECK ADD  CONSTRAINT [CK_Applications] CHECK  (([Status]=(3) OR [Status]=(2) OR [Status]=(1) OR [Status]=(0)))
GO
ALTER TABLE [dbo].[Applications] CHECK CONSTRAINT [CK_Applications]
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD  CONSTRAINT [CHK_Feedback_Status] CHECK  (([Status]=(4) OR [Status]=(3) OR [Status]=(2) OR [Status]=(1)))
GO
ALTER TABLE [dbo].[Feedback] CHECK CONSTRAINT [CHK_Feedback_Status]
GO
ALTER TABLE [dbo].[JobPostings]  WITH CHECK ADD  CONSTRAINT [CK_JobPostings_Status] CHECK  (([Status]='Violate' OR [Status]='Closed' OR [Status]='Open'))
GO
ALTER TABLE [dbo].[JobPostings] CHECK CONSTRAINT [CK_JobPostings_Status]
GO
USE [master]
GO
ALTER DATABASE [WorkConnectDB] SET  READ_WRITE 
GO
