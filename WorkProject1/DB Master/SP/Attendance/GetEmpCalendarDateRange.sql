/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpCalendarDateRange]'))
BEGIN
DROP PROCEDURE  [GetEmpCalendarDateRange]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		KHALED
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[GetEmpCalendarDateRange] 
CREATE PROCEDURE [dbo].[GetEmpCalendarDateRange] 

	@CalandarId INT,
	@Type CHAR(1),
	@Year INT = NULL

AS
BEGIN
 
  DECLARE @start_date DATETIME , @end_date DATETIME

  --SET @start_date = CAST( @FromDate AS datetime)
  --SET @end_date = CAST( @ToDate AS datetime);
  SELECT @start_date = StartDate ,  @end_date = EndDate FROM Att_EmpAcademicCalendar WHERE Id =@CalandarId;

  WITH CTE AS
(
    SELECT @start_date AS cte_start_date
    UNION ALL
    SELECT DATEADD(MONTH, 1, cte_start_date)
    FROM CTE
    WHERE DATEADD(MONTH, 1, cte_start_date) <= @end_date   
)
		SELECT (YEAR( cte_start_date))AS [Year] , (MONTH(cte_start_date))AS MonthID , [MonthName] INTO #temp
		FROM CTE
		INNER JOIN Fees_FeesMonth ON FeesMonthId = MONTH(cte_start_date)

	IF(@Type='Y')
	SELECT Year FROM #temp GROUP BY Year
	IF(@Type='M')
	SELECT MonthId, MonthName FROM #temp WHERE Year = @Year

	DROP table #temp
END