/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetGrandMeritListConfig]'))
BEGIN
DROP PROCEDURE  GetGrandMeritListConfig
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
--execute [dbo].[GetGrandMeritListConfig] 1,6,9,1
CREATE PROCEDURE [dbo].[GetGrandMeritListConfig] 
	-- Add the parameters for the stored procedure here
	
	@VersionId int = null,
	@SessionId int = null,
	@ClassId int = null,
	@GroupId INT = null

AS
BEGIN

SELECT  V.VersionName , S.[SessionName] , C.ClassName, ME.MainExamName,ME.MainExamId, M.[MeritListConfigId] AS [MeritListConfigId], M.[VersionId]
      ,M.[SessionId]
      ,M.[ClassId]
      ,M.[GroupId]
      ,M.[SortSerialByGPAWith4th]
      ,M.[SortSerialByGPAWithout4th]
	  ,M.[MainGPAWO4th]
      ,M.[MainGPAW4th]
      ,M.[MainTotalMark]
      ,M.[SortSerialByTotalMark]
      ,M.[SortSerialByRoll]
      ,M.[SortSerialByName]
      ,M.[TotalMarkSameMerit]
      ,M.[TotalIsFraction]
      ,M.SubjectIsMainExam
	  ,M.[SubjectId1]
      ,M.[SortSerialBySubjectId1]
      ,M.[SubjectId2]
      ,M.[SortSerialBySubjectId2]
      ,M.[SubjectId3]
      ,M.[SortSerialBySubjectId3]
	  ,M.[BranchWise]
	  ,M.[NoOfAttendExam]
FROM [dbo].[Res_GrandMeritListConfig] M INNER JOIN [dbo].[Ins_Version] V ON  V.[VersionId] = M.VersionId 
											 INNER JOIN [dbo].[Ins_Session] S ON S.[SessionId] = M.[SessionId]
											 INNER JOIN [dbo].[Ins_ClassInfo] C ON C.[ClassId] = M.ClassId
											 INNER JOIN [dbo].[Res_MainExam] ME ON ME.[MainExamId] = M.[MainExamId]
			WHERE
			 (M.VersionId = @VersionId or @VersionId  IS NULL)  AND
			 (M.SessionId = @SessionId or @SessionId  IS NULL)  AND
			 (M.ClassId  = @ClassId or @ClassId   IS NULL)  AND
			 (M.GroupId = @GroupId or @GroupId   IS NULL) 
										 

END

