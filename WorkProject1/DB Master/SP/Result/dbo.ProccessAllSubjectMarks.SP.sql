/****** Object:  StoredProcedure [dbo].[ProccessAllSubjectMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessAllSubjectMarks]'))
BEGIN
DROP PROCEDURE  ProccessAllSubjectMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--execute ProccessAllSubjectMarks 2,16,1,28,3,5
CREATE PROCEDURE [dbo].[ProccessAllSubjectMarks]  
	(@VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@MainExamId int
	)
AS
BEGIN

DECLARE @SpcValue1 INT = 1

DECLARE @TotalCalculatuonRule varchar(5)
DECLARE @S1 INT, @S2 INT, @S3 INT , @Count INT = 1, @MaxId INT

DELETE  MERD  FROM [dbo].[Res_MainExamResultSubjectDetails] MERD INNER JOIN Student_BasicInfo   S ON S.StudentIID = MERD.[StudentIID]
WHERE MainExamId =@MainExamId AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId

DELETE  MER  FROM [dbo].[Res_MainExamResult] MER INNER JOIN Student_BasicInfo   S ON S.StudentIID = MER.[StudentIID]
WHERE MainExamId =@MainExamId AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId


Select @TotalCalculatuonRule=MMS.TotalCalculatuonRule from [dbo].[Res_MarksMigratedSetup] MMS Where MMS.VersionID=@VersionId and MMS.SessionID=@SessionId and MMS.ClassID=@ClassId and MMS.IsDeleted=0

IF(DB_Name() = 'sos_new_2018' and @ClassId=9)
BEGIN
	SET @SpcValue1 =2
END

INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]
           ([ResultId]
           ,[SubjectID]
           ,[MainExamId]
		   ,[StudentIID]
           ,[SubjectObtMarks]
           ,[SubjectConvertedMarks]
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[VirtualConvertedMarks1]
           ,[VirtualIsPass1]
           ,[VirtualConvertedMarks2]
           ,[VirtualIsPass2]
		   ,[SubjectOriginalObtMarks]
           )
     
          
		SELECT 0,SubjectID,@MainExamId, MERD.StudentIID
		,SUM(SubExamTotalObt) AS TotalObt
		,dbo.ConvertMarks( SUM(SubExamTotalConv)/@SpcValue1,@TotalCalculatuonRule) AS TotalConv
		,SUM(SubExamTotalFrac) AS TotalFrac
		,dbo.GPCalculationBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubExamTotalConv)/@SpcValue1,@TotalCalculatuonRule),SubjectID,@MainExamId,@TotalCalculatuonRule) AS GP
		,dbo.GLCalculationBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubExamTotalConv)/@SpcValue1,@TotalCalculatuonRule),SubjectID,@MainExamId,@TotalCalculatuonRule) AS GL
		,0 AS [SubjectHighestMark]
		,(CASE
		WHEN  dbo.CheckMainExamIsPass(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubExamTotalConv)/@SpcValue1,@TotalCalculatuonRule),SubjectID,@MainExamId) = 1
		THEN (
		ISNULL((SELECT TOP 1 SubExamIsPass FROM [Res_MEResultDetails] R 
				WHERE R.MainExamId =@MainExamId AND R.SubjectID= MERD.SubjectID AND R.StudentIID=MERD.StudentIID 
				AND SubExamIsPass=0 ),1)
		) ELSE 0
		END) as ispass ---

		,ISNULL((
				SELECT 1 FROM [Res_MEResultDetails] R 
				WHERE R.MainExamId =@MainExamId AND R.SubjectID= MERD.SubjectID AND R.StudentIID=MERD.StudentIID 
				AND ([WrittenIsAbsent1]=1 AND [WrittenIsAbsent2]=1 AND [WrittenIsAbsent3] = 1 AND [SubjectiveIsAbsent]=1 AND [ObjectiveIsAbsent]=1 AND [PracticalIsAbsent] =1)

		
		),0)  AS IsAbs
		,0
		,1
		,0
		,1
		,SUM(SubExamOriginalTotalObt) AS OriginalTotalObt


		 FROM [dbo].[Res_MEResultDetails] MERD INNER JOIN Student_BasicInfo S ON S.StudentIID = MERD.[StudentIID]
		WHERE MainExamId =@MainExamId  AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId --AND S.StudentIID = 11196
		GROUP BY MERD.StudentIID , SubjectID
		ORDER BY MERD.StudentIID






UPDATE [Res_MainExamResultSubjectDetails] 
SET SubjectGP = 0.0,
	SubjectGL = 'F'
	WHERE MainExamId = @MainExamId AND SubjectIsPass = 0


END