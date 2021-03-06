/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[WorkingDayCalculation]'))
BEGIN
DROP FUNCTION  WorkingDayCalculation
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  [WorkingDayCalculation]>
-- =============================================
CREATE FUNCTION [dbo].[WorkingDayCalculation]
(
	
	@Month Int,
	@year int,
	@Status VARCHAR(1),
	@FromDate SMALLDATETIME=NULL,
	@ToDate SMALLDATETIME=NULL
)
RETURNS Int
AS
BEGIN
	DECLARE @WorkingDay Int
	If(@Status='T')
	BEGIN
		Select @WorkingDay= Count (AC.[DayType]) From [dbo].[Att_AcademicCalendar] AC where DayType='Regular' 
	--	And (DATEPART(MONTH, @FromDate)<= AC.[Month] And DATEPART(MONTH, @ToDate)>= AC.[Month] ) AND @year=AC.[Year] 

  --AND cast(@year as varchar(10))+'-'+cast(AC.[Month] as varchar(10))+'-'+cast(AC.[Day] as varchar(10)) between @FromDate and @ToDate
  --AND cast(@year as varchar(10))+'-'+cast(AC.[Month] as varchar(10))+'-'+cast(AC.[Day] as varchar(10)) between @FromDate and @ToDate
   and CalendarDate between @FromDate and @ToDate

	END
	ELSE
	BEGIN
	Select @WorkingDay= Count (AC.[DayType]) From [dbo].[Att_AcademicCalendar] AC where DayType='Regular' And @Month =  AC.[Month] AND @year=AC.[Year] 
	END
	RETURN @WorkingDay

END

GO


