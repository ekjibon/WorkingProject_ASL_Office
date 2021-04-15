

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddComment]'))
BEGIN
DROP PROCEDURE  [AddComment]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[AddComment]
(
    @BranchID INT,
	@ClassID INT,
	@SessionID INT,
    @SectionID INT,
	@ShiftID INT,
	@Addby VARCHAR(MAX),
	@CommentDetails UTT_CommentDetails READONLY
)	
AS
BEGIN
	

	DECLARE @IID  INT 


	INSERT INTO Res_HeadsCommentMaster([BranchID],[ClassID],[SessionID],[SectionID],[ShiftID],[IsDeleted],[AddBy],[Status],[AddDate])
	VALUES( @BranchID,@ClassID,@SessionID,@SectionID,@ShiftID,0,@Addby,'A',GETDATE())

	SELECT @IID = @@IDENTITY

	INSERT INTO Res_HeadsCommentDetails([ID],[Comments])
	SELECT @IID,Comments FROM @CommentDetails 


END

		   
