
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DepositMoneyReceiptView]'))
BEGIN
DROP PROCEDURE  [DepositMoneyReceiptView]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		khaled
-- Create date: April 13, 2020
-- Description:	
-- =============================================

Create  PROCEDURE [dbo].[DepositMoneyReceiptView] 
(
    @Block INT=0,
	@MoneyReceiptNo nvarchar(20)=null,
	@StudentIID INT=0
)
AS
BEGIN
	IF(@Block=1)
	BEGIN  -- [DepositMoneyReceiptView] 1,null,4413		 
      SELECT M.*,SB.FullName,SB.StudentInsID,SB.RollNo,U.UserName	
	   from Fees_SecurityDepositDetails M 
	 -- left join Fees_FeesMonth FM on FM.FeesMonthId=M.MonthId 
	  left join [dbo].[vwStudentBasic] SB on SB.StudentIID=M.StudentIID	 
	  left join AspNetUsers U on u.UserName=M.AddBy
	  where M.StudentIID=@StudentIID  
	END
		IF(@Block=2)
	BEGIN  -- [DepositMoneyReceiptView] 2,'20421000003',null	 
      SELECT M.*,SB.FullName,SB.StudentInsID,SB.RollNo,(U.FullName) AS Ufullname,FH.HeadName,dbo.fnIntegerToWords(M.ReceiveAmount) as ReceiveAmountWords	
	   from Fees_SecurityDepositDetails M 
	 -- left join Fees_FeesMonth FM on FM.FeesMonthId=M.MonthId 
	  left join [dbo].[vwStudentBasic] SB on SB.StudentIID=M.StudentIID	
	  INNER JOIN [dbo].[Fees_Head] FH ON FH.FeesHeadId = M.FeesHeadId
	  left join AspNetUsers U on u.UserName=M.AddBy
	  where M.MoneyReceipt=@MoneyReceiptNo 
	END
END