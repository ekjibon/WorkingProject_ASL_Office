IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSecurityDepositListbyStudentIID]'))
BEGIN
DROP PROCEDURE  [GetSecurityDepositListbyStudentIID]
END
GO
/****** Object:  StoredProcedure [dbo].[GetSecurityDepositListbyStudentIID]    **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[GetSecurityDepositListbyStudentIID] 5118
Create Procedure [dbo].[GetSecurityDepositListbyStudentIID]
(
@StudentIID int
)
As
BEGIN
SELECT * FROM  [dbo].[Fees_SecurityDepositDetails] SD
 WHERE SD.StudentIID = @StudentIID 

END