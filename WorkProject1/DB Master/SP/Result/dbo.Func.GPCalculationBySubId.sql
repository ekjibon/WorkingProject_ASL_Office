/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GPCalculationBySubId]'))
BEGIN
DROP FUNCTION  GPCalculationBySubId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
CREATE FUNCTION [dbo].[GPCalculationBySubId]
(
	@SessionID int,
	@ClassID int,
	@Marks decimal(10,2),
	@SubId int,
	@MainExamId INT
	
)
RETURNS VARCHAR(5)
--RETURNS  decimal(10,2)
AS
BEGIN
	DECLARE @GP real=5.0,@FullMarks decimal(10,2)=1,@DBname VARCHAR(100)
		SELECT @FullMarks = MainExamFullMarks FROM [Res_MainExamMarkSetup] WHERE MainExamSubjectID = @SubId AND MainExamId = @MainExamId and IsDeleted=0

		

        Select Top(1) @GP=GS.GP 
		from  Res_GradingSystem  GS 
		where GS.SessionID=@SessionID and GS.ClassID=@ClassID
		 and GS.Marks_From<=@Marks
		  and GS.Marks_To>=@Marks and GS.IsDeleted=0 
		  ORDER BY GS.Marks_To DESC
    RETURN @GP
	--Return @FullMarks


END
GO
