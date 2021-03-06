
/****** Object:  StoredProcedure [dbo].[GetPortalResult]    Script Date: 1/22/2019 11:49:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPortalResult]'))
BEGIN
DROP PROCEDURE  GetPortalResult
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Comments --
-- EXEC GetPortalResult 77

CREATE PROCEDURE [dbo].[GetPortalResult] 
	@SId INT
AS
BEGIN
	CREATE TABLE #Result
	(
		Id INT,
		ExamName VARCHAR(50),
		SessionName VARCHAR(50),
		TotalMarks DECIMAL(10,2),
		GPA DECIMAL(10,2),
		GradeLetter VARCHAR(5),
		[Status] VARCHAR(20),
		DisplayOrder INT, 
		OverAllMerit INT,
	)

	INSERT INTO #Result
	SELECT M.MainExamId, M.MainExamName , SS.SessionName,
	--R.TotalMarks,
	R.GPA,R.GradeLetter,
	--CASE WHEN R.IsPass=1 THEN 'Passed' ELSE 'Failed' END,
	M.MainExamGrandShowOrder
	--,R.OverAllMerit
	FROM Res_MainExamResult R 
	INNER JOIN Res_MainExam M ON M.MainExamId = R.MainExamId
	INNER JOIN Student_BasicInfo SB ON SB.StudentIID = R.StudentIID
	INNER JOIN Ins_Session SS ON SS.SessionId = SB.SessionId 
	WHERE R.StudentIID =@SId
	ORDER BY M.MainExamGrandShowOrder ASC


	SELECT * FROM #Result ORDER BY DisplayOrder
	DROP TABLE #Result

END
