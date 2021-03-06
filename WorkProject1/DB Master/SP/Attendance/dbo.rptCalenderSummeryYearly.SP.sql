/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptCalenderSummeryYearly]'))
BEGIN
DROP PROCEDURE  rptCalenderSummeryYearly
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
-- rptCalenderSummeryYearly  2018
CREATE PROCEDURE [dbo].[rptCalenderSummeryYearly]     
	@YearId INT =null
AS
BEGIN
DECLARE @WorkingDay Int
 SELECT [DayType],[Month],COUNT([Year]) as CalculateDays,@YearId as [Year]
  FROM [dbo].[Att_AcademicCalendar]
  WHERE [Year]=@YearId
  GROUP BY [DayType],[Month]
  ORDER BY [Month]
END

--   select * form Att_AcademicCalendar