/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoEnrollmentList]'))
BEGIN
DROP PROCEDURE  [GetStudentInfoEnrollmentList]
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

  CREATE PROCEDURE [dbo].[GetStudentInfoEnrollmentList] 
(
    @Block INT=0,
	@SessionId INT=null,
	@BranchId INT=null,
	@ShiftId INT =null,
	@ClassId INT = null,
	@Section INT = null
)	
AS
BEGIN
		IF(@SessionId=0) SET @SessionId = NULL;
		IF(@BranchId=0) SET @BranchId = NULL;
		IF(@ShiftId=0) SET @ShiftId = NULL;
		IF(@ClassId=0) SET @ClassId = NULL;
		IF(@Section=0) SET @Section = NULL;
 
	IF(@Block=1)
	BEGIN 
	    SELECT * FROM dbo.Student_BasicInfo
	END	
	
END








