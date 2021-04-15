/****** Object:  StoredProcedure [dbo].[ProccessGrandAllSubjectMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessGrandAllSubjectMarks]'))
BEGIN
DROP PROCEDURE  ProccessGrandAllSubjectMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- execute ProccessGrandAllSubjectMarks 1,6,1,6,0,1

CREATE PROCEDURE [dbo].[ProccessGrandAllSubjectMarks]  
	(@VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@GrandExamId int
	)
AS
BEGIN



DECLARE @TotalCalculatuonRule varchar(5) , @IfAvarage bit=0,  @NumberExam int =3 ,  @MainExamId1 int, @MainExamId2 int
If EXISTS (select Tag From Res_Config where classId=@ClassId and Tag='AVG')
BEGIN
set @IfAvarage=1
END

Select @MainExamId1=MainExamId from [dbo].[Res_GrandSetup] where [GrandExamId]=@GrandExamId and [MainExamPercent]=40
Select @MainExamId2=MainExamId from [dbo].[Res_GrandSetup] where [GrandExamId]=@GrandExamId and [MainExamPercent]=60


DELETE  MERD  FROM [dbo].[Res_GrandResultSubjectDetails] MERD INNER JOIN Student_BasicInfo   S ON S.StudentIID = MERD.[StudentIID]
WHERE GrandExamId =@GrandExamId AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId



Select @TotalCalculatuonRule=MMS.TotalCalculatuonRule from [dbo].[Res_MarksMigratedSetup] MMS Where MMS.VersionID=@VersionId and MMS.SessionID=@SessionId and MMS.ClassID=@ClassId and MMS.IsDeleted=0

if(@IfAvarage=0)
BEGIN

print 'heeeeeeeeeeeeeeeeee'
INSERT INTO [dbo].[Res_GrandResultSubjectDetails]
           ([SubjectID]
           ,[GrandExamId]
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
		   ,SubjectOriginalObtMarks
           )
     
          
SELECT SubjectID,@GrandExamId, MERD.StudentIID
,SUM(SubExamTotalObt) AS TotalObt
,dbo.ConvertMarks( SUM(SubExamTotalConv),@TotalCalculatuonRule) AS TotalConv
,SUM(SubExamTotalFrac) AS TotalFrac
,dbo.Grand_GPCalcBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubExamTotalConv),@TotalCalculatuonRule),SubjectID,@GrandExamId,@TotalCalculatuonRule) AS GP
,dbo.Grand_GLCalcBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubExamTotalConv),@TotalCalculatuonRule),SubjectID,@GrandExamId,@TotalCalculatuonRule) AS GL
,0 AS [SubjectHighestMark]

,(CASE
WHEN  dbo.CheckGrandExamIsPass(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubExamTotalConv),@TotalCalculatuonRule),SubjectID,@GrandExamId) = 1
THEN (
ISNULL((SELECT TOP 1 0 FROM [Res_GrandResultMarksDetails] R 
		WHERE R.GrandExamId =@GrandExamId AND R.SubjectID= MERD.SubjectID AND R.StudentIID=MERD.StudentIID 
		AND SubExamIsPass=0 ),1)
) ELSE 0
END) as ispass ---

,ISNULL((
		SELECT 1 FROM [Res_GrandResultMarksDetails] R 
		WHERE R.GrandExamId =@GrandExamId AND R.SubjectID= MERD.SubjectID AND R.StudentIID=MERD.StudentIID 
		AND ([WrittenIsAbsent1]=1 AND [WrittenIsAbsent2]=1 AND [WrittenIsAbsent3] = 1 AND [SubjectiveIsAbsent]=1 AND [ObjectiveIsAbsent]=1 AND [PracticalIsAbsent] =1)

		
),0)  AS IsAbs
,0
,1
,0
,1
,SUM(SubExamOriginalTotalObt) AS OriginalTotalObt


 FROM [dbo].[Res_GrandResultMarksDetails] MERD INNER JOIN Student_BasicInfo S ON S.StudentIID = MERD.[StudentIID]
WHERE GrandExamId =@GrandExamId  AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId
GROUP BY MERD.StudentIID , SubjectID
ORDER BY MERD.StudentIID
End
Else
Begin
SELECT @NumberExam=Count(MainExamId) from Res_GrandSetup where GrandExamId =@GrandexamId
IF((select DB_NAME()) in ('zcpsc_new_db','scpsc_new_db'))
BEGIN
INSERT INTO [dbo].[Res_GrandResultSubjectDetails]
           ([SubjectID]
           ,[GrandExamId]
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
		   ,SubjectOriginalObtMarks
           )
     
          
SELECT SubjectID,@GrandExamId, MS.StudentIID
,SUM(SubjectObtMarks)/@NumberExam AS TotalObt
,dbo.ConvertMarks( SUM(SubjectConvertedMarksFraction)/@NumberExam,@TotalCalculatuonRule) AS TotalConv
,SUM(SubjectConvertedMarksFraction)/@NumberExam  AS TotalFrac
,dbo.Grand_GPCalcBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarksFraction)/@NumberExam ,@TotalCalculatuonRule),SubjectID,@GrandExamId,@TotalCalculatuonRule) AS GP
,dbo.Grand_GLCalcBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarksFraction)/@NumberExam ,@TotalCalculatuonRule),SubjectID,@GrandExamId,@TotalCalculatuonRule) AS GL
,0 AS [SubjectHighestMark]
,(CASE
WHEN  dbo.CheckGrandExamIsPass(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarksFraction)/@NumberExam,@TotalCalculatuonRule),SubjectID,@GrandExamId) = 1
THEN (
ISNULL((SELECT TOP 1 0 FROM [Res_GrandResultMarksDetails] R 
		WHERE R.GrandExamId =@GrandExamId AND R.SubjectID= MS.SubjectID 
		AND R.StudentIID=MS.StudentIID 
		AND R.SubExamIsPass=0 ),1)
) ELSE 0
END) as ispass ---
,
ISNULL((
		SELECT 1 FROM [Res_GrandResultMarksDetails] R 
		WHERE R.GrandExamId =@GrandExamId AND R.SubjectID= MS.SubjectID AND R.StudentIID=MS.StudentIID 
		AND (R.[WrittenIsAbsent1]=1 AND R.[WrittenIsAbsent2]=1 AND R.[WrittenIsAbsent3] = 1 AND R.[SubjectiveIsAbsent]=1 AND R.[ObjectiveIsAbsent]=1 AND R.[PracticalIsAbsent] =1)

		
),0)  AS IsAbs

,0
,1
,0
,1
,0


from Res_MainExamResultSubjectDetails MS inner join Res_GrandSetup GS on MS.MainExamId=GS.MainExamId 
inner join Student_BasicInfo S on S.StudentIID = MS.[StudentIID] where GS.GrandExamId=@GrandExamId AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId GROUP BY MS.StudentIID , MS.SubjectID
ORDER BY MS.StudentIID
END
ELSE

BEGIN
IF((select DB_NAME()) <> 'abc_new_db')
BEGIN
			 INSERT INTO [dbo].[Res_GrandResultSubjectDetails]
					   ([SubjectID]
					   ,[GrandExamId]
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
					   ,SubjectOriginalObtMarks
					   )
     
          
			SELECT SubjectID,@GrandExamId, MS.StudentIID
			,SUM(SubjectObtMarks)/@NumberExam AS TotalObt
			,dbo.ConvertMarks( SUM(SubjectConvertedMarks)/@NumberExam,@TotalCalculatuonRule) AS TotalConv
			,SUM(SubjectConvertedMarksFraction)/@NumberExam  AS TotalFrac
			,dbo.Grand_GPCalcBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarks)/@NumberExam ,@TotalCalculatuonRule),SubjectID,@GrandExamId,@TotalCalculatuonRule) AS GP
			,dbo.Grand_GLCalcBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarks)/@NumberExam ,@TotalCalculatuonRule),SubjectID,@GrandExamId,@TotalCalculatuonRule) AS GL
			,0 AS [SubjectHighestMark]
			,(CASE
			WHEN  dbo.CheckGrandExamIsPass(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarks)/@NumberExam,@TotalCalculatuonRule),SubjectID,@GrandExamId) = 1
			THEN (
			ISNULL((SELECT TOP 1 0 FROM [Res_GrandResultMarksDetails] R 
					WHERE R.GrandExamId =@GrandExamId AND R.SubjectID= MS.SubjectID 
					AND R.StudentIID=MS.StudentIID 
					AND R.SubExamIsPass=0 ),1)
			) ELSE 0
			END) as ispass ---
			,
			ISNULL((
					SELECT 1 FROM [Res_GrandResultMarksDetails] R 
					WHERE R.GrandExamId =@GrandExamId AND R.SubjectID= MS.SubjectID AND R.StudentIID=MS.StudentIID 
					AND (R.[WrittenIsAbsent1]=1 AND R.[WrittenIsAbsent2]=1 AND R.[WrittenIsAbsent3] = 1 AND R.[SubjectiveIsAbsent]=1 AND R.[ObjectiveIsAbsent]=1 AND R.[PracticalIsAbsent] =1)

		
			),0)  AS IsAbs

			,0
			,1
			,0
			,1
			,0


			from Res_MainExamResultSubjectDetails MS inner join Res_GrandSetup GS on MS.MainExamId=GS.MainExamId 
			inner join Student_BasicInfo S on S.StudentIID = MS.[StudentIID] where GS.GrandExamId=@GrandExamId AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId GROUP BY MS.StudentIID , MS.SubjectID
			ORDER BY MS.StudentIID
END
ELSE
BEGIN
 INSERT INTO [dbo].[Res_GrandResultSubjectDetails]
           ([SubjectID]
           ,[GrandExamId]
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
		   ,SubjectOriginalObtMarks
           )
     
          
SELECT SubjectID,@GrandExamId, MS.StudentIID
,SUM(SubjectObtMarks)/@NumberExam AS TotalObt
,dbo.ConvertMarks( 

--SUM(SubjectConvertedMarks)

(select TOP 1 SubjectConvertedMarks*0.4 FROM Res_MainExamResultSubjectDetails MS 
inner join Res_GrandSetup GS on MS.MainExamId=GS.MainExamId 
inner join Student_BasicInfo S on S.StudentIID = MS.[StudentIID] where MS.MainExamId=@MainExamId1 and GS.GrandExamId=@GrandExamId AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId 
)

+
(select TOP 1 SubjectConvertedMarks*0.6 FROM Res_MainExamResultSubjectDetails MS 
inner join Res_GrandSetup GS on MS.MainExamId=GS.MainExamId 
inner join Student_BasicInfo S on S.StudentIID = MS.[StudentIID] where MS.MainExamId=@MainExamId2 and GS.GrandExamId=@GrandExamId AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId 
)

,@TotalCalculatuonRule) AS TotalConv
,SUM(SubjectConvertedMarksFraction)/@NumberExam  AS TotalFrac
,dbo.Grand_GPCalcBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarks)/@NumberExam ,@TotalCalculatuonRule),SubjectID,@GrandExamId,@TotalCalculatuonRule) AS GP
,dbo.Grand_GLCalcBySubId(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarks)/@NumberExam ,@TotalCalculatuonRule),SubjectID,@GrandExamId,@TotalCalculatuonRule) AS GL
,0 AS [SubjectHighestMark]
,(CASE
WHEN  dbo.CheckGrandExamIsPass(@VersionId,@SessionId, @ClassId,dbo.ConvertMarks( SUM(SubjectConvertedMarks)/@NumberExam,@TotalCalculatuonRule),SubjectID,@GrandExamId) = 1
THEN (
ISNULL((SELECT TOP 1 0 FROM [Res_GrandResultMarksDetails] R 
		WHERE R.GrandExamId =@GrandExamId AND R.SubjectID= MS.SubjectID 
		AND R.StudentIID=MS.StudentIID 
		AND R.SubExamIsPass=0 ),1)
) ELSE 0
END) as ispass ---
,
ISNULL((
		SELECT 1 FROM [Res_GrandResultMarksDetails] R 
		WHERE R.GrandExamId =@GrandExamId AND R.SubjectID= MS.SubjectID AND R.StudentIID=MS.StudentIID 
		AND (R.[WrittenIsAbsent1]=1 AND R.[WrittenIsAbsent2]=1 AND R.[WrittenIsAbsent3] = 1 AND R.[SubjectiveIsAbsent]=1 AND R.[ObjectiveIsAbsent]=1 AND R.[PracticalIsAbsent] =1)

		
),0)  AS IsAbs

,0
,1
,0
,1
,0


from Res_MainExamResultSubjectDetails MS inner join Res_GrandSetup GS on MS.MainExamId=GS.MainExamId 
inner join Student_BasicInfo S on S.StudentIID = MS.[StudentIID] where GS.GrandExamId=@GrandExamId AND S.ShiftID =@ShiftId AND S.GroupId = @GroupId GROUP BY MS.StudentIID , MS.SubjectID
ORDER BY MS.StudentIID
END
END
END


UPDATE [Res_GrandResultSubjectDetails] 
SET SubjectGP = 0.0,
	SubjectGL = 'F'
	WHERE GrandExamId = @GrandExamId AND SubjectIsPass = 0


END