/****** Object:  StoredProcedure [dbo].[GetOptionalSubject]    Script Date: 7/22/2017 4:11:01 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt_StudentMarks]'))
BEGIN
DROP PROCEDURE rpt_StudentMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[rpt_StudentMarks] --'1411dhm113011111sad1004'
(
	@VersionId INT,
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@SubjectID INT,
	@MainExamId INT,
	@SubExamId INT,
	@DividedExamId INT
)
AS
BEGIN
    
	DECLARE @FullMarks DECIMAL = 0; DECLARE	@DividedExamMarkSetupID INT;	
	 
    SELECT @FullMarks= [DividedExamExamMarks]
    FROM [Qry_MarkSetup] where [MainExamId]=@MainExamId and MainExamSubjectID=@SubjectID and SubExamId=@SubExamId and DividedExamId=@DividedExamId
	  SELECT DISTINCT
	   S.StudentInsID  
	  ,S.RollNo	  
	  ,S.FullName 
	  ,ISNULL(M.[IsAbsent],0) AS [IsAbsent]
      ,ISNULL(M.[ObtainMarks],0)AS ObtainMarks
	  ,@FullMarks AS FullMarks	   
	  FROM [dbo].[Res_MainExamMarks] M  	 
	  INNER JOIN Student_BasicInfo AS S  ON M.StudentIID = S.StudentIID 
	   WHERE M.VersionID =  @VersionId AND M.SessionId = @SessionId   AND M.ShiftID = @ShiftID AND M.ClassId = @ClassId 
	   AND M.GroupId = @GroupId AND M.SectionId = @SectionId AND M.MainExamID = @MainExamId AND M.SubExamID =  @SubExamId
	   AND M.DividedExamID = @DividedExamId AND M.IsDeleted=0 AND M.SubjectID=@SubjectID ORDER BY S.RollNo

	  SELECT [VersionName],[BranchName],[ClassName],[SessionName],[ShiftName],[GroupName],[SectionName],
	   (SELECT SubjectName FROM [dbo].[Res_SubjectSetup] WHERE [SubID]=@SubjectID) AS SubjectName,
	   (SELECT MainExamName FROM [dbo].[Res_MainExam] WHERE MainExamId=@MainExamId) AS MainExamName,
	   (SELECT SubExamName FROM Res_SubExam WHERE SubExamId=@SubExamId) AS SubExamName,
	   (SELECT DividedExamName FROM [dbo].[Res_DividedExam] WHERE [DividedExamId]=@DividedExamId) AS DividedExamName
	   FROM view_CommonTableNames
	   WHERE [SessionId]=@SessionId AND [GroupId]=@GroupId AND [ClassId]=@ClassId
	   AND [VersionId]=@VersionId AND [BranchId]=@BranchID AND [ShiftId]=@ShiftID AND [SectionId]=@SectionId


	 --,@VersionId AS [VersionId]
  --    ,@SessionId AS [SessionId]
  --    ,@ShiftID AS [ShiftId]
  --    ,@ClassId AS [ClassId]
  --    ,@GroupId AS [GroupId]
  --    ,@SectionId AS [SectionId]
	 -- ,@SubjectID AS [SubjectID]

	-- exec [GetAllMarks] 2002,2012,1019,9,2011,1,3019,18,103,102,70
	
END

-- exec [GetAllMarks] 1,5,1,1,15,1,50,47,125,133,132


 --select s.RollNo  FROM Student_BasicInfo S 
	--  INNER JOIN Res_StudentSubject ON S.StudentIID = Res_StudentSubject.StudentID AND Res_StudentSubject.SubjectID = 3 order by RollNo
















