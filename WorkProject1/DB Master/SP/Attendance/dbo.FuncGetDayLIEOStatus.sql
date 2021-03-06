/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FuncGetDayLIEOStatus]'))
BEGIN
DROP FUNCTION  FuncGetDayLIEOStatus
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
CREATE FUNCTION FuncGetDayLIEOStatus
			(
			 @DATE DATETIME,
			 @STUDENTID BIGINT,
			 @Type VARCHAR(5)
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
						
						DECLARE @IsLate BIT =0 , @IsEO BIT = 0
						SELECT @IsLate= ISNULL( A.IsLate,0) , @IsEO= ISNULL( A.IsEarlyOut,0) FROM [dbo].[Att_StudentAttendance] AS A
						WHERE A.StudentId=@STUDENTID  AND CONVERT(DATE,A.InTime)=CONVERT(DATE,@DATE) AND A.IsDeleted=0 AND A.IsPresent=1

						 IF(@IsLate=1 AND @Type = 'LI')
							RETURN 'LI'
						ELSE IF(@IsEO=1 AND @Type = 'EO')
							RETURN 'EO'
					 END
					
			
				END
				
				RETURN ''
				
			END 