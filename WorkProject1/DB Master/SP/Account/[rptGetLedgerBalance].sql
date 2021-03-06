IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetLedgerBalance]'))
BEGIN
DROP PROCEDURE  rptGetLedgerBalance
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
GO -- EXEC rptGetLedgerBalance 4
CREATE PROCEDURE [dbo].[rptGetLedgerBalance] 
	@RootGroupId INT
AS
BEGIN  


with name_tree as (
		SELECT LedgerId,ParentID, Name,Code, CurrentBalance,CurrentBalanceDc
		FROM  [dbo].[ACC_Ledgers]
		WHERE RootGroupId = @RootGroupId

		
		union all
		SELECT P.LedgerId,P.ParentID,P.Name,P.Code, P.CurrentBalance,P.CurrentBalanceDc
		FROM  [dbo].[ACC_Ledgers] P
			join name_tree T on T.LedgerId = P.ParentId  -- this is the recursion
		) 
		select Distinct * , (SELECT Name FROM ACC_Ledgers WHERE LedgerId = name_tree.ParentId) AS ParentName,CASE WHEN @RootGroupId=1 THEN 'Asset' WHEN @RootGroupId=2 THEN 'Liabilities' WHEN @RootGroupId=3 THEN 'Income' WHEN @RootGroupId=4 THEN 'Expenditure' END RootGroup
		from name_tree 
		--WHERE ParentId =@RootGroupId
	
	



	
END


-- SELECT  * FROM ACC_Ledgers
-- rptGetLedgerBalance 'ad'