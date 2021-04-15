TRUNCATE TABLE ACC_Ledgers;
-----------------------------------------------------------------------Root Asset-----------------------------------------------------------
INSERT INTO [dbo].[ACC_Ledgers]([Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) 
VALUES('Assest','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES('Liabilities','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES('Income','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES('Expense','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
-----------------------------------------------------------------------Root Asset-----------------------------------------------------------
-----------------------------------------------------------------------Start Asset-----------------------------------------------------------
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(1,'Fixed Assest','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(1,'Current Assest','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(1,'Accumulated','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(1,'Other Assest','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
-----------------------------------------------------------------------End Asset-----------------------------------------------------------
-----------------------------------------------------------------------Start Liabilities---------------------------------------------------
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(2,'Accounts Payable','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(2,'Income Tax Payable','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(2,'Bank Account Overdrafts','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(2,'Accrued Expenses','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(2,'Short-term Loans','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(2,'Long-term Loans','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(2,'Owners Equity','',0,0,0,0,1,0,0,'admin',GETDATE())
-----------------------------------------------------------------------End Liabilities-----------------------------------------------------------
-----------------------------------------------------------------------Start Income---------------------------------------------------
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(3,'Revenue','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(3,'Sales Return','',0,0,0,0,1,0,0,'admin',GETDATE())
-----------------------------------------------------------------------End Income-----------------------------------------------------
-----------------------------------------------------------------------Start Expense---------------------------------------------------
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Advertising Expense','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Bank Fees','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Depreciation Expense','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Payroll Tax Expense','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Rent Expense','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Supplies Expense','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Utilities Expense','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Wages Expense','',0,0,0,0,1,0,0,'admin',GETDATE())
GO
INSERT INTO [dbo].[ACC_Ledgers]([ParentId],[Name],[Code],[OpenningBalance],[OpenningBalanceDc],[CurrentBalance], [IsEdit],IsGroup,[CurrentBalanceDc],[IsDeleted],[AddBy],[AddDate]) VALUES(4,'Other Expenses','',0,0,0,0,1,0,0,'admin',GETDATE())

-----------------------------------------------------------------------End Expense---------------------------------------------------
select * from dbo.ACC_Ledgers