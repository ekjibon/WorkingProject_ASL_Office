/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ModifyMoneyReceipt]'))
BEGIN
DROP PROCEDURE  [ModifyMoneyReceipt]
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


CREATE  PROCEDURE [dbo].[ModifyMoneyReceipt] 
(
    @Block INT=0,
	@MoneyReceiptNo nvarchar(20)=null,
	@MasterId INT=0
)
	
AS
BEGIN
	
	IF(@Block=1)
	BEGIN  -- [ModifyMoneyReceipt] 1,'180612000246',null
     SELECT SB.StudentIID,SB.StudentInsID,SB.RollNo,SB.RegiNo,SB.FullName,sb.FatherName,MotherName from Fees_CollectionMaster M 
	 left join [dbo].[vwStudentBasic] SB on SB.StudentIID=M.StudentIID
	 where M.MoneyReceipt=@MoneyReceiptNo and M.IsDeleted=0

	  SELECT M.*,FM.[MonthName] from Fees_CollectionMaster M 
	  left join Fees_FeesMonth FM on FM.FeesMonthId=M.MonthId
	  where M.MoneyReceipt=@MoneyReceiptNo and M.IsDeleted=0
	 
	END
	IF(@Block=2)
	BEGIN  -- [ModifyMoneyReceipt] 2,null,117
     SELECT H.HeadName,CONCAT(LEFT(FM.[MonthName],3),'-' ,RIGHT(D.[year],2)) AS [Month],D.*
	  from Fees_CollectionDetails D 
	 left join Fees_Head H on H.FeesHeadId=D.HeadId
	 left join Fees_FeesMonth FM on FM.FeesMonthId=D.MonthId
	 where D.MasterID=@MasterId and D.IsDeleted=0
	END

	IF(@Block=3)
	BEGIN  -- [ModifyMoneyReceipt] 3,'111822030',null     mr-180513001121  id-111822030
      SELECT M.*,FM.[MonthName] from Fees_CollectionMaster M 
	  left join Fees_FeesMonth FM on FM.FeesMonthId=M.MonthId	  
	  left join Student_BasicInfo s on s.StudentIID=M.StudentIID
	  where (M.MoneyReceipt=@MoneyReceiptNo or S.StudentInsID=@MoneyReceiptNo) and M.IsDeleted=0
	END

	
	
END


 
