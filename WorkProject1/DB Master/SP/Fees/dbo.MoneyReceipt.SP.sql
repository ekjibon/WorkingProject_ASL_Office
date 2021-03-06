/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyReceipt]'))
BEGIN
DROP PROCEDURE  MoneyReceipt
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[MoneyReceipt] 1,34
CREATE PROCEDURE [dbo].[MoneyReceipt] -- Total 9 param
	@Block INT = 0,
	@ID INT =null
	
	
AS
BEGIN

 IF(@Block=1) -- [MoneyReceipt] 1,24  
 
 BEGIN
 Declare @Vat int
	select top 1 @Vat=VatPercent from dbo.Fees_Setting 
	SELECT C.[Id]
      ,C.[StudentIID]
      ,B.FullName
      ,B.RollNo
	  ,(U.FullName) AS Ufullname -- Add by khaled for user name 24/04/2020
      ,B.StudentInsID
	  ,Br.BranchName
	  ,Fm.MonthName
	  ,FORMAT( PaymentDate, 'dd/MM/yyyy', 'en-US' )as PaymentDate
      ,[TotalAmount]
      ,[ReceivedAmount]
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
       [Id]
      ,[MasterID]
      ,[Amount]
      ,[DueAmount]
      ,[AdvanceAmount]
      ,[ScholarshipAmount]
      ,[DiscountAmount]
      ,[ReceiveAmount]
      ,(([TotalAmount]*@Vat)/100) as VAT
      ,[IsLateFine]      
      ,[HeadId]
	  ,S.SessionName
	  ,Cs.ClassName
	  ,Sec.SectionName
   ,H.HeadName
   ,fm.MonthName + '''' +cast(D.Year as nvarchar(10)) AS Narration
   --COLLECTION DETAILS
  FROM [dbo].[Fees_CollectionMaster] AS C 
  INNER JOIN  [dbo].[Fees_CollectionDetails] AS D ON C.Id=D.MasterID AND D.IsDeleted=0 
  INNER JOIN [dbo].[Student_BasicInfo] AS B ON C.StudentIID=B.StudentIID AND B.IsDeleted=0 AND B.[Status] = 'A'
  INNER JOIN [dbo].Ins_Session AS S ON S.SessionId=B.SessionId 
  INNER JOIN [dbo].Ins_ClassInfo AS Cs ON Cs.ClassId=B.ClassId 
  INNER JOIN dbo.Ins_Branch AS Br ON Br.BranchId = B.BranchID
  INNER JOIN [dbo].Ins_Section AS Sec ON Sec.SectionId=B.SectionId 
  INNER JOIN [dbo].[Fees_Head] AS H ON D.HeadId=H.FeesHeadId AND H.IsDeleted=0
  inner join  Fees_FeesMonth FM on FM.FeesMonthId=D.MonthId 
  
    left join AspNetUsers U on u.UserName=C.AddBy -- Add by khaled for user name 24/04/2020
  WHERE C.Id=@ID AND C.IsDeleted=0
 END
 IF(@Block=2) -- [dbo].[MoneyReceipt] 2,20
 
 BEGIN
 --Declare @Vat int
	--select top 1 @Vat=VatPercent from dbo.Fees_Setting 
	SELECT C.[Id]
      ,C.[StudentIID]
      ,B.FullName
      ,B.RollNo
	  ,(U.FullName) AS Ufullname
      ,B.StudentInsID
	  ,FORMAT( PaymentDate, 'dd/MM/yyyy', 'en-US' )as PaymentDate
	  ,FORMAT( BankCollectionDate, 'dd/MM/yyyy', 'en-US' )as BankCollectionDate
      ,[TotalAmount]
      ,[ReceivedAmount]
	  ,dbo.fnIntegerToWords([TotalAmount]) as TotalAmountWords
      ,[TotalDiscountAmount]
	  ,C.[AddBy]
      ,[PaymentMonth]
      ,[MoneyReceipt]
      ,[PaymentType]
      ,[ChequeNo]
      ,[BankName]
      ,[IsPosted]
      ,[BoothID]
      ,[ScrollNumber]
      ,[BankCollectionDate]
	  
   --COLLECTION DETAILS
       [Id]
      ,[MasterID]
      ,[Amount]
	  --,[Narration]
      ,[DueAmount]
      ,[AdvanceAmount]
      ,[ScholarshipAmount]
      ,[DiscountAmount]
      ,[ReceiveAmount]
      ,[IsLateFine]      
      ,[HeadId]
	  ,S.SessionName
	  ,Cs.ClassName
	  ,Sec.SectionName
   ,H.HeadName
  ,D.Narration
  -- ,fm.MonthName AS Narration
   --COLLECTION DETAILS
  FROM [dbo].[Fees_CollectionMaster] AS C 
  INNER JOIN  [dbo].[Fees_CollectionDetails] AS D ON C.Id=D.MasterID AND D.IsDeleted=0 
  INNER JOIN [dbo].[Student_BasicInfo] AS B ON C.StudentIID=B.StudentIID AND B.IsDeleted=0 AND B.[Status] = 'A'
  INNER JOIN [dbo].Ins_Session AS S ON S.SessionId=B.SessionId 
  INNER JOIN [dbo].Ins_ClassInfo AS Cs ON Cs.ClassId=B.ClassId 
  INNER JOIN [dbo].Ins_Section AS Sec ON Sec.SectionId=B.SectionId 
  INNER JOIN [dbo].[Fees_Head] AS H ON D.HeadId=H.FeesHeadId AND H.IsDeleted=0
  INNER JOIN  Fees_FeesMonth FM on FM.FeesMonthId=C.MonthId 
   left join AspNetUsers U on u.UserName=C.AddBy
  WHERE C.Id=@ID AND C.IsDeleted=0

  GROUP BY C.[Id]
      ,C.[StudentIID]
      ,B.FullName
      ,B.RollNo
      ,B.StudentInsID
	  ,PaymentDate
	  ,U.FullName
    --  ,[TotalAmount]
      ,[ReceivedAmount]
	  ,C.[AddBy]
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
	  ,TotalAmount
      ,[DueAmount]
	 
      ,[AdvanceAmount]
      ,[ScholarshipAmount]
      ,[DiscountAmount]
      ,[ReceiveAmount]
      ,VAT
      ,[IsLateFine]      
      ,[HeadId]
	  ,S.SessionName
	  ,Cs.ClassName
	  ,Sec.SectionName
   ,H.HeadName
   ,D.Narration
  -- ,Narration
  --,fm.MonthName 
 END
END






