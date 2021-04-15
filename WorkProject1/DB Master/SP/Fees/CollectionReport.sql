
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CollectionReport]'))
BEGIN
DROP PROCEDURE  CollectionReport
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[CollectionReport] 9,'2020-09-1','2020-09-5'
CREATE PROCEDURE [dbo].[CollectionReport]  
@BranchId INT=0,
@FromDate datetime=null,
@ToDate datetime=null
	
	
AS
BEGIN
		SELECT CM.StudentIID  studentIId, sb.StudentInsID,sb.ClassId, sb.FullName,case when b.BranchName='CGSD Primary' then 'Primary Campus' else 'Secondary Campus' end BranchName  ,
		c.ClassName,SUM(CD.ReceiveAmount) AS TotalAmount,CM.BankCollectionDate,Se.SectionName,CM.MoneyReceipt,
		(CASE WHEN CM.PaymentType =1 THEN 'CASH'
		     WHEN CM.PaymentType = 2 THEN 'CHEQUE'
			 WHEN CM.PaymentType = 3 THEN CASE WHEN CM.PCS_BankName = 'bKash' THEN 'BKash'
			                                   WHEN CM.PCS_BankName = 'EBLOTC' THEN 'Over The Counter'
											   WHEN CM.PCS_BankName = 'BANK_C01' THEN 'CARD' 
											   ELSE '' END
             ELSE '' END) AS PaymentMode,
			 (CAST(@FromDate AS date)) AS FromDate,
			 (CAST(@ToDate AS date)) AS ToDate
		FROM  dbo.Student_BasicInfo sb 
		 INNER JOIN [dbo].[Fees_CollectionMaster] CM ON CM.StudentIID = SB.StudentIID
		 INNER JOIN [dbo].[Fees_CollectionDetails] CD ON CD.MasterID = CM.Id 
		 INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 INNER JOIN dbo.Ins_Branch b ON sb.BranchID = b.BranchId
		 INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId	
		 INNER JOIN [dbo].[Ins_Section] Se ON Se.SectionId = sb.SectionId
		 WHERE sb.BranchID=@BranchId AND (CAST(CM.BankCollectionDate as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
		 GROUP BY CM.StudentIID,sb.StudentInsID,sb.ClassId, sb.FullName,b.BranchName,c.ClassName,CM.PaymentType,CM.PCS_BankName,Se.SectionName,CM.BankCollectionDate,CM.MoneyReceipt
		 ORDER BY sb.ClassId
 END