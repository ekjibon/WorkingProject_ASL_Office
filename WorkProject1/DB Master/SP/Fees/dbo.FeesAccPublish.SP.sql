/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesAccPublish]'))
BEGIN
DROP PROCEDURE  [FeesAccPublish]
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

--execute FeesAccPublish 1002,1002,'admin@admin.com'
CREATE  PROCEDURE [dbo].[FeesAccPublish] 
   @ProcessTypeId int=null,
   @FeesSessionYearId int=1,
   @AddBy VARCHAR(200)
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 

BEGIN TRY

Declare @MonthId int ,@YearValue int
SELECT @MonthId=MonthId,@YearValue=[YEAR] From Fees_FeesSessionYear where FeesSessionYearId=@FeesSessionYearId
--Print '@MonthId-------------------' Print @MonthId



CREATE TABLE #tmpFees_HeadAmountConfig(
	[Id] [int] IDENTITY(1,1) NOT NULL,	
	[HeadId] [int] NOT NULL,
	
	[SessionId] [int] NOT NULL,
	[BranchId] [int] NULL,
	[ShiftId] [int] NULL,
	[ClassId] [int] NOT NULL,
	
	[FessGroupId] [int] NULL,
	[StudentIID] [int] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[SectionId] [int] NOT NULL,
	[Priority] [int]  NULL
)

	
INSERT INTO #tmpFees_HeadAmountConfig
	([HeadId],[SessionId],[BranchId],[ShiftId],[ClassId],[FessGroupId],[StudentIID],[Amount],[SectionId],[Priority])  
SELECT 
	 A.[HeadId],A.[SessionId],A.[BranchId],A.[ShiftId],A.[ClassId],A.[FessGroupId],A.[StudentIID],A.[Amount],A.[SectionId],P.[AdvancePriority]
 FROM Fees_HeadAmountConfig A 
 Left Join Fees_HeadPriority  P ON P.FeesHeadId=A.HeadId
 WHERE isnull(A.IsDeleted,0) = 0 --AND StudentIID is null
 and (A.ProcessId=@ProcessTypeId OR @ProcessTypeId is null OR @ProcessTypeId=0) 
 Order BY P.SessionId,P.BranchId,P.ClassId, P.[AdvancePriority] ASC
	 
create table #tmpStudent
	(
	[Id] [int] IDENTITY(1,1) NOT NULL,	
	StudentIID int 
	)

 
			
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
	SELECT * FROM #Fees_TempCollection
delete Fees_Student where ProcessId=@ProcessTypeId and MonthId=@MonthId And ProcessType='G'
PRINT @MAXID

SELECT * FROM #tmpFees_HeadAmountConfig

WHILE (@COUNTER <= @MAXID)
	BEGIN
	--		FeesAccPublish 23,1
	--      select * from Fees_HeadAmountConfig --where AMount=0  --update Fees_HeadAmountConfig set amount=120 where AMount=0
	/*
	FeesCategoryId	CategoryName
1	Common Fees
2	Individual Fees
3	Automated Fees
	*/
	Print '166'
	DECLARE @HeadId int,@FeesGroupId int,@versionId int,@SessionId int,@BranchId int,@ShiftId int,
	@ClassId int,@GroupId int,@FessGroupId int,@StudentIID int,@Amount decimal (18,2),@PaidAmount decimal (18,2)=0,@RC int,@SectionId int;
	
	SELECT @HeadId=HeadId,@FeesGroupId=tmp.FessGroupId,@SessionId =SessionId, @BranchId=BranchId,@ShiftId=ShiftId,
	@ClassId=ClassId,@SectionId=SectionId,@StudentIID=StudentIID,@Amount=Amount  
	FROM #tmpFees_HeadAmountConfig tmp WHERE id=@COUNTER
	PRINT @COUNTER
	DECLARE @Category int;
	select @Category=CategoryId from Fees_Head where FeesHeadId=@HeadId
	
	if(/*@Category=1 and*/ @StudentIID is  null)--Common Fees
	BEGIN
		insert into #tmpStudent select StudentIID 
		from Student_BasicInfo sb where   sb.SessionId=@SessionId AND sb.BranchID=@BranchId AND sb.ShiftID=@ShiftId AND sb.ClassId=@ClassId
		AND sb.SectionId=@SectionId AND sb.IsDeleted = 0 AND sb.[Status] = 'A'
		AND (sb.StudentTypeID=@FeesGroupId OR @FeesGroupId is null) --and (sb.StudentIID=@StudentIID OR @StudentIID is null)

		DECLARE @Counter2 int=1,@MaxId2 int=0;
		SET @MaxId2=(select count(*) from #tmpStudent);
		PRINT 'MAXID2 ' + CAST( @MaxId2 AS VARCHAR)
		IF(@Amount<=0)
				RAISERROR ('Amount can not be 0.',16,1);

		WHILE(@Counter2<=@MaxId2)
		BEGIN
		Print '191'
			SET @StudentIID=(select StudentIID  from #tmpStudent where Id=@Counter2);
			If Exists (SELECT StudentIID FROM #Fees_TempCollection Where StudentIID=@StudentIID)
			BEGIN
			 SELECT Top(1) @PaidAmount=PaidAmount FROM #Fees_TempCollection  Where StudentIID=@StudentIID AND ProcessId=@ProcessTypeId and MonthId=@MonthId AND HeadId=@HeadId
			 DELETE  Fees_TempCollection  where ProcessId=@ProcessTypeId and MonthId=@MonthId AND  ProcessType='G' AND PaidAmount>0 and IsPaid=1 AND StudentIID=@StudentIID AND HeadId=@HeadId 
			END
			print 'STUDENT IDD NULL EXECUTE [dbo].[InsertSingleStudentFee] '+cast(@ProcessTypeId as varchar)+','+cast(@MonthId as varchar)+','+cast(@SessionId as varchar)+','+cast(@StudentIID as varchar)+','+cast(@Amount as varchar)+
				 ','+cast(@PaidAmount as varchar)+','+cast(@HeadId as varchar)+','+'G'+','+','+cast(@FeesSessionYearId as varchar)+',0,0,'+cast(@YearValue as varchar)
			EXECUTE @RC = [dbo].[InsertSingleStudentFee]  @ProcessTypeId,@MonthId,@SessionId,@StudentIID,@Amount,@PaidAmount,@HeadId,'G',@FeesSessionYearId,0,0,@YearValue,@AddBy;			
			
			SET @totalloop=@totalloop+1;
			SET @Counter2=@Counter2+1;
			SET  @StudentIID=null
			SET @PaidAmount=0
		END
	 
	END 
	
	ELSE IF(@Category=3)--Automated Fees
	BEGIN
		print @totalloop
	END
	print @totalloop
	--SELECT * FROM #tmpStudent
	truncate table #tmpStudent
	SET @COUNTER = @COUNTER + 1
	END
------------------------------
--SELECT * FROM #tmpFees_HeadAmountConfig

SELECT * FROM #Fees_TempCollection

DROP table #tmpFees_HeadAmountConfig
drop table #tmpStudent
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

END
go



