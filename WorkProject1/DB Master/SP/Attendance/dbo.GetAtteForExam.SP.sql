/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAtteForExam]'))
BEGIN
DROP PROCEDURE  GetAtteForExam
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[GetAtteForExam] '12/31/2016','2/4/2018', 1,1,1,1,1,0,7,100,0,null
CREATE PROCEDURE [dbo].[GetAtteForExam] 
	@FromDate SmallDateTime, 
	@ToDate SmallDateTime, 
	@VersionId INT,
	@BranchId INT,
	@SessionId INT,
	@ShiftId INT,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT, 	
	@ExamId INT ,
	@IsGrand BIT,
	@SID VARCHAR(150)=NULL

AS
BEGIN
DECLARE @TOTALSTUDENT  INT  =0 , @TOTALEXAMINEE INT = 0
IF(@SID IS NULL)
BEGIN	
	SELECT @TOTALSTUDENT= COUNT(S.StudentIID) FROM Student_BasicInfo AS S WHERE S.IsDeleted=0 AND S.GroupId=@GroupId AND S.ClassId=@ClassId	
	--AND S.VersionID=@VersionId AND S.BranchID = @BranchId AND S.SessionId=@SessionId AND S.ShiftID=@ShiftId AND S.SectionId = @SectionId

	SELECT @TOTALSTUDENT AS TotalStudent, SA.StudentId,S.StudentInsID, S.FullName,CAST( S.RollNo AS INT) AS RollNo , COUNT(SA.InTime) AS Attendance,  ISNULL(EA.PresentDay, 0) as PresentDay ,
	ISNULL(EA.TotalWorkingDays,0) as TotalWorkingDays, ISNULL(EA.ExamAttId, 0) as ExamAttId, CAST(ISNULL(@ExamId,0) AS int) as ExamId , @IsGrand as IsGrand    
	FROM [dbo].[Att_StudentAttendance] SA

	INNER JOIN Student_BasicInfo S ON S.StudentIID = SA.StudentId 
	LEFT OUTER JOIN Att_ExamAttendance EA ON EA.StudentId = SA.StudentId AND EA.ExamId = @ExamId AND IsGrand = @IsGrand

	WHERE CAST( SA.InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND S.IsDeleted=0 AND S.SectionId=@SectionId AND S.ShiftID = @ShiftId AND
	S.SessionId=@SessionId AND S.VersionID=@VersionId AND S.BranchID=@BranchId AND S.GroupId=@GroupId AND S.ClassId=@ClassId
	GROUP BY SA.StudentId,S.FullName, S.RollNo,EA.PresentDay,S.StudentInsID, EA.TotalWorkingDays, EA.ExamAttId
	ORDER BY  
		(CASE WHEN ISNUMERIC( S.RollNo )=1 THEN CAST(S.RollNo AS INT)
			ELSE S.RollNo 
			END)

END
ELSE
BEGIN

	DECLARE @CID INT, @GID INT
	SELECT @CID=S.ClassId, @GID=S.GroupId FROM Student_BasicInfo AS S WHERE S.IsDeleted=0 AND S.StudentInsID=@SID
	SELECT @TOTALSTUDENT= COUNT(S.StudentIID) FROM Student_BasicInfo AS S WHERE S.IsDeleted=0 AND S.GroupId=@GroupId AND S.ClassId=@ClassId		

	SELECT @TOTALSTUDENT AS TotalStudent, SA.StudentId,S.StudentInsID, S.FullName,S.RollNo , COUNT(SA.InTime) AS Attendance,  ISNULL(EA.PresentDay, 0) as PresentDay ,
	ISNULL(EA.TotalWorkingDays,0) as TotalWorkingDays, ISNULL(EA.ExamAttId, 0) as ExamAttId, CAST(ISNULL(@ExamId,0) AS int) as ExamId , @IsGrand as IsGrand    FROM [dbo].[Att_StudentAttendance] SA

	INNER JOIN Student_BasicInfo S ON S.StudentIID = SA.StudentId 
	LEFT OUTER JOIN Att_ExamAttendance EA ON EA.StudentId = SA.StudentId AND EA.ExamId = @ExamId AND IsGrand = @IsGrand

	WHERE CAST( SA.InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND S.StudentIID=@SID AND S.IsDeleted=0 
	GROUP BY SA.StudentId,S.FullName, S.RollNo,EA.PresentDay,S.StudentInsID, EA.TotalWorkingDays, EA.ExamAttId
	ORDER BY S.RollNo
END		 

END



