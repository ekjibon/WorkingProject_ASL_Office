IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSecurityDepositAdjustListbyStudentIID]'))
BEGIN
DROP PROCEDURE  [GetSecurityDepositAdjustListbyStudentIID]
END
GO
/****** Object:  StoredProcedure [dbo].[GetSecurityDepositAdjustListbyStudentIID]    **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[GetSecurityDepositAdjustListbyStudentIID] 4413
Create Procedure [dbo].[GetSecurityDepositAdjustListbyStudentIID]
(
@StudentIID int
)
As
BEGIN
SELECT FA.*, 
CASE WHEN(FA.IsRefund= 1 ) THEN 'Already refund'
	       WHEN(FA.IsResolved= 2) THEN 'Already resolved'
	       ELSE ''
		   END AS Status
		   FROM  [dbo].[Fees_Adjust] FA
 WHERE FA.StudentIID = @StudentIID 
 --AND FA.IsRefund = 0 AND FA.IsResolved = 0

END