/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GLCalculationBySubId]'))
BEGIN
DROP FUNCTION  GLCalculationBySubId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>

-- =============================================
CREATE FUNCTION [dbo].[GLCalculationBySubId]
(	
	@SessionID int,
	@ClassID int,
	@Marks decimal(10,2),
	@SubId int,
	@MainExamId INT
	
)
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @GL VARCHAR(5)='T' ,@FullMarks decimal(10,2)=1,@DBname VARCHAR(100), @TotalConv decimal (10,2),@TotalExamCount int
	SELECT @FullMarks = MainExamFullMarks FROM [Res_MainExamMarkSetup] WHERE MainExamSubjectID = @SubId AND MainExamId = @MainExamId and IsDeleted=0
	select @TotalExamCount = COUNT(SubExamId) from dbo.Res_SubExam where SubjectId=@SubId and MainExamId=@MainExamId
	

	 Select Top(1) @GL=GS.GL from  Res_GradingSystem  GS 
	 where  GS.SessionID=@SessionID and GS.ClassID=@ClassID 
	 and GS.Marks_From<=ROUND( @Marks,0) and GS.Marks_To>=ROUND( @Marks,0) and GS.IsDeleted=0 ORDER BY GS.Marks_To DESC
	RETURN @GL

END
GO