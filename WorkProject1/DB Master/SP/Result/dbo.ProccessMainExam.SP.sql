/****** Object:  StoredProcedure [dbo].[ProccessMainExam]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessMainExam]'))
BEGIN
DROP PROCEDURE  ProccessMainExam
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- [ProccessMainExam] 1,1,1,9,2,23,1030
CREATE PROCEDURE [dbo].[ProccessMainExam] 
	@VersionId int ,
	@SessionId int ,
	@ShiftId	INT ,
	@ClassId int ,
	@GroupId int ,
	@SectionId int,
	@MainExamId int
AS
BEGIN
	DECLARE @DBname VARCHAR(100)
    set @DBname=(select DB_Name())

	/*marks Migration Rule */
DECLARE @BodyCalculationRule VARCHAR(1)
DECLARE @TotalCalculatuonRule VARCHAR(1)
Select @BodyCalculationRule=MMS.BodyCalculationRule,@TotalCalculatuonRule=MMS.TotalCalculatuonRule from [dbo].[Res_MarksMigratedSetup] MMS Where MMS.VersionID=@VersionId and MMS.SessionID=@SessionId and MMS.ClassID=@ClassId and MMS.IsDeleted=0

/**/
	

CREATE TABLE #TempMarks(
	[MarksId] [int] IDENTITY(1,1) NOT NULL,
	[StudentIID] [bigint] NOT NULL,
	[MainExamID] [int] NOT NULL,
	[SubExamID] [int] NOT NULL,
	[DividedExamID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[ObtainMarks] [decimal](8, 2) NOT NULL,
	[IsAbsent] [bit] NOT NULL
	)

INSERT INTO #TempMarks 
	SELECT M.[StudentIID] ,M.[MainExamID] ,M.[SubExamID] ,M.[DividedExamID] ,
		M.[SubjectID] ,M.[ObtainMarks] ,M.[IsAbsent] 
	 FROM [dbo].[Res_MainExamMarks] M
	 INNER JOIN [dbo].[Student_BasicInfo] S ON S.[StudentIID] = M.[StudentIID] 
	 INNER JOIN [dbo].[Qry_MarkSetup] QM ON M.MainExamID=QM.MainExamID AND  M.SubjectID=QM.MainExamSubjectID 
	 AND M.SubExamID=QM.SubExamId  AND M.DividedExamID=QM.DividedExamId 
	 WHERE M.VersionId = @VersionId AND M.[SessionId] =  @SessionId AND M.ShiftId=@ShiftId AND  M.[ClassId] =  @ClassId 
	 AND M.GroupId = @GroupId AND M.SectionId=@SectionId AND M.MainExamID = @MainExamId AND S.[Status]='A' AND QM.[MIsDeleted]=0 and QM.[SIsDeleted]=0 
	 and QM.[DIsDeleted]=0 
	-- AND M.StudentIID IN (1050)
	 --AND M.SubjectID IN (56,57)
	 ORDER BY StudentIID 

	 --SELECT * FROM #TempMarks ORDER BY SubjectID	 return 
	 Print @@Rowcount


DECLARE @COUNTER INT, @MAXID INT 
DECLARE  @StudentIID INT, @SubExamID int , @MarkSetupId int, @DividedExamMarkSetupID INT,
 @DividedExamID int ,@SubjectID int ,@ObtainMarks decimal(8,2),@IsPass bit,@IsAbsent bit
DECLARE @ResultId BIGINT


	

SET @COUNTER = 1
SELECT @MAXID = COUNT(*) FROM #TempMarks
--return error if @MAXID is zero or null//check

WHILE (@COUNTER <= @MAXID)
BEGIN
	SELECT   @StudentIID =StudentIID, @SubExamID = SubExamID , @DividedExamID =  DividedExamID , @SubjectID = SubjectID , @ObtainMarks = ObtainMarks, @IsAbsent =IsAbsent
		 FROM #TempMarks WHERE MarksId = @COUNTER

		 PRINT @COUNTER 
		 PRINT 'EXEC ProccessMarks ' + CAST(@VersionId AS VARCHAR) +','+ CAST(@SessionId AS VARCHAR) +','+ CAST(@ShiftId AS VARCHAR) +','
									 + CAST(@ClassId AS VARCHAR) +','+ CAST(@GroupId AS VARCHAR) +','+ CAST(@StudentIID AS VARCHAR) +','
									 + CAST(@MainExamId AS VARCHAR) +',' + CAST(@SubExamID AS VARCHAR) +','+ CAST(@DividedExamID AS VARCHAR) +','
									 + CAST(@SubjectID AS VARCHAR) +','+ CAST(@ObtainMarks AS VARCHAR) +','
									 + CAST(@IsAbsent AS VARCHAR) +','''+ CAST(@BodyCalculationRule AS VARCHAR) +''','''
									 + CAST(@TotalCalculatuonRule AS VARCHAR) +''','''+ CAST(@DBname AS VARCHAR) +''''

	 Exec  ProccessMarks @VersionId , @SessionId , @ShiftId, @ClassId, @GroupId,@StudentIID, 
						@MainExamId,@SubExamID,@DividedExamID,@SubjectID,@ObtainMarks,
						@IsAbsent,@BodyCalculationRule,@TotalCalculatuonRule,@DBname
	



	SET @COUNTER = @COUNTER +1
END



END
