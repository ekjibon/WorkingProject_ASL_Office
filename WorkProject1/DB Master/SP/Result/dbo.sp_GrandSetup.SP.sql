/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sp_GrandSetup]'))
BEGIN
DROP PROCEDURE  sp_GrandSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Proc [dbo].[sp_GrandSetup]
(
    @VersionId INT=null,
	@SessionId INT=null,
	@ClassId INT=null,
	@GroupId INT=null
)
AS
BEGIN
-->>>>>
	SELECT 
      ISNULL(g.[GrandSetupId],0) [GrandSetupId],
      ISNULL(g.[GrandExamId],0) [GrandExamId]
      , m.[VersionId]
      , m.[SessionId]
      , m.[ClassId]
      , m.[GroupId]
      , m.[MainExamId]
      , m.MainExamName
	  ,ISNULL(g.[MainExamPercent],0) [MainExamPercent]
	  ,ISNULL(g.[IsPassDependet],0) [IsPassDependet]
	  ,ISNULL(g.[AddBy],'') AS [AddBy], ISNULL(g.[AddDate],'') AS [AddDate]
	   
  FROM [dbo].[Res_GrandSetup] as g Right join [Res_MainExam] as m on g.MainExamId= m.MainExamId and g.IsDeleted=0
  where m.[VersionId]=ISNULL(@VersionId,m.[VersionId]) and  m.[SessionId]=ISNULL(@SessionId,m.[SessionId])
   and  m.[ClassId]=ISNULL(@ClassId,m.[ClassId]) and m.[GroupId]=ISNULL(@GroupId,m.[GroupId])  and m.IsDeleted=0
  and m.MainExamIsGrand=1 
END