/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[fnGetDayStatus]'))
BEGIN
DROP FUNCTION  fnGetDayStatus
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Abu Abdullah>
-- Create date: <25-Feb-2017,>
-- Description:	<For Attendance Monthly Report Block 3>
-- =============================================
CREATE FUNCTION fnGetDayStatus
			(
			 @DATE DATETIME,
			 @STUDENTID BIGINT
			)
			RETURNS VARCHAR(150)
			AS
			BEGIN 	
				DECLARE @HoliDayName VARCHAR(100)		
				IF EXISTS(SELECT TOP 1 DayType FROM [dbo].[Att_AcademicCalendar] WHERE DayType='Regular' AND CONVERT(DATE,CalendarDate)=CONVERT(DATE,@DATE))
				BEGIN
					 IF EXISTS (SELECT TOP 1 A.AttendId FROM [dbo].[Att_StudentAttendance] AS A
					 WHERE A.StudentId=@STUDENTID  AND CONVERT(DATE,A.InTime)=CONVERT(DATE,@DATE) AND A.IsDeleted=0 AND A.IsPresent=1)
					 BEGIN
						RETURN 'P'
					 END
					 ELSE
					 BEGIN
						IF EXISTS(SELECT TOP 1 L.IsLeave FROM [dbo].[Att_StudentAttendance] AS L
						WHERE  L.IsLeave=1 AND L.StudentId=@STUDENTID AND CONVERT(DATE, L.InTime)=CONVERT(DATE,@DATE) AND L.IsDeleted=0)
						BEGIN
							RETURN 'L'
						END
						ELSE
						BEGIN
							IF(@DATE > GETDATE())
							BEGIN 
								RETURN ''
							END
							ELSE
							RETURN 'A'
						END
					 END
			
				END
				ELSE
				BEGIN
					IF EXISTS(SELECT TOP 1 DayType FROM [dbo].[Att_AcademicCalendar] WHERE DayType='Weekend' AND CONVERT(DATE,CalendarDate)=CONVERT(DATE,@DATE))
					BEGIN
					 RETURN 'W'
					END
					ELSE
					BEGIN					 
					 SELECT TOP 1 @HoliDayName= HolidayName FROM [dbo].[Att_AcademicCalendar] WHERE CONVERT(DATE,CalendarDate)=CONVERT(DATE,@DATE)					
					END
				END
				 RETURN 'H'
			END 