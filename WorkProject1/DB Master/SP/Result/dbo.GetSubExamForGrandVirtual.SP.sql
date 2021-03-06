/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSubExamForGrandVirtual]'))
BEGIN
DROP PROCEDURE  [GetSubExamForGrandVirtual]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[GetSubExamForGrandVirtual] 
	-- Add the parameters for the stored procedure here	
	@VersionId int,
	@SessionId int ,
	@ClassId int ,
	@GroupId INT ,
	@GrandExamId INT,
	@SubjectID INT

AS
BEGIN
	
	SELECT  S.GrandSubExamName AS GrandSubExamName,  S.GrandSubExamID,
	@VersionId AS VersionId ,@SessionId AS SessionId,@ClassId AS ClassId ,@GroupId AS  GroupId,
	@GrandExamId AS  GrandExamID,  @SubjectID AS SubjectID,
	V.DivExamTypeVirtual1 , ISNULL( V.VirtualPassMark1,0)  AS VirtualPassMark1,
	V.DivExamTypeVirtual2 , ISNULL( V.VirtualPassMark2,0) AS VirtualPassMark2,
	IsNULL(V.VirtualPassMarkIsPercent1,0) AS VirtualPassMarkIsPercent1,
	IsNULL(V.VirtualPassMarkIsPercent2,0) AS VirtualPassMarkIsPercent2
	FROM Res_GrandSubExam AS S LEFT OUTER JOIN Res_GrandVirtualExamSetup AS V
	ON V.GrandSubExamID = S.GrandSubExamId AND V.SubjectID = @SubjectID WHERE S.GrandExamId =  @GrandExamId 
END
---  EXEC [GetSubExamForGrandVirtual] 1,4,4,1,2,216

	--SELECT SubExamName , S.SubExamId AS SubExamID, @VersionId AS VersionId ,@SessionId AS SessionId,@ClassId AS ClassId ,@GroupId AS  GroupId,
	--@MainExamID AS  MainExamID,  @SubjectID AS SubjectID,
	--V.DivExamTypeVirtual1 , ISNULL( V.VirtualPassMark1,0)  AS VirtualPassMark1, V.DivExamTypeVirtual2,
	--ISNULL( V.VirtualPassMark2,0) AS VirtualPassMark2, ISNULL(V.VirtualPassMarkIsPercent1,0) AS VirtualPassMarkIsPercent1,
	--IsNULL(V.VirtualPassMarkIsPercent2,0) AS VirtualPassMarkIsPercent2
	--FROM Res_SubExam S LEFT OUTER JOIN Res_VirtualExamSetup V   ON v.[SubExamID] = S.SubExamId AND V.SubjectID = @SubjectID WHERE S.MainExamId =  @MainExamID

