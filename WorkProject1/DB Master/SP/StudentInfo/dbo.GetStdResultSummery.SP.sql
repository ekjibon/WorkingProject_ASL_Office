/****** Object:  StoredProcedure [dbo].[GetStdResultSummery]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStdResultSummery]'))
BEGIN
DROP PROCEDURE  GetStdResultSummery
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   [GetStdResultSummery] 93
CREATE PROCEDURE [dbo].[GetStdResultSummery] 
	@StudentId INT 
AS
BEGIN

CREATE TABLE #tempResult
(
	ExamName VARCHAR(100),
	SessionName VARCHAR(100),
	GPA DECIMAL(10,2)

)
	INSERT INTO #tempResult
	SELECT M.MainExamName, S.SessionName ,MR.GPA
	FROM Res_MainExamResult MR 
	INNER JOIN Res_MainExam M ON M.MainExamId = MR.MainExamId
	INNER JOIN Ins_Session S ON S.SessionId = M.SessionId
    WHERE StudentIID = @StudentId

	SELECT * FROM #tempResult

	DROP TABLE #tempResult

END

