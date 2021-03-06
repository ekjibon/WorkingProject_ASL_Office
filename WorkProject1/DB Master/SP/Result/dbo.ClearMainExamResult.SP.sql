/****** Object:  StoredProcedure [dbo].[ClearMainExamResult]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ClearMainExamResult]'))
BEGIN
DROP PROCEDURE  ClearMainExamResult
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- [ClearMainExamResult] 3,1,'M'
CREATE PROCEDURE [dbo].[ClearMainExamResult] 
	@ExamId int,
	@ShiftId int,
	@ExamType CHAR(2)
AS
BEGIN
	
	IF(@ExamType='M')
	BEGIN
	DELETE M FROM Res_MainExamResult M
				INNER JOIN Student_BasicInfo S ON S.StudentIID = M.StudentIID
	WHERE [MainExamId] =  @ExamId  AND S.ShiftID = @ShiftId
	DELETE M FROM Res_MainExamResultSubjectDetails M
	INNER JOIN Student_BasicInfo S ON S.StudentIID = M.StudentIID
	WHERE [MainExamId] =  @ExamId AND S.ShiftID = @ShiftId
	DELETE M  FROM Res_MEResultDetails M
	INNER JOIN Student_BasicInfo S ON S.StudentIID = M.StudentIID
	 WHERE [MainExamId] =  @ExamId AND S.ShiftID = @ShiftId

	 IF(@@ROWCOUNT > 0)
	 BEGIN
	 Declare @mainExamName varchar(100)
	 SELECT @mainExamName=MainExamName FROM Res_MainExam WHERE MainExamId =@ExamId
		INSERT INTO [dbo].[Res_ExamProccessLog]([VersionID],[SessionId],[ShiftID],[ClassId],[GroupId],[MainExamId],[PId],[LogTime],[Msg],[AddBy])
     VALUES (0,0,@ShiftId,0,0,@ExamId,@ExamId,GETDATE(), @mainExamName+ ' Exam Cleared !! ','')
	 END

	END
    IF(@ExamType='G')
	BEGIN
	DELETE M FROM Res_GrandResult M
				INNER JOIN Student_BasicInfo S ON S.StudentIID = M.StudentIID
	WHERE GrandExamId =  @ExamId  AND S.ShiftID = @ShiftId

	DELETE M FROM Res_GrandResultSubjectDetails M
	INNER JOIN Student_BasicInfo S ON S.StudentIID = M.StudentIID
	WHERE GrandExamId =  @ExamId AND S.ShiftID = @ShiftId

	DELETE M  FROM Res_GrandResultMarksDetails M
	INNER JOIN Student_BasicInfo S ON S.StudentIID = M.StudentIID
	 WHERE GrandExamId =  @ExamId AND S.ShiftID = @ShiftId
	END

END
