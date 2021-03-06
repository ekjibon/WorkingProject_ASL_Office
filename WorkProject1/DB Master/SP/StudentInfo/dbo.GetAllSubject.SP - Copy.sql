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

Create Proc sp_GrandSetup
(
	@SessionId INT,
	@ClassId INT,
	@MainExamID INT
)
AS
BEGIN
SELECT 
      ISNULL(g.[GrandSetupId],0) [GrandSetupId],
      ISNULL(g.[GrandExamId],0) [GrandExamId]
      , m.[VersionId]
      , m.[SessionId]
      , m.[ClassId]
      , m.[GroupId]
      ,ISNULL(m.[MainExamId],0) [MainExamId]

      , m.MainExamName
	   ,ISNULL(g.[MainExamPercent],0) [MainExamPercent]
	   ,ISNULL(g.[IsPassDependet],0) [IsPassDependet]
  FROM [dbo].[Res_GrandSetup] as g right join [Res_MainExam] as m on g.MainExamId= m.MainExamId
  where  m.[SessionId]=@SessionId and m.[ClassId]=@ClassId and m.MainExamId=@MainExamID
 
   END