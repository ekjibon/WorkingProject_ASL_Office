/****** Object:  StoredProcedure [dbo].[DuplicateRow]    Script Date: 7/22/2017 3:39:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DuplicateRow]'))
BEGIN
DROP PROCEDURE  DuplicateRow
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[DuplicateRow]
As

 select * from Res_MainExamMarks where MarksId not in 
                   ( select Max(MarksId) 
                     from Res_MainExamMarks group by VersionId,SessionId,ShiftId,ClassId,GroupId,SectionId,StudentIID,
					 MainExamID,SubExamID,DividedExamID,SubjectID);
--delete from Res_MainExamMarks where MarksId not in 
--                   ( select min(MarksId) 
--                     from Res_MainExamMarks group by VersionId,SessionId,ShiftId,ClassId,GroupId,SectionId,StudentIID,
--		