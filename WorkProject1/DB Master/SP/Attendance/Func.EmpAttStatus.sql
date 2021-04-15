/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EmpAttStatus]'))
BEGIN
DROP FUNCTION  EmpAttStatus
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Arifur>
-- Create date: <01-Dec-2020,>
-- Description:	<For Latter grade ad GP  Calculation>
-- =============================================
CREATE FUNCTION [dbo].[EmpAttStatus] 
( 
	@EmpId INT,
	@Date DATETIME,
	@Type VARCHAR(25)
)

RETURNS  VARCHAR(100)

AS

BEGIN

    DECLARE @AttStatus VARCHAR(100) =  NULL,@LStatus VARCHAR(100) =  NULL,@LIStatus VARCHAR(100) =  NULL,@EOStatus VARCHAR(100) =  NULL
						,@HDStatus VARCHAR(100) =  NULL

		
		-- Leave
		IF(@Type='L')
		BEGIN
			SELECT @AttStatus = (CASE WHEN IsLeave = 1 THEN ' L'  END ) FROM dbo.Emp_Attendance 
				WHERE EmpId = @EmpId AND CAST(InTime AS DATE) =  CAST(@Date AS DATE)
		END
		-- Late In
		IF(@Type='LI')
		BEGIN
			SELECT @AttStatus = (CASE WHEN IsLate = 1 AND IsPresent =  1 THEN 'Late In'  END ) FROM dbo.Emp_Attendance 
				WHERE EmpId = @EmpId AND CAST(InTime AS DATE) =  CAST(@Date AS DATE)
		END

		-- Early Out
		IF(@Type='EO')
		BEGIN
			SELECT @AttStatus = (CASE WHEN IsEarlyOut = 1 AND IsPresent =  1 THEN 'Early Out'  END ) FROM dbo.Emp_Attendance 
				WHERE EmpId = @EmpId AND CAST(InTime AS DATE) =  CAST(@Date AS DATE)
		END
	
		IF(@Type='HDL')
		BEGIN
		-- Half Day Leave
		SELECT @AttStatus = (CASE WHEN IsHalfDay = 1 AND IsPresent =  1 THEN 'HDL'  END ) FROM dbo.Emp_Attendance 
			WHERE EmpId = @EmpId AND CAST(InTime AS DATE) =  CAST(@Date AS DATE)
		END
	--SET @AttStatus =  ISNULL(@LStatus,'') + ISNULL(@LIStatus,'') + ISNULL(@EOStatus,'')+ ISNULL(@HDStatus,'')
    return @AttStatus

END  

-- SELECT [dbo].[EmpAttStatus]  (24,'2020-12-15 15:58:06.000','EO')