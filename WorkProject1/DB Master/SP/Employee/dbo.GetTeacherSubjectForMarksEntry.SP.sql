/****** Object:  StoredProcedure [dbo].[ProccessMainExam]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetTeacherSubjectForMarksEntry]'))
BEGIN
DROP PROCEDURE  GetTeacherSubjectForMarksEntry
END
GO							--- GetTeacherSubjectForMarksEntry '3b864d8e-c9c8-484d-b470-ab2146a388ae',5
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTeacherSubjectForMarksEntry] 
(
 @TeacherId varchar(150),
 @BlockId int
)
AS
BEGIN
	IF(@BlockId=1)
	BEGIN
		DECLARE @TID INT
		SELECT @TID = EmpId FROM [dbo].[AspNetUsers] WHERE Id=@TeacherId

	SELECT DISTINCT --A.[AssignSubID], 
	     @TeacherId as TeacherUserId,
		  V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName], V.[SectionName],
		   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId], A.[TeacherID], E.[FullName],
		   A.[SubjectID], S.[SubjectName], A.[MainExamID], m.[MainExamName],m.IsEnableForMakrsEntry,t.TermId, t.Name as TermName,E.IsClassTeacher --,A.[SubExamID], VE.[SubExamName], A.[DivideExamID], VE.[DividedExamName],
		   --ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE MainExamId=A.MainExamID AND SubExamId=A.SubExamID
		   --AND DividedExamId=A.DivideExamID AND SubjectID=A.SubjectID AND A.IsDeleted=0),0) AS MARKS  
FROM [dbo].[Res_AssignSubjectsToTeacher] AS A 
		   INNER JOIN [view_CommonTableNames] AS V ON  A.BranchID=V.BranchId AND A.ClassID=V.ClassId
		   AND A.SessionID=V.SessionId AND A.ShiftID=V.ShiftId AND A.SectionID=V.SectionId
		   INNER JOIN Emp_BasicInfo AS E ON A.TeacherID=E.EmpBasicInfoID AND E.IsDeleted=0
		   INNER JOIN Res_MainExam m on m.MainExamID=A.MainExamID
		   INNER JOIN dbo.Res_Terms T on T.TermId=M.TermId
		  -- AND VE.IsEnableForMakrsEntry = 1 --AND A.SubExamID=VE.SubExamId AND A.DivideExamID=VE.DividedExamId
		   INNER JOIN Res_SubjectSetup AS S ON A.SubjectID=S.SubID
		   --LEFT JOIN Res_MainExamMarks AS ME ON A.MainExamID=ME.MainExamID
		   WHERE A.TeacherID=@TID AND A.IsDeleted=0  
		 group by V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName],  V.[SectionName],
		   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId], A.[TeacherID], E.[FullName],
		   A.[SubjectID], S.[SubjectName], A.[MainExamID] ,m.[MainExamName],m.IsEnableForMakrsEntry,E.IsClassTeacher,t.TermId, t.Name --,A.[DivideExamID], VE.[DividedExamName]
		   ORDER BY V.[SessionId], V.[BranchId], V.[ShiftId], V.[ClassId], V.[SectionId], A.[SubjectID] 
	END
		
	IF(@BlockId=2) -- [GetTeacherSubjectForMarksEntry] '059ef886-40bc-44bd-9149-c065e7b8e05e',2
	BEGIN
		DECLARE @TeachersID VARCHAR(100), @UserId VARCHAR(50), @Name VARCHAR(150), @MainExamName VARCHAR(100)
		SELECT @TID = EmpId, @UserId=UserName FROM [dbo].[AspNetUsers] WHERE Id=@TeacherId
		SELECT @TeachersID=EmpID, @Name=FullName FROM Emp_BasicInfo WHERE EmpBasicInfoID=@TID AND IsDeleted=0
		Declare @Totalrow int;
		declare @Counter int =1;
		DECLARE @Class int, @IND INT=0;
	SELECT DISTINCT	 
      C.SessionName AS [Session]
      ,C.BranchName AS [Branch]
      ,C.ShiftName AS [Shift]
      ,C.ClassName AS [Class]
      ,C.SectionName AS [Section]
      ,[TeacherID]
      ,S.SubjectName AS [Subject]
      ,E.MainExamName AS [MainExam]	     
	  ,E.SubExamName	  
	
	  ,(SELECT COUNT(*) FROM [Res_StudentSubject] WHERE SubjectID=A.SubjectID AND StudentID IN (SELECT StudentIID FROM [Student_BasicInfo] AS B
		WHERE  B.SessionId=A.SessionID AND B.BranchID=A.BranchID AND B.ShiftID=A.ShiftID AND B.ClassID=A.ClassId
		 AND B.SectionID=A.SectionId AND B.IsDeleted=0)) AS TotalStudent
	  ,0 AS MarksEntry
	  ,C.SessionId
	  ,C.BranchId
	  ,C.ShiftId
	  ,C.ClassId
	  ,C.SectionId	
	  ,A.SubjectID
	  ,E.MainExamId AS MainExamID
	  ,E.SubExamId AS SubExamID
	   INTO #TempList
  FROM [Res_AssignSubjectsToTeacher] AS A
  INNER JOIN [view_CommonTableNames] AS C ON  A.SessionID=C.SessionId AND A.BranchID=C.BranchId AND A.ShiftID=C.ShiftId
  AND A.ClassID=C.ClassId  AND A.SectionID=C.SectionId AND A.IsDeleted=0
  INNER JOIN Res_SubjectSetup AS S ON A.SubjectID=S.SubID AND S.IsDeleted=0
  INNER JOIN [vwMainExam] AS E ON A.MainExamID=E.MainExamId AND A.SubExamID=E.SubExamId   AND E.IsEnableForMakrsEntry =1
  INNER JOIN [Qry_MarkSetup] AS M ON M.MainExamSubjectID=A.SubjectID AND A.MainExamID=M.MainExamId AND A.SubExamID=M.SubExamId AND A.IsDeleted=0  
  WHERE A.TeacherID=@TID AND A.IsDeleted=0 
  SELECT  ROW_NUMBER() over( order by SubExamID) as SLNO, * INTO #Temp FROM #TempList
	  SET @Totalrow=@@ROWCOUNT		
	  WHILE @Counter<=@Totalrow
	  BEGIN
			DECLARE @StudentMarksEntry INT
			SELECT @StudentMarksEntry=COUNT(M.MarksId) FROM Res_MainExamMarks AS M INNER JOIN #Temp AS T ON  M.SessionId=T.SessionId
			AND M.ShiftId=T.ShiftId AND M.ClassId=T.ClassId  AND M.SectionId=T.SectionId AND M.SubjectID=T.SubjectID AND M.MainExamID=T.MainExamId
			AND M.SubExamID=T.SubExamId AND M.IsDeleted=0 AND T.SLNO=@Counter
			UPDATE #Temp SET MarksEntry=TotalStudent-@StudentMarksEntry WHERE SLNO=@Counter
			--SELECT * FROM #Temp
			SET @StudentMarksEntry = NULL 
		SET @Counter=@Counter+1;
		print @Counter
	  END
	    SELECT DISTINCT ClassId INTO #CLASS1 FROM #Temp 
	    SELECT  @TeachersID AS TeachersID, @UserId AS UserId, @Name AS [Name], ClassId, ROW_NUMBER() over( order by ClassId) AS SLNO INTO #CLASS FROM #CLASS1 
		SET @Class=@@ROWCOUNT
		SELECT * FROM #CLASS
		WHILE(@IND<=@Class)
		BEGIN
		SELECT  [Session], [Branch], [Shift], [Class], 
		[Section], [Subject], [MainExam], SubExamName, TotalStudent, MarksEntry 
		INTO #PIVOT FROM #Temp WHERE ClassId=(SELECT ClassId FROM #CLASS WHERE SLNO=@IND)		

			DECLARE @cols AS NVARCHAR(MAX),
				@query  AS NVARCHAR(MAX);

			--SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.Exam) 
			--			FROM #PIVOT c
			--			FOR XML PATH(''), TYPE
			--			).value('.', 'NVARCHAR(MAX)') 
			--		,1,1,'')

			set @query = 'SELECT  Session, Branch, Shift, Class,
		Section,Subject, MainExam, TotalStudent, ' + @cols + ' from 
						(
						SELECT  Session, Branch, Shift, Class,
		Section,Subject, MainExam, Exam, TotalStudent, MarksEntry
							from #PIVOT
					   ) x
						pivot 
						(
							 max(MarksEntry)
							for Exam in (' + @cols + ')
						) p '


			execute(@query)

			drop table #PIVOT

		--SELECT @IND
		SET @IND=@IND+1
		END
		--SELECT @TeachersID AS TeachersID,@UserId AS UserId,@Name AS [Name], @MainExamName,* FROM #Temp
		DROP TABLE #TempList, #Temp,#CLASS1,#CLASS
	END


	IF(@BlockId=3)   -- [GetTeacherSubjectForMarksEntry] '059ef886-40bc-44bd-9149-c065e7b8e05e',3
	BEGIN
		DECLARE @TEID INT
		SELECT @TEID = EmpId FROM [dbo].[AspNetUsers] WHERE Id=@TeacherId

	SELECT DISTINCT --A.[AssignSubID],
		  V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName], V.[SectionName],
		   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId], A.[TeacherID], E.[FullName],
		   A.[SubjectID], S.[SubjectName], A.[MainExamID], m.[MainExamName],m.IsEnableForMakrsEntry,t.TermId, t.Name as TermName,E.IsClassTeacher --,A.[SubExamID], VE.[SubExamName], A.[DivideExamID], VE.[DividedExamName],
		   --ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE MainExamId=A.MainExamID AND SubExamId=A.SubExamID
		   --AND DividedExamId=A.DivideExamID AND SubjectID=A.SubjectID AND A.IsDeleted=0),0) AS MARKS  
		FROM [dbo].[Res_AssignSubjectsToTeacher] AS A 
		   INNER JOIN [view_CommonTableNames] AS V ON  A.BranchID=V.BranchId AND A.ClassID=V.ClassId
		   AND A.SessionID=V.SessionId AND A.ShiftID=V.ShiftId AND A.SectionID=V.SectionId
		   INNER JOIN Emp_BasicInfo AS E ON A.TeacherID=E.EmpBasicInfoID AND E.IsDeleted=0
		   INNER JOIN Res_MainExam m on m.MainExamID=A.MainExamID
		   INNER JOIN dbo.Res_Terms T on T.TermId=M.TermId
		  -- AND VE.IsEnableForMakrsEntry = 1 --AND A.SubExamID=VE.SubExamId AND A.DivideExamID=VE.DividedExamId
		   INNER JOIN Res_SubjectSetup AS S ON A.SubjectID=S.SubID
		   --LEFT JOIN Res_MainExamMarks AS ME ON A.MainExamID=ME.MainExamID
		   WHERE A.TeacherID=@TEID AND A.IsDeleted=0  
		 group by V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName],  V.[SectionName],
		   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId], A.[TeacherID], E.[FullName],
		   A.[SubjectID], S.[SubjectName], A.[MainExamID] ,m.[MainExamName],m.IsEnableForMakrsEntry,E.IsClassTeacher,t.TermId, t.Name --,A.[DivideExamID], VE.[DividedExamName]
		   ORDER BY V.[SessionId], V.[BranchId], V.[ShiftId], V.[ClassId], V.[SectionId], A.[SubjectID] 
	END
	IF(@BlockId=4)   -- [GetTeacherSubjectForMarksEntry] '059ef886-40bc-44bd-9149-c065e7b8e05e',4
	BEGIN
		DECLARE @CTEID INT
		SELECT @CTEID = EmpId FROM [dbo].[AspNetUsers] WHERE Id=@TeacherId
		PRINT @CTEID

	SELECT DISTINCT --A.[AssignSubID],
		  V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName], V.[SectionName],
		   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId],E.[FullName],
		 E.IsClassTeacher 
		 --,A.[SubExamID], VE.[SubExamName], A.[DivideExamID], VE.[DividedExamName],
		   --ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE MainExamId=A.MainExamID AND SubExamId=A.SubExamID
		   --AND DividedExamId=A.DivideExamID AND SubjectID=A.SubjectID AND A.IsDeleted=0),0) AS MARKS  
		FROM [dbo].Emp_ClassTeacher AS ECT 
		   INNER JOIN [view_CommonTableNames] AS V ON  ECT.BranchID=V.BranchId AND ECT.ClassID=V.ClassId
		   AND ECT.SessionID=V.SessionId AND ECT.ShiftID=V.ShiftId AND ECT.SectionID=V.SectionId
		   INNER JOIN Emp_BasicInfo AS E ON ECT.TeacherID=E.EmpBasicInfoID AND E.IsDeleted=0
		   --INNER JOIN Res_MainExam m on m.MainExamID=A.MainExamID
		   --INNER JOIN dbo.Res_Terms T on T.TermId=M.TermId
		  -- AND VE.IsEnableForMakrsEntry = 1 --AND A.SubExamID=VE.SubExamId AND A.DivideExamID=VE.DividedExamId
		   --INNER JOIN Res_SubjectSetup AS S ON A.SubjectID=S.SubID
		   --LEFT JOIN Res_MainExamMarks AS ME ON A.MainExamID=ME.MainExamID
		   WHERE ECT.TeacherID=@CTEID AND ECT.IsDeleted=0  
		 group by V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName],  V.[SectionName],
		   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId],E.[FullName],
		   E.IsClassTeacher --,A.[DivideExamID], VE.[DividedExamName]
		   ORDER BY V.[SessionId], V.[BranchId], V.[ShiftId], V.[ClassId], V.[SectionId]

		   -- SELECT * FROM [dbo].Emp_ClassTeacher WHERE TeacherID = 73
	END


	IF(@BlockId=5)  --GetTeacherSubjectForMarksEntry '3b864d8e-c9c8-484d-b470-ab2146a388ae',5
	BEGIN
		DECLARE @TeacID INT
		SELECT @TeacID = EmpId FROM [dbo].[AspNetUsers] WHERE Id=@TeacherId
		--PRINT 
	SELECT DISTINCT --A.[SubjectID], 
	     @TeacherId as TeacherUserId,
			V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName], V.[SectionName],
		   V.[SessionId]
		   ,V.[ClassId]
		   ,V.[BranchId]
		   , V.[ShiftId]
		   ,V.[SectionId]
		   ,A.[TeacherID]
		   ,E.[FullName],
		   A.[SubjectID], S.[SubjectName], A.[MainExamID], m.[MainExamName],m.IsEnableForMakrsEntry,t.TermId
		   ,t.Name as TermName,E.IsClassTeacher 
		   --,A.[SubExamID], VE.[SubExamName], A.[DivideExamID], VE.[DividedExamName],
		   --ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE MainExamId=A.MainExamID AND SubExamId=A.SubExamID
		   --AND DividedExamId=A.DivideExamID AND SubjectID=A.SubjectID AND A.IsDeleted=0),0) AS MARKS  
	FROM dbo.Emp_ClassTeacher ECT 
	       INNER JOIN [dbo].[Res_AssignSubjectsToTeacher] AS A ON A.TeacherID = ECT.TeacherId
							AND A.ClassId = ECT.ClassId AND A.SectionID = ECT.SectionId AND A.ShiftID = ECT.ShiftId AND A.BranchID = ECT.BranchId
							AND A.SessionID = ECT.SessionId 
		   INNER JOIN [view_CommonTableNames] AS V ON  ECT.BranchID=V.BranchId AND ECT.ClassID=V.ClassId
						AND ECT.SessionID=V.SessionId AND ECT.ShiftID=V.ShiftId AND ECT.SectionID=V.SectionId
		   INNER JOIN Emp_BasicInfo AS E ON A.TeacherID=E.EmpBasicInfoID AND E.IsDeleted=0
		   INNER JOIN Res_MainExam m on m.MainExamID=A.MainExamID
		   INNER JOIN dbo.Res_Terms T on T.TermId=M.TermId
		  -- AND VE.IsEnableForMakrsEntry = 1 --AND A.SubExamID=VE.SubExamId AND A.DivideExamID=VE.DividedExamId
		   INNER JOIN Res_SubjectSetup AS S ON A.SubjectID=S.SubID
		   --LEFT JOIN Res_MainExamMarks AS ME ON A.MainExamID=ME.MainExamID
		   WHERE A.TeacherID=@TeacID AND A.IsDeleted=0  AND ECT.IsDeleted = 0
		 group by V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName],  V.[SectionName],
		   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId], A.[TeacherID], E.[FullName],
		   A.[SubjectID], S.[SubjectName], A.[MainExamID] ,m.[MainExamName],m.IsEnableForMakrsEntry,E.IsClassTeacher,t.TermId, t.Name --,A.[DivideExamID], VE.[DividedExamName]
		   ORDER BY V.[SessionId], V.[BranchId], V.[ShiftId], V.[ClassId], V.[SectionId], A.[SubjectID] 
	END
		IF(@BlockId=6)  --GetTeacherSubjectForMarksEntry '3b864d8e-c9c8-484d-b470-ab2146a388ae',5
	BEGIN
		DECLARE @TeachID INT
		SELECT @TeachID = EmpId FROM [dbo].[AspNetUsers] WHERE Id=@TeacherId
		--PRINT 
	SELECT DISTINCT --A.[SubjectID], 
	     @TeacherId as TeacherUserId,
			V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName], V.[SectionName],
		   V.[SessionId]
		   ,V.[ClassId]
		   ,V.[BranchId]
		   , V.[ShiftId]
		   ,V.[SectionId]
		   ,ECT.[TeacherId]
		   ,t.TermId
		   ,E.[FullName]
			, EM.[MainExamName],EM.IsEnableForMakrsEntry,EM.MainExamId AS [MainExamID]
			,E.IsClassTeacher 
			 ,t.Name as TermName
		   --,A.[SubExamID], VE.[SubExamName], A.[DivideExamID], VE.[DividedExamName],
		   --ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE MainExamId=A.MainExamID AND SubExamId=A.SubExamID
		   --AND DividedExamId=A.DivideExamID AND SubjectID=A.SubjectID AND A.IsDeleted=0),0) AS MARKS  
	FROM dbo.Emp_ClassTeacher ECT 
	       
		   INNER JOIN [view_CommonTableNames] AS V ON  ECT.BranchID=V.BranchId AND ECT.ClassID=V.ClassId
						AND ECT.SessionID=V.SessionId AND ECT.ShiftID=V.ShiftId AND ECT.SectionID=V.SectionId
		   INNER JOIN Emp_BasicInfo AS E ON ECT.TeacherID=E.EmpBasicInfoID AND E.IsDeleted=0
			INNER JOIN Res_MainExam EM ON EM.SessionId = ECT.SessionId 
											AND EM.ClassId = ECT.ClassId AND EM.BranchID = ECT.BranchId 
		   INNER JOIN dbo.Res_Terms T on T.TermId=EM.TermId
		  -- AND VE.IsEnableForMakrsEntry = 1 --AND A.SubExamID=VE.SubExamId AND A.DivideExamID=VE.DividedExamId
		
		   --LEFT JOIN Res_MainExamMarks AS ME ON A.MainExamID=ME.MainExamID
		   WHERE ECT.TeacherID=@TeachID AND ECT.IsDeleted=0  AND ECT.IsDeleted = 0
		 group by V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName],  V.[SectionName],
		   V.[SessionId], V.[ClassId], V.[BranchId], V.[ShiftId], V.[SectionId], E.[FullName]	
		   ,ECT.[TeacherId]	, EM.[MainExamName],EM.IsEnableForMakrsEntry,t.TermId
		  ,E.IsClassTeacher,t.Name,EM.MainExamId --,A.[DivideExamID], VE.[DividedExamName]
		   ORDER BY V.[SessionId], V.[BranchId], V.[ShiftId], V.[ClassId], V.[SectionId]
	END
END

 -- GetTeacherSubjectForMarksEntry '95a2f599-c12a-44c4-be46-a0903aea59cb',6