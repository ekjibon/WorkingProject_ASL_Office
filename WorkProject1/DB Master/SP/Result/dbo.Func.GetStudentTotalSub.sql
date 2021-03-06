/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentTotalSub]'))
BEGIN
DROP FUNCTION  [dbo].[GetStudentTotalSub]
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
CREATE FUNCTION [dbo].[GetStudentTotalSub]
(
	@StudentIID int,
	@MainExamId int
)
RETURNS DECIMAL
AS
BEGIN
DECLARE @TermId INT=0;
SET @TermId=( select TermId from res_mainexam where MainExamId=@MainExamId)

	DECLARE @TotalSubCount DECIMAL = 0
	SELECT @TotalSubCount = COUNT(*) FROM dbo.Res_MainExamMarkSetup R 
	INNER JOIN dbo.Res_StudentSubject SS ON SS.SubjectID = R.MainExamSubjectID AND SS.TermId = @TermId
	WHERE SS.StudentID =  @StudentIID AND R.IsDeleted = 0 AND R.MainExamId = @MainExamId
	SET @TotalSubCount = @TotalSubCount * 100;
    RETURN @TotalSubCount

END

GO
---SELECT dbo.GetStudentTotalSub(4922,1056)