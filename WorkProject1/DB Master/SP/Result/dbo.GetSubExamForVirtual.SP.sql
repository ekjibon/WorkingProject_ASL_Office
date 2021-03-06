/****** Object:  StoredProcedure [dbo].[ClearExamResult]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSubExamForVirtual]'))
BEGIN
DROP PROCEDURE  GetSubExamForVirtual
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetSubExamForVirtual] 	
	@VersionId int,
	@SessionId int ,
	@ClassId int ,
	@GroupId INT ,
	@MainExamID INT,
	@SubjectID INT = NULL

AS
BEGIN
	
	SELECT SubExamName , S.SubExamId AS SubExamID, @VersionId AS VersionId ,@SessionId AS SessionId,@ClassId AS ClassId ,@GroupId AS  GroupId,
	@MainExamID AS  MainExamID,  @SubjectID AS SubjectID,
	V.DivExamTypeVirtual1 , ISNULL( V.VirtualPassMark1,0)  AS VirtualPassMark1, V.DivExamTypeVirtual2,
	ISNULL( V.VirtualPassMark2,0) AS VirtualPassMark2, IsNULL(V.VirtualPassMarkIsPercent1,0) AS VirtualPassMarkIsPercent1,
	IsNULL(V.VirtualPassMarkIsPercent2,0) AS VirtualPassMarkIsPercent2
	FROM Res_SubExam S LEFT OUTER JOIN Res_VirtualExamSetup V   ON v.[SubExamID] = S.SubExamId AND V.SubjectID = @SubjectID WHERE S.MainExamId =  @MainExamID

	--SELECT SubExamName , S.SubExamId AS SubExamID, @VersionId AS VersionName ,@SessionId AS SessionId,@ClassId AS ClassId ,@GroupId AS  GroupId,
	--dbo.Ins_Version.VersionName, dbo.Ins_Group.GroupName, dbo.Ins_Session.SessionName, dbo.Res_MainExam.MainExamName, dbo.Res_SubjectSetup.SubjectName, dbo.Ins_ClassInfo.ClassName,
	--@MainExamID AS  MainExamID,  @SubjectID AS SubjectID,
	--V.DivExamTypeVirtual1 , ISNULL( V.VirtualPassMark1,0)  AS VirtualPassMark1, V.DivExamTypeVirtual2,
	--ISNULL( V.VirtualPassMark2,0) AS VirtualPassMark2, IsNULL(V.VirtualPassMarkIsPercent1,0) AS VirtualPassMarkIsPercent1,
	--IsNULL(V.VirtualPassMarkIsPercent2,0) AS VirtualPassMarkIsPercent2
	
	--FROM Res_SubExam S LEFT OUTER JOIN Res_VirtualExamSetup V   ON v.[SubExamID] = S.SubExamId AND V.SubjectID = @SubjectID 
	
	--INNER JOIN
 --                        dbo.Ins_ClassInfo ON V.ClassId = dbo.Ins_ClassInfo.ClassId INNER JOIN
 --                        dbo.Ins_Session ON V.SessionId = dbo.Ins_Session.SessionId INNER JOIN
 --                        dbo.Res_MainExam ON V.MainExamID = dbo.Res_MainExam.MainExamId INNER JOIN
 --                        dbo.Res_SubjectSetup ON V.SubjectID = dbo.Res_SubjectSetup.SubID INNER JOIN
 --                        dbo.Ins_Group ON V.GroupId = dbo.Ins_Group.GroupId CROSS JOIN
 --                        dbo.Ins_Version
	
	
	
	
	--WHERE S.MainExamId =  @MainExamID AND S.IsDeleted=0




END

---  EXEC GetSubExamForVirtual 1,5,10,1,14,106
