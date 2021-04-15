IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptSecurityDepositReportByStudentIID]'))
BEGIN
DROP PROCEDURE  [rptSecurityDepositReportByStudentIID]
END
GO
/****** Object:  StoredProcedure [dbo].[GetFeesDeuListbyStudentIID]    **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[rptSecurityDepositReportByStudentIID]  4398
Create Procedure [dbo].[rptSecurityDepositReportByStudentIID]
(
@StudentIID INT
--@Block INT
)
As
BEGIN
SELECT SB.FullName,SB.StudentInsID,C.ClassName,S.SessionName,SB.AdmissionDate, SD.*

FROM [dbo].[Fees_SecurityDepositDetails] SD
INNER JOIN [dbo].[Student_BasicInfo] SB ON SB.StudentIID = SD.StudentIID
INNER JOIN [dbo].[Ins_ClassInfo] C ON C.ClassId=SB.ClassId
INNER JOIN [dbo].[Ins_Session] S ON S.SessionId =SB.SessionId
WHERE SD.StudentIID = @StudentIID --AND 
END