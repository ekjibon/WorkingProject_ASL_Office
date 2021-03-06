/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/1717 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[fnGetEmpDayStatus]'))
BEGIN
DROP FUNCTION  fnGetEmpDayStatus
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-1717,>
-- Description:	<For Latter grade ad GP  Calculation>
-- =============================================
CREATE FUNCTION [dbo].[fnGetEmpDayStatus]
			(
			 @DATE DATETIME,
			 @EmpId BIGINT
			)
			RETURNS VARCHAR(150)
			AS
			BEGIN 	
				DECLARE @HoliDayName VARCHAR(170)		
				IF EXISTS(SELECT TOP 1 Id FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE  CONVERT(DATE,CalendarDate)=CONVERT(DATE,@DATE))
				BEGIN
					 IF EXISTS (SELECT TOP 1 A.AttendId FROM [dbo].Emp_Attendance AS A
					 WHERE A.EmpId=@EmpId  AND CONVERT(DATE,A.InTime)=CONVERT(DATE,@DATE) AND A.IsDeleted=0 AND A.IsPresent=1)
					 BEGIN
						RETURN 'P'
					 END
					 ELSE
					 BEGIN
						IF EXISTS(SELECT TOP 1 L.IsLeave FROM [dbo].Emp_Attendance AS L
						WHERE  L.IsLeave=1 AND L.EmpId=@EmpId AND CONVERT(DATE, L.InTime)=CONVERT(DATE,@DATE) AND L.IsDeleted=0)
						BEGIN
							RETURN 'L'
						END
						ELSE IF EXISTS( SELECT TOP 1 DayType FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='Weekend' AND CONVERT(DATE,CalendarDate)=CONVERT(DATE,@DATE))
							BEGIN
								RETURN 'W'
							END
						ELSE IF EXISTS( SELECT TOP 1 DayType FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='Holiday' AND CONVERT(DATE,CalendarDate)=CONVERT(DATE,@DATE))
							BEGIN
								RETURN 'H'
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
					--IF EXISTS(SELECT TOP 1 DayType FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='Weekend' AND CONVERT(DATE,CalendarDate)=CONVERT(DATE,@DATE))
					--BEGIN
					-- RETURN 'W'
					--END
					--ELSE
					--BEGIN					 
					-- SELECT TOP 1 @HoliDayName= HolidayName FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE CONVERT(DATE,CalendarDate)=CONVERT(DATE,@DATE)					
					--END
					RETURN ''
				END
				 RETURN ''
			END 


