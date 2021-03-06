/****** Object:  StoredProcedure [dbo].[InsertMarksForApps]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertMarksForApps]'))
BEGIN
DROP PROCEDURE  InsertMarksForApps
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--execute InsertMarksForApps 2002,2012,9,2011,1,3019,1 ,0,104,103,101,136,15,0,'Good','biplob'
--execute InsertMarksForApps 1,5,1,14,1,48,1283,0,117,123,111,4,15,0,'Good','biplob'  

-- Truncate Table  [dbo].[Res_MainExamMarks] Truncate Table [dbo].[Res_MainExamResult] Truncate Table [dbo].[Res_MainExamResultSubjectDetails] Truncate Table[dbo].[Res_MEResultDetails]
CREATE PROCEDURE [dbo].[InsertMarksForApps]   --execute InsertMarksForApps 1,8,2,1,0,1,1177 ,0,  1,1,3,  7,0.0,0,'U','a824790f-6be8-4218-9c10-72eea8d83f89'
	(
	
	@StudentIID int,
	@MarksID int,
	@MainExamID int,
	@SubExamID int,
	@DividedExamID int,
	@SubjectID int,
	@ObtainMarks decimal(8,2),
	@IsAbsent bit,
	@Remarks VARCHAR(100),
	@AddedBy VARCHAR(50)

	)
AS
BEGIN

	DECLARE @VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@SectionId int

	SELECT @VersionID = VersionID , @SessionId =  SessionId,@ShiftId = ShiftID , @ClassId = ClassId , @GroupId =  GroupId , @SectionId = SectionId 
	FROM Student_BasicInfo WHERE StudentIID = @StudentIID

IF (@IsAbsent=1)
BEGIN
SET @ObtainMarks=0
END
DECLARE @ConvertedMarks_Abs decimal(8, 2) ,
	@ConvertedMarks_Ceiling decimal(8, 2) ,
	@ConvertedMarks_Floor decimal(8, 2) ,
	@ConvertedMarks_Round decimal(8, 2),
	@ConvertedMarks decimal(8, 2),
	@ConvertedMarksFraction decimal(8, 2),
	@FullMarks  decimal(8, 2),
	@ExamMarks  decimal(8, 2)

DECLARE @err_message nvarchar(255) , @DivExamType varchar(10) ,
		@DivIsPassDepended BIT

	SELECT @FullMarks = MS.DividedExamFullMarks,
		   @ExamMarks = MS.DividedExamExamMarks,
		   @DivExamType = MS.DividedExamType,
		   @DivIsPassDepended = MS.DividedExamIsPassDepend
	 FROM [dbo].[Qry_MarkSetup] MS 
	WHERE MS.MainExamId= @MainExamID AND 
		  MS.SubExamId = @SubExamID AND 
		  MS.DividedExamId = @DividedExamID AND
		  MS.MainExamSubjectID = @SubjectID

		  PRINT @FullMarks 
		  PRINT @ExamMarks
IF (@FullMarks>0 AND @ExamMarks>0)
	BEGIN
		
		SET @ConvertedMarks =( (@FullMarks* @ObtainMarks) / @ExamMarks)
	END	
ELSE
	BEGIN
		SET @err_message = 'Invaild Setup'
		SELECT @err_message AS SUCCESS_OR_FAIL
		RAISERROR (@err_message,10, 1) 
		 return -1
	END


IF(@MarksID=0)  -- If Marks Does not entry Insert it
	BEGIN

	--PRINT @DivExamFullmarks
	    IF NOT EXISTS(SELECT * FROM [Res_MainExamMarks] AS M WHERE M.VersionId=@VersionId AND M.SessionId=@SessionId AND M.ShiftId = @ShiftId AND M.ClassId=@ClassId AND M.GroupId=@GroupId AND M.SectionId=@SectionId AND M.StudentIID=@StudentIID AND M.SubjectID =@SubjectID AND M.MainExamID=@MainExamID AND M.SubExamID=@SubExamID AND M.DividedExamID=@DividedExamID AND M.IsDeleted=0 )
		BEGIN
			Insert into [dbo].[Res_MainExamMarks]([VersionId],[SessionId],[ShiftId],[ClassId],[GroupId],[SectionId], 
			[StudentIID],[MainExamID],[SubExamID],[DividedExamID],[SubjectID], [ObtainMarks],[ConvertedMarks_Abs],[ConvertedMarks_Ceiling],[ConvertedMarks_Floor],[ConvertedMarks_Round],[ConvertedMarks],
			[ConvertedMarksFraction], [DividedExamType],[IsPassDepended],[IsPass],[IsAbsent],[IsDeleted], [AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status])
		    values(@VersionId, @SessionId,@ShiftId,@ClassId,@GroupId,@SectionId,
		    @StudentIID,@MainExamID,@SubExamID,@DividedExamID,@SubjectID, @ObtainMarks,0,0,0,0,@ConvertedMarks,0, @DivExamType,@DivIsPassDepended,0,@IsAbsent,0,@AddedBy,GETDATE(),@AddedBy,GETDATE(),@Remarks ,'A')
		    SELECT @@ROWCOUNT AS SUCCESS_OR_FAIL
		END
		ELSE
		BEGIN 
			Update [dbo].[Res_MainExamMarks] set ObtainMarks=@ObtainMarks, [IsAbsent]=@IsAbsent, ConvertedMarks = @ConvertedMarks WHERE VersionId=@VersionId AND SessionId=@SessionId AND ShiftId = @ShiftId AND ClassId=@ClassId AND GroupId=@GroupId AND SectionId=@SectionId AND StudentIID=@StudentIID AND SubjectID =@SubjectID AND MainExamID=@MainExamID AND SubExamID=@SubExamID AND DividedExamID=@DividedExamID AND IsDeleted=0  
			SELECT @@ROWCOUNT AS SUCCESS_OR_FAIL
		END

		 --PRINT 'Marks Table Insert Success'
	END
Else ---  If Marks entry Then Update marks
--PRINT  @MarksID
	BEGIN
	Update [dbo].[Res_MainExamMarks] set ObtainMarks=@ObtainMarks, [IsAbsent]=@IsAbsent,
	ConvertedMarks = @ConvertedMarks where MarksId=@MarksID
	SELECT @@ROWCOUNT AS SUCCESS_OR_FAIL
		--PRINT 'Marks Table Update Success'
	End


/*End Process*/
--SELECT @@ROWCOUNT AS SUCCESS_OR_FAIL
END

--execute InsertMarksForApps 1,1,1,1, 1,1,2,2 ,0,1,1,1,10.0,0,'Good','biplob'
--Add Validation and Update Absent By Shahin 17Dec2017 as per scpsc 
