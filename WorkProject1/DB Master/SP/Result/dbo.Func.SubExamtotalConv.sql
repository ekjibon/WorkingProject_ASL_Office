/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SubExamtotalConv]'))
BEGIN
DROP FUNCTION  SubExamtotalConv
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

CREATE FUNCTION [dbo].[SubExamtotalConv]
(
 @ObtMarks decimal(10,2) ,
 @SubjectId INT,
 @MainExamId INT,
 @SubExamId INT

)
RETURNS  decimal(10,2)
AS
BEGIN
	DECLARE @SubExamtotalConv DECIMAL(10,2), @PassMark DECIMAL(10,2), @ExamMark DECIMAL(10,2),@FullMark DECIMAL(10,2)

	SELECT @ExamMark= SubExamExamMarks,@FullMark = SubExamFullMarks FROM Qry_MarkSetup  WHERE MainExamSubjectID = @SubjectId AND SubExamId = @SubExamId


	SET @SubExamtotalConv = (@ObtMarks * @FullMark )/@ExamMark

	RETURN @SubExamtotalConv




END

GO


