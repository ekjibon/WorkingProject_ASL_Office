/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CheckGrandExamIsPass]'))
BEGIN
DROP FUNCTION  CheckGrandExamIsPass
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
CREATE FUNCTION [dbo].[CheckGrandExamIsPass]
(
	@VersionID int,
	@SessionID int,
	@ClassID int,
	@Marks decimal(10,2),
	@SubId int,
	@GrandExamId INT
	
)
RETURNS BIT
AS
BEGIN
	DECLARE @ISPass BIT=1 ,@GrandExamIsPassDepend BIT,@SubjectFullMark DECIMAL(10,2),@SubjectPassMark DECIMAL(10,2),@GrandExamPassMarkIsPercent bit

	SELECT @GrandExamIsPassDepend = ExamIsPassDepend ,@SubjectFullMark = ExamFullMarks , @SubjectPassMark= ExamPassMark,@GrandExamPassMarkIsPercent= ExamPassMarkIsPercent
	FROM [dbo].[Res_GrandExamMarkSetup]
	 WHERE ExamSubjectID = @SubId AND GrandExamId = @GrandExamId AND IsDeleted = 0
	-- GROUP BY GrandExamId,GrandExamFullMarks
	
 IF(@GrandExamIsPassDepend=1)
  BEGIN
	If(@GrandExamPassMarkIsPercent=0)
	   Begin
			If(@Marks>=@SubjectPassMark)
			 set @ISPass=1
			Else
			 set @ISPass=0
		END	
    ELSE
	  BEGIN
		If(((100*@Marks)/@SubjectFullMark)>=@SubjectPassMark)
			 set @ISPass=1
			Else
			 set @ISPass=0		  
	  END
  END

RETURN @ISPass

END
GO
