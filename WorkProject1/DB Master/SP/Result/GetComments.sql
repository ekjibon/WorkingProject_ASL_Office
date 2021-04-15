
/****** Object:  StoredProcedure [dbo].[GetHeadCommentsSectionWise]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetComments]'))
BEGIN
DROP PROCEDURE  GetComments
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetComments] 15
CREATE PROCEDURE [dbo].[GetComments]  -- 5 
@HeadsCommentID INT


AS
BEGIN

     SELECT * FROM Res_HeadsCommentDetails 
	 WHERE HeadsCommentID = @HeadsCommentID
 
 END