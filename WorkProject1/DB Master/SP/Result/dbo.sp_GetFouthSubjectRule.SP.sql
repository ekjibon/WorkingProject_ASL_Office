/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sp_GetFouthSubjectRule]'))
BEGIN
DROP PROCEDURE  sp_GetFouthSubjectRule
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 --execute [AllSectionClassWise] 10,1
CREATE Proc [dbo].[sp_GetFouthSubjectRule]
@VersionId int = null,
@SessionId int =null,
@ClassId int =null,
@GroupId int =null

AS
BEGIN

select 
  f.AttendancePassFailimpact
 ,f.IsFailImpact
 ,f.DeductMarks
 ,f.DeductGP
 ,CL.ClassName
 ,GR.GroupName
	 from [dbo].[Res_FouthSubjectRules] f
	INNER JOIN Ins_ClassInfo CL ON CL.ClassId =  f.ClassID
	INNER JOIN Ins_Group GR ON GR.GroupId = f.GroupID
	where f.IsDeleted = 0 
	and f.VersionID=@VersionId
	and f.SessionID=@SessionId 
	and f.ClassID= COALESCE( @ClassId ,f.ClassID)
	and f.GroupID=COALESCE(@GroupId, f.GroupID)
END



--exec [sp_GetFouthSubjectRule] 1,6,NULL,NULL