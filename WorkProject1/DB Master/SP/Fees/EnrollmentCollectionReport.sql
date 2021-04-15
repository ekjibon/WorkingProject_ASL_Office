/****** Object:  StoredProcedure [dbo].[EnrollmentCollectionReport]    Script Date: 4/12/2020 12:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EnrollmentCollectionReport]'))
BEGIN
DROP PROCEDURE  EnrollmentCollectionReport
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[EnrollmentCollectionReport] '2019-01-01 00:00:00.000','2020-05-24 00:00:00.000'
CREATE PROCEDURE [dbo].[EnrollmentCollectionReport] -- Total 2 param
	@FromDate SMALLDATETIME=NULL,
	@ToDate SMALLDATETIME=NULL
		
AS
BEGIN
	SELECT DISTINCT C.[Id]
	,C.IsEnrollment
      ,C.[StudentIID]
      ,B.FullName
      ,B.RollNo
      ,B.StudentInsID
	  ,IB.BranchName
	  ,FORMAT( PaymentDate, 'dd/MM/yyyy', 'en-US' )as PaymentDate
      ,C.[TotalAmount]
      ,[ReceivedAmount]
	  ,(CASE WHEN (FS.Stutype =1) THEN 'General'
	        WHEN (FS.Stutype =2) THEN 'Transfer from CTG BC'
			WHEN (FS.Stutype =3) THEN 'Special Consideration'
			WHEN (FS.Stutype =4) THEN 'Third Child Benefit'
			ELSE '' END) AS Stutype
	  ,dbo.fnIntegerToWords([ReceivedAmount]) as TotalAmountWords
      ,[TotalDiscountAmount]
      ,[PaymentMonth]
      ,[MoneyReceipt]
      ,[PaymentType]
      ,[ChequeNo]
      ,[BankName]
      ,[IsPosted]
      ,[BoothID]
      ,[ScrollNumber]
      ,[BankCollectionDate]
      ,[TrxID]
      ,[PCS_BankName]
      ,[PCS_TrxID]   
   --COLLECTION DETAILS
     --  [Id]
    --  ,[MasterID]
      ,[Amount]
      ,D.[DueAmount]
      ,D.[AdvanceAmount]
      ,D.[ReceiveAmount]
      ,(SELECT SUM(FD.AdvanceAmount) FROM Fees_CollectionDetails FD WHERE FD.MasterID = C.Id) AS TotalAdv
 
      ,D.[HeadId]
	  ,S.SessionName
	  ,Cs.ClassName
	  ,Sec.SectionName
   ,H.HeadName
   --,fm.MonthName AS Narration
   --COLLECTION DETAILS
  FROM [dbo].[Fees_CollectionMaster] AS C 
  INNER JOIN  [dbo].[Fees_CollectionDetails] AS D ON C.Id=D.MasterID AND D.IsDeleted=0 
  INNER JOIN [dbo].Fees_Student AS FS ON FS.StudentIID = C.StudentIID AND FS.HeadId=2
  INNER JOIN [dbo].[Student_BasicInfo] AS B ON C.StudentIID=B.StudentIID AND B.IsDeleted=0 AND B.[Status] = 'A'
  INNER JOIN [dbo].[Ins_Branch] AS IB ON IB.BranchId= B.BranchID
  INNER JOIN [dbo].Ins_Session AS S ON S.SessionId=B.SessionId 
  INNER JOIN [dbo].Ins_ClassInfo AS Cs ON Cs.ClassId=B.ClassId 
  INNER JOIN [dbo].Ins_Section AS Sec ON Sec.SectionId=B.SectionId 
  INNER JOIN [dbo].[Fees_Head] AS H ON D.HeadId=H.FeesHeadId AND H.IsDeleted=0
  inner join  Fees_FeesMonth FM on FM.FeesMonthId=C.MonthId 
  WHERE C.BankCollectionDate BETWEEN (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
  AND C.IsEnrollment =1
  GROUP BY C.[Id]
  ,C.IsEnrollment
      ,C.[StudentIID]
      ,B.FullName
      ,B.RollNo
      ,B.StudentInsID
	  ,IB.BranchName
	  ,PaymentDate
      ,C.[TotalAmount]
      ,[ReceivedAmount]
	  ,Stutype
      ,[TotalDiscountAmount]
      ,[PaymentMonth]
      ,[MoneyReceipt]
      ,[PaymentType]
      ,[ChequeNo]
      ,[BankName]
      ,[IsPosted]
      ,[BoothID]
      ,[ScrollNumber]
      ,[BankCollectionDate]
      ,[TrxID]
      ,[PCS_BankName]
      ,[PCS_TrxID]   
   --COLLECTION DETAILS

     ,[MasterID]
      ,[Amount]
	  --,D.TotalAmount
      ,D.[DueAmount]
	
      ,D.[AdvanceAmount]
      ,D.[ReceiveAmount]     
      ,D.[HeadId]
	  ,S.SessionName
	  ,Cs.ClassName
	  ,Sec.SectionName
      ,H.HeadName
  -- ,D.Narration
  -- ,Narration


END






