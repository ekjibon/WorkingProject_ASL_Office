/****** Object:  StoredProcedure [dbo].[GetAllMarks]    Script Date: 7/22/2017 4:04:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetMainExamAllMarks]'))
BEGIN
DROP PROCEDURE  GetMainExamAllMarks
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


CREATE PROCEDURE [dbo].[GetMainExamAllMarks] -- [GetMainExamAllMarks] 1,1,1,1,1,0,7,156,110
	@VersionId INT,
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@SubjectID INT,
	@MainExamId INT
AS
BEGIN
    
	DECLARE @FullMarks DECIMAL = 0; DECLARE	@DividedExamMarkSetupID INT;	
	 
   -- SELECT @DividedExamMarkSetupID= [DibExamMarkSetupID],@FullMarks= [DividedExamExamMarks]
   -- FROM [Qry_MarkSetup] where [MainExamId]=@MainExamId and MainExamSubjectID=@SubjectID and SubExamId=@SubExamId and DividedExamId=@DividedExamId
	  SELECT DISTINCT
	  ISNULL(M.[MarksId],0) AS [MarksId]
	  ,S.RollNo
	  ,S.StudentIID
	  ,S.FullName 
      ,S.StudentInsID     
      ,@VersionId AS [VersionId]
      ,@SessionId AS [SessionId]
      ,@ShiftID AS [ShiftId]
      ,@ClassId AS [ClassId]
      ,@GroupId AS [GroupId]
      ,@SectionId AS [SectionId]
	  ,@SubjectID AS [SubjectID]
	  ,ISNULL(M.[IsAbsent],0) AS [IsAbsent]
      ,ISNULL(M.[ObtainMarks],0)AS ObtainMarks
	  ,ISNULL(QM.[DividedExamExamMarks],0) AS FullMarks
	   ,ISNULL(M.[Remarks],'') AS [Remarks]	  
	  ,@MainExamId AS [MainExamID]
   --   ,@SubExamId AS [SubExamID]
   --   ,@DividedExamId AS [DividedExamID]
	  ,ISNULL(QM.[DibExamMarkSetupID],0) AS [DividedExamMarkSetupID]
	 
	  
	  FROM Student_BasicInfo S 
	  INNER JOIN Res_StudentSubject ON S.StudentIID = Res_StudentSubject.StudentID AND Res_StudentSubject.SubjectID = @SubjectID
	  LEFT OUTER JOIN [dbo].[Res_MainExamMarks] M ON M.StudentIID = S.StudentIID 
	  AND M.VersionID =  @VersionId AND M.SessionId = @SessionId   AND M.ShiftID = @ShiftID AND M.ClassId = @ClassId
	  AND M.GroupId = @GroupId AND M.SectionId = @SectionId AND M.MainExamID = @MainExamId --AND M.SubExamID =  @SubExamId
	  --AND M.DividedExamID = @DividedExamId 
	  AND M.IsDeleted=0 and M.SubjectID=@SubjectID
	  LEFT OUTER JOIN [Qry_MarkSetup] AS QM ON QM.[MainExamId]=@MainExamId and MainExamSubjectID=@SubjectID
	  WHERE S.VersionID =  @VersionId AND S.SessionId = @SessionId AND S.BranchID =  @BranchID 
	  AND S.ShiftID = @ShiftID AND S.ClassId = @ClassId AND S.GroupId = @GroupId  AND S.SectionId = @SectionId AND S.IsDeleted=0 AND Res_StudentSubject.[IsDeleted] = 0
	  ORDER BY S.RollNo
	
	-- exec [GetAllMarks] 2002,2012,1019,9,2011,1,3019,18,103,102,70
	
END

-- exec [GetAllMarks] 1,5,1,1,15,1,50,47,125,133,132


 --select s.RollNo  FROM Student_BasicInfo S 
	--  INNER JOIN Res_StudentSubject ON S.StudentIID = Res_StudentSubject.StudentID AND Res_StudentSubject.SubjectID = 3 order by RollNo
















