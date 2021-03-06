/****** Object:  StoredProcedure [dbo].[ProccessMerit]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateGrandMerit]'))
BEGIN
DROP PROCEDURE  UpdateGrandMerit
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Biplob>
-- Create date: <19/9/2017>
-- Description:	<Description,,>
-- =============================================
--execute [dbo].[UpdateGrandMerit] 5,10,1,3
CREATE PROCEDURE UpdateGrandMerit
	@GrandExamID int ,
	@StudentIID int ,
	@Position int ,
	@wise varchar(1)
AS
BEGIN
	if(@wise='O')
	BEGIN
	Update dbo.Res_GrandResult set OverAllMerit=@Position where GrandExamId=@GrandExamID AND StudentIID=@StudentIID
	END

	if(@wise='C')
	BEGIN
	Update dbo.Res_GrandResult set ClassWiseMerit=@Position  where GrandExamId=@GrandExamID AND StudentIID=@StudentIID
	END

	if(@wise='S')
	BEGIN
	Update dbo.Res_GrandResult set ShiftWiseMerit=@Position  where GrandExamId=@GrandExamID AND StudentIID=@StudentIID
	END

	if(@wise='E')
	BEGIN
	Update dbo.Res_GrandResult set SectionWiseMerit=@Position  where GrandExamId=@GrandExamID AND StudentIID=@StudentIID
	END
	
END
GO