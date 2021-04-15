IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertStudentEnrollment]'))
BEGIN
DROP PROCEDURE  [InsertStudentEnrollment]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [InsertStudentEnrollment] 5137
Create Procedure [dbo].[InsertStudentEnrollment]
(
@StudentId INT=NULL

)
As
BEGIN
DECLARE 
    @ErrorMessage  NVARCHAR(4000), 
    @ErrorSeverity INT, 
    @ErrorState    INT;
 
BEGIN TRY

DECLARE @ClassId INT,@BranchId INT,@SesionId INT,@ShiftId INT,@SectionId INT,@StudenTypeID INT,@Amount DECIMAL,@Year INT, @Month INT,@Addby VARCHAR(MAX),@Count INT,@FeesBookNo VARCHAR(MAX) 

SELECT @Count = COUNT(*) FROM dbo.Fees_Student
SET @FeesBookNo = CAST(YEAR(GETDATE()) AS VARCHAR) + CAST(MONTH(GETDATE()) AS VARCHAR) + CAST(@Count+1 AS VARCHAR)

--PRINT @FeesBookNo+'  ' +CAST(@Count AS VARCHAR)
 

SELECT @ClassId = ClassId,@BranchId = BranchID,@SesionId = SessionId,@ShiftId=ShiftID,@SectionId = SectionId,@Addby = AddBy,@StudenTypeID =StudentTypeID FROM dbo.Student_BasicInfo WHERE StudentIID = @StudentId


INSERT INTO [dbo].[Fees_Student]
           ([ProcessId],[StudentIID],[HeadId],[TotalAmount],[DueAmount],[ScholarshipAmount],[DiscountAmount],[PaidAmount],[IsPaid]
           ,[IsCompleted],[IsDeleted],[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status],[IP],[MacAddress],[MonthId]
           ,[AdvanceAmount],[Narration],[FeesBookNo],[SessionId],[ProcessType],[NoModifiedDueAmount],[FeesSessionYearId],[EmpId]
		   ,[IsVerification],[AppVerificationNo],[AutomatedDays],[AutomatedConsecutiveDays],[IsPublished],[Year],[InvoiceAmount],[ProcessedAmount])

			 SELECT 0,@StudentId,HeadId,Amount,Amount,0,0,0,0
					,0,0,@Addby,GETDATE(),'',GETDATE(),'','','','',MONTH(DueMonth)
					,0,'',@FeesBookNo,@SesionId,'E',0,0,''
					,'','',0,0,1,YEAR(DueMonth),Amount,0  
				FROM dbo.Fees_HeadAmountConfig WHERE IsEnrollment = 1 AND ClassId = @ClassId  AND IsDeleted = 0
					AND BranchId = @BranchId  AND SessionId = @SesionId AND ShiftId = @ShiftId AND SectionId = @SectionId  AND FessGroupId = @StudenTypeID

  -- SELECT * FROM dbo.Fees_HeadAmountConfig WHERE IsEnrollment = 1 AND IsDeleted = 0
		
		--SELECT @Amount,@Year,@Month
		SELECT @@ROWCOUNT

		if(@@ROWCOUNT = 0)
		Begin
		RAISERROR('Enrollment Proccess Fail', 17, 1);
		END
		
		END TRY
BEGIN CATCH
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(), 
        @ErrorSeverity = ERROR_SEVERITY(), 
        @ErrorState = ERROR_STATE();
 
    -- return the error inside the CATCH block
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
END
