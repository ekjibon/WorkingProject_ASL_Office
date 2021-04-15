TRUNCATE TABLE dbo.[ACC_COATemp];
--Declare @id int
--Declare @ParentId int
--SET @id =(select LedgerId from dbo.ACC_Ledgers where Name='Fixed Assest') 
--SET @ParentId=(select LedgerId from dbo.ACC_Ledgers where Name='Assest') 
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name], [Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Building','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Computer equipment','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Compurter Software','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Furniture and Fixtures','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Land','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Machinery','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Vehicles','',0,@ParentId )
--SET @id =(select LedgerId from dbo.ACC_Ledgers where Name='Current Assest') 
--SET @ParentId=(select LedgerId from dbo.ACC_Ledgers where Name='Assest') 
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Cash In Hand','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Bank','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Accounts Receivable','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Prepaid Expenses','',0,@ParentId )
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Inventory','',0,@ParentId )

--SET @id =(select LedgerId from dbo.ACC_Ledgers where Name='Other Assest') 
--SET @ParentId=(select LedgerId from dbo.ACC_Ledgers where Name='Assest') 
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Advance Employee','',0,@ParentId )

--SET @id =(select LedgerId from dbo.ACC_Ledgers where Name='Other Assest') 
--SET @ParentId=(select LedgerId from dbo.ACC_Ledgers where Name='Liabilities') 
--INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Advance Employee','',0,@ParentId )

-----------------------------------------------------------------------Root Asset-----------------------------------------------------------
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[Type],[RootGroupId],DisplayOrder) VALUES('Assest',0,0,1,0,1)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[Type],[RootGroupId],DisplayOrder) VALUES('Liabilities',0,0,2,0,2)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[Type],[RootGroupId],DisplayOrder) VALUES('Income',0,0,3,0,3)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[Type],[RootGroupId],DisplayOrder) VALUES('Expense',0,0,4,0,4)
GO
-----------------------------------------------------------------------Root Asset-----------------------------------------------------------
-----------------------------------------------------------------------Start Asset-----------------------------------------------------------
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Fixed Assest',1,0,1,5)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Current Assest',1,0,1,6)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Accumulated',1,0,1,7)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Other Assest',1,0,1,8)
GO
-----------------------------------------------------------------------End Asset-----------------------------------------------------------
-----------------------------------------------------------------------Start Liabilities---------------------------------------------------
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Current Liabilities',2,0,2,9)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Non-Current Liabilities',2,0,2,10)
GO
-----------------------------------------------------------------------End Liabilities-----------------------------------------------------------
-----------------------------------------------------------------------Start Income---------------------------------------------------
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Revenue',3,1,3,11)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Sales Return',3,1,3,12)
Go
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Direct Income',3,0,3,13)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Indirect Income',3,0,3,14)
-----------------------------------------------------------------------End Income-----------------------------------------------------
-----------------------------------------------------------------------Start Expense---------------------------------------------------
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Advertising Expense',4,1,4,15)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Bank Fees',4,1,4,16)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Depreciation Expense',4,1,4,17)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Payroll Tax Expense',4,1,4,18)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Rent Expense',4,1,4,19)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Supplies Expense',4,1,4,20)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Utilities Expense',4,1,4,21)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Wages Expense',4,1,4,22)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Other Expenses',4,1,4,24)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('Direct Expenses',4,0,4,25)
GO
INSERT INTO [dbo].[ACC_COATemp]([Name],[ParentId],[IsEdit],[RootGroupId],DisplayOrder) VALUES('InDirect Expenses',4,0,4,26)

-----------------------------------------------------------------------End Expense---------------------------------------------------
Declare @id int
Declare @ParentId int
SET @id =(select Id from dbo.ACC_COATemp where Name='Fixed Assest') 
SET @ParentId=(select Id from dbo.ACC_COATemp where Name='Assest') 
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name], [Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Building','',1,@ParentId,27 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Computer equipment','',1,@ParentId,28 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Compurter Software','',1,@ParentId,29 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Furniture and Fixtures','',1,@ParentId ,30)
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Land','',1,@ParentId ,31)
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Machinery','',1,@ParentId,32 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Vehicles','',1,@ParentId,33 )

SET @id =(select Id from dbo.ACC_COATemp where Name='Current Assest') 
SET @ParentId=(select Id from dbo.ACC_COATemp where Name='Assest') 
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Cash In Hand','',1,@ParentId,34 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Bank','',1,@ParentId,35)
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Accounts Receivable','',1,@ParentId,36 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Prepaid Expenses','',1,@ParentId,37 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],[Name],[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Inventory','',1,@ParentId,38 )

SET @id =(select Id from dbo.ACC_COATemp where Name='Other Assest') 
SET @ParentId=(select Id from dbo.ACC_COATemp where Name='Assest') 
INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Advance Employee','',1,@ParentId,39 )

SET @id =(select Id from dbo.ACC_COATemp where Name='Current Liabilities') 
SET @ParentId=(select Id from dbo.ACC_COATemp where Name='Liabilities') 
INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Account Payable','',1,@ParentId ,40)
INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Income Taxes Payable','',1,@ParentId,41 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Bank Account Overdrafts','',1,@ParentId ,42)
INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Accrued Expenses','',1,@ParentId,43 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Short-term Loans','',1,@ParentId,44 )

SET @id =(select Id from dbo.ACC_COATemp where Name='Non-Current Liabilities') 
SET @ParentId=(select Id from dbo.ACC_COATemp where Name='Liabilities') 
INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Long-term Loans','',1,@ParentId,45 )
INSERT INTO [dbo].[ACC_COATemp]([ParentId],Name,[Type],[IsEdit],[RootGroupId],DisplayOrder) VALUES (@id,'Owners Equity','',1,@ParentId,46 )

select * from [dbo].[ACC_COATemp]

