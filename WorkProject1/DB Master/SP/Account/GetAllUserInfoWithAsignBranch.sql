
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllUserInfoWithAsignBranch]'))
BEGIN
DROP PROCEDURE  GetAllUserInfoWithAsignBranch
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- GetAllUserInfoWithAsignBranch 1
CREATE PROC [dbo].[GetAllUserInfoWithAsignBranch] 
(
@BranchId INT 
)
AS
BEGIN
	SELECT * FROM dbo.Acc_UserAccBranch 
	WHERE AccBranchId = @BranchId AND IsDeleted = 0 AND Status = 'A'

END