/****** Object:  StoredProcedure [dbo].[ProccessMerit]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateMerit]'))
BEGIN
DROP PROCEDURE  UpdateMerit
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
--execute [dbo].[ProccessMerit] 5,10,1,3
CREATE PROCEDURE UpdateMerit
	@MainExamID int ,
	@StudentIID int ,
	@Position int ,
	@wise varchar(1)
AS
BEGIN
	if(@wise='O')
	BEGIN
	Update dbo.Res_MainExamResult set OverAllMerit=@Position where MainExamId=@MainExamID AND StudentIID=@StudentIID
	END

	if(@wise='C')
	BEGIN
	Update dbo.Res_MainExamResult set ClassWiseMerit=@Position  where MainExamId=@MainExamID AND StudentIID=@StudentIID
	END

	if(@wise='S')
	BEGIN
	Update dbo.Res_MainExamResult set ShiftWiseMerit=@Position  where MainExamId=@MainExamID AND StudentIID=@StudentIID
	END

	if(@wise='E')
	BEGIN
	Update dbo.Res_MainExamResult set SectionWiseMerit=@Position  where MainExamId=@MainExamID AND StudentIID=@StudentIID
	END
	
END
GO