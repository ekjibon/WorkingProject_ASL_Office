/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSubjectByMainExam]'))
BEGIN
DROP PROCEDURE  GetSubjectByMainExam
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
CREATE PROC [dbo].[GetSubjectByMainExam] 
(
@MainExamIds NVARCHAR(MAX)=NULL,
@Block INT
)
AS
BEGIN
		BEGIN
		DECLARE @sql NVARCHAR(MAX)=NULL
		DECLARE @VERSION INT=0, @SESSION INT=0, @CLASS INT =0, @GROUP INT=0;
		CREATE TABLE #MAINEXAM
		(
		VersionID INT NULL,
		SessionId INT NULL,
		ClassId INT NULL,
		GroupId INT NULL
		)
		--INSERT INTO #MAINEXAM SELECT VersionId,SessionId,ClassId,GroupId FROM Res_MainExam WHERE MainExamId IN()  AND IsDeleted=0
			SET @sql = 'INSERT INTO #MAINEXAM SELECT VersionId,SessionId,ClassId,GroupId FROM Res_MainExam '
				PRINT(@sql)
			 IF(@MainExamIds IS NOT NULL and  @MainExamIds <> '')
			 BEGIN
				SET @sql = @sql + ' WHERE '+ @MainExamIds
			 END				 
				EXEC(@sql)
			END			
			if(@Block=1)
			begin
			SELECT SubID,
			SubjectName+'_'+
			(SELECT ClassName FROM Ins_ClassInfo WHERE ClassId=S.ClassId)+'-'+
			(SELECT GroupName FROM Ins_Group WHERE GroupId=S.GroupId) AS SubjectName
			 FROM Res_SubjectSetup AS S WHERE S.VersionID IN(SELECT VersionID FROM #MAINEXAM)
			 AND S.SessionId IN(SELECT SessionId FROM #MAINEXAM)
			 AND S.ClassId IN (SELECT ClassId FROM #MAINEXAM)
			  AND S.GroupId IN(SELECT GroupId FROM #MAINEXAM) 
			end
			if(@Block=2)
			begin
			SELECT G.GL, 
			GL+'  '+
			(SELECT ClassName FROM Ins_ClassInfo WHERE ClassId=G.ClassId) AS Remarks 			
			 FROM [dbo].[Res_GradingSystem] AS G WHERE G.VersionID IN(SELECT VersionID FROM #MAINEXAM)
			 AND G.SessionId IN(SELECT SessionId FROM #MAINEXAM)
			 AND G.ClassId IN (SELECT ClassId FROM #MAINEXAM)			  
			end
			if(@Block=3)
			begin
			SELECT ROW_NUMBER() Over (Order by S.SubID) as Sub, cast(ROW_NUMBER() Over (Order by S.SubID) as varchar(50))+' Subject' As [NoOfSub]
			 FROM Res_SubjectSetup AS S WHERE S.VersionID IN(SELECT VersionID FROM #MAINEXAM)
			 AND S.SessionId IN(SELECT SessionId FROM #MAINEXAM)
			 AND S.ClassId IN (SELECT ClassId FROM #MAINEXAM)
			  AND S.GroupId IN(SELECT GroupId FROM #MAINEXAM) 		  
			end
			DROP TABLE #MAINEXAM

END
