
/****** Object:  StoredProcedure [dbo].[GetStudentAttendence]    Script Date: 1/24/2019 10:59:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentAttendence]'))
BEGIN
DROP PROCEDURE  GetStudentAttendence
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- execute [dbo].[GetStudentAttendence] 3109
CREATE PROCEDURE [dbo].[GetStudentAttendence] 
    @StudentId VARCHAR(50),
	@Month INT=0
AS
BEGIN
	IF @Month = 0
		SELECT * FROM dbo.Att_StudentAttendance WHERE StudentId = @StudentId AND YEAR(InTime) = YEAR(GETDATE()) AND IsPresent = 1 AND IsLeave = 0
	ELSE
		SELECT * FROM dbo.Att_StudentAttendance WHERE StudentId = @StudentId 
		AND YEAR(InTime) = YEAR(GETDATE()) AND IsPresent = 1 AND IsLeave = 0 AND MONTH(InTime) = @Month

END


