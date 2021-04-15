IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAttendanceDashBoardData]'))
BEGIN
DROP PROCEDURE  [GetAttendanceDashBoardData]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Comments --
-- EXEC [GetAttendanceDashBoardData]

CREATE PROCEDURE [dbo].[GetAttendanceDashBoardData]
AS
BEGIN

SELECT SB.FullName
		,SB.StudentInsID,CAST(CAST(SL.AddDate AS Date) AS varchar) AS AddDate
		,SL.[Status] FROM dbo.Att_StudentAttendance SA
		INNER JOIN dbo.Att_StudentLeave SL ON SL.StudentIId = SA.StudentId
		INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIId = SA.StudentId
		WHERE IsLeave = 1 AND SL.[Status] = 'Pending' AND SL.IsDeleted = 0 AND SA.IsDeleted = 0


SELECT  SB.StudentIID
		,CAST(SA.InTime AS TIME)  AS InTime
		,CAST(SA.OutTime AS TIME)  AS OutTime,
		SB.FullName,SA.LateTime
		,SB.StudentInsID
		FROM dbo.Att_StudentAttendance SA
		INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIId = SA.StudentId
		WHERE  SA.IsDeleted = 0 AND (SA.IsLate = 1  OR SA.IsEarlyOut = 1)
END

