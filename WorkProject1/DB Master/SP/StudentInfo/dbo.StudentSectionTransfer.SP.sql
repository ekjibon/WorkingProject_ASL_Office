/****** Object:  StoredProcedure [dbo].[GetStudentInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[StudentSectionTransfer]'))
BEGIN
DROP PROCEDURE  StudentSectionTransfer
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--StudentSectionTransfer 1,1,1,1,1,1,0,1,1,1,1,1,1,0,'15,55,85,'
CREATE PROCEDURE [dbo].[StudentSectionTransfer] 
	
	@FSessionId INT ,
	@FBranchID INT ,
	@FShiftID INT ,
	@FClassId INT ,

	@FSectionId INT ,
	
	@TSessionId INT ,
	@TBranchID INT ,
	@TShiftID INT ,
	@TClassId INT ,

	@TSectionId INT ,
	@StuIds VARCHAR(1000)
	
	
AS
BEGIN
IF 1=0 BEGIN
    SET FMTONLY OFF
END

SELECT value  INTO #StuId
FROM STRING_SPLIT(@StuIds, ',')  

BEGIN TRANSACTION;
	BEGIN TRY

	UPDATE Student_BasicInfo 
	SET 
		BranchID = @TBranchID ,
		SessionId = @TSessionId,
		ShiftID = @TShiftID,
		ClassId = @TClassId,
		
		SectionId = @TSectionId
	WHERE 
		
		BranchID = @FBranchID AND
		SessionId = @FSessionId AND
		ShiftID = @FShiftID AND
		ClassId = @FClassId AND
		
		SectionId = @FSectionId
		AND StudentIID IN (SELECT * FROM #StuId)

	END TRY
		BEGIN CATCH
			SELECT '999' AS MessageCode, ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;

			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
		END CATCH;
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
		

END


