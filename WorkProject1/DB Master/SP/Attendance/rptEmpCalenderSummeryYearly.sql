/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptEmpCalenderSummeryYearly]'))
BEGIN
DROP PROCEDURE  [rptEmpCalenderSummeryYearly]
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
-- rptEmpCalenderSummeryYearly  2021,1,1
CREATE PROCEDURE [dbo].[rptEmpCalenderSummeryYearly]     
	@YearId			INT =	null
   ,@MonthId		INT =	null
   ,@CalendarId		INT =	null
AS
BEGIN
DECLARE @WorkingDay Int
SELECT [DayType],[Month],COUNT([Year]) as CalculateDays,@YearId as [Year],
	CASE 
	WHEN Month = 1 THEN 'January'
	WHEN Month = 2 THEN 'February'
	WHEN Month = 3 THEN 'March'
	WHEN Month = 4 THEN 'April'
	WHEN Month = 5 THEN 'May'
	WHEN Month = 6 THEN 'June'
	WHEN Month = 7 THEN 'July'
	WHEN Month = 8 THEN 'August'
	WHEN Month = 9 THEN 'September'
	WHEN Month = 10 THEN 'October'
	WHEN Month = 11 THEN 'November'
	WHEN Month = 12 THEN 'December'
	END AS MonthName

    FROM [dbo].[Att_EmpAcademicCalendarDetails]
    WHERE [Year]=@YearId AND [Month]=  @MonthId AND [CalendarId] = @CalendarId
    GROUP BY [DayType],[Month]
   --ORDER BY [Month]
END

