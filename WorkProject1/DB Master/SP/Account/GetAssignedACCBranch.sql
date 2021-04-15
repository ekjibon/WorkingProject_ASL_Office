
/****** Object:  StoredProcedure [dbo].[GetCOATree]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAssignedACCBranch]'))
BEGIN
DROP PROCEDURE  [GetAssignedACCBranch]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetAssignedACCBranch]   ---[GetAssignedACCBranch] 'a824790f-6be8-4218-9c10-72eea8d83f89'
(
@UserId Varchar(MAX)
)
AS
BEGIN
	
	SELECT UAB.*, 
			AB.[Name]
		FROM dbo.Acc_UserAccBranch UAB
		INNER JOIN dbo.ACC_Branchs AB ON UAB.AccBranchId = AB.BranchId AND AB.[Status] = 'A' AND AB.IsDeleted = 0 
		WHERE UAB.UserId = @UserId 
END






