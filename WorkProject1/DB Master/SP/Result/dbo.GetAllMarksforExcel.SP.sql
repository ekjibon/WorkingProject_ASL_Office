/****** Object:  StoredProcedure [dbo].[GetAllMarksforExcel]    Script Date: 7/22/2017 4:04:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllMarksforExcel]'))
BEGIN
DROP PROCEDURE  GetAllMarksforExcel
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
-- exec [GetAllMarksforExcel] 7,128,1099,1019

CREATE PROCEDURE [dbo].[GetAllMarksforExcel]	
	@ShiftID INT ,	
	@SectionId INT,
	@SubjectID INT,
	@MainExamId INT
	
AS
BEGIN
    
	DECLARE @FullMarks DECIMAL = 0; DECLARE	@DividedExamMarkSetupID INT;	
	 
    
	  SELECT 
	  ISNULL(M.[MarksId],0) AS [MarksId]
	  , S.RollNo 
	  ,S.StudentIID
	  ,S.FullName 
      ,S.StudentInsID     
     
	  ,ISNULL(M.[IsAbsent],0) AS [IsAbsent]
      ,ISNULL(M.[ObtainMarks],0)AS ObtainMarks
	  ,@FullMarks AS FullMarks
	   ,ISNULL(M.[Remarks],'') AS [Remarks]	  
	   ,m.DividedExamID
	 
     
	  FROM Student_BasicInfo S 
	  INNER JOIN Res_StudentSubject ON S.StudentIID = Res_StudentSubject.StudentID AND Res_StudentSubject.SubjectID = @SubjectID
	  LEFT OUTER JOIN [dbo].[Res_MainExamMarks] M ON M.StudentIID = S.StudentIID 
	  
	  AND M.IsDeleted=0 and M.SubjectID=@SubjectID
	  AND Res_StudentSubject.IsDeleted  = 0 
	 

	  WHERE S.ShiftID = @ShiftID AND S.SectionId = @SectionId AND S.IsDeleted=0 AND Res_StudentSubject.[IsDeleted] = 0
	  ORDER BY  S.RollNo 
	 -- CASE WHEN ISNUMERIC(S.RollNo)=0 THEN CAST( S.RollNo   as int)
		--ELSE S.RollNo
		--END

	
	
	
END















