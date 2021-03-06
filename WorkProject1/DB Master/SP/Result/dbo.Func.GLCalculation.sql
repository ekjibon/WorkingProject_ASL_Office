/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GLCalculation]'))
BEGIN
DROP FUNCTION  GLCalculation
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
-- SELECT dbo.GLCalculation(11,24,((785/900)*100),100)--[dbo].[GLCalculation]( 11,24,785,800)
CREATE FUNCTION [dbo].[GLCalculation]
(
	@SessionID int,
	@ClassID int,
	@Marks decimal(10,2),
	@FullMarks decimal(10,2)
	
)
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @GL VARCHAR(5)='T'
	--PRINT @Marks
	Select top (1) @GL=GS.GL from  Res_GradingSystem  GS 
	where GS.SessionID=@SessionID and GS.ClassID=@ClassID 
	and GS.Marks_From<=ROUND(@Marks,0) and GS.Marks_To>= ROUND(@Marks,0) and GS.IsDeleted=0 
	ORDER BY GS.Marks_To Desc
	RETURN @GL

END

GO


