IF EXISTS (SELECT *  FROM   sys.objects WHERE  object_id = Object_id(N'GetDetailsTransaction')) 
  BEGIN 
      DROP PROCEDURE GetDetailsTransaction 
  END 
go 
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO 

/****** Object:  StoredProcedure [dbo].[GetDetailsTransaction]    Script Date: 10/8/2019 8:54:02 PM ******/

CREATE PROCEDURE GetDetailsTransaction   --113
@Id INT
AS
IF (@Id IS NOT NULL)
BEGIN  
	
	SELECT td.*,[Date] ,[DrTotal] ,[CrTotal] ,t.[IsDeleted] ,t.[AddBy] ,t.[AddDate] ,t.[UpdateBy] 
         ,t.[UpdateDate] ,t.[Remarks] ,t.[Status] ,t.[IP],
		  CASE T.TransType 
				WHEN 1 THEN 'Receive'
				WHEN 2 THEN 'Payment'
				WHEN 3 THEN 'Contra'
				WHEN 4 THEN 'Journal'
		  END AS TypeName
		 ,CASE t.PayMode
				WHEN 1 THEN 'Cash'
				WHEN 2 THEN 'Cheque'
				WHEN 3 THEN 'On Credit'
		  END AS PayModeName 
		  ,t.[MacAddress] ,t.[FiscalYearId] ,t.[AccBranchId] ,[TransNo] ,[TransType] ,[PayMode] 
		 ,[ApproveDate] ,[ApproveBy] ,[IsApproved] ,[PayTo] ,[RecivedBy] ,[ChequeNo] ,[ChequeDate]
         ,[Description] ,F.Name, F.Id as FisId ,l.Name AS LedgerName  ,b.Name as AccountBranch
	FROM  ACC_TransactionDetail td
	left join ACC_Transaction t on t.Id=td.TransactionId
	inner JOIN dbo.ACC_FiscalYear F ON T.FiscalYearID = f.Id
	inner join ACC_Ledgers l on l.LedgerId=td.LedgerId
	inner join ACC_Branchs b on b.BranchId=t.AccBranchId
	where td.TransactionId=@Id

	--where td.TransactionId=1  
END