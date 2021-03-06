/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ClearProcessFees]'))
BEGIN
DROP PROCEDURE  [ClearProcessFees]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Biplob
-- Create date: 
-- Description:	
-- =============================================

 --execute ProcessFees 51,1
CREATE  PROCEDURE [dbo].[ClearProcessFees] 
   @ProcessTypeId int=null,
   @FeesSessionYearId int=1,
   @Type Varchar(1),
   @Block int=1
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 
BEGIN TRY

Declare @MonthId int 
SELECT @MonthId=MonthId From Fees_FeesSessionYear where FeesSessionYearId=@FeesSessionYearId
Print '@MonthId-------------------' Print @MonthId

If(@Block=1) -- Clare Process type wise
BEGIN
 Insert Into Fees_TempCollection(
	[ProcessId], 
	[SessionId],
	[MonthId] ,
	[StudentIID] ,
	[HeadId] ,
	[TotalAmount] ,
	[DueAmount] ,
	[NoModifiedDueAmount],
	[ScholarshipAmount] ,
	[DiscountAmount],
	[PaidAmount] ,
	[AdvanceAmount] ,
	[IsPaid] ,
	[IsCompleted],
	[Narration] ,
	[FeesBookNo],
	[ProcessType] ,
	[IsDeleted] ,
	[AddBy] ,
	[AddDate] ,
	[UpdateBy] ,
	[UpdateDate] ,
	[Remarks],
	[Status],
	[IP] ,
	[MacAddress])
	select [ProcessId], 
	[SessionId],
	[MonthId] ,
	[StudentIID] ,
	[HeadId] ,
	[TotalAmount] ,
	[DueAmount] ,
	[NoModifiedDueAmount],
	[ScholarshipAmount] ,
	[DiscountAmount],
	[PaidAmount] ,
	[AdvanceAmount] ,
	[IsPaid] ,
	[IsCompleted],
	[Narration] ,
	[FeesBookNo],
	[ProcessType] ,
	[IsDeleted] ,
	[AddBy] ,
	[AddDate] ,
	[UpdateBy] ,
	[UpdateDate] ,
	[Remarks],
	[Status],
	[IP] ,
	[MacAddress] From  Fees_Student where ProcessId=@ProcessTypeId and FeesSessionYearId=@FeesSessionYearId AND PaidAmount>0 and IsPaid=1 And ProcessType=@Type
    delete Fees_Student where ProcessId=@ProcessTypeId and FeesSessionYearId=@FeesSessionYearId  And ProcessType=@Type
 END

 IF(@Block=2)
 BEGIN
 declare @x int
 END
------------------------------
COMMIT TRANSACTION ;
END TRY
BEGIN CATCH;
	ROLLBACK TRANSACTION ;
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  
    RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);  

END CATCH  


END
GO



