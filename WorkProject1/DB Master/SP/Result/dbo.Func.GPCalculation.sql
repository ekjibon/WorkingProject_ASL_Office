/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GPCalculation]'))
BEGIN
DROP FUNCTION  GPCalculation
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
CREATE FUNCTION [dbo].[GPCalculation]
(	
	@SessionID int,
	@ClassID int,
	@Marks decimal,
	@FullMarks decimal
	
)
RETURNS  real
AS
BEGIN
	DECLARE @GP real=5.0
	SET @Marks=ROUND(@Marks,0)
	Select top(1) @GP=GS.GP from  Res_GradingSystem  GS where GS.SessionID=@SessionID and GS.ClassID=@ClassID and GS.Marks_From<=@Marks*100 and GS.Marks_To>=@Marks and GS.IsDeleted=0 ORDER BY GS.Marks_To Desc
	RETURN @GP

END


GO
