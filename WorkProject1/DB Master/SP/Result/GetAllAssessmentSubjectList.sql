IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllAssessmentSubjectList]'))
BEGIN
DROP PROCEDURE  GetAllAssessmentSubjectList
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllAssessmentSubjectList]    Script Date: 5/22/2019 3:41:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetAllAssessmentSubjectList]
(
@Type INT,
@TermId INT,
@MainExamId INT,
@SubjectId INT
)
As
Begin
IF(@Type=1)
Begin
Select ras.*,rm.MainExamName,c.ClassId,rs.SubjectName,s.SessionId,rt.Name as TermName from dbo.Res_AssessmentSubSetup ras
           inner join dbo.Res_MainExam rm on rm.MainExamId = ras.MainExamId           
		   inner join dbo.Res_Terms rt on rt.TermId = ras.TermId		 
		   inner join dbo.Res_SubjectSetup rs on rs.SubID = ras.SubjectId
		   inner join dbo.Ins_Session s on s.SessionId = rs.SessionId
		   inner join dbo.Ins_ClassInfo c on c.ClassId = rs.ClassId
		   where ras.IsDeleted = 0 and ras.Status = 'A' order By ras.Id desc
End
IF(@Type=2)
Begin
Select ras.*,rm.MainExamName,c.ClassId,s.SessionId,rs.SubjectName,rt.Name as TermName from dbo.Res_AssessmentSubSetup ras
           inner join dbo.Res_MainExam rm on rm.MainExamId = ras.MainExamId           
		   inner join dbo.Res_Terms rt on rt.TermId = ras.TermId		 
		   inner join dbo.Res_SubjectSetup rs on rs.SubID = ras.SubjectId
		     inner join dbo.Ins_Session s on s.SessionId = rs.SessionId
		   inner join dbo.Ins_ClassInfo c on c.ClassId = rs.ClassId
		   where  ras.TermId=@TermId and ras.MainExamId=@MainExamId and ras.SubjectId=@SubjectId and ras.IsDeleted = 0 and ras.Status = 'A' 
		   order By ras.Id desc
End
End
