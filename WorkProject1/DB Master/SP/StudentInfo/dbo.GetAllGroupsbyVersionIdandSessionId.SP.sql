/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllGroupsbyVersionIdandSessionId]'))
BEGIN
DROP PROCEDURE  GetAllGroupsbyVersionIdandSessionId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  GetAllGroupsbyVersionIdandSessionId 1,9 
Create Proc GetAllGroupsbyVersionIdandSessionId
(
    @VersionId INT,
	@SessionId INT
)
AS
BEGIN
	SELECT ClassId,ClassName, Class_HasGroup, GroupId, GroupName INTO #tempg
	FROM Ins_ClassInfo CROSS JOIN Ins_Group order by GroupId

	DELETE FROm #tempg WHERE Class_HasGroup = 0 AND GroupId<> 0
	DELETE FROm #tempg WHERE Class_HasGroup = 1 AND GroupId= 0

	--SELECT * FROM #tempg order by ClassId
	

SELECT cs.[ClassSubConfigId],@VersionId as VersionId,@SessionId as SessionId,ci.ClassId,tg.GroupId,cs.[TotalSub],cs.[TotalCompolsary],cs.[TotalSelective]
	   ,cs.[TotalForth],cs.[TotalThird],ci.ClassName,tg.GroupName
FROM 
		#tempg TG 
		INNER JOIN Ins_ClassInfo ci ON TG.ClassId = CI.ClassId 
		LEFT JOIN Res_ClassSubjectConfig CS ON CS.ClassId = TG.ClassId AND CS.GroupId = TG.GroupId AND CS.SessionId =@SessionId
		WHERE CI.VersionId = @VersionId

drop table #tempg
END

