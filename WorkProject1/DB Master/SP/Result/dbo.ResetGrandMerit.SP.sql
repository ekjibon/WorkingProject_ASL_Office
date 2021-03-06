/****** Object:  StoredProcedure [dbo].[ProccessMerit]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ResetGrandMerit]'))
BEGIN
DROP PROCEDURE  ResetGrandMerit
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
--execute [dbo].[ResetGrandMerit] 1,9,1,4
CREATE PROCEDURE ResetGrandMerit
    @SessionId int ,
	@ClassId int ,
	@GroupId INT ,
	@GrandExamIdVertion1 int
AS
BEGIN
    DECLARE @GrandExamIdVertion2 int=0, @GrandExamName Varchar(200)
    Select @GrandExamName=G.GrandExamName from [dbo].[Res_GrandExam] G where G.GrandExamId=@GrandExamIdVertion1
	select @GrandExamIdVertion2=G.GrandExamId from [dbo].[Res_GrandExam] G where G.GrandExamName=@GrandExamName And G.GrandExamId=@GrandExamIdVertion1 and G.SessionId=@SessionId and G.GroupId=@GroupId
	Update [dbo].[Res_GrandResult] set [OverAllMerit]=0, [SectionWiseMerit]=0,[ShiftWiseMerit]=0, [ClassWiseMerit]=0 where [GrandExamId] in(@GrandExamIdVertion1,@GrandExamIdVertion2)
END
GO