
/****** Object:  StoredProcedure [dbo].[GetHeadCommentsSectionWise]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetHeadCommentsSectionWise]'))
BEGIN
DROP PROCEDURE  GetHeadCommentsSectionWise
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetHeadCommentsSectionWise] 8,11,2,19,76
CREATE PROCEDURE [dbo].[GetHeadCommentsSectionWise]  -- 5 
@BranchID INT, 
@SessionId INT, 
@ShiftId INT, 
@ClassId INT, 
@SectionId INT


AS
BEGIN

     SELECT HCD.* FROM Res_HeadsCommentDetails HCD
	 INNER JOIN  Res_HeadsCommentMaster HCM ON HCM.HeadsCommentID = HCD.HeadsCommentID
	 WHERE HCM.SessionID = @SessionId AND HCM.BranchID = @BranchID AND HCM.ShiftID = @ShiftId AND HCM.ClassID = @ClassId AND HCM.SectionID = @SectionId
 
 END