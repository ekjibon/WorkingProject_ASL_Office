/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[QuickStudentFees]'))
BEGIN
DROP PROCEDURE  QuickStudentFees
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].QuickStudentFees 
	@IID Bigint,
	@SessionId INT = NULL
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 

BEGIN TRY

Declare @MonthId int ,@YearValue int,
@ProcessTypeId INT, @FeesSessionYearId INT , @ProcessSessionId INT , @ClassId INT , @GroudId INT , @SectionId INT 

select @ClassId=ClassId,@GroudId=GroupId,@SectionId=SectionId from dbo.Student_BasicInfo where StudentIID=@IID

SELECT @ProcessTypeId = FeesProcessId FROM Fees_Process WHERE SessionId = @SessionId AND ProcessType = 1
SELECT TOP 1 @FeesSessionYearId = SessionYearId  FROM Fees_ProcessDetails WHERE ProcessId = @ProcessTypeId
	SET @ProcessSessionId = @SessionId

SELECT @MonthId=MonthId,@YearValue=[YEAR] From Fees_FeesSessionYear 
where FeesSessionYearId=@FeesSessionYearId
Print '@MonthId-------------------' Print @MonthId

CREATE TABLE #tmpFees_HeadAmountConfig(
	[Id] [int] IDENTITY(1,1) NOT NULL,	
	[HeadId] [int] NOT NULL,
	[VersionId] [int] NOT NULL,
	[SessionId] [int] NOT NULL,
	[BranchId] [int] NULL,
	[ShiftId] [int] NULL,
	[ClassId] [int] NOT NULL,
	[GroupId] [int] NULL,
	[FessGroupId] [int] NULL,
	[StudentIID] [int] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[SectionId] [int] NOT NULL,
	[Priority] [int]  NULL
)

	
INSERT INTO #tmpFees_HeadAmountConfig
	([HeadId],[VersionId],[SessionId],[BranchId],[ShiftId],[ClassId],[GroupId],[FessGroupId],[StudentIID],[Amount],[SectionId],[Priority])  
SELECT 
	 A.[HeadId],A.[VersionId],A.[SessionId],A.[BranchId],A.[ShiftId],A.[ClassId],A.[GroupId],A.[FessGroupId],A.[StudentIID],A.[Amount],A.[SectionId],P.[AdvancePriority]
 FROM Fees_HeadAmountConfig A 
 Left Join Fees_HeadPriority  P ON P.FeesHeadId=A.HeadId
 WHERE isnull(A.IsDeleted,0) = 0 --AND StudentIID is null
 and (A.ProcessId=@ProcessTypeId OR @ProcessTypeId is null OR @ProcessTypeId=0) 
 and A.ClassId=@ClassId and A.GroupId=@GroudId and A.SectionId=@SectionId
 Order BY P.VersionId,P.SessionId,P.BranchId,P.ClassId, P.[AdvancePriority] ASC
 
			
DECLARE @COUNTER INT, @MAXID INT,@totalloop int=0,@tt int=34, @dd int=0;

SET @COUNTER = 1
SELECT @MAXID = COUNT(*) FROM #tmpFees_HeadAmountConfig
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
	[MacAddress] From  Fees_Student where ProcessId=@ProcessTypeId and MonthId=@MonthId And ProcessType='G' AND PaidAmount>0 and IsPaid=1

	Create Table #Fees_TempCollection
	(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProcessId] int, 	
	[MonthId] int,
	[StudentIID] int ,
	[HeadId] int ,
	[PaidAmount] decimal(18,2),
	[AdvanceAmount] decimal(18,2)
	)

	Insert Into #Fees_TempCollection
	(
	[ProcessId] ,
	[MonthId] ,
	[StudentIID],
	[HeadId],
	[PaidAmount] ,
	[AdvanceAmount]
	)
	 SELECT [ProcessId] ,
	[MonthId] ,
	[StudentIID],
	[HeadId],
	[PaidAmount],[AdvanceAmount] From Fees_TempCollection where ProcessId=@ProcessTypeId and MonthId=@MonthId And ProcessType='G' AND PaidAmount>0 and IsPaid=1

delete Fees_Student where ProcessId=@ProcessTypeId and MonthId=@MonthId And ProcessType='G'

WHILE (@COUNTER <= @MAXID)
	BEGIN
	--		ProcessFees 23,1
	--      select * from Fees_HeadAmountConfig --where AMount=0  --update Fees_HeadAmountConfig set amount=120 where AMount=0
	/*
	FeesCategoryId	CategoryName
1	Common Fees
2	Individual Fees
3	Automated Fees
	*/
	DECLARE @HeadId int,@FeesGroupId int,@versionId int,@BranchId int,@ShiftId int,
	@ClassId int,@GroupId int,@FessGroupId int,@StudentIID int,@Amount decimal (18,2),@PaidAmount decimal (18,2)=0,@RC int,@SectionId int;
	
	SELECT @HeadId=HeadId,@FeesGroupId=tmp.FessGroupId,@versionId=VersionId, @BranchId=BranchId,@ShiftId=ShiftId,
	@ClassId=ClassId,@GroupId=GroupId,@SectionId=SectionId,@StudentIID=StudentIID,@Amount=Amount  
	FROM #tmpFees_HeadAmountConfig tmp WHERE id=@COUNTER

	DECLARE @Category int;
	select @Category=CategoryId from Fees_Head where FeesHeadId=@HeadId
	
	--Common Fees
	BEGIN
		
		IF(@Amount<=0)
				RAISERROR ('Amount can not be 0.',16,1);
			SET @StudentIID=@IID
			If Exists (SELECT StudentIID FROM #Fees_TempCollection Where StudentIID=@StudentIID)
			BEGIN
			 SELECT Top(1) @PaidAmount=PaidAmount FROM #Fees_TempCollection  Where StudentIID=@StudentIID AND ProcessId=@ProcessTypeId and MonthId=@MonthId AND HeadId=@HeadId
			 DELETE  Fees_TempCollection  where ProcessId=@ProcessTypeId and MonthId=@MonthId AND  ProcessType='G' AND PaidAmount>0 and IsPaid=1 AND StudentIID=@StudentIID AND HeadId=@HeadId 
			END
			EXECUTE @RC = [dbo].[InsertSingleStudentFee]  @ProcessTypeId,@MonthId,@SessionId,@StudentIID,@Amount,@PaidAmount,@HeadId,'G',@FeesSessionYearId,0,0,@YearValue;			
			
			SET @totalloop=@totalloop+1;
			SET  @StudentIID=null
			SET @PaidAmount=0
		
	 
	END
	
	print @totalloop
	SET @COUNTER = @COUNTER + 1
	END
------------------------------
DROP table #tmpFees_HeadAmountConfig
drop table  #Fees_TempCollection

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
select @MonthId
END