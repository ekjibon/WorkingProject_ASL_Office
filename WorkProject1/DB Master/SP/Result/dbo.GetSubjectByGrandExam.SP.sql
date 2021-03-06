/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSubjectByGrandExam]'))
BEGIN
DROP PROCEDURE  GetSubjectByGrandExam
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  Calculation>
-- =============================================
CREATE PROC [dbo].[GetSubjectByGrandExam] 
(
@GrandExamIds NVARCHAR(MAX)=NULL,
@Block INT
)
AS
BEGIN
		BEGIN
		DECLARE @sql NVARCHAR(MAX)=NULL
		DECLARE @VERSION INT=0, @SESSION INT=0, @CLASS INT =0, @GROUP INT=0;
		
		CREATE TABLE #GRANDEXAM
		(
		VersionID INT NULL,
		SessionId INT NULL,
		ClassId INT NULL,
		GroupId INT NULL
		)
		--INSERT INTO #GRANDEXAM SELECT VersionId,SessionId,ClassId,GroupId FROM Res_GRANDEXAM WHERE GRANDEXAMId IN()  AND IsDeleted=0
			SET @sql = 'INSERT INTO #GRANDEXAM SELECT VersionId,SessionId,ClassId,GroupId FROM Res_GrandExam '
				PRINT(@sql)
			 IF(@GrandExamIds IS NOT NULL and  @GrandExamIds <> '')
			 BEGIN
				SET @sql = @sql + ' WHERE '+ @GrandExamIds
			 END				 
				EXEC(@sql)
			END			
			if(@Block=1)
			begin
			SELECT SubID,
			SubjectName+'_'+
			(SELECT ClassName FROM Ins_ClassInfo WHERE ClassId=S.ClassId)+'-'+
			(SELECT GroupName FROM Ins_Group WHERE GroupId=S.GroupId) AS SubjectName
			 FROM Res_SubjectSetup AS S WHERE S.VersionID IN(SELECT VersionID FROM #GRANDEXAM)
			 AND S.SessionId IN(SELECT SessionId FROM #GRANDEXAM)
			 AND S.ClassId IN (SELECT ClassId FROM #GRANDEXAM)
			  AND S.GroupId IN(SELECT GroupId FROM #GRANDEXAM) 
			end
			if(@Block=2)
			begin
			SELECT G.GL, 
			GL+'  '+
			(SELECT ClassName FROM Ins_ClassInfo WHERE ClassId=G.ClassId) AS Remarks 			
			 FROM [dbo].[Res_GradingSystem] AS G WHERE G.VersionID IN(SELECT VersionID FROM #GRANDEXAM)
			 AND G.SessionId IN(SELECT SessionId FROM #GRANDEXAM)
			 AND G.ClassId IN (SELECT ClassId FROM #GRANDEXAM)			  
			end
			if(@Block=3)
			begin
			SELECT ROW_NUMBER() Over (Order by S.SubID) as Sub, cast(ROW_NUMBER() Over (Order by S.SubID) as varchar(50))+' Subject' As [NoOfSub]
			 FROM Res_SubjectSetup AS S WHERE S.VersionID IN(SELECT VersionID FROM #GRANDEXAM)
			 AND S.SessionId IN(SELECT SessionId FROM #GRANDEXAM)
			 AND S.ClassId IN (SELECT ClassId FROM #GRANDEXAM)
			  AND S.GroupId IN(SELECT GroupId FROM #GRANDEXAM) 		  
			end
			DROP TABLE #GRANDEXAM

END
