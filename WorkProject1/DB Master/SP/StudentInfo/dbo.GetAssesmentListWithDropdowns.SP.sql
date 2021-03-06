/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAssesmentListWithDropdowns]'))
BEGIN
DROP PROCEDURE  GetAssesmentListWithDropdowns
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetAssesmentListWithDropdowns 28,1031,10
CREATE PROCEDURE [dbo].[GetAssesmentListWithDropdowns] -- Total 7 param
	(
	@ClassId int,
	@MainExamId int,
	@TermId int
	)
AS
BEGIN
	SELECT  CL.ClassName,CL.ClassId,ME.MainExamName,ME.MainExamId,TE.Name as TermName,Te.TermId, 
	A.Name as AssesmentName,A.Id as AssesmentId,AO.Id as DropdownId, AO.Name as DropdownName 
	from Res_AssessmentClassSetUp A left outer join 
	Res_AssesmentClassOptions AO on AO.AssessmentClassSetUId=A.Id 
	left outer join Ins_ClassInfo CL on CL.ClassId=A.ClassId
	left outer join Res_MainExam ME on ME.MainExamId=A.MainExamId
	left outer join Res_Terms TE on TE.TermId=ME.TermId
	where TE.TermId=@TermId and TE.IsDeleted=0 and ME.MainExamId=@MainExamId and A.ClassId=@ClassId
	and AO.IsDeleted=0
END


--EXEC GetStudentInfoForResult
