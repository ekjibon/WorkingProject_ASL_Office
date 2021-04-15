IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertSingleStudentFee]'))
BEGIN
DROP PROCEDURE  InsertSingleStudentFee
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE InsertSingleStudentFee 
	@ProcessTypeId int=null,
	@MonthId int =null,
	@SeesionId INT ,
	@StudentIID bigint =null,
	@Fees_HeadAmount decimal(18, 2)=0,
	@PaidAmount decimal(18, 2),
	@HeadId int=null,
	@ProcessType Varchar(1),
	@FeesSessionYearId int=1,
	@AutomatedDays int=0,
	@AutomatedConsecutiveDays int=0,
	@Year int,
	@AddBy VARCHAR(200)--,
	--@FeesNo VARCHAR(200)
AS
BEGIN
 DECLARE @FeesBookNo VARCHAR(25), @suffix VARCHAR(8),@prefix VARCHAR(8), @FeesSeeionYearId INT ,@Cond INT =1,
 @Scholarship decimal(18,2)=0, @ScholarshipAmount decimal(18,2)=0, @DueAmount decimal (18,2)=0,@ScholarshipIsp bit=0, @IsPaid bit=0, @IsCompleted bit=0,
 @NoModifiedDueAmount decimal(18,2)=0, @Advance DECIMAL(10,2)=0 , @AdvHeadId INT,@FeesAccAmount DECIMAL(10,2),@FeesAccId INT,@ScholarshipAmt DECIMAL(10,2)
 set @DueAmount=@Fees_HeadAmount

   If EXISTS(SELECT top(1) Amount FROM Qry_Scholarship Where StudentId=@StudentIID AND MonthId=@MonthId AND FeesHeadId=@HeadId AND IsDeleted = 0 AND FeesSessionYearId = @FeesSessionYearId)
	 BEGIN
	 SELECT top(1) @Scholarship= Amount,@ScholarshipIsp=IsPercentage FROM Qry_Scholarship Where StudentId=@StudentIID AND MonthId=@MonthId AND FeesHeadId=@HeadId AND FeesSessionYearId = @FeesSessionYearId
	 If(@ScholarshipIsp=1)
		 BEGIN
		 set @ScholarshipAmount=(@Scholarship*@Fees_HeadAmount)/100
		 END
		 ELSE
		  BEGIN
		   set @ScholarshipAmount=@Scholarship
		  END
		 
	   set @DueAmount=@DueAmount-@ScholarshipAmount 
	 END

 set @DueAmount=@DueAmount-@PaidAmount
	 If(@PaidAmount>0)
	 set @IsPaid=1

	 SELECT TOP 1 @Advance = ISNULL( AdvanceAmount,0),@ScholarshipAmt = ScholarshipAmount, @AdvHeadId = FeesStudentId FROM Fees_Student WHERE StudentIID= @StudentIID AND AdvanceAmount > 0 AND HeadId = @HeadId
	 --SELECT @FeesAccAmount = Amount,@FeesAccId=FeesAccountsId FROM Fees_Accounts WHERE ProcessId = @ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId AND HeadId = @HeadId
			IF(@Advance!=0)
			BEGIN
				IF(@Advance>=@DueAmount)
				BEGIN
					INSERT INTO dbo.Fees_Accounts ([ProcessId],[FeesSessionYearId],[HeadId],[Amount],[AmountType],[IsApplied],[IsDeleted]) 
											VALUES(@ProcessTypeId,@FeesSessionYearId,@HeadId,@DueAmount,'A',0,0)
					PRINT 'Fees Accounts 1 '+ CAST( @@Identity AS VARCHAR(MAX))+ ' ProcessId ' + CAST( @FeesSessionYearId AS VARCHAR(MAX)) + ' HeadId ' + CAST( @HeadId AS VARCHAR(MAX))
					PRINT 'Amount '+ CAST( @DueAmount AS VARCHAR(MAX))
					--SET @NoModifiedDueAmount = @DueAmount;
					SET @Advance =  @Advance - @DueAmount
					SET @DueAmount = 0
					SET @IsPaid = 1
					SET @IsCompleted = 1
					UPDATE Fees_Student SET AdvanceAmount = @Advance WHERE FeesStudentId = @AdvHeadId
					
				END
				ELSE
				BEGIN
					INSERT INTO dbo.Fees_Accounts ([ProcessId],[FeesSessionYearId],[HeadId],[Amount],[AmountType],[IsApplied],[IsDeleted]) 
											VALUES(@ProcessTypeId,@FeesSessionYearId,@HeadId,@Advance,'A',0,0)
						PRINT 'Fees Accounts 2 '+ CAST( @@ROWCOUNT AS VARCHAR(MAX))+ ' ProcessId ' + CAST( @FeesSessionYearId AS VARCHAR(MAX)) + ' HeadId ' + CAST( @HeadId AS VARCHAR(MAX))
					PRINT 'Amount '+ CAST( @DueAmount AS VARCHAR(MAX))
					SET @DueAmount = @DueAmount - @Advance
					SET @IsPaid = 1 
					UPDATE Fees_Student SET AdvanceAmount = 0 WHERE FeesStudentId = @AdvHeadId
					

					--UPDATE Fees_Accounts SET Amount = @FeesAccAmount WHERE FeesAccountsId = @FeesAccId

				END
				
			END

			



	 print 'Call InsertSingleStudentFee ' 

 
	 If(@DueAmount=0)
	 Set @IsCompleted=1

	 --IF(@StudentIID=134)
	 --BEGIN
	 --SET @Cond =1
	 --END

		--	--SELECT  @FeesSeeionYearId  = FeesSessionYearId FROM Fees_FeesSessionYear WHERE MonthId = @MonthId AND SessionId = @SeesionId
		--IF EXISTS (SELECT FeesBookNo FROM Fees_Student WHERE StudentIID=@StudentIID AND MonthId=  @MonthId AND SessionId = @SeesionId)
		--BEGIN
		--	SELECT @FeesBookNo = FeesBookNo FROM Fees_Student WHERE StudentIID=@StudentIID AND MonthId=  @MonthId AND SessionId = @SeesionId
		--END
		--ELSE
		--BEGIN
		--	WHILE(@Cond=1)
		--	BEGIN
		--	SELECT @suffix=  CAST( Cast(RAND()*(9999999-1111111)+11 as int) AS varchar)
		--	SELECT @prefix=  CAST( Cast(RAND()*(99-11)+11 as int) AS varchar)

		--	SET @FeesBookNo  = @prefix +FORMAT(@FeesSeeionYearId,'00#')+ @suffix
		--	IF NOT EXISTS(SELECT FeesBookNo FROM Fees_Student WHERE FeesBookNo=@FeesBookNo)
		--	SET @Cond = 0 
		--	END
		--END
			SELECT @FeesBookNo = 'F'+ Cast(year(getdate()) as varchar) +  Cast(month(getdate()) as varchar) +Cast(day(getdate()) as varchar) + CAST((Select  Count(*)+ 1 From Fees_Student) as varchar)


 print @FeesBookNo
 print @StudentIID
 print @ProcessTypeId
 set @NoModifiedDueAmount= @DueAmount + @PaidAmount
 Print 'NoModDueAmount : ' + CAST( @NoModifiedDueAmount AS VARCHAR)
 INSERT INTO Fees_Student([ProcessId],[StudentIID],[HeadId],[TotalAmount],[DueAmount],InvoiceAmount,[ScholarshipAmount],[DiscountAmount],[PaidAmount],[IsPaid],[IsCompleted],[IsPublished]
					      ,[IsDeleted],[MonthId],[FeesBookNo],[AdvanceAmount],[SessionId],[Narration],[ProcessType],[NoModifiedDueAmount],[FeesSessionYearId],AutomatedDays,AutomatedConsecutiveDays,[Year],AddBy,AddDate,[ProcessedAmount],IsAdjust,IsRefund,IsResolved)
SELECT					@ProcessTypeId,@StudentIID,@HeadId,@Fees_HeadAmount,@DueAmount,@DueAmount,@ScholarshipAmount,0,@PaidAmount,@IsPaid,@IsCompleted,0
						,0,@MonthId,@FeesBookNo,0,@SeesionId,null,@ProcessType,@NoModifiedDueAmount,@FeesSessionYearId,@AutomatedDays,@AutomatedConsecutiveDays,@Year,@AddBy,GETDATE(),(@Fees_HeadAmount-@ScholarshipAmount),0,0,0

 return 0;
END
