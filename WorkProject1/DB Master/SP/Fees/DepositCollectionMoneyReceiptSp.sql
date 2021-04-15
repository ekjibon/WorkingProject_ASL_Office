/****** Object:  StoredProcedure [dbo].[DepositColectinMoneyReceipt]    Script Date: 4/8/2020  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DepositColectinMoneyReceipt]'))
BEGIN
DROP PROCEDURE  DepositColectinMoneyReceipt
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[DepositColectinMoneyReceipt] 13
CREATE PROCEDURE [dbo].[DepositColectinMoneyReceipt] -- Total 1 param
	@ID INT =null
AS
BEGIN
SELECT FS.SecurityDepositDetailsId,FS.StudentIID,SB.FullName,C.ClassName,SB.StudentInsID,FS.DepositAmont,FS.ReceiveAmount,FS.Installment,FS.InstallmentAmount,FS.MoneyReceipt,dbo.fnIntegerToWords(FS.ReceiveAmount) as ReceiveAmountWords,FS.Narration,FS.BankDate,FH.HeadName FROM Fees_SecurityDepositDetails FS 
INNER JOIN  [dbo].[Student_BasicInfo] SB ON SB.StudentIID = FS.StudentIID
INNER JOIN  [dbo].[Ins_ClassInfo] C ON C.ClassId = SB.ClassId
INNER JOIN [dbo].[Fees_Head] FH ON FH.FeesHeadId = FS.FeesHeadId
WHERE FS.SecurityDepositDetailsId = @ID
END






