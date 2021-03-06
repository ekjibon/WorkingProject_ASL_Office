/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptInvStuYearlyDetails]'))
BEGIN
DROP PROCEDURE  rptInvStuYearlyDetails
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].rptInvStuYearlyDetails 
	@Year INT ,
	@StuIds VARCHAR(1000)
AS
BEGIN      
SELECT @StuIds = ',' + @StuIds +','
CREATE TABLE #Id(
ID int identity(1,1) primary key,
StudentIID BIGINT
)     
DECLARE @sql varchar(max)

	-- exec rptInvStuYearlyDetails 2018, '20927,20928'

INSERT INTO #Id
Select StudentIID from Student_BasicInfo
where CHARINDEX(',' +cast(StudentIID as varchar) +',', @StuIds) > 0

--select @StuIds,* from #Id
--	INSERT INTO #Id 

--SET @sql = '	
		 
		
--		  '
--		  PRINT(@sql)
-- EXEC(@sql)
	CREATE TABLE #Temp(
	[Type] VARCHAR(50),
	[Month] INT,
	[YEAR] INT,
	StudentIID BIGINT,
	Amount decimal(10,2),
	RowOrder int
	)
	DECLARE @counter int =0, @counterStu int =0,@Month int=null,@StudentIID int ,@TotalAmount decimal(18,2);;
	--------------------------------------------------------------------------------------------------
	INSERT INTO #Temp
	SELECT 'Payable Amount',FS.MonthId,@Year,FS.StudentIID, SUM(FS.NoModifiedDueAmount) ,1 RowOrder
	FROM Fees_Student FS
	WHERE [year] = @Year and  StudentIID in (select StudentIID from #Id)
	GROUP BY FS.StudentIID ,FS.MonthId
	
	/*----------------------------------Previous Due-----------------------------------------------*/
	while(@counter<12)--12 months
	BEGIN
	print 'month'	print @counter
	SET @counter=@counter+1;
		While(@counterStu<(select max(ID) from #Id))
		begin	
			print 'stu' print @counterStu
			SET @counterStu=@counterStu+1;
 
			SET @StudentIID=(select top 1 StudentIID from #Id where Id=@counterStu);

			select @Month=month(isnull(BankCollectionDate,PaymentDate))  from Fees_CollectionMaster fc 
			where month(isnull(BankCollectionDate,PaymentDate))<=@counter-1 and fc.MonthId=@counter and  StudentIID = @StudentIID--fees of prev month is collected
			IF(@Month is null)--Not paid
			BEGIN
				SET @TotalAmount=(select isnull(sum(fs.TotalAmount),0) from Fees_Student fs where fs.MonthId=@counter-1 and [year] = @Year and fs.StudentIID=@StudentIID);	
				if(@TotalAmount >0)--due
				BEGIN
					 insert into #Temp values('Previous Due',@counter,@Year,@StudentIID,@TotalAmount,2)
				END
			END
			ELSE
			BEGIN
				insert into #Temp values('Previous Due',@counter,@Year,@StudentIID,null,2)
			END
				-- exec rptInvStuYearlyDetails 2018, '20927,20928'

		END
		SET @counterStu=0;
	END
	/*---------------------------------------------------------------------------------------------*/
	SET @counter=0;SET @counterStu=0;
	/*----------------------------------Current Due------------------------------------------------*/
	while(@counter<12)--12 months
	BEGIN
	print 'month'	print @counter
	SET @counter=@counter+1;
		While(@counterStu<(select max(ID) from #Id))
		begin	
			print 'stu' print @counterStu
			SET @counterStu=@counterStu+1; 

			SET @StudentIID=(select top 1 StudentIID from #Id where Id=@counterStu);

			select @Month=month(isnull(BankCollectionDate,PaymentDate))  from Fees_CollectionMaster fc 
			where month(isnull(BankCollectionDate,PaymentDate))<=@counter and fc.MonthId=@counter and  StudentIID = @StudentIID
			IF(@Month is null)--Not paid
			BEGIN
				SET @TotalAmount=(select isnull(sum(fs.TotalAmount),0) from Fees_Student fs where fs.MonthId=@counter and [year] = @Year and fs.StudentIID=@StudentIID);	
				if(@TotalAmount >0)--due
				BEGIN
					 insert into #Temp values('Current Due',@counter,@Year,@StudentIID,@TotalAmount,3)
				END
			END
			ELSE
			BEGIN
				insert into #Temp values('Current Due',@counter,@Year,@StudentIID,null,3)
			END

				-- exec rptInvStuYearlyDetails 2018, '20927,20928'

		END
		SET @counterStu=0;
	END

	/*---------------------------------------------------------------------------------------------*/
		SET @counter=0;SET @counterStu=0;
	/*-------------------------------------------Total Paid----------------------------------------*/
	while(@counter<12)--12 months
	BEGIN
	print 'month'	print @counter
	SET @counter=@counter+1;
		While(@counterStu<(select max(ID) from #Id))
		begin	
			print 'stu' print @counterStu
			SET @counterStu=@counterStu+1; 

			SET @StudentIID=(select top 1 StudentIID from #Id where Id=@counterStu);

				SET @TotalAmount=(select isnull(sum(fs.TotalAmount),0) from Fees_Student fs where fs.MonthId=@counter and [year] = @Year and fs.StudentIID=@StudentIID);	
				if(@TotalAmount >0)--due
				BEGIN
					 insert into #Temp values('Total Paid',@counter,@Year,@StudentIID,@TotalAmount,4)
				END			
		END
		SET @counterStu=0;
	END
	/*----------------------------------------------------------------------------------------------*/
	SET @counter=0;SET @counterStu=0;
	/*-------------------------------------------Advanced------------------------------------------*/
	while(@counter<12)--12 months
	BEGIN
	print 'month'	print @counter
	SET @counter=@counter+1;
		While(@counterStu<(select max(ID) from #Id))
		begin	
			print 'stu' print @counterStu
			SET @counterStu=@counterStu+1; 

			SET @StudentIID=(select top 1 StudentIID from #Id where Id=@counterStu);

			--select @Month=month(isnull(BankCollectionDate,PaymentDate))  from Fees_CollectionMaster fc 
			--where month(isnull(BankCollectionDate,PaymentDate))=@counter and fc.MonthId=@counter+1 and  StudentIID = @StudentIID
			--									--3				  3           4			4  
			select @Month=month(isnull(BankCollectionDate,PaymentDate))  from Fees_CollectionMaster fc 
			where month(isnull(BankCollectionDate,PaymentDate))=@counter and fc.MonthId=@counter+1 and  StudentIID = @StudentIID
						
			IF(@Month is not null)
			BEGIN
				SET @TotalAmount=(select isnull(sum(fs.AdvanceAmount),0) from Fees_Student fs where fs.MonthId=@counter and [year] = @Year and  fs.StudentIID=@StudentIID);	
				if(@TotalAmount >0)--due
				BEGIN
					 insert into #Temp values('Advance Paid',@counter,@Year,@StudentIID,@TotalAmount,5)
				END
				BEGIN
					insert into #Temp values('Advance Paid',@counter,@Year,@StudentIID,null,5)
				END
			END
		END
		SET @counterStu=0;
	END
	/*----------------------------------------------------------------------------------------------*/

	SELECT *,SUBSTRING(DateName( month , DateAdd( month , month  , -1 )),1,3)+'-'+substring(cast(year as varchar(50)),3,2) MonthName FROM #Temp
	--order by YEAR,month
	--SELECT * FROM #Id
	DROP TABLE #Id,#Temp

END

	-- exec rptInvStuYearlyDetails 2018, '20927,20928'