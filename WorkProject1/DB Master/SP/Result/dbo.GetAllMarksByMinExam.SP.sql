/****** Object:  StoredProcedure [dbo].[GetAllMarks]    Script Date: 7/22/2017 4:04:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllMarksByMinExam]'))
BEGIN
DROP PROCEDURE  GetAllMarksByMinExam
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
-- [GetAllMarksByMinExam]  11,8,4,26,107,55,1068,4777,2
CREATE PROCEDURE [dbo].[GetAllMarksByMinExam] 
	@SessionId INT=NULL,
	@BranchID INT=NULL,
	@ShiftID INT=NULL ,
	@ClassId INT=NULL,
	@SectionId INT=NULL,
	@SubjectID INT=NULL,
	@MainExamId INT=NULL,
	@StudentId INT=NULL,
	@Block INT
AS
BEGIN
DECLARE @TermId INT=0;
SET @TermId=( select TermId from res_mainexam where MainExamId=@MainExamId)
	IF(@Block=1)
	BEGIN
		DECLARE @MAINEXAMNAME VARCHAR(50)
		
		SELECT @MAINEXAMNAME=[MainExamName] FROM [dbo].[Res_MainExam] WHERE [MainExamId]=@MainExamId AND IsDeleted=0	

		SELECT DISTINCT @MainExamId AS MainExamId, @MAINEXAMNAME AS MainExamName, B.StudentIID, B.StudentInsID,B.FullName, B.RollNo  
		,ctn.SessionName,ctn.BranchName,ctn.ShiftName,ctn.ClassName,
		ctn.SectionName,sub.SubjectName
		FROM Student_BasicInfo AS B
		INNER JOIN Res_StudentSubject AS SS ON B.StudentIID = SS.StudentID AND SS.SubjectID = @SubjectID AND SS.TermId=	@TermId
		INNER JOIN view_CommonTableNames ctn on ctn.SessionId=B.SessionId and ctn.ShiftId= B.ShiftID AND ctn.ClassId=B.ClassId and ctn.SectionId=B.SectionId
		INNER JOIN Res_SubjectSetup sub on sub.SubID=ss.SubjectID
		WHERE B.SessionId=@SessionId AND B.ShiftID=@ShiftID
		AND B.BranchID=@BranchID AND B.ClassId=@ClassId AND B.SectionId=@SectionId AND B.IsDeleted=0 
	END
	IF(@Block=2)
	BEGIN	-- [GetAllMarksByMinExam] 10,8,2,19,76,1,1,13798,2
		
		SELECT DISTINCT ISNULL(M.MarksId,0) AS MarksId, @StudentId AS StudentIId, S.MainExamId, S.SubExamId,
		S.SubExamExamMarks as FullMarks,ISNULL(M.ObtainMarks,0) AS Marks,CAST( ISNULL( M.IsAbsent,0) AS BIT) IsAbsent,
		(SELECT SubExamName FROM Res_SubExam WHERE SubExamId=S.SubExamId and s.SubjectId=s.SubjectId) AS SubExamName,
		ISNULL(M.ObtainMarks,0) AS Marks,CAST( ISNULL( M.IsAbsent,0) AS BIT) IsAbsent, @SubjectID	AS SubjectId
		FROM [Qry_MarkSetup] AS S 
		LEFT JOIN [dbo].[Res_MainExamMarks] AS M ON S.MainExamId=M.MainExamID AND S.SubExamId=M.SubExamID and s.SubjectId=@SubjectID

		AND M.IsDeleted=0 AND M.StudentIID=@StudentId AND (M.SubjectID=@SubjectID)  -- OR @SubjectID=0) 
		AND M.SessionId=@SessionId AND M.ShiftId=@ShiftID
		AND M.ClassId=@ClassId AND M.SectionId=@SectionId 
		INNER JOIN dbo.Res_StudentSubject ss on ss.StudentID=@StudentId AND SS.TermId=	@TermId
		
		WHERE   S.MainExamId =@MainExamId AND (S.MainExamSubjectID=@SubjectID)  and s.SubjectId=@SubjectID AND S.SectionId = @SectionId
		order by s.SubExamId
	END	
	IF(@Block=3)
	BEGIN
		
    	-- [GetAllMarksByMinExam] 1,6,1,1,10,1,103,125,12,'',3
    	SELECT DISTINCT B.FullName, B.StudentIID, B.StudentInsID, CAST( B.RollNo   AS INT) RollNo,		
		S.MainExamId, (SELECT MainExamName FROM [dbo].[Res_MainExam] WHERE MainExamId=S.MainExamId) AS MainExamName, 
		S.SubExamId, (SELECT SubExamName FROM Res_SubExam WHERE SubExamId=S.SubExamId AND SectionId = @SectionId) AS SubExamName,
		ISNULL(M.ObtainMarks,0) AS Marks, CAST( ISNULL( M.IsAbsent,0) AS BIT) AS IsAbsent,
		M.SubjectID	AS SubjectId
		FROM [Qry_MarkSetup] AS S  
		INNER JOIN [dbo].[Res_MainExamMarks] AS M ON S.MainExamSubjectID=M.SubjectID AND S.MainExamId=M.MainExamID AND S.SubExamId=M.SubExamID 
		AND M.SessionId=@SessionId AND  M.ClassId=@ClassId
	   AND M.ShiftID=@ShiftID AND M.SectionId=@SectionId 
		INNER JOIN Student_BasicInfo AS B ON M.StudentIID = B.StudentIID AND B.IsDeleted=0 AND B.[Status]='A'
		AND B.SessionId=@SessionId AND B.ClassId=@ClassId
	    AND B.BranchID=@BranchID AND B.ShiftID=@ShiftID AND B.SectionId=@SectionId 
		WHERE   S.MainExamId=@MainExamId AND S.MainExamSubjectID=@SubjectID
		order BY CAST(b.RollNo as int) desc

	   SELECT [BranchName],[ClassName],[SessionName],[ShiftName],[SectionName],
	   (SELECT SubjectName FROM [dbo].[Res_SubjectSetup] WHERE [SubID]=@SubjectID) AS SubjectName	 
	   FROM view_CommonTableNames
	   WHERE [SessionId]=@SessionId AND [ClassId]=@ClassId
	   AND [BranchId]=@BranchID AND [ShiftId]=@ShiftID AND [SectionId]=@SectionId

	END
	IF(@Block=4)
	BEGIN
		DECLARE @TotalStudent INT, @Exam INT, @TotalExam INT, @StudentMarksEntry INT, @StudentZeroMarksEntry INT, @StudentAbsentMarksEntry INT, @StudentMarksNotInputed INT
		SELECT @TotalStudent=COUNT(*) FROM [Res_StudentSubject] WHERE SubjectID=@SubjectID AND StudentID IN (SELECT StudentIID FROM [Student_BasicInfo] AS B
		WHERE  B.SessionId=@SessionId AND B.BranchID=@BranchID AND B.ShiftID=@ShiftID AND B.ClassID=@ClassId
		AND B.SectionID=@SectionId AND B.IsDeleted=0) 
			
			
			SET @TotalExam=@TotalStudent*@Exam

			SELECT @StudentMarksEntry=COUNT(M.MarksId) FROM Res_MainExamMarks AS M  WHERE M.SessionId=@SessionId
			AND M.ShiftId=@ShiftID AND M.ClassId=@ClassId AND  M.SectionId=@SectionId AND M.SubjectID=@SubjectID AND M.MainExamID=@MainExamId
			AND M.IsDeleted=0 AND M.IsAbsent=0 AND M.ObtainMarks>0

			SELECT @StudentZeroMarksEntry=COUNT(M.MarksId) FROM Res_MainExamMarks AS M  WHERE M.SessionId=@SessionId
			AND M.ShiftId=@ShiftID AND M.ClassId=@ClassId AND M.SectionId=@SectionId AND M.SubjectID=@SubjectID AND M.MainExamID=@MainExamId
			AND M.IsDeleted=0 AND M.IsAbsent=0 AND M.ObtainMarks=0
			
			SELECT @StudentAbsentMarksEntry=COUNT(M.MarksId) FROM Res_MainExamMarks AS M  WHERE M.SessionId=@SessionId
			AND M.ShiftId=@ShiftID AND M.ClassId=@ClassId AND M.SectionId=@SectionId AND M.SubjectID=@SubjectID AND M.MainExamID=@MainExamId
			AND M.IsDeleted=0 AND M.IsAbsent=1 AND M.ObtainMarks=0
			SET @StudentMarksNotInputed=@TotalExam-(@StudentMarksEntry+@StudentZeroMarksEntry+@StudentAbsentMarksEntry)
			SELECT @Exam, @TotalStudent AS TotalStudent, @TotalExam AS TotalExam, @StudentMarksEntry AS StudentMarksEntry, @StudentZeroMarksEntry AS StudentZeroMarksEntry, @StudentAbsentMarksEntry AS StudentAbsentMarksEntry, @StudentMarksNotInputed AS StudentMarksNotInputed		

	END

	IF(@Block=5)
	BEGIN
	/*@VersionId INT=NULL,
	@SessionId INT=NULL,
	@BranchID INT=NULL,
	@ShiftID INT=NULL ,
	@ClassId INT=NULL,
	@GroupId INT=NULL,
	@SectionId INT=NULL,
	@SubjectID INT=NULL,
	@MainExamId INT=NULL,
	@StudentId INT=NULL,
	@Block INT*/
	--    GetAllMarksByMinExam  @Block=5,@ClassId=11,@groupID=1,@SectionId=44,@MainExamId=11,@SubjectID=120
	--    GetAllMarksByMinExam  @Block=5,@ClassId=9,@groupID=0,@SectionId=38,@MainExamId=9,@SubjectID=91
		--DECLARE @MAINEXAMNAME VARCHAR(50)
		SELECT @MAINEXAMNAME=[MainExamName] FROM [dbo].[Res_MainExam] WHERE [MainExamId]=@MainExamId AND IsDeleted=0	

		SELECT   @MainExamId AS MainExamId, @MAINEXAMNAME AS MainExamName, B.StudentIID, B.StudentInsID,B.FullName, B.RollNo  
		,ctn.SessionName,ctn.BranchName,ctn.ShiftName,ctn.ClassName,
		ctn.SectionName,sub.SubjectName,sub.SubID as SubjectID
		FROM Student_BasicInfo AS B
		left JOIN Res_StudentSubject AS SS ON B.StudentIID = SS.StudentID AND SS.SubjectID = @SubjectID AND SS.TermId=	@TermId	--and ss.IsDeleted=0
		left JOIN view_CommonTableNames ctn on ctn.SessionId=B.SessionId and ctn.ShiftId= B.ShiftID AND ctn.ClassId=B.ClassId AND ctn.SectionId=B.SectionId
		left JOIN Res_SubjectSetup sub on sub.SubID=ss.SubjectID		
		WHERE (B.SessionId=@SessionId OR @SessionId is null) AND (B.ShiftID=@ShiftID OR @ShiftID is null)
		AND (B.BranchID=@BranchID OR @BranchID is null) AND (B.ClassId=@ClassId OR @ClassId  is null) AND 
		(B.SectionId=@SectionId OR @SectionId is null) AND B.IsDeleted=0 and sub.IsDeleted=0 --and ss.IsDeleted=0
		order by cast( RollNo as int)
	END
	IF(@Block=6)--not in use
	BEGIN	-- [GetAllMarksByMinExam] 1,6,1,1,9,1,104,91,6,2660,2
		--    GetAllMarksByMinExam  @Block=6,@ClassId=3,@SectionId=124,@StudentId=19473

		--DECLARE @DivExamCount INT;
		
		SELECT DISTINCT ISNULL(M.MarksId,0) AS MarksId, @StudentId AS StudentIId, S.MainExamId, S.SubExamId
		,CAST( ISNULL( M.IsAbsent,0) AS BIT) IsAbsent, @SubjectID	AS SubjectId
		 ,sub.SubjectName
		FROM [Qry_MarkSetup] AS S  
		LEFT   JOIN [dbo].[Res_MainExamMarks] AS M ON S.MainExamId=M.MainExamID AND S.SubExamId=M.SubExamID 
		INNER JOIN Res_StudentSubject AS SS ON SS.StudentID = @StudentId AND SS.TermId=	@TermId	
		INNER JOIN Res_SubjectSetup sub on sub.SubID=ss.SubjectID		
		AND M.IsDeleted=0 AND M.StudentIID=@StudentId --AND M.SubjectID=@SubjectID 
		WHERE   S.MainExamId=@MainExamId --AND S.MainExamSubjectID=@SubjectID
		
	END	
END

--select * from dbo.Qry_MarkSetup where MainExamId=6 and MainExamSubjectID=91
--select * from dbo.Res_DividedExamMarkSetup where SubExamMarkSetupId=161


--7delete dbo.Res_MainExamMarks where StudentIID=2704 and SubjectID=91
