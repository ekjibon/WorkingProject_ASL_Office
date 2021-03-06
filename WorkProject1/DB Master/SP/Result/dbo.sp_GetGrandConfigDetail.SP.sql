/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sp_GetGrandConfigDetail]'))
BEGIN
DROP PROCEDURE  sp_GetGrandConfigDetail
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 --execute [AllSectionClassWise] 10,1
Create Proc [dbo].[sp_GetGrandConfigDetail]
@VersionId int = null,
@SessionId int =null,
@ClassId int =null,
@GroupId int =null

AS
BEGIN 

select Distinct
--g.GrandConfigId
--,g.SubjectId
 g.MainExamId
,g.SubExamId
,g.DivExamId
,g.DivExamType
,g.GrandExamId
,g.GrandSubExamId
,g.GrandDivExamId
,g.GrandDivExamType
,g.DivExamPercentage
,m.MainExamName 
,se.SubExamName
,de.DividedExamName
,ge.GrandExamName
,gse.GrandSubExamName
,gde.DividedExamName GrandDividedExamName
,CL.ClassName
,GR.GroupName
	 from Res_GrandConfig g
	left outer join Res_MainExam m on g.MainExamId =m.MainExamId and m.IsDeleted=0
	left outer join Res_SubExam se on g.SubExamId =se.SubExamId
	left outer join Res_DividedExam de on g.DivExamId =de.DividedExamId
	left outer join Res_GrandExam ge on g.GrandExamId =ge.GrandExamId
	left outer join Res_GrandSubExam gse on g.GrandSubExamId =gse.GrandSubExamId
	left outer join Res_GrandDividedExam gde on g.GrandDivExamId =gde.GrandDividedExamId
	INNER JOIN Ins_ClassInfo CL ON CL.ClassId =  m.ClassId
	INNER JOIN Ins_Group GR ON GR.GroupId = m.GroupId
	where g.IsDeleted = 0 
	and ge.VersionId=@VersionId 
	and ge.SessionId=@SessionId 
	and ge.ClassId= COALESCE( @ClassId ,ge.ClassId)
	and ge.GroupId=COALESCE(@GroupId, ge.GroupId)
END



--exec [sp_GetGrandConfigDetail] 1,6,NULL,NULL