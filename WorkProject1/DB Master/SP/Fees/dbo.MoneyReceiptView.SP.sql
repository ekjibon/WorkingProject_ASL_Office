/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyReceiptView]'))
BEGIN
DROP PROCEDURE  [MoneyReceiptView]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shahin
-- Create date: March 19, 2018
-- Description:	
-- =============================================

Create  PROCEDURE [dbo].[MoneyReceiptView] 
(
    @Block INT=0,
	@MoneyReceiptNo nvarchar(20)=null,
	@StudentIID INT=0,
	@PostingDate SMALLDATETIME=NULL,  
	@BankDate SMALLDATETIME=NULL,
	@UserId nvarchar(200)=NULL,
	@BoothId INT=0,
	@BranchId INT=0,
	@MoneyReceiptBatch VARCHAR(1000) = NULL,
	@PyamentType INT =0
)
AS
BEGIN
	IF(@Block=1)
	BEGIN  -- [MoneyReceiptView] 1,'180624000249',null,null,null,null,null,null,null,null 		 
      SELECT M.*,FM.[MonthName],SB.FullName,SB.StudentInsID,SB.RollNo,U.UserName	
	   from Fees_CollectionMaster M 
	  left join Fees_FeesMonth FM on FM.FeesMonthId=M.MonthId 
	  left join [dbo].[vwStudentBasic] SB on SB.StudentIID=M.StudentIID	 
	  left join AspNetUsers U on u.UserName=M.AddBy
	  where M.MoneyReceipt=@MoneyReceiptNo  and M.IsDeleted=0
	END  -- [MoneyReceiptView] 2,null,143,null,null,null,null,null,null,null 
	IF(@Block=2)-- [MoneyReceiptView] 2,null,4531,null,null,null,null,null,null,1 
	BEGIN  -- [MoneyReceiptView] 2,null,138,null,'2018-05-15',null,null,null,null,null 
      SELECT M.*,FM.[MonthName],SB.FullName,SB.StudentInsID,SB.RollNo,U.UserName from Fees_CollectionMaster M 
	  left join Fees_FeesMonth FM on FM.FeesMonthId=M.MonthId 
	  left join [dbo].[vwStudentBasic] SB on SB.StudentIID=M.StudentIID	
	   left join AspNetUsers U on u.Id=M.AddBy
	  where M.IsDeleted=0 AND M.IsEnrollment = 0
	  and M.StudentIID=@StudentIID 
	  and CAST( M.PaymentDate AS DATE)= ISNULL(CAST( @PostingDate AS DATE),M.PaymentDate)	
	  and  CAST( M.BankCollectionDate AS DATE)= ISNULL(CAST( @BankDate AS DATE),M.BankCollectionDate)
	  and M.PaymentType=ISNULL(@PyamentType,M.PaymentType)
	  order by M.AddDate DESC
	END
	IF(@Block=3)-- [MoneyReceiptView] 3,null,null,'2018-05-14',null,null,3,null,null,null   --   a824790f-6be8-4218-9c10-72eea8d83f89
	BEGIN  -- [MoneyReceiptView] 3,null,null,'2018-05-15',null,'a824790f-6be8-4218-9c10-72eea8d83f89',null,null,null,null
      SELECT M.*,FM.[MonthName],SB.FullName,SB.StudentInsID,SB.RollNo,U.UserName 
	  from Fees_CollectionMaster M 
	  left join Fees_FeesMonth FM on FM.FeesMonthId=M.MonthId 
	  left join [dbo].[vwStudentBasic] SB on SB.StudentIID=M.StudentIID	
	  left join AspNetUsers U on u.Id=M.AddBy
	  where M.IsDeleted=0
	  and CAST( M.PaymentDate AS DATE)= COALESCE(CAST( @PostingDate AS DATE),M.PaymentDate)	
	  and M.BoothID=COALESCE(@BoothId,M.BoothID) 
	  and M.AddBy=COALESCE(@UserId,M.AddBy)
	  and M.PaymentType=COALESCE(@PyamentType,M.PaymentType)
	  order by M.AddDate DESC
	END
	IF(@Block=4)
	BEGIN  --  [MoneyReceiptView] 4,null,null,null,null,null,null,12 ,null,null
     select u.* from [dbo].[AspNetUsers] u
	left join Emp_BasicInfo e on e.EmpBasicInfoID=u.EmpId 
	where e.BranchID=@BranchId
	END	
	IF(@Block=5)
	BEGIN  --  [MoneyReceiptView] 5,'20629000028',null,null,null,null,null,null,null,null	
	 select
	     sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID,sb.SMSNotificationNo, sb.FullName, SB.SessionName, SB.BranchName, 
         SB.ShiftName, SB.ClassName, SB.SectionName, sb.RollNo
		 ,CM.ReceivedAmount as TotalAmount
		 ,CM.TotalDiscountAmount,CM.VAT,(U.FullName) AS Ufullname -- Add by khaled for user name 24/04/2020
		 ,FORMAT( CM.BankCollectionDate, 'dd/MM/yyyy', 'en-US' )as PaymentDate, H.HeadName,CM.MoneyReceipt,SUM(CD.ReceiveAmount) Amount
		 ,FM.[MonthName]
		,[dbo].fnIntegerToWords(CM.ReceivedAmount) as TotalAmountWords 
		----------------------------------
		,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace((Select (
		STUFF ((
		Select DISTINCT	',' +SUBSTRING(fm.MonthName ,0,4),fm.FeesMonthId
		from dbo.Fees_CollectionDetails f 
		inner join  Fees_CollectionMaster fcm  on fcm.Id=f.MasterID
		join dbo.Fees_FeesMonth fm on fm.FeesMonthId=f.MonthId  and  fcm.Id=cm.Id --and f.MonthId<=cm.MonthId
		where  f.HeadId=CD.HeadId   ORDER BY  
		fm.FeesMonthId  For Xml Path (''), Type).value('.', 'Varchar(Max)'), 1, 1, '') ) AS MonthName
		),1,''),2,'') ,3,'') ,4,'') ,5,'') ,6,'') ,7,'') ,8,'') ,9,'') ,10,'') ,11,'') ,12,''),0,'')    
		AS Narration
		
       --------------------------------------------
     from  Fees_CollectionMaster CM
	 inner join  Fees_CollectionDetails CD on cm.Id=CD.MasterID
	 inner join  [dbo].[vwStudentBasic]  SB on SB.StudentIID=CM.StudentIID
	 inner join  Fees_FeesMonth FM on FM.FeesMonthId=CM.MonthId 
	 inner join  Fees_Head H on H.FeesHeadId=CD.HeadId
	 left join AspNetUsers U on u.UserName=CM.AddBy -- Add by khaled for user name 24/04/2020
	 WHERE CM.MoneyReceipt = @MoneyReceiptNo AND CD.ReceiveAmount <> 0 
	 AND CM.IsEnrollment = 0 --khaled 4/13/2020
	 
	 group by 
	  sb.StudentIID, RTRIM(sb.StudentInsID) , sb.FullName, SB.SessionName, SB.BranchName, 
         SB.ShiftName, SB.ClassName,SB.SectionName, sb.RollNo,CM.ReceivedAmount,CM.TotalDiscountAmount,CM.VAT,U.FullName
		 ,FORMAT( CM.BankCollectionDate, 'dd/MM/yyyy', 'en-US' ), H.HeadName,CM.MoneyReceipt,FM.[MonthName]
		,[dbo].fnIntegerToWords(CM.ReceivedAmount)--
		 ,cm.MonthId,cm.Id,cd.HeadId,sb.SMSNotificationNo
	END
	IF(@Block=6)
	BEGIN  --  [MoneyReceiptView] 6,'180515-001188',null,null,null,null,null,null,null,null 
	 select
	     sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName,SB.SessionName, SB.BranchName, 
         SB.ShiftName, SB.ClassName, SB.SectionName, sb.RollNo,CM.ReceivedAmount as TotalAmount,CM.TotalDiscountAmount,CM.VAT
		 ,FORMAT( CM.PaymentDate, 'dd/MM/yyyy', 'en-US' )as PaymentDate, H.HeadName, CM.MoneyReceipt 
		 ,SUM(CD.ReceiveAmount) ReceiveAmount,FM.[MonthName],[dbo].fnIntegerToWords(CM.ReceivedAmount) as InWord   
		 ----------------------------------
		,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace((Select (
		STUFF ((
		Select DISTINCT	',' +SUBSTRING(fm.MonthName ,0,4),fm.FeesMonthId
		from dbo.Fees_CollectionDetails f 
		inner join  Fees_CollectionMaster fcm  on fcm.Id=f.MasterID
		join dbo.Fees_FeesMonth fm on fm.FeesMonthId=f.MonthId and f.MonthId<=cm.MonthId and  fcm.Id=cm.Id
		where  f.HeadId=CD.HeadId   ORDER BY  
		fm.FeesMonthId  For Xml Path (''), Type).value('.', 'Varchar(Max)'), 1, 1, '') ) AS MonthName
		),1,''),2,'') ,3,'') ,4,'') ,5,'') ,6,'') ,7,'') ,8,'') ,9,'') ,10,'') ,11,'') ,12,'')  
		AS Narration
       --------------------------------------------
     from  Fees_CollectionMaster CM
	 inner join  Fees_CollectionDetails CD on cm.Id=CD.MasterID
	 inner join  [dbo].[vwStudentBasic]  SB on SB.StudentIID=CM.StudentIID
	 inner join  Fees_FeesMonth FM on FM.FeesMonthId=CM.MonthId 
	 inner join  Fees_Head H on H.FeesHeadId=CD.HeadId
	 where CM.Id  IN (SELECT * FROM [dbo].StringSplit(@MoneyReceiptBatch,',')) AND CM.IsDeleted=0 
	  group by 
	  sb.StudentIID, RTRIM(sb.StudentInsID) , sb.FullName, SB.SessionName, SB.BranchName, 
         SB.ShiftName, SB.ClassName, SB.SectionName, sb.RollNo,CM.ReceivedAmount,CM.TotalDiscountAmount,CM.VAT
		 ,FORMAT( CM.PaymentDate, 'dd/MM/yyyy', 'en-US' ), H.HeadName,CM.MoneyReceipt,FM.[MonthName]
		,[dbo].fnIntegerToWords(CM.ReceivedAmount)-- 
		,cm.MonthId,cm.Id,cd.HeadId
	 END
	 IF(@Block=7)  --khaled 4/13/2020
	BEGIN  --  [MoneyReceiptView] 7,'20412000100',null,null,null,null,null,null,null,null	
	 select
	     sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID,sb.SMSNotificationNo, sb.FullName, SB.SessionName, SB.BranchName, 
         SB.ShiftName, SB.ClassName, SB.SectionName, sb.RollNo
		 ,CM.ReceivedAmount as TotalAmount
		 ,CM.TotalDiscountAmount,CM.VAT
		 ,FORMAT( CM.BankCollectionDate, 'dd/MM/yyyy', 'en-US' )as BankCollectionDate, H.HeadName,CM.MoneyReceipt,CD.Amount--,SUM(CD.ReceiveAmount) Amount
		 ,FM.[MonthName],CD.Narration,(U.FullName) AS Ufullname
		,[dbo].fnIntegerToWords(CM.ReceivedAmount) as TotalAmountWords 
		----------------------------------
		,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace((Select (
		STUFF ((
		Select DISTINCT	',' +SUBSTRING(fm.MonthName ,0,4),fm.FeesMonthId
		from dbo.Fees_CollectionDetails f 
		inner join  Fees_CollectionMaster fcm  on fcm.Id=f.MasterID
		join dbo.Fees_FeesMonth fm on fm.FeesMonthId=f.MonthId and f.MonthId<=cm.MonthId and  fcm.Id=cm.Id
		where  f.HeadId=CD.HeadId   ORDER BY  
		fm.FeesMonthId  For Xml Path (''), Type).value('.', 'Varchar(Max)'), 1, 1, '') ) AS MonthName
		),1,''),2,'') ,3,'') ,4,'') ,5,'') ,6,'') ,7,'') ,8,'') ,9,'') ,10,'') ,11,'') ,12,''),0,'')    
		
		
       --------------------------------------------
     from  Fees_CollectionMaster CM
	 inner join  Fees_CollectionDetails CD on cm.Id=CD.MasterID
	 inner join  [dbo].[vwStudentBasic]  SB on SB.StudentIID=CM.StudentIID
	 inner join  Fees_FeesMonth FM on FM.FeesMonthId=CM.MonthId 
	 inner join  Fees_Head H on H.FeesHeadId=CD.HeadId
	 left join AspNetUsers U on u.UserName=CM.AddBy
	 WHERE CM.MoneyReceipt = @MoneyReceiptNo AND CM.IsEnrollment=1 
	 group by 
	  sb.StudentIID, RTRIM(sb.StudentInsID) , sb.FullName, SB.SessionName, SB.BranchName, 
         SB.ShiftName, SB.ClassName,SB.SectionName, sb.RollNo,CM.ReceivedAmount,CM.TotalDiscountAmount,CM.VAT
		 ,FORMAT( CM.BankCollectionDate, 'dd/MM/yyyy', 'en-US' ), H.HeadName,CM.MoneyReceipt,CD.Amount,FM.[MonthName],CD.Narration,U.FullName
		,[dbo].fnIntegerToWords(CM.ReceivedAmount)--
		 ,cm.MonthId,cm.Id,cd.HeadId,sb.SMSNotificationNo
	END
	IF(@Block=8)-- [MoneyReceiptView] 2,null,4531,null,null,null,null,null,null,1 
	BEGIN  -- [MoneyReceiptView] 2,null,138,null,'2018-05-15',null,null,null,null,null 
      SELECT M.*,FM.[MonthName],SB.FullName,SB.StudentInsID,SB.RollNo,U.UserName from Fees_CollectionMaster M 
	  left join Fees_FeesMonth FM on FM.FeesMonthId=M.MonthId 
	  left join [dbo].[vwStudentBasic] SB on SB.StudentIID=M.StudentIID	
	   left join AspNetUsers U on u.Id=M.AddBy
	  where M.IsDeleted=0 AND M.IsEnrollment = 1
	  and M.StudentIID=@StudentIID 
	  and CAST( M.PaymentDate AS DATE)= ISNULL(CAST( @PostingDate AS DATE),M.PaymentDate)	
	  and  CAST( M.BankCollectionDate AS DATE)= ISNULL(CAST( @BankDate AS DATE),M.BankCollectionDate)
	  and M.PaymentType=ISNULL(@PyamentType,M.PaymentType)
	  order by M.AddDate DESC
	END
END

    
 
