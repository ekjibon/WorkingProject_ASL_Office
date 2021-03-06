/****** Object:  StoredProcedure [dbo].[InsertMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertMarks]'))
BEGIN
DROP PROCEDURE  InsertMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- execute InsertMarks 10,5,31,123,4248,0,2032,244,158,45,0,"U",UID

--execute InsertMarks 1,5,1,14,1,48,1283,0,117,123,111,4,15,0,'Good','biplob'  

-- Truncate Table  [dbo].[Res_MainExamMarks] Truncate Table [dbo].[Res_MainExamResult] Truncate Table [dbo].[Res_MainExamResultSubjectDetails] Truncate Table[dbo].[Res_MEResultDetails]
CREATE PROCEDURE [dbo].[InsertMarks]   
-- execute InsertMarks 12,1002,19,76,13609,0,1003,4,14,29,0,'U','UID'
	(
	
	@SessionId int,
	@ShiftId int,
	@ClassId int,
	@SectionId int,
	@StudentIID int,
	@MarksID int,
	@MainExamID int,
	@SubExamID int,
	@SubjectID int,
	@ObtainMarks decimal(8,2),
	@IsAbsent bit,
	@Remarks VARCHAR(100),
	@AddedBy VARCHAR(50)

	)
AS
BEGIN
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
		@SubExamIsPassDepended BIT

	SELECT @FullMarks = MS.SubExamFullMarks,
		   @ExamMarks = MS.SubExamExamMarks
		
	 FROM [dbo].[Qry_MarkSetup] MS 
	WHERE MS.MainExamId= @MainExamID AND 
		  MS.SubExamId = @SubExamID AND 
		  MS.MainExamSubjectID = @SubjectID
print '1'
IF (@FullMarks>0 AND @ExamMarks>0)
	BEGIN
print '2'
		
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
print '3'

		--PRINT @DivExamFullmarks
	    IF NOT EXISTS(SELECT * FROM [Res_MainExamMarks] AS M WHERE  M.SessionId=@SessionId AND MainExamID=@MainExamID AND M.ShiftId = @ShiftId AND M.ClassId=@ClassId AND m.SubjectID=@SubjectID and m.StudentIID=@StudentIID and m.SubExamID=@SubExamID and M.IsDeleted=0 )
		BEGIN
print '4'
			Insert into [dbo].[Res_MainExamMarks]([SessionId],[ShiftId],[ClassId],[SectionId], 
			[StudentIID],[MainExamID],[SubExamID],[SubjectID], [ObtainMarks],[ConvertedMarks],
			[IsAbsent],[IsDeleted], [AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status])
		    values(@SessionId,@ShiftId,@ClassId,@SectionId,@StudentIID,@MainExamID,@SubExamID,@SubjectID, @ObtainMarks,@ConvertedMarks,@IsAbsent,0,@AddedBy,GETDATE(),@AddedBy,GETDATE(),@Remarks ,'A')
		    SELECT @@ROWCOUNT AS SUCCESS_OR_FAIL
		END
		ELSE
		BEGIN 
print '5'
			Update [dbo].[Res_MainExamMarks] set ObtainMarks=@ObtainMarks, [IsAbsent]=@IsAbsent, ConvertedMarks = @ConvertedMarks 
			, UpdateBy = @AddedBy , UpdateDate = GETDATE()
			WHERE SessionId=@SessionId 
			AND ShiftId = @ShiftId AND ClassId=@ClassId 
			AND SectionId=@SectionId 
			AND StudentIID=@StudentIID AND SubjectID =@SubjectID 
			AND MainExamID=@MainExamID AND SubExamID=@SubExamID 
			AND IsDeleted=0  
			SELECT @@ROWCOUNT AS SUCCESS_OR_FAIL
		END

		 --PRINT 'Marks Table Insert Success'
	END
Else ---  If Marks entry Then Update marks
--PRINT  @MarksID
	BEGIN
print '6'

	Update [dbo].[Res_MainExamMarks] set ObtainMarks=@ObtainMarks, [IsAbsent]=@IsAbsent,  UpdateBy = @AddedBy , UpdateDate = GETDATE(),
	ConvertedMarks = @ConvertedMarks where MarksId=@MarksID
	SELECT @@ROWCOUNT AS SUCCESS_OR_FAIL
		--PRINT 'Marks Table Update Success'
	End


/*End Process*/
--SELECT @@ROWCOUNT AS SUCCESS_OR_FAIL
END

--execute InsertMarks 1,1,1,1, 1,1,2,2 ,0,1,1,1,10.0,0,'Good','biplob'
--Add Validation and Update Absent By Shahin 17Dec2017 as per scpsc 
