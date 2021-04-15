IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_GetIssueHistory'))
BEGIN
DROP PROCEDURE  SP_GetIssueHistory
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	

CREATE PROCEDURE [dbo].SP_GetIssueHistory

AS
BEGIN 
      SELECT IH.* , I.Id, S.Id 
	   FROM  
			Task_IssueHistory IH   
			INNER JOIN Task_Issue I ON IH.IssueId = I.Id
			INNER JOIN Task_Sprint S ON IH.SprinttId = S.Id   
		
END  


----- EXEC SP_GetIssueHistory 

