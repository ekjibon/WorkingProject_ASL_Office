IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSecurityDepositWithoutAdjustListbyStudentIID]'))
BEGIN
DROP PROCEDURE  [GetSecurityDepositWithoutAdjustListbyStudentIID]
END
GO
/****** Object:  StoredProcedure [dbo].[GetSecurityDepositAdjustListbyStudentIID]    **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[GetSecurityDepositWithoutAdjustListbyStudentIID] 15177
Create Procedure [dbo].[GetSecurityDepositWithoutAdjustListbyStudentIID]
(
@StudentIID int
)
As
BEGIN
SELECT SecurityDepositDetailsId,StudentIID,DepositAmont,ReceiveAmount,IsRefund,IsResolved,
(SELECT SUM(ReceiveAmount) FROM Fees_SecurityDepositDetails WHERE StudentIID = @StudentIID ) AS TotalDepositpaid,
 CASE WHEN(IsRefund= 1 OR IsResolved= 1 ) THEN '0'
 ELSE (SELECT SUM(ReceiveAmount) FROM Fees_SecurityDepositDetails WHERE StudentIID = @StudentIID )
 END AS TotalDueDeposit,
         CASE WHEN(IsRefund= 1 ) THEN 'Already refund'
	       WHEN(IsResolved= 1) THEN 'Already resolved'
	       ELSE ''
		   END AS Status
		   FROM  [dbo].[Fees_SecurityDepositDetails] 
 WHERE StudentIID = @StudentIID AND IsAdjusted = 0 
 --AND FA.IsRefund = 0 AND FA.IsResolved = 0
 GROUP BY SecurityDepositDetailsId,StudentIID,DepositAmont,ReceiveAmount,IsRefund,IsResolved
END