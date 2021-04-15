----Std Summary_Daily or Date Range

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CollectionReportSummaryDailyorDateRange ]'))
BEGIN
DROP PROCEDURE  CollectionReportSummaryDailyorDateRange  
END
GO
create proc CollectionReportSummaryDailyorDateRange 
 @Where varchar(MAX) = NULL,
 @sortbyClause varchar(MAX) = NULL
as
DECLARE @Where2 varchar(MAX) = NULL,@FromDate date='2018-01-01',@ToDate date='2018-05-31',@PeriodType varchar(50) ='Monthly'--'Yearly'--'Date Range'
	,@Year int =2018,@Month int =5--params
          
DECLARE @sql varchar(max)

--   exec CollectionReportSummaryDailyorDateRange


SET @sql =' SELECT v.VersionName,s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,g.GroupName ,sc.SectionName ,
			sb.StudentIID,cast(sb.RollNo AS INT) RollNo, sb.StudentInsID, sb.FullName,
			CD.MonthId,FM.MonthName,CD.Year, CD.Amount,cm.PaymentDate,cm.BankCollectionDate,cm.PCS_BankName,fh.HeadName,u.UserName
			FROM Fees_CollectionMaster CM 
			INNER JOIN Fees_CollectionDetails CD ON CM.Id= CD.MasterID
			INNER JOIN dbo.Student_BasicInfo sb ON sb.StudentIID = CM.StudentIID
			left outer join dbo.Ins_Version v on sb.VersionID=v.VersionId
			left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
			left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
			left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
			left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
			left outer join dbo.Ins_Group g ON sb.GroupId = g.GroupId
			left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
			INNER JOIN [dbo].[Fees_FeesMonth] FM ON FM.FeesMonthId = CD.MonthId 
			INNER JOIN  Fees_Head fh on cd.HeadId=fh.FeesHeadId
			inner join AspNetUsers u on cm.AddBy=u.Id
			  '		
	--IF(@PeriodType='Date Range')
	--BEGIN
	--	SET @sql=@sql+'  Where cm.BankCollectionDate between  '''+cast(@FromDate as varchar)+ ''' and '''+cast(@ToDate as varchar)+''''
	--END
	--IF(@PeriodType='Yearly')
	--BEGIN
	--	IF(CHARINDEX(@sql,'where')>0)
	--		SET @sql=@sql+' and CD.Year ='+cast(@Year as varchar(50))
	--	else 
	--		SET @sql=@sql+'  Where CD.Year ='+cast(@Year as varchar(50))
	--END
	--IF(@PeriodType='Monthly')
	--BEGIN
	--IF(CHARINDEX(@sql,'where')>0)
	--	SET @sql=@sql+' and CD.Year ='+cast(@Year as varchar(50))+' and CD.MonthId  ='+cast(@Month as varchar(50))
	--else 
	--	SET @sql=@sql+'  Where CD.Year ='+cast(@Year as varchar(50))+' and CD.MonthId = '+cast(@Month as varchar(50))
	--END


	IF(isnull(@Where,'')<> '')
	BEGIN
	IF(CHARINDEX(@sql,'where')>0)
		SET @sql = @sql + ' and '+ @Where
	else 
		SET @sql = @sql + ' WHERE '+ @Where
	END
	 
	  IF(@sortbyClause IS NOT NULL AND  @sortbyClause <> '')
	 BEGIN
	 SET @sql = @sql + ' Order by '+ @sortbyClause
	 END

	PRINT(@sql)
	EXEC(@sql)