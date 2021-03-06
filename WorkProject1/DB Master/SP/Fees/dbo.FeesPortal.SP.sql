/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesPortal]'))
BEGIN
DROP PROCEDURE  [FeesPortal]
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
CREATE  PROCEDURE [dbo].[FeesPortal] 
(
    @Block INT=0,
	@StudentIId INT=null,
	@Month INT =null,
	@Year INT =null
)
AS
BEGIN   -- SELECT * FROM Fees_Student Where StudentIID = 3606
	IF(@Block=1) --[dbo].[FeesPortal] 1,4389,8,2019
	BEGIN  	    
      select StudentIID,
	  fm.MonthName, SUM(DueAmount) AS TotalAmount,fs.InvoiceAmount,FAH.LateDate,
	  fs.MonthId,fs.Year from dbo.Fees_Student FS
JOIN dbo.Fees_FeesMonth FM on fm.FeesMonthId=FS.MonthId
INNER JOIN [dbo].[Fees_AutomatedFeesConfig] FAH ON FAH.FeesSessionYearId = FS.FeesSessionYearId --Add by Khaled
group by MonthId, StudentIID,fm.MonthName,IsCompleted,fs.Year,fs.InvoiceAmount,FAH.LateDate 
having StudentIID=@StudentIId and  IsCompleted = 0  
	
	END
		IF(@Block=2) --[dbo].[FeesPortal] 2,4819,null,null
	BEGIN  	    
      select fcm.StudentIID, fm.MonthName,sum(FCD.ReceiveAmount) as ReceivedAmount,fcm.PaymentDate,fcm.MoneyReceipt,fm.FeesMonthId  from dbo.Fees_CollectionMaster fcm 
	  INNER JOIN dbo.Fees_CollectionDetails FCD on fcd.MasterID=fcm.Id
	  INNER JOIN dbo.Fees_FeesMonth fm on fm.FeesMonthId=fcm.MonthId
	  group by FCD.MasterID,fcd.MonthId,fcd.Year,fcm.StudentIID,fm.MonthName,fcm.PaymentDate,fcm.MoneyReceipt,fm.FeesMonthId
	  having fcm.StudentIID =@StudentIId 
	END	
	Begin
	IF(@Block=3) --[dbo].[FeesPortal] 3,4819,3,null
	select fd.HeadName,gcd.Amount from dbo.Fees_CollectionMaster fcm
INNER JOIN  dbo.Fees_CollectionDetails gcd on gcd.MasterID=fcm.Id
 INNER JOIN dbo.Fees_Head fd on fd.FeesHeadId=gcd.HeadId
 where fcm.StudentIID=@StudentIId and fcm.MonthId=@Month
	End
	begin
		IF(@Block=4) --[dbo].[FeesPortal] 4,4819,9,2019 Month Details wise Due Collection
		
	select fd.HeadName,fs.DueAmount,fm.MonthName,fs.InvoiceAmount from dbo.Fees_Student fs 
INNER JOIN dbo.Fees_Head fd on fd.FeesHeadId=fs.HeadId
INNER JOIN dbo.Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
where fs.StudentIID=@StudentIId and fs.MonthId=@Month and fs.IsCompleted=0
	End
END