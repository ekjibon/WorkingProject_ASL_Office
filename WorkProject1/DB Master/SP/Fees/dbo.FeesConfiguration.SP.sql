/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesConfiguration]'))
BEGIN
DROP PROCEDURE  [FeesConfiguration]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shahin
-- Create date: March 19, 2018
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[FeesConfiguration]
(
    @Block INT=0,
	@Where varchar(MAX) = NULL
)	
AS
BEGIN
	IF(@Block=1)
	BEGIN

		DECLARE @sql varchar(max)
        --SET @sql = 'SELECT [HeadAmountConfigId], [ProcessId], [HeadId], [VersionId], [SessionId], [BranchId], [ShiftId], [ClassId], [GroupId], [SectionId], [FessGroupId],
        --   [StudentIID],[Amount], [IsAllBranch], [IsAllShift], [IsDeleted], [AddBy], [AddDate], [UpdateBy], [UpdateDate], [Remarks], [Status], [IP], [MacAddress]
        --   FROM [dbo].[Fees_HeadAmountConfig] '


		--SET @sql = 'SELECT HA.*,H.HeadName,ST.StudentTypeName, C.VersionName AS [Version], C.SessionName AS [Session], C.ShiftName AS [Shift], C.BranchName AS Branch,
  --      C.ClassName AS Class, C.GroupName AS [Group], C.SectionName AS Section  FROM [dbo].[Fees_HeadAmountConfig] AS HA 
		--INNER JOIN Fees_Head H On H.FeesHeadId=HA.HeadId
		--LEFT OUTER JOIN Ins_StudentType ST ON ST.StudentTypeId=HA.FessGroupId
		--LEFT OUTER JOIN view_CommonTableNames AS C ON HA.VersionId=C.VersionId AND HA.SessionId=C.SessionId AND HA.BranchId=C.BranchId AND HA.ShiftId=C.ShiftId
		--AND HA.ClassId=C.ClassId AND HA.GroupId=C.GroupId AND HA.SectionId=C.SectionId '

		SET @sql = 'SELECT [HeadAmountConfigId], [ProcessId], [HeadId],  [FessGroupId], [StudentIID], [Amount], 		
		H.HeadName,ST.StudentTypeName,  C.SessionName AS [Session], C.ShiftName AS [Shift], C.BranchName AS Branch,
        C.ClassName AS Class, C.SectionName AS Section  FROM [dbo].[Fees_HeadAmountConfig] AS HA 
		INNER JOIN Fees_Head H On H.FeesHeadId=HA.HeadId		
		LEFT OUTER JOIN Ins_StudentType ST ON ST.StudentTypeId=HA.FessGroupId
		LEFT OUTER JOIN view_CommonTableNames AS C ON  HA.SessionId=C.SessionId AND HA.BranchId=C.BranchId AND HA.ShiftId=C.ShiftId
		AND HA.ClassId=C.ClassId AND HA.SectionId=C.SectionId '


	 IF(@Where IS NOT NULL AND  @Where <> '')
	 BEGIN
	 SET @sql = @sql + ' WHERE '+ @Where+'AND HA.IsDeleted=0'
	 END
	EXEC(@sql)

	END
	IF(@Block=2) --[FeesConfiguration] 2,'SELECT SB.FullName,SB.RollNo,SB.StudentInsID, SB.StudentIID,SB.VersionID,SB.SessionId,SB.BranchID,SB.ShiftID,SB.ClassId,SB.GroupId,SB.SectionId,HA.Amount,51 AS ProcessId,8 AS HeadId From Student_BasicInfo SB LEFT JOIN Fees_HeadAmountConfig HA ON SB.StudentIID = HA.StudentIID AND HA.ProcessId = 51 AND HA.HeadId = 8 WHERE SB.IsDeleted=0 AND SB.VersionId IN (1) AND SB.SessionId IN (1) AND SB.BranchId IN (2) AND SB.ShiftId IN (1) AND SB.ClassId IN (1) AND SB.GroupId IN (0) AND SB.SectionId IN (5) ORDER BY (SB.RollNo ) ASC'
	BEGIN
		DECLARE @sqlIndividual VARCHAR(MAX)

	 IF(@Where IS NOT NULL AND  @Where <> '')
	 BEGIN
	 SET @sqlIndividual = @Where
	 END
	EXEC(@sqlIndividual)

	END
	IF(@Block=3)  --[FeesConfiguration] 3,'Tes'
	BEGIN		
		SELECT [HeadName] AS [Text], CAST([FeesHeadId] AS VARCHAR) AS [Value],[CategoryId] FROM [Fees_Head]
		WHERE [IsDeleted]=0 AND CategoryId=1 AND HeadName like '%'+@Where+'%' 
		 
	END
END


		   
