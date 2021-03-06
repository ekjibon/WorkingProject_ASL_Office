/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AssignSubjectToTeacher]'))
BEGIN
DROP PROCEDURE  AssignSubjectToTeacher
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --@EmpBasicInfoID int, @MainExamID int=3, @SubExamID int=4, 
--execute AssignSubjectToTeacher 1029,4046,8,4,104

CREATE PROCEDURE AssignSubjectToTeacher
	(	
		@EmpBasicInfoID int,
		@MainExamID int,
		@Branch int,
		@Shift int, 
		@Section int
	)
AS
SELECT m.[Id]
      ,m.[SessionId]
      ,m.[ClassId]
	  ,m.[MainExamSubjectID] 
	  ,ss.SubjectName 
	  ,ss.SubjectCode
      ,m.[MainExamId]
	  ,v.MainExamName 
      ,m.[IsDeleted] 
  INTO #MARKSETUP FROM [Res_MainExamMarkSetup] as m 
  inner join [dbo].[Res_SubjectSetup] as ss on m.MainExamSubjectID=ss.SubID
  --inner join [dbo].[Res_MainExamMarkSetup] as s on m.MainExamSubjectID=ss.SubID
  inner join [dbo].Res_MainExam as v on m.MainExamId=v.MainExamId 
  where m.MainExamId=@MainExamID and m.IsDeleted=0 and ss.IsDeleted=0 
 
 --SELECT * FROM #MARKSETUP
  
  SELECT DISTINCT ISNULL(A.AssignSubID,0) AS AssignSubID
   
	  ,@Branch AS BranchId
	  ,@Shift AS [Shift]
      ,M.[SessionId]
      ,M.[ClassId]
   
	  ,@Section AS Section
	  ,M.[MainExamSubjectID] 
	  ,M.SubjectName 
	  ,M.SubjectCode
      ,M.[MainExamId]
	  ,M.MainExamName
	  ,@EmpBasicInfoID AS TeacherID
	  ,CASE WHEN A.TeacherID !=0 THEN 1 ELSE 0 END AS ASSIGN_TEACHER
	  INTO #ASSIGNSUBJET 
	  FROM [dbo].[Res_AssignSubjectsToTeacher] AS A 
	  RIGHT JOIN #MARKSETUP AS M ON A.MainExamID=M.MainExamID AND A.SubjectID=M.MainExamSubjectID
  AND A.SubjectID=M.MainExamSubjectID AND A.SectionID=@Section AND A.TeacherID=@EmpBasicInfoID AND A.IsDeleted=0 AND A.MainExamID=@MainExamID --WHERE A.IsDeleted=0 --AND A.MainExamID=1146
  SELECT * FROM #ASSIGNSUBJET
  DROP TABLE #MARKSETUP,#ASSIGNSUBJET
  /*
		  DECLARE @cols AS NVARCHAR(MAX),
		@query  AS NVARCHAR(MAX)

		SELECT @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME(ExamName) 
							FROM #ASSIGNSUBJET
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

		SELECT @query = 
		'SELECT * FROM
		(SELECT DISTINCT    
		  --  MainExamSubjectID 
		    SubjectName 
		  --  ,MainExamId
		  --  ,MainExamName 
		  --  ,SubExamId
		  --  ,SubExamName
		  --  ,DividedExamId
		  --  ,DividedExamName
		    ,ExamName
		    ,TeacherID
			,ASSIGN_TEACHER
		FROM #ASSIGNSUBJET)X
		PIVOT 
		(
			AVG([ASSIGN_TEACHER])
			for [ExamName] in (' + @cols + ')
		) P'

		EXEC SP_EXECUTESQL @query
		DROP TABLE #MARKSETUP,#ASSIGNSUBJET */













/* Backup old sp
BEGIN	
    DECLARE @Counter int=1, @RowCount int;
	--MainExamMarkSetup
	CREATE TABLE #TSM
	(
	ID INT IDENTITY(1,1) NOT NULL,
	AssignSubID INT NOT NULL DEFAULT (0),
	TeacherID INT NOT NULL DEFAULT(0),
	SubjectID INT NULL,
	SubjectName VARCHAR(160) NULL,
	SubjectCode VARCHAR(160) NULL,
	MainExamID INT NULL,
	SubExamID INT NULL,
	DW1 INT NOT NULL DEFAULT(0),
	W1 BIT NOT NULL DEFAULT(0),
	DW2 INT NOT NULL DEFAULT(0),
	W2 BIT NOT NULL DEFAULT(0),
	DW3 INT  NOT NULL DEFAULT(0),
	W3 BIT NOT NULL DEFAULT(0),
	DS INT  NOT NULL DEFAULT(0),
	S BIT NOT NULL DEFAULT(0),
	DO INT NOT NULL DEFAULT(0),
	O BIT NOT NULL DEFAULT(0),
	DP INT NOT NULL DEFAULT(0),
	P BIT NOT NULL DEFAULT(0),
	AllItem BIT NOT NULL DEFAULT(0)
	)
	INSERT INTO #TSM(TeacherID,SubjectID,SubjectName,SubjectCode,MainExamID,SubExamID)
	SELECT @EmpBasicInfoID, MainExamSubjectID,Res_SubjectSetup.SubjectName, Res_SubjectSetup.SubjectCode, @MainExamID, @SubExamID FROM Res_MainExamMarkSetup
	INNER JOIN Res_SubjectSetup ON Res_SubjectSetup.SubID=Res_MainExamMarkSetup.MainExamSubjectID AND Res_SubjectSetup.IsDeleted=0
	WHERE MainExamId=@MainExamID AND Res_MainExamMarkSetup.IsDeleted=0 AND Res_SubjectSetup.SubjectType != 'T'

	--End MainExamMarkSetup

		CREATE TABLE #VMS
		(
		ID INT IDENTITY(1,1) NOT NULL,
		[MainExamId] INT NOT NULL DEFAULT (0),
		[MainExamSubjectID] INT NOT NULL DEFAULT(0),
		[SubExamMarkSetupID] INT NULL,
		[SubExamId] INT NOT NULL DEFAULT(0),
		[DivExamMarkSetupID] INT NOT NULL DEFAULT(0),
		[DividedExamId] INT NOT NULL DEFAULT(0),
		[DividedExamType] NVARCHAR(10) NULL,
		[MIsDeleted] BIT NULL,
		[SIsDeleted] BIT NULL,
		[DIsDeleted] BIT NULL
		)
		INSERT INTO #VMS
		SELECT
		   [MainExamId]
		  ,[MainExamSubjectID]      
		  ,[SubExamMarkSetupID]
		  ,[SubExamId]     
		  ,[DibExamMarkSetupID]
		  ,[DividedExamId]
		  ,[DividedExamType]      
		  ,[MIsDeleted]
		  ,[SIsDeleted]
		  ,[DIsDeleted]
	  FROM [Qry_MarkSetup]
	  WHERE MainExamId=@MainExamID and SubExamId=@SubExamID and MIsDeleted=0 and SIsDeleted=0 and DIsDeleted=0
	  ORDER BY [MainExamSubjectID]	
	  SET @RowCount= @@ROWCOUNT
		-- [dbo].[Res_AssignSubjectsToTeacher] temp
		SELECT [AssignSubID]
			  ,[VersionID]
			  ,[SessionID]
			  ,[BranchID]
			  ,[ShiftID]
			  ,[ClassID]
			  ,[GroupID]
			  ,[SectionID]
			  ,[TeacherID]
			  ,[SubjectID]
			  ,[MainExamID]
			  ,[SubExamID]
			  ,[DivideExamID]    
			INTO #AtoT FROM [Res_AssignSubjectsToTeacher]
			 Where [TeacherID]= @EmpBasicInfoID AND [MainExamID]=@MainExamID AND [SubExamID]=@SubExamID
			 AND [VersionID]=@Version AND [SessionID]=@Session AND [BranchID]=@Branch AND [ShiftID]=@Shift
			 AND [ClassID]=@ClassId AND [GroupID]=@GroupId AND [SectionID]=@Section   AND [IsDeleted]=0			
		-- End [dbo].[Res_AssignSubjectsToTeacher] temp 
		WHILE @Counter <= @RowCount
		BEGIN
			DECLARE @DID INT, @DT VARCHAR(10), @SID INT 
			SELECT  @SID=[MainExamSubjectID], @DID =[DividedExamId], @DT=[DividedExamType]  FROM #VMS WHERE ID=@Counter				
			print @DT print @DID			
				IF(@DT='W1')	
					BEGIN
					UPDATE #TSM SET DW1 = @DID WHERE SubjectID=@SID			
					UPDATE T SET T.AssignSubID = A.AssignSubID,			
					T.W1 = CASE WHEN A.DivideExamID IS NULL   THEN 0 ELSE 1	END			
					  FROM #TSM AS T INNER JOIN   #AtoT AS A ON 
					T.TeacherID=A.TeacherID AND T.SubjectID=A.SubjectID AND T.MainExamID=A.MainExamID AND T.SubExamID=A.SubExamID
					WHERE A.SubjectID=@SID AND A.DivideExamID=@DID
					END
			ELSE IF(@DT='W2')
				BEGIN
					UPDATE #TSM SET DW2 = @DID	WHERE SubjectID=@SID	
					UPDATE T SET T.AssignSubID = A.AssignSubID,					
					T.W2 = CASE WHEN A.DivideExamID IS NULL   THEN 0 ELSE 1	END			
					  FROM #TSM AS T INNER JOIN   #AtoT AS A ON 
					T.TeacherID=A.TeacherID AND T.SubjectID=A.SubjectID AND T.MainExamID=A.MainExamID AND T.SubExamID=A.SubExamID   
					WHERE A.SubjectID=@SID AND A.DivideExamID=@DID
				END
			ELSE IF(@DT='W3')
				BEGIN
					UPDATE #TSM SET DW3 = @DID	WHERE SubjectID=@SID	
					UPDATE T SET T.AssignSubID = A.AssignSubID,		
					T.W3 = CASE WHEN A.DivideExamID IS NULL   THEN 0 ELSE 1	END			
					  FROM #TSM AS T INNER JOIN   #AtoT AS A ON 
					T.TeacherID=A.TeacherID AND T.SubjectID=A.SubjectID AND T.MainExamID=A.MainExamID AND T.SubExamID=A.SubExamID 
					WHERE A.SubjectID=@SID AND A.DivideExamID=@DID
				END 
			ELSE IF(@DT='S')
				BEGIN
					UPDATE #TSM SET DS = @DID WHERE SubjectID=@SID	
					UPDATE T SET T.AssignSubID= A.AssignSubID,				
					T.S = CASE WHEN A.DivideExamID IS NULL   THEN 0 ELSE 1	END			
					  FROM #TSM AS T INNER JOIN   #AtoT AS A ON 
					T.TeacherID=A.TeacherID AND T.SubjectID=A.SubjectID AND T.MainExamID=A.MainExamID AND T.SubExamID=A.SubExamID 
					WHERE A.SubjectID=@SID 	AND A.DivideExamID=@DID
				END
			ELSE IF(@DT='O')
				BEGIN
					UPDATE #TSM SET DO = @DID WHERE SubjectID=@SID	
					UPDATE T SET T.AssignSubID = A.AssignSubID,
					T.O = CASE WHEN A.DivideExamID IS NULL   THEN 0 ELSE 1	END			
					  FROM #TSM AS T INNER JOIN   #AtoT AS A ON 
					T.TeacherID=A.TeacherID AND T.SubjectID=A.SubjectID AND T.MainExamID=A.MainExamID AND T.SubExamID=A.SubExamID  
					WHERE A.SubjectID=@SID AND A.DivideExamID=@DID
				END
			ELSE IF(@DT='P')
				BEGIN
				    UPDATE #TSM SET DP = @DID	WHERE SubjectID=@SID	
					UPDATE T SET T.AssignSubID = A.AssignSubID,			
					T.P = CASE WHEN A.DivideExamID IS NULL   THEN 0 ELSE 1	END			
					  FROM #TSM AS T INNER JOIN   #AtoT AS A ON 
					T.TeacherID=A.TeacherID AND T.SubjectID=A.SubjectID AND T.MainExamID=A.MainExamID AND T.SubExamID=A.SubExamID  
					WHERE A.SubjectID=@SID AND A.DivideExamID=@DID
				END

		   SET @Counter = @Counter + 1;
		END;
--select [DividedExamId], [DividedExamType] FROM #VMS WHERE ID=1
--select [DividedExamId], [DividedExamType] FROM #VMS WHERE ID=3
	SELECT * FROM #TSM WHERE DW1 != 0 OR DW2 !=0 OR DW3 !=0 OR DS !=0 OR DO !=0 OR DP !=0 ORDER BY SubjectID
	DROP TABLE #VMS, #AtoT, #TSM
END
Backup old sp */