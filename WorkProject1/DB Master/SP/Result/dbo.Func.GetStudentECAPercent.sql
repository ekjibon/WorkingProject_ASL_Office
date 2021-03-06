/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentECAPercent]'))
BEGIN
DROP FUNCTION  [dbo].[GetStudentECAPercent]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  Calculation>
-- =============================================
CREATE FUNCTION [dbo].[GetStudentECAPercent]
(
	@StudentIID INT,
	@MainExamID INT
)
RETURNS INT
AS
BEGIN

	DECLARE @TotalWithoutECAPer INT = 0,@IsECA BIT = 0;

	SELECT @IsECA = ISEca FROM Res_MainExamResultSubjectDetails  WHERE  StudentIID = @StudentIID AND MainExamId = @MainExamID  

	IF(@IsECA=0)
	BEGIN
		SELECT
		@TotalWithoutECAPer = ( SUM(ROUND(SubjectConvertedMarks,0))/(dbo.GetStudentTotalSub(@StudentIID,@MainExamID)))*100 
		FROM Res_MainExamResultSubjectDetails WHERE ISEca = 0  AND StudentIID = @StudentIID AND MainExamId = @MainExamID 
	END
 	IF(@IsECA=1)
	BEGIN
		SELECT
		@TotalWithoutECAPer = ( SUM(ROUND(SubjectConvertedMarks,0))/(dbo.GetStudentTotalSub(@StudentIID,@MainExamID)-100) )*100 
		FROM Res_MainExamResultSubjectDetails WHERE ISEca = 0  AND StudentIID = @StudentIID AND MainExamId = @MainExamID 
	END

    RETURN @TotalWithoutECAPer


END

GO
--- SELECT dbo.[GetStudentECAPercent](4976,1022)