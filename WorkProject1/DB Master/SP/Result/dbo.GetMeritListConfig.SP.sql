/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetMeritListConfig]'))
BEGIN
DROP PROCEDURE  GetMeritListConfig
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
--execute [dbo].[GetMeritListConfig] 1,5,10,1
CREATE PROCEDURE [dbo].[GetMeritListConfig] 
	-- Add the parameters for the stored procedure here
	

	@SessionId int ,
	@ClassId INT =null 
	

AS
BEGIN

SELECT  S.[SessionName] , C.ClassName, M.[MeritListConfigId] AS [MeritListConfigId]
      ,M.[SessionId]
      ,M.[ClassId]
    
      ,[SortSerialByGPAWith4th]
      ,[SortSerialByGPAWithout4th]
      ,[SortSerialByTotalMark]
      ,[SortSerialByRoll]
      ,[SortSerialByName]
      ,[TotalMarkSameMerit]
      ,[TotalIsFraction]
      ,[IsGrand]
	  ,[SubjectId1]
      ,[SortSerialBySubjectId1]
      ,[SubjectId2]
      ,[SortSerialBySubjectId2]
      ,[SubjectId3]
      ,[SortSerialBySubjectId3]
	  ,[BranchWise]
FROM [dbo].[Res_MeritListConfig] M 
											 INNER JOIN [dbo].[Ins_Session] S ON S.[SessionId] = M.[SessionId]
											 INNER JOIN [dbo].[Ins_ClassInfo] C ON C.[ClassId] = M.ClassId
			WHERE M.SessionId =  @SessionId AND M.ClassId =COALESCE(@ClassId,M.ClassId) 
											 
	
	--SELECT SubExamName , S.SubExamId, @VersionId AS VersionId ,@SessionId AS SessionId,@ClassId AS ClassId ,@GroupId AS  GroupId, @MainExamID AS  MainExamID,  @SubjectID AS SubjectID,
	--V.DivExamTypeVirtual1 , ISNULL( V.VirtualPassMark1,0)  AS VirtualPassMark1, V.DivExamTypeVirtual2 , ISNULL( V.VirtualPassMark2,0) AS VirtualPassMark2
	-- FROM Res_SubExam S LEFT OUTER JOIN Res_VirtualExamSetup V   ON v.[SubExamID] = S.SubExamId AND V.SubjectID = @SubjectID WHERE S.MainExamId =  @MainExamID


END

---  EXEC GetMeritListConfig 1,5,7,0
