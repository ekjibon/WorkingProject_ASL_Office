USE [ASL_Office_DB_test]
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_Branchs]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_Branchs](
	[BranchId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Code] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.ACC_Branchs] PRIMARY KEY CLUSTERED 
(
	[BranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_CostCategory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_CostCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CostCategoryName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.ACC_CostCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_CostCenter]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_CostCenter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CostCategoryId] [int] NOT NULL,
	[CostCenterName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.ACC_CostCenter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_CostCenterDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_CostCenterDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TransactionId] [int] NULL,
	[LedgerId] [int] NULL,
	[CostCenterId] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.ACC_CostCenterDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_FiscalYear]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_FiscalYear](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.ACC_FiscalYear] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_Ledgers]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_Ledgers](
	[LedgerId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](1000) NULL,
	[Code] [nvarchar](500) NULL,
	[OpenningBalance] [decimal](18, 2) NOT NULL,
	[OpenningBalanceDc] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[RootGroupId] [int] NOT NULL,
	[CurrentBalance] [decimal](18, 2) NOT NULL,
	[CurrentBalanceDc] [int] NOT NULL,
	[IsEdit] [bit] NOT NULL,
	[IsLedger] [bit] NOT NULL,
	[IsGroup] [bit] NOT NULL,
	[ParentId] [int] NOT NULL,
	[IsDisplay] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CashFlowType] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.ACC_Ledgers] PRIMARY KEY CLUSTERED 
(
	[LedgerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_Logs]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_Logs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TransactionDetailId] [int] NOT NULL,
	[LedgerId] [int] NOT NULL,
	[DrAmount] [decimal](18, 2) NOT NULL,
	[CrAmount] [decimal](18, 2) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.ACC_Logs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_RootGroup]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_RootGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Prefix] [nvarchar](max) NULL,
	[Surfix] [nvarchar](max) NULL,
	[Seperator] [nvarchar](max) NULL,
	[Order] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[Position] [nvarchar](max) NULL,
	[Length] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ACC_RootGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_Settings]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_Settings](
	[SettingId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[FiscalYearStart] [datetime] NOT NULL,
	[FiscalYearEnd] [datetime] NOT NULL,
	[DecimalPlaces] [int] NOT NULL,
	[DateFormat] [nvarchar](max) NULL,
	[TimeZone] [nvarchar](max) NULL,
	[ManageInventory] [bit] NOT NULL,
	[AccountLocked] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.ACC_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_Tags]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_Tags](
	[TagId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Color] [nvarchar](max) NULL,
	[Background] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.ACC_Tags] PRIMARY KEY CLUSTERED 
(
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_Transaction]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_Transaction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[DrTotal] [decimal](18, 2) NOT NULL,
	[CrTotal] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[FiscalYearId] [int] NOT NULL,
	[AccBranchId] [int] NOT NULL,
	[TransNo] [nvarchar](12) NOT NULL,
	[TransType] [int] NOT NULL,
	[PayMode] [int] NOT NULL,
	[ApproveDate] [datetime] NOT NULL,
	[ApproveBy] [nvarchar](max) NULL,
	[IsApproved] [bit] NOT NULL,
	[PayTo] [nvarchar](max) NULL,
	[RecivedBy] [nvarchar](max) NULL,
	[ChequeNo] [nvarchar](max) NULL,
	[ChequeDate] [datetime] NULL,
	[Description] [nvarchar](max) NULL,
	[IsReject] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.ACC_Transaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACC_TransactionDetail]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_TransactionDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TransactionId] [int] NOT NULL,
	[LedgerId] [int] NOT NULL,
	[DrAmount] [decimal](18, 2) NOT NULL,
	[CrAmount] [decimal](18, 2) NOT NULL,
	[CurrentAmount] [decimal](18, 2) NOT NULL,
	[OpeningAmount] [decimal](18, 2) NOT NULL,
	[DC] [int] NULL,
 CONSTRAINT [PK_dbo.ACC_TransactionDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Acc_UserAccBranch]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Acc_UserAccBranch](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NOT NULL,
	[AccBranchId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Acc_UserAccBranch] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetApis]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetApis](
	[ApiId] [int] IDENTITY(1,1) NOT NULL,
	[Controller] [nvarchar](max) NULL,
	[Action] [nvarchar](max) NULL,
	[Route] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetApis] PRIMARY KEY CLUSTERED 
(
	[ApiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetPageApis]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetPageApis](
	[PageApiId] [int] IDENTITY(1,1) NOT NULL,
	[ApiId] [int] NOT NULL,
	[PageId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetPageApis] PRIMARY KEY CLUSTERED 
(
	[PageApiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetPages]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetPages](
	[PageID] [int] NOT NULL,
	[ParentID] [int] NOT NULL,
	[NameOption_En] [nvarchar](max) NULL,
	[NameOption_Bn] [nvarchar](max) NULL,
	[Controller] [nvarchar](max) NULL,
	[Action] [nvarchar](max) NULL,
	[Area] [nvarchar](max) NULL,
	[IconClass] [nvarchar](max) NULL,
	[ActiveLi] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[Displayorder] [int] NOT NULL,
	[IsParent] [bit] NULL,
	[IsModule] [bit] NOT NULL,
	[ModuleId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetPages] PRIMARY KEY CLUSTERED 
(
	[PageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetPagesRoles]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetPagesRoles](
	[PageRoleId] [int] IDENTITY(1,1) NOT NULL,
	[PageId] [int] NOT NULL,
	[RoleId] [nvarchar](128) NULL,
	[CanAdd] [bit] NOT NULL,
	[CanEdit] [bit] NOT NULL,
	[CanView] [bit] NOT NULL,
	[CanDelete] [bit] NOT NULL,
	[CanApprove] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetPagesRoles] PRIMARY KEY CLUSTERED 
(
	[PageRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetPortalUsers]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetPortalUsers](
	[Id] [nvarchar](128) NOT NULL,
	[StudentId] [int] NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetPortalUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserAspNetRoles]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserAspNetRoles](
	[AspNetUser_Id] [nvarchar](128) NOT NULL,
	[AspNetRole_Id] [nvarchar](128) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[Image] [varbinary](max) NULL,
	[Address] [nvarchar](max) NULL,
	[EmpId] [int] NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[AccountBranchId] [int] NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Att_AbscondingDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Att_AbscondingDetails](
	[AbscondingId] [bigint] IDENTITY(1,1) NOT NULL,
	[AttenId] [bigint] NOT NULL,
	[PeriodId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Att_AbscondingDetails] PRIMARY KEY CLUSTERED 
(
	[AbscondingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Att_EmpAcademicCalendar]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Att_EmpAcademicCalendar](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[EmpCategory] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Att_EmpAcademicCalendar] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Att_EmpAcademicCalendarDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Att_EmpAcademicCalendarDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CalendarId] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[CalendarDate] [datetime] NOT NULL,
	[DayType] [nvarchar](20) NULL,
	[HolidayName] [nvarchar](300) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Att_EmpAcademicCalendarDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Att_EmpRoster]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Att_EmpRoster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NULL,
	[EmpCategory] [int] NULL,
	[BranchId] [int] NULL,
	[CalendarDate] [datetime] NOT NULL,
	[InTime] [time](7) NOT NULL,
	[OutTime] [time](7) NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[TempInTime] [time](7) NULL,
	[TempOutTime] [time](7) NULL,
	[IsTempApproved] [bit] NOT NULL,
	[IsTemporary] [bit] NOT NULL,
	[IsRejected] [bit] NOT NULL,
	[IsTempRejected] [bit] NOT NULL,
	[DayType] [nvarchar](20) NULL,
	[Day] [nvarchar](max) NULL,
	[CalendarId] [int] NULL,
 CONSTRAINT [PK_dbo.Att_EmpRoster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Att_ExamAttendance]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Att_ExamAttendance](
	[ExamAttId] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentId] [bigint] NOT NULL,
	[ExamId] [int] NOT NULL,
	[IsGrand] [bit] NOT NULL,
	[PresentDay] [int] NOT NULL,
	[TotalWorkingDays] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Att_ExamAttendance] PRIMARY KEY CLUSTERED 
(
	[ExamAttId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Att_LeaveTypes]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Att_LeaveTypes](
	[LeaveId] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Att_LeaveTypes] PRIMARY KEY CLUSTERED 
(
	[LeaveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Common_AlertSetting]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Common_AlertSetting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AlertType] [nvarchar](max) NULL,
	[FromAddress] [nvarchar](max) NULL,
	[ToAddress] [nvarchar](max) NULL,
	[CCAddress] [nvarchar](max) NULL,
	[BCCAddress] [nvarchar](max) NULL,
	[Subject] [nvarchar](max) NULL,
	[DestinationMobileNo] [nvarchar](max) NULL,
	[Body] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Common_AlertSetting] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Common_District]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Common_District](
	[DistrictId] [int] IDENTITY(1,1) NOT NULL,
	[DistrictName] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_dbo.Common_District] PRIMARY KEY CLUSTERED 
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Common_DropDownConfig]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Common_DropDownConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[Type] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Common_DropDownConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Common_PoliceStation]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Common_PoliceStation](
	[PsId] [int] IDENTITY(1,1) NOT NULL,
	[DistrictId] [int] NOT NULL,
	[PsName] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_dbo.Common_PoliceStation] PRIMARY KEY CLUSTERED 
(
	[PsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_Client]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Client](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[ShortName] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[BaseUrl] [nvarchar](max) NULL,
	[Apps] [nvarchar](max) NULL,
	[WebPortal] [nvarchar](max) NULL,
	[SMS] [nvarchar](max) NULL,
	[Subscription] [nvarchar](max) NULL,
	[ActivityStatus] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[HasAppsService] [bit] NOT NULL,
	[HasWebPortal] [bit] NOT NULL,
	[HasSMS] [bit] NOT NULL,
	[DefaultDbId] [int] NULL,
	[ClientId] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.CRM_Client] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_Clients_db]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Clients_db](
	[ClientsDbId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[Host] [nvarchar](30) NOT NULL,
	[DbName] [nvarchar](max) NULL,
	[DbUserName] [nvarchar](max) NULL,
	[DbPass] [nvarchar](max) NULL,
	[Type] [nvarchar](5) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.CRM_Clients_db] PRIMARY KEY CLUSTERED 
(
	[ClientsDbId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_Meeting]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_Meeting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Topics] [nvarchar](max) NOT NULL,
	[ClientId] [int] NULL,
	[MeetingDate] [datetime] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[Location] [nvarchar](max) NOT NULL,
	[MeetingPersonName] [nvarchar](max) NULL,
	[MeetingPersonMobileNo] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.CRM_Meeting] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CRM_MeetingPersons]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRM_MeetingPersons](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MeetingId] [int] NOT NULL,
	[UserId] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.CRM_MeetingPersons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Attendance]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Attendance](
	[AttendId] [bigint] IDENTITY(1,1) NOT NULL,
	[EmpId] [bigint] NOT NULL,
	[InTime] [datetime] NOT NULL,
	[OutTime] [datetime] NULL,
	[IsPresent] [bit] NOT NULL,
	[IsLeave] [bit] NOT NULL,
	[LeaveId] [int] NULL,
	[IsLate] [bit] NULL,
	[LateTime] [int] NULL,
	[IsEarlyOut] [bit] NULL,
	[EarlyOutTime] [int] NULL,
	[Device_SerialNo] [nvarchar](25) NULL,
	[Device_UserID] [nvarchar](25) NULL,
	[Device_CardNo] [nvarchar](25) NULL,
	[EntryType] [nvarchar](2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[UpdatedStatus] [nvarchar](max) NULL,
	[IsPriApproved] [bit] NOT NULL,
	[IsFinalApproved] [bit] NOT NULL,
	[IsChangedStatus] [bit] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[IsRejected] [bit] NOT NULL,
	[IsWithPay] [bit] NULL,
	[IsWithOutPay] [bit] NULL,
	[IsHalfDay] [bit] NULL,
	[IsAbsetLongHoliday] [bit] NULL,
	[IsDutyOff] [bit] NULL,
	[IsECAabsent] [bit] NULL,
	[IsEarlyOut5Years] [bit] NULL,
	[IsPresentInHoliday] [bit] NULL,
	[IsPriReject] [bit] NULL,
 CONSTRAINT [PK_dbo.Emp_Attendance] PRIMARY KEY CLUSTERED 
(
	[AttendId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_BasicInfo]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_BasicInfo](
	[EmpBasicInfoID] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [nvarchar](max) NULL,
	[FullName] [nvarchar](max) NULL,
	[DesignationID] [int] NOT NULL,
	[IsClassTeacher] [bit] NOT NULL,
	[TypeID] [int] NOT NULL,
	[SectionID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[ShiftID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[JoiningDate] [datetime] NULL,
	[StatusID] [int] NOT NULL,
	[Image] [varbinary](max) NULL,
	[FatherName] [nvarchar](max) NULL,
	[MotherName] [nvarchar](max) NULL,
	[Nationality] [nvarchar](max) NULL,
	[Religion] [nvarchar](max) NULL,
	[BloodGroup] [nvarchar](max) NULL,
	[NationalID] [nvarchar](max) NULL,
	[DateOfBirth] [datetime] NULL,
	[Contact] [nvarchar](max) NULL,
	[PresentAddress] [nvarchar](max) NULL,
	[PresentPost] [nvarchar](max) NULL,
	[PresentThana] [nvarchar](max) NULL,
	[PresentDistrict] [nvarchar](max) NULL,
	[PermanentAddress] [nvarchar](max) NULL,
	[PermanentPost] [nvarchar](max) NULL,
	[PermanentThana] [nvarchar](max) NULL,
	[PermanentDistrict] [nvarchar](max) NULL,
	[InstituteAccount] [nvarchar](max) NULL,
	[IsGovtSalaryActive] [bit] NOT NULL,
	[GovtSalaryGrade] [int] NOT NULL,
	[GovtAccount] [nvarchar](max) NULL,
	[Gender] [nvarchar](max) NULL,
	[MaritalStatus] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[SMSNotificationNo] [nvarchar](max) NULL,
	[DeviceUserID] [nvarchar](max) NULL,
	[CardNo] [nvarchar](max) NULL,
	[IsPermanent] [bit] NOT NULL,
	[ProbationPeriodEndDate] [datetime] NULL,
	[ConfirmationDate] [datetime] NULL,
	[Accountname] [nvarchar](max) NULL,
	[AccountType] [nvarchar](max) NULL,
	[BankName] [nvarchar](max) NULL,
	[BranchName] [nvarchar](max) NULL,
	[MPOIndexNo] [nvarchar](max) NULL,
	[PassportNo] [nvarchar](max) NULL,
	[EmergencyContactName] [nvarchar](max) NULL,
	[EmergencyContactRelation] [nvarchar](max) NULL,
	[EmergencyContactAddress] [nvarchar](max) NULL,
	[EmergencyTandTNo] [nvarchar](max) NULL,
	[ContactOfficeEmail] [nvarchar](max) NULL,
	[ContactOtherEmail] [nvarchar](max) NULL,
	[ContactHomeNo] [nvarchar](max) NULL,
	[ContactOfficeNo] [nvarchar](max) NULL,
	[DPSAcccountNo] [nvarchar](max) NULL,
	[eTIN] [nvarchar](max) NULL,
	[InstituteGrade] [nvarchar](max) NULL,
	[PFAccountNo] [nvarchar](max) NULL,
	[ReportingPersonID] [int] NOT NULL,
	[ReportOrderNo] [int] NOT NULL,
	[SalaryGradeID] [int] NOT NULL,
	[ShortName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[SalaryACNo] [nvarchar](max) NULL,
	[EmergencyContactNo] [nvarchar](max) NULL,
	[RetirementDate] [datetime] NULL,
	[BirthRegNo] [nvarchar](max) NULL,
	[DrivingLicenseNo] [nvarchar](max) NULL,
	[OfficePhoneNo] [nvarchar](max) NULL,
	[HomePhoneNo] [nvarchar](max) NULL,
	[TINNo] [nvarchar](max) NULL,
	[LeaveTypeId] [int] NULL,
	[DisOrder] [int] NOT NULL,
	[SpouseName] [nvarchar](max) NULL,
	[SpouseMobile] [nvarchar](max) NULL,
	[Child] [nvarchar](max) NULL,
	[BirthCertificate] [nvarchar](max) NULL,
	[DrawbackMedicine] [nvarchar](max) NULL,
	[PPExpireDate] [datetime] NULL,
	[JoiningSalary] [nvarchar](max) NULL,
	[ConfirmationSalary] [nvarchar](max) NULL,
	[CurrentSalary] [nvarchar](max) NULL,
	[PFACNo] [nvarchar](max) NULL,
	[PFBankName] [nvarchar](max) NULL,
	[PFBankBranch] [nvarchar](max) NULL,
	[WelfareACNo] [nvarchar](max) NULL,
	[MembershipNo] [nvarchar](max) NULL,
	[IsResignationApplied] [bit] NULL,
	[ServeDate] [datetime] NULL,
	[SalaryPaymentMode] [nvarchar](max) NULL,
	[TeamId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Emp_BasicInfo] PRIMARY KEY CLUSTERED 
(
	[EmpBasicInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Category]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](max) NULL,
	[CategoryIsTeacher] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_ClassTeacher]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_ClassTeacher](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [int] NOT NULL,
	[BranchId] [int] NOT NULL,
	[ShiftId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[SectionId] [int] NOT NULL,
	[TeacherId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_ClassTeacher] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Department]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[DisOrder] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Emp_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Designation]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Designation](
	[DesignationID] [int] IDENTITY(1,1) NOT NULL,
	[DesignationName] [nvarchar](max) NULL,
	[CategoryID] [nvarchar](max) NULL,
	[DesignationOrder] [int] NOT NULL,
	[CategoryName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Designation] PRIMARY KEY CLUSTERED 
(
	[DesignationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_DocumentArchive]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_DocumentArchive](
	[EmpDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [int] NOT NULL,
	[DocumentName] [nvarchar](max) NULL,
	[File] [varbinary](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_DocumentArchive] PRIMARY KEY CLUSTERED 
(
	[EmpDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_EducationalInfo]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_EducationalInfo](
	[EducationalInfo_ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[ExamBoard] [nvarchar](50) NOT NULL,
	[ExamInstituteName] [nvarchar](50) NOT NULL,
	[ExamPasYear] [int] NOT NULL,
	[ExamTotal] [nvarchar](50) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[ExamGroupName] [nvarchar](max) NULL,
	[ExamName] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Emp_EducationalInfo] PRIMARY KEY CLUSTERED 
(
	[EducationalInfo_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_ExamBoard]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_ExamBoard](
	[EmployeeExamBoard_ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeExamBoard_Name] [nvarchar](100) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_ExamBoard] PRIMARY KEY CLUSTERED 
(
	[EmployeeExamBoard_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_ExamName]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_ExamName](
	[EmployeeExam_ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeExam_Name] [nvarchar](100) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_ExamName] PRIMARY KEY CLUSTERED 
(
	[EmployeeExam_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Image]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Image](
	[ImageId] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [bigint] NOT NULL,
	[Photo] [varbinary](max) NULL,
	[ImageName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Image] PRIMARY KEY CLUSTERED 
(
	[ImageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_JobHistory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_JobHistory](
	[EmpJobId] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[Companyname] [nvarchar](max) NULL,
	[Designation] [nvarchar](max) NULL,
	[AreaOfExperiance] [nvarchar](max) NULL,
	[From] [nvarchar](max) NULL,
	[To] [nvarchar](max) NULL,
	[YearOfExperiance] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_JobHistory] PRIMARY KEY CLUSTERED 
(
	[EmpJobId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_LeaveType]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_LeaveType](
	[EmpLeaveTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_LeaveType] PRIMARY KEY CLUSTERED 
(
	[EmpLeaveTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_LIEO]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_LIEO](
	[LIEOId] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[LateInTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[EarlyOutTime] [time](7) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[EmpId] [int] NULL,
 CONSTRAINT [PK_dbo.Emp_LIEO] PRIMARY KEY CLUSTERED 
(
	[LIEOId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_MeetingConfig]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_MeetingConfig](
	[ConfigId] [int] IDENTITY(1,1) NOT NULL,
	[EmpCategoryId] [nvarchar](max) NOT NULL,
	[FirstEmpId] [int] NOT NULL,
	[SecondEmpId] [int] NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[BranchId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[DayId] [int] NULL,
 CONSTRAINT [PK_dbo.Emp_MeetingConfig] PRIMARY KEY CLUSTERED 
(
	[ConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Nominee]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Nominee](
	[EmpNomineeID] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [int] NOT NULL,
	[NomineeName] [nvarchar](150) NULL,
	[DOB] [datetime] NULL,
	[FathersName] [nvarchar](150) NULL,
	[MothersName] [nvarchar](150) NULL,
	[SpouseName] [nvarchar](50) NULL,
	[PresentAddress] [nvarchar](250) NULL,
	[PermanentAddress] [nvarchar](150) NULL,
	[Relation] [nvarchar](50) NULL,
	[NationalID] [nvarchar](50) NULL,
	[BirthRegNo] [nvarchar](50) NULL,
	[Picture] [image] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Nominee] PRIMARY KEY CLUSTERED 
(
	[EmpNomineeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Request]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Request](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[RequestType] [int] NOT NULL,
	[CategoryId] [int] NULL,
	[DesignationId] [int] NULL,
	[Date] [datetime] NULL,
	[Reason] [nvarchar](max) NULL,
	[Time] [datetime] NULL,
	[Description] [nvarchar](max) NULL,
	[MeetingIssue] [nvarchar](max) NULL,
	[NOCType] [int] NOT NULL,
	[TravelDesination] [nvarchar](max) NULL,
	[TravelTo] [datetime] NULL,
	[TravelFrom] [datetime] NULL,
	[LeaveDate] [datetime] NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[Duration] [int] NULL,
	[RequestOn] [datetime] NULL,
	[File] [varbinary](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[LeaveCategoryId] [int] NULL,
	[AdjustableDay] [int] NULL,
	[UnadjustedDay] [int] NULL,
	[Withpay] [int] NULL,
	[WithOutpay] [int] NULL,
	[MaternityLeaveType] [int] NULL,
	[LeaveTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.Emp_Request] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Section]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Section](
	[SectionID] [int] IDENTITY(1,1) NOT NULL,
	[SectionName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Section] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Shift]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Shift](
	[ShiftID] [int] IDENTITY(1,1) NOT NULL,
	[ShiftBranchID] [int] NOT NULL,
	[ShiftName] [nvarchar](max) NULL,
	[ShiftInTime] [nvarchar](max) NULL,
	[ShiftOutTime] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Shift] PRIMARY KEY CLUSTERED 
(
	[ShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Status]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Status](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Subject]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Subject](
	[SubjectID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Subject] PRIMARY KEY CLUSTERED 
(
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Emp_Training]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Emp_Training](
	[EmpTrainingID] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[TopicsCovered] [nvarchar](50) NOT NULL,
	[InstituteName] [nvarchar](50) NOT NULL,
	[TrainingCountry] [nvarchar](50) NOT NULL,
	[TrainingLocation] [nvarchar](50) NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[EmpTraining_IsContinued] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Emp_Training] PRIMARY KEY CLUSTERED 
(
	[EmpTrainingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_Asset]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Asset](
	[AssetId] [int] IDENTITY(1,1) NOT NULL,
	[AssetName] [nvarchar](max) NULL,
	[AssetCode] [nvarchar](max) NULL,
	[AssetSubCatId] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[AssetTypeId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[SellingPrice] [decimal](18, 2) NOT NULL,
	[AccCode] [nvarchar](max) NULL,
	[DeprcAmount] [int] NOT NULL,
	[IsPercentage] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.FA_Asset] PRIMARY KEY CLUSTERED 
(
	[AssetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetCategory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetCategory](
	[AssetCateId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](max) NULL,
	[CategoryCode] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.FA_AssetCategory] PRIMARY KEY CLUSTERED 
(
	[AssetCateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetDetails](
	[DetailId] [int] IDENTITY(1,1) NOT NULL,
	[AssetIId] [int] NOT NULL,
	[AssetID] [nvarchar](max) NULL,
	[Building] [nvarchar](max) NULL,
	[Room] [nvarchar](max) NULL,
	[Location] [nvarchar](max) NULL,
	[AssetLifeTime] [nvarchar](max) NULL,
	[Quantity] [int] NOT NULL,
	[SerialNo] [int] NOT NULL,
	[DisposedBy] [nvarchar](max) NULL,
	[IsDispose] [bit] NOT NULL,
	[IsExisting] [bit] NOT NULL,
	[DisposComment] [nvarchar](max) NULL,
	[warrentyPeriod] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[PurchseValue] [decimal](18, 2) NOT NULL,
	[CurrentValue] [decimal](18, 2) NOT NULL,
	[Brand] [nvarchar](max) NULL,
	[BranchID] [nvarchar](max) NULL,
	[SalvageValue] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_dbo.FA_AssetDetails] PRIMARY KEY CLUSTERED 
(
	[DetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetPurchaseOrder]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetPurchaseOrder](
	[POId] [int] IDENTITY(1,1) NOT NULL,
	[POCode] [nvarchar](max) NULL,
	[SupplierId] [int] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[TotalPrice] [decimal](18, 2) NOT NULL,
	[IsReceived] [bit] NOT NULL,
	[ReceivedBy] [nvarchar](max) NULL,
	[ReceiverComments] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.FA_AssetPurchaseOrder] PRIMARY KEY CLUSTERED 
(
	[POId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetPurchaseOrderDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetPurchaseOrderDetails](
	[PODetailsId] [int] IDENTITY(1,1) NOT NULL,
	[POId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TotalPrice] [decimal](18, 2) NOT NULL,
	[Building] [nvarchar](max) NULL,
	[Room] [nvarchar](max) NULL,
	[Location] [nvarchar](max) NULL,
	[AssetLifeTime] [nvarchar](max) NULL,
	[Discount] [decimal](18, 2) NOT NULL,
	[ReceiveQuantity] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_dbo.FA_AssetPurchaseOrderDetails] PRIMARY KEY CLUSTERED 
(
	[PODetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetQuotation]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetQuotation](
	[QuotationId] [int] IDENTITY(1,1) NOT NULL,
	[QuotationCode] [nvarchar](max) NULL,
	[SupplierId] [int] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.FA_AssetQuotation] PRIMARY KEY CLUSTERED 
(
	[QuotationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetQuotationDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetQuotationDetails](
	[QuotationDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[QuotationId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[Discount] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.FA_AssetQuotationDetails] PRIMARY KEY CLUSTERED 
(
	[QuotationDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetRequisition]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetRequisition](
	[AssetRequisitionId] [int] IDENTITY(1,1) NOT NULL,
	[ReqCode] [nvarchar](max) NULL,
	[DueDate] [datetime] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[IsApproved] [bit] NOT NULL,
	[ApprovedBy] [nvarchar](max) NULL,
	[ApprovedComments] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.FA_AssetRequisition] PRIMARY KEY CLUSTERED 
(
	[AssetRequisitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetRequisitionDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetRequisitionDetails](
	[ReqDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[ReqId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_dbo.FA_AssetRequisitionDetails] PRIMARY KEY CLUSTERED 
(
	[ReqDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetSubCategory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetSubCategory](
	[AssetSubCatId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[SubCategoryName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.FA_AssetSubCategory] PRIMARY KEY CLUSTERED 
(
	[AssetSubCatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FA_AssetUnitSetup]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_AssetUnitSetup](
	[UnitSetupId] [int] IDENTITY(1,1) NOT NULL,
	[UnitName] [nvarchar](max) NULL,
	[UnitCode] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.FA_AssetUnitSetup] PRIMARY KEY CLUSTERED 
(
	[UnitSetupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fees_FeesMonth]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fees_FeesMonth](
	[FeesMonthId] [int] IDENTITY(1,1) NOT NULL,
	[MonthName] [nvarchar](max) NOT NULL,
	[Code] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Fees_FeesMonth] PRIMARY KEY CLUSTERED 
(
	[FeesMonthId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fees_OnlineTrans]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fees_OnlineTrans](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TillMonth] [int] NOT NULL,
	[TillYear] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[InvoiceNumber] [nvarchar](max) NULL,
	[HeadDetails] [nvarchar](max) NULL,
	[PayMode] [nvarchar](max) NULL,
	[ChaqueNumber] [nvarchar](max) NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[bKashCharge] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Fees_OnlineTrans] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fees_pay2feeTransection]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fees_pay2feeTransection](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TillMonth] [int] NOT NULL,
	[TillYear] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[InvoiceNumber] [nvarchar](max) NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Fees_pay2feeTransection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_AdvanceSalary]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_AdvanceSalary](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[SalaryPeriodId] [int] NULL,
	[SanctionDate] [datetime] NOT NULL,
	[HeadId] [int] NULL,
	[NoOfInstallment] [int] NULL,
	[AdvanceAmount] [decimal](18, 2) NULL,
	[InstallmentAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[MonthName] [nvarchar](max) NULL,
	[InvoiceNumber] [int] NULL,
 CONSTRAINT [PK_dbo.HR_AdvanceSalary] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_AdvanceSalaryPayment]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_AdvanceSalaryPayment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[SalaryPeriodId] [int] NULL,
	[AdvanceSalaryId] [int] NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_AdvanceSalaryPayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_EmpLeaveQuota]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_EmpLeaveQuota](
	[EmpLeaveQuotaId] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[BranchId] [int] NOT NULL,
	[EmpCategory] [int] NOT NULL,
	[AnnualLeaveDay] [int] NOT NULL,
	[SickLeaveDay] [int] NOT NULL,
	[AdvanceLeaveDay] [int] NOT NULL,
	[MaternityLeaveDay] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[CalenderId] [int] NULL,
 CONSTRAINT [PK_dbo.HR_EmpLeaveQuota] PRIMARY KEY CLUSTERED 
(
	[EmpLeaveQuotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_EmployeeSalary]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_EmployeeSalary](
	[EmployeeSalaryId] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[PeriodId] [int] NOT NULL,
	[HeadId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[DisburseDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_EmployeeSalary] PRIMARY KEY CLUSTERED 
(
	[EmployeeSalaryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_EmployeeTaxSetup]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_EmployeeTaxSetup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CurrentSalary] [nvarchar](max) NULL,
	[TaxAmount] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[EmpId] [int] NOT NULL,
	[TaxYearId] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.HR_EmployeeTaxSetup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_LeaveApplication]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_LeaveApplication](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[LeaveTypeId] [int] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[TotalDays] [int] NOT NULL,
	[TotalEffectDays] [int] NULL,
	[Reason] [nvarchar](max) NULL,
	[Attachment] [varbinary](max) NULL,
	[ApproveBy] [nvarchar](max) NULL,
	[ApproveDate] [datetime] NULL,
	[ApproveComments] [nvarchar](max) NULL,
	[RejectedBy] [nvarchar](max) NULL,
	[RejectedDate] [datetime] NULL,
	[RejectedComments] [nvarchar](max) NULL,
	[IsReApplied] [bit] NULL,
	[BalanceLeave] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_LeaveApplication] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_LeaveCategory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_LeaveCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_LeaveCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_LeaveQuota]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_LeaveQuota](
	[LeaveQuotaId] [int] IDENTITY(1,1) NOT NULL,
	[LeaveTypeId] [int] NOT NULL,
	[LeaveCatgoryId] [int] NOT NULL,
	[NoOfDay] [int] NOT NULL,
	[IsCarryForward] [bit] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_LeaveQuota] PRIMARY KEY CLUSTERED 
(
	[LeaveQuotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_Reward]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_Reward](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[RewardAmount] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_Reward] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryEmployee]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryEmployee](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SalaryPeriodId] [int] NOT NULL,
	[HeadId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[GradeId] [int] NOT NULL,
	[TaxYearId] [int] NULL,
	[Amount] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_SalaryEmployee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryGrade]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryGrade](
	[SalaryGradeId] [int] IDENTITY(1,1) NOT NULL,
	[BranchId] [int] NOT NULL,
	[Code] [nvarchar](20) NULL,
	[Name] [nvarchar](max) NULL,
	[MinSalary] [decimal](18, 2) NOT NULL,
	[MaxSalary] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_SalaryGrade] PRIMARY KEY CLUSTERED 
(
	[SalaryGradeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryHead]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryHead](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccHeadId] [int] NOT NULL,
	[HeadName] [nvarchar](max) NULL,
	[HeadCode] [nvarchar](max) NULL,
	[Category] [int] NOT NULL,
	[IsBasic] [bit] NULL,
	[DisplayOrder] [int] NULL,
	[IsAccLedger] [bit] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[IsEdit] [bit] NULL,
 CONSTRAINT [PK_dbo.HR_SalaryHead] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryHeadWiseConfig]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryHeadWiseConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HeadId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[IsPercentage] [bit] NULL,
	[MinAmount] [decimal](18, 2) NULL,
	[MaxAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.HR_SalaryHeadWiseConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryHold]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryHold](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[GrossSalary] [decimal](18, 2) NULL,
	[HoldPerMonthAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[SalaryPeriodId] [int] NULL,
	[HoldDate] [datetime] NULL,
	[HeadId] [int] NULL,
	[NoOfInstallment] [int] NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[MonthName] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.HR_SalaryHold] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryHoldPayment]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryHoldPayment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[SalaryPeriodId] [int] NULL,
	[SalaryHoldId] [int] NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[ToptalPaymentAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_SalaryHoldPayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryHoldRefund]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryHoldRefund](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NULL,
	[Installment] [int] NULL,
	[SalaryPeriodId] [int] NULL,
	[InstallmentAmount] [decimal](18, 2) NULL,
	[HoldedAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[SalaryYearId] [int] NULL,
 CONSTRAINT [PK_dbo.HR_SalaryHoldRefund] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryIncrement]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryIncrement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[Type] [nvarchar](max) NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[IsPercentage] [bit] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[SalaryYearId] [int] NULL,
	[GrossSalary] [decimal](18, 2) NULL,
	[AmountAfterIncrement] [decimal](18, 2) NULL,
	[IncrementPercentage] [decimal](18, 2) NULL,
 CONSTRAINT [PK_dbo.HR_SalaryIncrement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryPayDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryPayDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SalaryPeriodId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[NetAmount] [decimal](18, 2) NOT NULL,
	[BankAmount] [decimal](18, 2) NOT NULL,
	[CashAmount] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[CategoryID] [int] NOT NULL,
	[GrossAmount] [decimal](18, 2) NOT NULL,
	[IsConfirmed] [bit] NULL,
	[IsModified] [bit] NULL,
	[DesignationName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryPeriod]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryPeriod](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FiscalYearId] [int] NOT NULL,
	[PeriodName] [nvarchar](max) NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [nvarchar](max) NULL,
	[DaysWorking] [int] NULL,
	[ProcessDate] [datetime] NULL,
	[IsLock] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[CategoryID] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[SalaryYearId] [int] NULL,
	[SalaryTaxYearId] [int] NULL,
	[IsDeductTax] [bit] NULL,
	[IsLongHoliday] [bit] NULL,
	[PeriodStartDate] [datetime] NULL,
	[PeriodEndDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.HR_SalaryPeriod] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryStructure]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryStructure](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HeadId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[GradeId] [int] NULL,
	[TaxYearId] [int] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[CurrentSalary] [nvarchar](max) NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.HR_SalaryStructure] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryStructurePeriod]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryStructurePeriod](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PeriodId] [int] NOT NULL,
	[HeadId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[GradeId] [int] NULL,
	[TaxYearId] [int] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[ProccessDate] [datetime] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[IsModified] [bit] NULL,
 CONSTRAINT [PK_dbo.HR_SalaryStructurePeriod] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryStructurePeriodModifylog]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryStructurePeriodModifylog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[PeriodId] [int] NOT NULL,
	[HeadId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[GradeId] [int] NULL,
	[TaxYearId] [int] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[ProccessDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[PaydetailsId] [int] NOT NULL,
	[NetAmount] [decimal](18, 2) NOT NULL,
	[SalaryStructurePeriodId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.HR_SalaryStructurePeriodModifylog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryTaxYear]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryTaxYear](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[YearName] [nvarchar](max) NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_SalaryTaxYear] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HR_SalaryYear]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HR_SalaryYear](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[YearName] [nvarchar](max) NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.HR_SalaryYear] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_Branch]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_Branch](
	[BranchId] [int] IDENTITY(1,1) NOT NULL,
	[BranchName] [nvarchar](max) NOT NULL,
	[BranchNameBangla] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[AddressBangla] [nvarchar](max) NULL,
	[Branch_ContactNumber] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Fax] [nvarchar](max) NULL,
	[SS_Lang] [nvarchar](100) NULL,
	[SS_Latu] [nvarchar](100) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[DisOrder] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Ins_Branch] PRIMARY KEY CLUSTERED 
(
	[BranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_ECAClub]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_ECAClub](
	[ClubId] [int] IDENTITY(1,1) NOT NULL,
	[ClubName] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[CategoryName] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Ins_ECAClub] PRIMARY KEY CLUSTERED 
(
	[ClubId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_ECAClubConfig]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_ECAClubConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BranchId] [int] NOT NULL,
	[SessionId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[ShiftId] [int] NOT NULL,
	[ClubId] [int] NOT NULL,
	[TermId] [int] NOT NULL,
	[DayId] [int] NOT NULL,
	[SeatCapacity] [int] NOT NULL,
	[NoOfClass] [int] NOT NULL,
	[Deadline] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[CategoryName] [nvarchar](max) NULL,
	[FromTime] [datetime] NULL,
	[ToTime] [datetime] NULL,
 CONSTRAINT [PK_dbo.Ins_ECAClubConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_NoticeDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_NoticeDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[NoticeId] [int] NOT NULL,
	[TargetId] [int] NOT NULL,
	[TargetType] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Ins_NoticeDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_NoticeInfo]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_NoticeInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[PublishDate] [datetime] NOT NULL,
	[ColorCode] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Ins_NoticeInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_ReportHeader]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_ReportHeader](
	[ReportHeaderId] [int] IDENTITY(1,1) NOT NULL,
	[LegalLandscape] [image] NOT NULL,
	[LegalPortrait] [image] NULL,
	[A4Landscape] [image] NULL,
	[A4Portrait] [image] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Ins_ReportHeader] PRIMARY KEY CLUSTERED 
(
	[ReportHeaderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ins_Version]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ins_Version](
	[VersionId] [int] IDENTITY(1,1) NOT NULL,
	[VersionName] [nvarchar](max) NOT NULL,
	[VersionCode] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Ins_Version] PRIMARY KEY CLUSTERED 
(
	[VersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_AssetDisposal]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_AssetDisposal](
	[DisposalId] [int] IDENTITY(1,1) NOT NULL,
	[DisposalType] [nvarchar](max) NULL,
	[SellingPrice] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[AccountCode] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Inv_AssetDisposal] PRIMARY KEY CLUSTERED 
(
	[DisposalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_Customer]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_Customer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](max) NULL,
	[CustomerCode] [nvarchar](max) NULL,
	[BIN] [nvarchar](max) NULL,
	[CompanyName] [nvarchar](max) NULL,
	[ContactPersonName] [nvarchar](max) NULL,
	[ConatactPersonMobileNo] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[AccountCode] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_Distribution]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_Distribution](
	[DistributionId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Qty] [decimal](18, 2) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_Distribution] PRIMARY KEY CLUSTERED 
(
	[DistributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_Product]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_Product](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](max) NULL,
	[ProductCode] [nvarchar](max) NULL,
	[ProductSubCateId] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[ReOrderLevel] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[OpeningBalance] [decimal](10, 2) NOT NULL,
	[SellingPrice] [decimal](10, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[ProductTypeId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[AccCode] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Inv_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_ProductCategory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_ProductCategory](
	[ProductCateId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](max) NULL,
	[CategoryCode] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_ProductCategory] PRIMARY KEY CLUSTERED 
(
	[ProductCateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_ProductStocks]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_ProductStocks](
	[StockId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_ProductStocks] PRIMARY KEY CLUSTERED 
(
	[StockId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_ProductSubCategory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_ProductSubCategory](
	[ProductSubCatId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[SubCategoryName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_ProductSubCategory] PRIMARY KEY CLUSTERED 
(
	[ProductSubCatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_PurchaseOrder]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_PurchaseOrder](
	[POId] [int] IDENTITY(1,1) NOT NULL,
	[POCode] [nvarchar](max) NULL,
	[SupplierId] [int] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[TotalPrice] [decimal](18, 2) NOT NULL,
	[IsReceived] [bit] NOT NULL,
	[ReceivedBy] [nvarchar](max) NULL,
	[ReceiverComments] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_PurchaseOrder] PRIMARY KEY CLUSTERED 
(
	[POId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_PurchaseOrderDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_PurchaseOrderDetails](
	[PODetailsId] [int] IDENTITY(1,1) NOT NULL,
	[POId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TotalPrice] [decimal](18, 2) NOT NULL,
	[Discount] [decimal](18, 2) NOT NULL,
	[ReceiveQuantity] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_dbo.Inv_PurchaseOrderDetails] PRIMARY KEY CLUSTERED 
(
	[PODetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_Quotation]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_Quotation](
	[QuotationId] [int] IDENTITY(1,1) NOT NULL,
	[QuotationCode] [nvarchar](max) NULL,
	[SupplierId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[DueDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.Inv_Quotation] PRIMARY KEY CLUSTERED 
(
	[QuotationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_QuotationDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_QuotationDetails](
	[QuotationDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[QuotationId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[Discount] [decimal](10, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_QuotationDetails] PRIMARY KEY CLUSTERED 
(
	[QuotationDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_Requisition]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_Requisition](
	[RequisitionId] [int] IDENTITY(1,1) NOT NULL,
	[ReqCode] [nvarchar](max) NULL,
	[DueDate] [datetime] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[IsApproved] [bit] NOT NULL,
	[ApprovedBy] [nvarchar](max) NULL,
	[ApprovedComments] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_Requisition] PRIMARY KEY CLUSTERED 
(
	[RequisitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_RequisitionDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_RequisitionDetails](
	[ReqDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[ReqId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_dbo.Inv_RequisitionDetails] PRIMARY KEY CLUSTERED 
(
	[ReqDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_Sales]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_Sales](
	[SalesId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[Discount] [decimal](18, 2) NOT NULL,
	[Vat] [decimal](18, 2) NOT NULL,
	[NetPayable] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_Sales] PRIMARY KEY CLUSTERED 
(
	[SalesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_SalesDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_SalesDetails](
	[SalesDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[SalesId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[Discount] [decimal](18, 2) NOT NULL,
	[Vat] [decimal](18, 2) NOT NULL,
	[NetPayable] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_SalesDetails] PRIMARY KEY CLUSTERED 
(
	[SalesDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_ServiceSetup]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_ServiceSetup](
	[ServiceSetupId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [nvarchar](max) NULL,
	[ServiceCode] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_ServiceSetup] PRIMARY KEY CLUSTERED 
(
	[ServiceSetupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_StockTransaction]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_StockTransaction](
	[TransactionId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [decimal](10, 2) NOT NULL,
	[LastStockQty] [decimal](10, 2) NOT NULL,
	[TransType] [nvarchar](max) NULL,
	[TransCategory] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_StockTransaction] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_Supplier]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_Supplier](
	[SupplierId] [int] IDENTITY(1,1) NOT NULL,
	[SupplierName] [nvarchar](max) NULL,
	[SupplierCode] [nvarchar](max) NULL,
	[CompanyName] [nvarchar](max) NULL,
	[ContactPersonName] [nvarchar](max) NULL,
	[ConatactPersonMobileNo] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[AccountCode] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[BIN] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Inv_Supplier] PRIMARY KEY CLUSTERED 
(
	[SupplierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inv_UnitSetup]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inv_UnitSetup](
	[UnitSetupId] [int] IDENTITY(1,1) NOT NULL,
	[UnitName] [nvarchar](max) NULL,
	[UnitCode] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Inv_UnitSetup] PRIMARY KEY CLUSTERED 
(
	[UnitSetupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_BillingHead]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_BillingHead](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BillingHeadName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[BillingHeadType] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Invoice_BillingHead] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_BillingHeadConfig]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_BillingHeadConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[InvoiceServiceId] [int] NOT NULL,
	[BillingHeadId] [int] NOT NULL,
	[BillingHeadType] [nvarchar](max) NULL,
	[BillingMethodId] [int] NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[MinAmount] [decimal](18, 2) NOT NULL,
	[MaxAmount] [decimal](18, 2) NOT NULL,
	[MaskAmount] [decimal](18, 2) NOT NULL,
	[NoMaskAmount] [decimal](18, 2) NOT NULL,
	[Year] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[Quantity] [int] NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[ProcessAmount] [decimal](18, 2) NOT NULL,
	[TotalStudent] [int] NOT NULL,
	[TotalSMS] [int] NOT NULL,
	[TotalEmail] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Invoice_BillingHeadConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_BillingHeadConfigDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_BillingHeadConfigDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BillingHeadConfigId] [int] NULL,
	[Year] [int] NULL,
	[MonthId] [int] NULL,
	[MonthName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Invoice_BillingHeadConfigDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_BillingMethod]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_BillingMethod](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BillingMethodName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Invoice_BillingMethod] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_BillingProcess]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_BillingProcess](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NULL,
	[Year] [int] NULL,
	[MonthId] [int] NULL,
	[BillingHeadId] [int] NULL,
	[Quantity] [decimal](18, 2) NULL,
	[Rate] [decimal](18, 2) NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Invoice_BillingProcess] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_CollectionDetails]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_CollectionDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MasterID] [int] NOT NULL,
	[Year] [int] NULL,
	[MonthId] [int] NULL,
	[BillingHeadId] [int] NULL,
	[Quantity] [decimal](18, 2) NULL,
	[Rate] [decimal](18, 2) NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[DueAmount] [decimal](18, 2) NULL,
	[CollectionAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Invoice_CollectionDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_CollectionMaster]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_CollectionMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceNo] [nvarchar](max) NULL,
	[InvoiceAmount] [decimal](18, 2) NULL,
	[ClientId] [int] NULL,
	[Year] [int] NULL,
	[MonthId] [int] NULL,
	[CollectionDate] [datetime] NULL,
	[CollectionAmount] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[PaymentMethod] [nvarchar](max) NULL,
	[ChequeNo] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Invoice_CollectionMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_InvoiceGenerate]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_InvoiceGenerate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceNo] [nvarchar](max) NULL,
	[InvoiceAmount] [decimal](18, 2) NOT NULL,
	[ClientId] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[MonthId] [int] NOT NULL,
	[BillingHeadId] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[IssueDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[BillingPeriodStart] [datetime] NOT NULL,
	[BillingPeriodEnd] [datetime] NOT NULL,
	[InvoiceStatus] [nvarchar](max) NULL,
	[IsPaid] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[DueAmount] [decimal](18, 2) NULL,
	[CollectionAmount] [decimal](18, 2) NULL,
	[Status] [nvarchar](20) NULL,
 CONSTRAINT [PK_dbo.Invoice_InvoiceGenerate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_PhoneCallMaintain]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_PhoneCallMaintain](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[CallDate] [datetime] NOT NULL,
	[ProbablePaymentDate] [datetime] NOT NULL,
	[ContactNo] [nvarchar](max) NULL,
	[ContactPerson] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Invoice_PhoneCallMaintain] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice_Service]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Service](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Invoice_Service] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Logs]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Logs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](max) NULL,
	[MessageTemplate] [nvarchar](max) NULL,
	[Level] [nvarchar](max) NULL,
	[TimeStamp] [datetime] NULL,
	[Exception] [nvarchar](max) NULL,
	[UserName] [nvarchar](128) NULL,
 CONSTRAINT [PK_Logs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Portal_Document]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Portal_Document](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[TypeId] [int] NOT NULL,
	[Year] [int] NULL,
	[Month] [nvarchar](max) NULL,
	[SessionId] [int] NOT NULL,
	[ClassId] [int] NULL,
	[ShiftId] [int] NULL,
	[BranchId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[File] [varbinary](max) NULL,
	[FileName] [nvarchar](max) NULL,
	[DocType] [int] NOT NULL,
	[EmpId] [int] NULL,
 CONSTRAINT [PK_dbo.Portal_Document] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Res_Config]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Res_Config](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassId] [int] NOT NULL,
	[Tag] [varchar](50) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Res_Config] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SchoolSetups]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchoolSetups](
	[SchoolID] [int] IDENTITY(1,1) NOT NULL,
	[SchoolName] [nvarchar](150) NOT NULL,
	[SchoolNameBangla] [nvarchar](250) NULL,
	[WebURL] [nvarchar](150) NULL,
	[Email] [nvarchar](150) NULL,
	[Address] [nvarchar](500) NULL,
	[SchoolLogo] [image] NOT NULL,
	[AddressBangla] [nvarchar](250) NULL,
	[ContactNumber] [nvarchar](20) NULL,
	[Fax] [nvarchar](10) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[Email_1] [nvarchar](150) NULL,
 CONSTRAINT [PK_dbo.SchoolSetups] PRIMARY KEY CLUSTERED 
(
	[SchoolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMS_ScheduleSMSConfig]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_ScheduleSMSConfig](
	[ConfigId] [int] IDENTITY(1,1) NOT NULL,
	[RunTime] [nvarchar](max) NULL,
	[Body] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[CategoryId] [int] NOT NULL,
	[Recipent] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.SMS_ScheduleSMSConfig] PRIMARY KEY CLUSTERED 
(
	[ConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMS_Settings]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_Settings](
	[SettingsId] [int] IDENTITY(1,1) NOT NULL,
	[NoSMSPart] [int] NOT NULL,
	[AllowUnicode] [bit] NOT NULL,
	[ForStudent] [bit] NOT NULL,
	[ForEmployee] [bit] NOT NULL,
	[ClientId] [nvarchar](max) NULL,
	[Key] [nvarchar](max) NULL,
	[UserName] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[IsSMSNumber] [bit] NOT NULL,
	[IsFatherNumber] [bit] NOT NULL,
	[IsMotherNumber] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.SMS_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMS_SMSExtGroup]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_SMSExtGroup](
	[GroupId] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.SMS_SMSExtGroup] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMS_SMSExtNumbers]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_SMSExtNumbers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[ReceiveNumber] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.SMS_SMSExtNumbers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMS_SMSSendHistroy]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_SMSSendHistroy](
	[HistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentIId] [bigint] NULL,
	[EmpId] [int] NULL,
	[TemplateId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[SMSBody] [nvarchar](max) NULL,
	[SMSPart] [int] NOT NULL,
	[SMSLength] [int] NOT NULL,
	[SMSTypeId] [int] NOT NULL,
	[SendDateTime] [datetime] NOT NULL,
	[SendStatus] [int] NOT NULL,
	[JobId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[ReceiveNumber] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.SMS_SMSSendHistroy] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMS_SMSTemplate]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_SMSTemplate](
	[TemplateId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[TempType] [nvarchar](max) NULL,
	[CategoryId] [int] NOT NULL,
	[BodyType] [int] NOT NULL,
	[AddType] [nvarchar](max) NULL,
	[SMSBody] [nvarchar](max) NULL,
	[SMSPart] [int] NOT NULL,
	[SMSLen] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[isUnicode] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.SMS_SMSTemplate] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMS_SMSTempTag]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_SMSTempTag](
	[TagId] [int] IDENTITY(1,1) NOT NULL,
	[TagType] [nvarchar](max) NULL,
	[TagName] [nvarchar](max) NULL,
	[FieldsName] [nvarchar](max) NULL,
	[Count] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.SMS_SMSTempTag] PRIMARY KEY CLUSTERED 
(
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stu_Clubs]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stu_Clubs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [bigint] NOT NULL,
	[ClubId] [int] NOT NULL,
	[TermId] [int] NOT NULL,
	[NewClubId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[DayId] [int] NOT NULL,
	[ChoiceTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.Stu_Clubs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stu_ClubsHistory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stu_ClubsHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [bigint] NOT NULL,
	[FromClubId] [int] NOT NULL,
	[ToClubId] [int] NOT NULL,
	[ChangingDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[Reason] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Stu_ClubsHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stu_ECAAttendance]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stu_ECAAttendance](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [bigint] NOT NULL,
	[ClubId] [int] NOT NULL,
	[AttnDateTime] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[TermId] [int] NOT NULL,
	[DayId] [int] NOT NULL,
	[IsPresent] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Stu_ECAAttendance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemLogs]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemLogs](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[Msg] [int] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[Status] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.SystemLogs] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Bug]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Bug](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ModuleId] [int] NOT NULL,
	[TestSiteId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Code] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[DeveloperFeedback] [nvarchar](max) NULL,
	[TesterFeedback] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_Bug] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_BugAttachment]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_BugAttachment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BugId] [int] NOT NULL,
	[Path] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Task_BugAttachment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Comments]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Like] [int] NOT NULL,
	[Dislike] [int] NOT NULL,
	[AddBy] [nvarchar](max) NULL,
	[AddDate] [datetime] NOT NULL,
	[IssueId] [int] NOT NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_dbo.Task_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Issue]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Issue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NULL,
	[IssueTypeId] [int] NULL,
	[SprintId] [int] NULL,
	[AssigneeId] [int] NULL,
	[ReporterId] [int] NULL,
	[ClientId] [int] NULL,
	[Title] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Priority] [nvarchar](max) NULL,
	[AlertRule] [nvarchar](max) NULL,
	[DueDate] [datetime] NULL,
	[ParentId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[StatusId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[EstimatedTime] [int] NOT NULL,
	[EstimatedType] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Task_Issue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_IssueAttachment]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_IssueAttachment](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[IssueId] [int] NOT NULL,
	[FileName] [nvarchar](max) NULL,
	[FileType] [nvarchar](max) NULL,
	[ImageUrl] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Task_IssueAttachment] PRIMARY KEY CLUSTERED 
(
	[AttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_IssueHistory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_IssueHistory](
	[HistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[IssueId] [int] NOT NULL,
	[ParentId] [int] NULL,
	[SprinttId] [int] NULL,
	[ModifyDate] [datetime] NOT NULL,
	[PreviousId] [int] NULL,
	[PresentId] [int] NULL,
 CONSTRAINT [PK_dbo.Task_IssueHistory] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_IssueType]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_IssueType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IssueTypeName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_IssueType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_IssueWebLink]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_IssueWebLink](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IssueId] [int] NOT NULL,
	[Url] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Task_IssueWebLink] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Modules]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Modules](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ModuleName] [nvarchar](max) NULL,
	[ProductName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_Modules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Notifications]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Notifications](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
	[Title] [nvarchar](30) NOT NULL,
	[Message] [nvarchar](200) NOT NULL,
	[DetailsURL] [nvarchar](200) NULL,
	[SentTo] [nvarchar](max) NULL,
	[AddDate] [datetime] NOT NULL,
	[IsRead] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsReminder] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Task_Notifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Project]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Project](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [nvarchar](max) NULL,
	[ExpireDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[IsSupport] [bit] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Task_Project] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_ProjectCategory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_ProjectCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_ProjectCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_ProjectUsers]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_ProjectUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[UserId] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_ProjectUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Sprint]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Sprint](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SprintTitle] [nvarchar](max) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Completed] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
	[Goal] [nvarchar](max) NULL,
	[PersonId] [nvarchar](max) NULL,
	[IsStart] [bit] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[IsSupport] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Task_Sprint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Status]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Status](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [nvarchar](max) NULL,
	[ColorCode] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_TaskActivityLog]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_TaskActivityLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[RefId] [int] NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[StatusId] [int] NULL,
 CONSTRAINT [PK_dbo.Task_TaskActivityLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_TaskAssign]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_TaskAssign](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TaskId] [int] NOT NULL,
	[UserId] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_TaskAssign] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_TaskInfo]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_TaskInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TicketId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[SprintId] [int] NOT NULL,
	[TaskName] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[StartDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[WorkingHour] [int] NOT NULL,
	[IsClosed] [bit] NOT NULL,
	[ClientId] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_TaskInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_TestSite]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_TestSite](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SiteName] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[URL] [nvarchar](max) NULL,
	[TestingPerson] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_TestSite] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_TicketCategory]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_TicketCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_TicketCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_TicketFwdMapping]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_TicketFwdMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[UserId] [nvarchar](max) NULL,
	[UserName] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Task_TicketFwdMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_Tickets]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_Tickets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[ProjectId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[ModuleId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Priority] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[ClosedDate] [datetime] NOT NULL,
	[ClientId] [int] NOT NULL,
	[Url] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AddBy] [nvarchar](128) NULL,
	[AddDate] [datetime] NULL,
	[UpdateBy] [nvarchar](128) NULL,
	[UpdateDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[Status] [nvarchar](20) NULL,
	[IP] [nvarchar](50) NULL,
	[MacAddress] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Task_Tickets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_TicketsAttachment]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_TicketsAttachment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TicketId] [int] NOT NULL,
	[FileName] [nvarchar](max) NULL,
	[FileType] [nvarchar](max) NULL,
	[Size] [int] NOT NULL,
	[Path] [nvarchar](max) NULL,
	[File] [varbinary](max) NULL,
	[ImgUrl] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Task_TicketsAttachment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task_TicketUsers]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task_TicketUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NULL,
	[TicketId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Task_TicketUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestTran]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestTran](
	[Cola] [int] NOT NULL,
	[Colb] [char](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[Cola] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[AggregatedCounter]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[AggregatedCounter](
	[Key] [nvarchar](100) NOT NULL,
	[Value] [bigint] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_CounterAggregated] PRIMARY KEY CLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Counter]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Counter](
	[Key] [nvarchar](100) NOT NULL,
	[Value] [int] NOT NULL,
	[ExpireAt] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Hash]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Hash](
	[Key] [nvarchar](100) NOT NULL,
	[Field] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ExpireAt] [datetime2](7) NULL,
 CONSTRAINT [PK_HangFire_Hash] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Field] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Job]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Job](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[StateId] [bigint] NULL,
	[StateName] [nvarchar](20) NULL,
	[InvocationData] [nvarchar](max) NOT NULL,
	[Arguments] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Job] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[JobParameter]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[JobParameter](
	[JobId] [bigint] NOT NULL,
	[Name] [nvarchar](40) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_HangFire_JobParameter] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[JobQueue]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[JobQueue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[Queue] [nvarchar](50) NOT NULL,
	[FetchedAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_JobQueue] PRIMARY KEY CLUSTERED 
(
	[Queue] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[List]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[List](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_List] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Schema]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Schema](
	[Version] [int] NOT NULL,
 CONSTRAINT [PK_HangFire_Schema] PRIMARY KEY CLUSTERED 
(
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Server]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Server](
	[Id] [nvarchar](200) NOT NULL,
	[Data] [nvarchar](max) NULL,
	[LastHeartbeat] [datetime] NOT NULL,
 CONSTRAINT [PK_HangFire_Server] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Set]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Set](
	[Key] [nvarchar](100) NOT NULL,
	[Score] [float] NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Set] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[State]    Script Date: 1/10/2021 7:53:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[State](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Reason] [nvarchar](100) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[Data] [nvarchar](max) NULL,
 CONSTRAINT [PK_HangFire_State] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACC_Ledgers] ADD  CONSTRAINT [DF__tmp_ms_xx__RootG__78008E0A]  DEFAULT ((0)) FOR [RootGroupId]
GO
ALTER TABLE [dbo].[ACC_Ledgers] ADD  CONSTRAINT [DF__tmp_ms_xx__Curre__78F4B243]  DEFAULT ((0)) FOR [CurrentBalance]
GO
ALTER TABLE [dbo].[ACC_Ledgers] ADD  CONSTRAINT [DF__tmp_ms_xx__IsEdi__79E8D67C]  DEFAULT ((0)) FOR [IsEdit]
GO
ALTER TABLE [dbo].[ACC_Ledgers] ADD  CONSTRAINT [DF__tmp_ms_xx__IsLed__7ADCFAB5]  DEFAULT ((0)) FOR [IsLedger]
GO
ALTER TABLE [dbo].[ACC_Ledgers] ADD  CONSTRAINT [DF__tmp_ms_xx__IsGro__7BD11EEE]  DEFAULT ((0)) FOR [IsGroup]
GO
ALTER TABLE [dbo].[ACC_Ledgers] ADD  CONSTRAINT [DF__tmp_ms_xx__Paren__7CC54327]  DEFAULT ((0)) FOR [ParentId]
GO
ALTER TABLE [dbo].[ACC_Ledgers] ADD  CONSTRAINT [DF__tmp_ms_xx__IsDis__7DB96760]  DEFAULT ((0)) FOR [IsDisplay]
GO
ALTER TABLE [dbo].[ACC_Ledgers] ADD  CONSTRAINT [DF__tmp_ms_xx__Displ__7EAD8B99]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[ACC_RootGroup] ADD  DEFAULT ((0)) FOR [Length]
GO
ALTER TABLE [dbo].[ACC_Transaction] ADD  DEFAULT ((0)) FOR [FiscalYearId]
GO
ALTER TABLE [dbo].[ACC_Transaction] ADD  DEFAULT ((0)) FOR [AccBranchId]
GO
ALTER TABLE [dbo].[ACC_Transaction] ADD  DEFAULT ('') FOR [TransNo]
GO
ALTER TABLE [dbo].[ACC_Transaction] ADD  DEFAULT ((0)) FOR [TransType]
GO
ALTER TABLE [dbo].[ACC_Transaction] ADD  DEFAULT ((0)) FOR [PayMode]
GO
ALTER TABLE [dbo].[ACC_Transaction] ADD  DEFAULT ('1900-01-01T00:00:00.000') FOR [ApproveDate]
GO
ALTER TABLE [dbo].[ACC_Transaction] ADD  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[ACC_Transaction] ADD  DEFAULT ((0)) FOR [IsReject]
GO
ALTER TABLE [dbo].[AspNetPages] ADD  DEFAULT ((0)) FOR [IsModule]
GO
ALTER TABLE [dbo].[AspNetPages] ADD  DEFAULT ((0)) FOR [ModuleId]
GO
ALTER TABLE [dbo].[Att_EmpRoster] ADD  CONSTRAINT [DF__tmp_ms_xx__IsTem__32381C97]  DEFAULT ((0)) FOR [IsTempApproved]
GO
ALTER TABLE [dbo].[Att_EmpRoster] ADD  CONSTRAINT [DF__tmp_ms_xx__IsTem__332C40D0]  DEFAULT ((0)) FOR [IsTemporary]
GO
ALTER TABLE [dbo].[Att_EmpRoster] ADD  CONSTRAINT [DF__tmp_ms_xx__IsRej__34206509]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [dbo].[Att_EmpRoster] ADD  CONSTRAINT [DF__tmp_ms_xx__IsTem__35148942]  DEFAULT ((0)) FOR [IsTempRejected]
GO
ALTER TABLE [dbo].[CRM_Client] ADD  DEFAULT ((0)) FOR [HasAppsService]
GO
ALTER TABLE [dbo].[CRM_Client] ADD  DEFAULT ((0)) FOR [HasWebPortal]
GO
ALTER TABLE [dbo].[CRM_Client] ADD  DEFAULT ((0)) FOR [HasSMS]
GO
ALTER TABLE [dbo].[Emp_Attendance] ADD  CONSTRAINT [DF__tmp_ms_xx__IsPri__5C642BE4]  DEFAULT ((0)) FOR [IsPriApproved]
GO
ALTER TABLE [dbo].[Emp_Attendance] ADD  CONSTRAINT [DF__tmp_ms_xx__IsFin__5D58501D]  DEFAULT ((0)) FOR [IsFinalApproved]
GO
ALTER TABLE [dbo].[Emp_Attendance] ADD  CONSTRAINT [DF__tmp_ms_xx__IsCha__5E4C7456]  DEFAULT ((0)) FOR [IsChangedStatus]
GO
ALTER TABLE [dbo].[Emp_Attendance] ADD  CONSTRAINT [DF__tmp_ms_xx__IsApp__5F40988F]  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[Emp_Attendance] ADD  CONSTRAINT [DF__tmp_ms_xx__IsRej__6034BCC8]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [dbo].[Emp_BasicInfo] ADD  CONSTRAINT [DF__Emp_Basic__Retir__3A5795F5]  DEFAULT ('1900-01-01T00:00:00.000') FOR [RetirementDate]
GO
ALTER TABLE [dbo].[Emp_BasicInfo] ADD  DEFAULT ((0)) FOR [DisOrder]
GO
ALTER TABLE [dbo].[Emp_BasicInfo] ADD  DEFAULT ('1900-01-01T00:00:00.000') FOR [PPExpireDate]
GO
ALTER TABLE [dbo].[Emp_BasicInfo] ADD  DEFAULT ((0)) FOR [TeamId]
GO
ALTER TABLE [dbo].[Emp_Department] ADD  DEFAULT ((0)) FOR [DisOrder]
GO
ALTER TABLE [dbo].[Emp_MeetingConfig] ADD  DEFAULT ((0)) FOR [BranchId]
GO
ALTER TABLE [dbo].[Emp_MeetingConfig] ADD  DEFAULT ((0)) FOR [ClassId]
GO
ALTER TABLE [dbo].[FA_AssetDetails] ADD  DEFAULT ((0)) FOR [PurchseValue]
GO
ALTER TABLE [dbo].[FA_AssetDetails] ADD  DEFAULT ((0)) FOR [CurrentValue]
GO
ALTER TABLE [dbo].[FA_AssetDetails] ADD  DEFAULT ((0)) FOR [SalvageValue]
GO
ALTER TABLE [dbo].[HR_SalaryHead] ADD  CONSTRAINT [DF_HR_SalaryHead_IsEdit]  DEFAULT ((0)) FOR [IsEdit]
GO
ALTER TABLE [dbo].[HR_SalaryHeadWiseConfig] ADD  DEFAULT ((0)) FOR [CategoryID]
GO
ALTER TABLE [dbo].[HR_SalaryPayDetails] ADD  CONSTRAINT [DF_HR_SalaryPayDetails_IsConfirmed]  DEFAULT ((0)) FOR [IsConfirmed]
GO
ALTER TABLE [dbo].[HR_SalaryPayDetails] ADD  CONSTRAINT [DF_HR_SalaryPayDetails_IsModified]  DEFAULT ((0)) FOR [IsModified]
GO
ALTER TABLE [dbo].[HR_SalaryPeriod] ADD  DEFAULT ((0)) FOR [CategoryID]
GO
ALTER TABLE [dbo].[HR_SalaryPeriod] ADD  CONSTRAINT [DF_HR_SalaryPeriod_IsDeductTax]  DEFAULT ((0)) FOR [IsDeductTax]
GO
ALTER TABLE [dbo].[HR_SalaryPeriod] ADD  CONSTRAINT [DF_HR_SalaryPeriod_IsLongHoliday]  DEFAULT ((0)) FOR [IsLongHoliday]
GO
ALTER TABLE [dbo].[HR_SalaryStructure] ADD  DEFAULT ((0)) FOR [CategoryID]
GO
ALTER TABLE [dbo].[HR_SalaryStructurePeriod] ADD  DEFAULT ((0)) FOR [CategoryID]
GO
ALTER TABLE [dbo].[HR_SalaryStructurePeriod] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Portal_Document] ADD  DEFAULT ((0)) FOR [DocType]
GO
ALTER TABLE [dbo].[SMS_SMSTemplate] ADD  DEFAULT ((0)) FOR [isUnicode]
GO
ALTER TABLE [dbo].[Stu_Clubs] ADD  DEFAULT ((0)) FOR [DayId]
GO
ALTER TABLE [dbo].[Stu_ECAAttendance] ADD  DEFAULT ((0)) FOR [TermId]
GO
ALTER TABLE [dbo].[Stu_ECAAttendance] ADD  DEFAULT ((0)) FOR [DayId]
GO
ALTER TABLE [dbo].[Stu_ECAAttendance] ADD  DEFAULT ((0)) FOR [IsPresent]
GO
ALTER TABLE [dbo].[Task_Comments] ADD  DEFAULT ((0)) FOR [IssueId]
GO
ALTER TABLE [dbo].[Task_Issue] ADD  DEFAULT ((0)) FOR [EstimatedTime]
GO
ALTER TABLE [dbo].[Task_Project] ADD  DEFAULT ((0)) FOR [IsSupport]
GO
ALTER TABLE [dbo].[Task_Project] ADD  DEFAULT ((0)) FOR [CategoryId]
GO
ALTER TABLE [dbo].[Task_Project] ADD  DEFAULT ((0)) FOR [DepartmentId]
GO
ALTER TABLE [dbo].[Task_Sprint] ADD  DEFAULT ((0)) FOR [IsStart]
GO
ALTER TABLE [dbo].[Task_Sprint] ADD  DEFAULT ((0)) FOR [ProjectId]
GO
ALTER TABLE [dbo].[Task_Sprint] ADD  DEFAULT ((0)) FOR [IsSupport]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[Common_PoliceStation]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.Common_PoliceStation_dbo.Common_District_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[Common_District] ([DistrictId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Common_PoliceStation] CHECK CONSTRAINT [FK_dbo.Common_PoliceStation_dbo.Common_District_DistrictId]
GO
ALTER TABLE [HangFire].[JobParameter]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_JobParameter_Job] FOREIGN KEY([JobId])
REFERENCES [HangFire].[Job] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HangFire].[JobParameter] CHECK CONSTRAINT [FK_HangFire_JobParameter_Job]
GO
ALTER TABLE [HangFire].[State]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_State_Job] FOREIGN KEY([JobId])
REFERENCES [HangFire].[Job] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HangFire].[State] CHECK CONSTRAINT [FK_HangFire_State_Job]
GO
