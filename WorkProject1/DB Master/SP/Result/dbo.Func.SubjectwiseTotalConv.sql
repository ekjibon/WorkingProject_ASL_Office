/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SubjectwiseTotalConv]'))
BEGIN
DROP FUNCTION  SubjectwiseTotalConv
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Kawsar>
-- =============================================
--select [dbo].[SubjectwiseTotalConv] (19.95,85,1064,80,1)
CREATE FUNCTION [dbo].[SubjectwiseTotalConv]
(
 @TotalConvMarks decimal(10,2) ,
 @SubjectId INT,
 @MainExamId INT,
 @Percentage INT,
 @TotalExamCount int
)
RETURNS  decimal(10,2)
AS
BEGIN
	DECLARE @TotalConv DECIMAL(10,2), @PassMark DECIMAL(10,2), @ExamMark DECIMAL(10,2),@FullMark DECIMAL(10,2)
	SELECT @ExamMark= ROUND(SUM( SubExamExamMarks),0) FROM Qry_MarkSetup  
	WHERE MainExamSubjectID = @SubjectId 
	SET @TotalConv =@TotalConvMarks/ROUND((@TotalExamCount*20),0)*100
	if(@Percentage <> 0)
	begin
	SET @TotalConv =((@TotalConvMarks/ROUND((@TotalExamCount*20),0)*100)*@Percentage)/100
	END
	RETURN @TotalConv
END 
GO
--select [dbo].[SubjectwiseTotalConv] (60,134,2033,1)
--select ROUND(17.50,0)

