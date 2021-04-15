IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllAssessmentClassList]'))
BEGIN
DROP PROCEDURE  GetAllAssessmentClassList
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllAssessmentClassList]    Script Date: 5/22/2019 3:41:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetAllAssessmentClassList]
(
@Type INT,
@TermId INT,
@MainExamId INT,
@ClassId INT,     --- GetAllAssessmentClassList 1,null,null,null,
@BranchID INT
)
As
Begin
IF(@Type=1)
Begin
Select rcs.*,rm.MainExamName,c.ClassName,rt.Name as TermName,b.BranchName
                  from dbo.Res_AssessmentClassSetUp rcs
           inner join dbo.Res_MainExam rm on rm.MainExamId = rcs.MainExamId           
		   inner join dbo.Res_Terms rt on rt.TermId = rcs.TermId	
		     inner join dbo.Ins_ClassInfo c on c.ClassId = rcs.ClassId
			   inner join dbo.Ins_Branch b on b.BranchId = rcs.BranchID
		  where rcs.IsDeleted = 0 and rcs.Status = 'A' order By rcs.Id desc
End
IF(@Type=2)
Begin
Select rcs.*,rm.MainExamName,c.ClassName,rt.Name as TermName,b.BranchName  from dbo.Res_AssessmentClassSetUp rcs
           inner join dbo.Res_MainExam rm on rm.MainExamId = rcs.MainExamId           
		   inner join dbo.Res_Terms rt on rt.TermId = rcs.TermId		 
		   inner join dbo.Ins_ClassInfo c on c.ClassId = rcs.ClassId
		   inner join dbo.Ins_Branch b on b.BranchId = rcs.BranchID
		   where  rcs.TermId=@TermId and rcs.MainExamId=@MainExamId and rcs.ClassId=@ClassId and rcs.BranchID=@BranchID and rcs.IsDeleted = 0 and rcs.Status = 'A' 
		   order By rcs.Id desc
End
End
