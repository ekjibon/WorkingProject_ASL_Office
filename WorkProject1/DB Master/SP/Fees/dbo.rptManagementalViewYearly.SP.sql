/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptManagementalViewYearly]'))
BEGIN
DROP PROCEDURE  rptManagementalViewYearly
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].rptManagementalViewYearly -- Total 11 param

@Where varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)
SET @sql = '	 
     SELECT v.VersionName,s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,g.GroupName ,sc.SectionName ,
			sb.StudentIID,sb.RollNo, sb.StudentInsID, sb.FullName, 
			M.PreviousAmount, (M.PreviousAmount-M.ChangeAmount) AS ModifiedAmount, M.ChangeAmount AS PresentAmount, FM.MonthName, Y.Year,			
			H.[FeesHeadId] , H.[HeadName], U.UserName, M.AddDate AS TIME			
			FROM Fees_FeesModifyLog M INNER JOIN		
			dbo.Student_BasicInfo sb ON sb.StudentIID = M.StudentId AND  M.UpdateType=''ModifyFeesHead''
			left outer join dbo.Ins_Version v on sb.VersionID=v.VersionId
			left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
			left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
			left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
			left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
			left outer join dbo.Ins_Group g ON sb.GroupId = g.GroupId
			left outer join dbo.Ins_Section sc ON sb.SectionId = sc.SectionId
			INNER JOIN Fees_Head H ON H.FeesHeadId = M.HeadId
			INNER JOIN AspNetUsers U ON M.AddBy=U.UserName
			INNER JOIN Fees_FeesSessionYear Y on M.FeesSessionYearId=Y.FeesSessionYearId
			INNER JOIN [dbo].[Fees_FeesMonth] FM ON FM.FeesMonthId = Y.MonthId
		  '
		PRINT(@sql)
	 IF(@Where IS NOT NULL and  @Where <> '')
	 BEGIN
 SET @sql = @sql + ' WHERE '+ @Where
	 END
	 

	-- SET @sql = @sql + '  ORDER BY cast(sb.RollNo AS INT)'
	  EXEC(@sql)
END
  DECLARE @ROWCOUNT INT, @IND INT
  create table #tmp
  (
  Id INT IDENTITY(1,1),
  Months Varchar(100),
  [Month's Payable] Decimal(18,2) null,
  [Previous Due] Decimal(18,2) null,
  [Total Payable] Decimal(18,2) null,
  [Total Collection] Decimal(18,2) null,
  [Month Collection] Decimal(18,2) null,
  [Previous Due Collection] Decimal(18,2) null,
  [Advance Collection] Decimal(18,2) null,
  [Existing Due] Decimal(18,2) null,
  [Collection Rate] Decimal(18,2) null,
  [MID] INT NOT NULL,
  [YID] INT NOT NULL
  )
  INSERT INTO #tmp(Months, MID, YID)
    select distinct f.MonthName+'-'+CAST(RIGHT(s.Year,2) AS varchar(25)), S.MonthId, S.Year from [dbo].[Fees_Student] S inner join Fees_FeesMonth as f on s.MonthId=f.FeesMonthId ORDER BY S.MonthId
	SET @ROWCOUNT=@@ROWCOUNT  
	SELECT * FROM #tmp
	


WHILE (@ROWCOUNT > @IND )
BEGIN
	IF(@IND=1)
	BEGIN
		
		SELECT sum([TotalAmount]) AS [Month's Payable], 0.0 AS [Previous Due], sum([TotalAmount]) AS [Total Payable],
		sum([PaidAmount]) AS [Total Collection], sum([PaidAmount])-sum(AdvanceAmount) AS [Month Collection], 0.00 AS [Previous Due Collection],
		sum([AdvanceAmount]) AS [Advance Collection], sum([TotalAmount])-(sum([PaidAmount])-sum(AdvanceAmount)) AS  [AS Existing Due], MonthId, Year 
		FROM [TEST_DB2].[dbo].[Fees_Student] S
		where MonthId=(select MID from #tmp where Id=@IND) and Year=(select YID from #tmp where Id=@IND) GROUP BY [MonthId],Year
	END
		ELSE
	BEGIN
		SELECT sum([TotalAmount]) AS [Month's Payable], 0.0 AS [Previous Due], sum([TotalAmount]) AS [Total Payable],
		sum([PaidAmount]) AS [Total Collection], sum([PaidAmount])-sum(AdvanceAmount) AS [Month Collection], 0.00 AS [Previous Due Collection],
		sum([AdvanceAmount]) AS [Advance Collection], sum([TotalAmount])-(sum([PaidAmount])-sum(AdvanceAmount)) AS  [AS Existing Due], MonthId, Year 
		FROM [TEST_DB2].[dbo].[Fees_Student] S
		where MonthId=(select MID from #tmp where Id=@IND) and Year=(select YID from #tmp where Id=@IND) GROUP BY [MonthId],Year
	END
	 
	 
	   
    SET @IND = @IND+1
END
	
	
DROP TABLE #tmp