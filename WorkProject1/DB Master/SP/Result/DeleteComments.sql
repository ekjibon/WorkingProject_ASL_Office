

/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteComments]'))
BEGIN
DROP PROCEDURE  DeleteComments
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetMultiSection] '11','5','27'
CREATE PROCEDURE [dbo].[DeleteComments]  
@BLOCK INT,
@ID INT
		
AS
BEGIN
IF(@BLOCK=1)
BEGIN
DELETE FROM Res_HeadsCommentMaster
WHERE HeadsCommentID =@ID ;

DELETE FROM Res_HeadsCommentDetails
WHERE HeadsCommentID =@ID ;
END

IF(@BLOCK=2)
BEGIN
DELETE FROM Res_HeadsCommentDetails
WHERE ID = @ID ;
END
 
END