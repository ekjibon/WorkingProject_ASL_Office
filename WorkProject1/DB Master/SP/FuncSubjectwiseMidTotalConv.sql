/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SubjectwiseMidTotalConv]'))
BEGIN
DROP FUNCTION  SubjectwiseMidTotalConv
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- =============================================
--select dbo.SubjectwiseMidTotalConv(100,93,1045,60,122 )  [dbo].[SubjectwiseMidTotalConv] (60,134,2033,60,1) 
CREATE FUNCTION [dbo].[SubjectwiseMidTotalConv]
(
 @TotalConvMarks decimal(10,2) ,
 @SubjectId INT,
 @MainExamId INT,
 @Percentage INT,
 @SectionId INT
 --,@TotalExamCount int
)
RETURNS  decimal(10,2)
AS
BEGIN
	DECLARE @TotalConv DECIMAL(10,2), @PassMark DECIMAL(10,2), @ExamMark DECIMAL(10,2),@FullMark DECIMAL(10,2)
	SELECT @ExamMark = ROUND((SubExamExamMarks),0) FROM Qry_MarkSetup  
	WHERE MainExamSubjectID = @SubjectId  AND IsMidYear = 1 AND MainExamId = @MainExamId AND SectionId = @SectionId
	SET @TotalConv =(@TotalConvMarks/@ExamMark)*100
	if(@Percentage <> 0)
	begin
	SET @TotalConv =((@TotalConvMarks/@ExamMark)*100)*@Percentage/100
	END
	
	RETURN @TotalConv
END 
GO
--select [dbo].[SubjectwiseTotalConv] (60,134,2033,1)
--select ROUND(17.50,0)

