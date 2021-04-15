IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_GetIssueHistory'))
BEGIN
DROP PROCEDURE  SP_GetIssueHistory
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_GetMonth 

CREATE PROCEDURE [dbo].SP_GetIssueHistory
(  
  	@IssueId INT
)
AS
BEGIN 
      SELECT IH.* , I.Id, S.Id ,s.SprintTitle as SprintName , I.Title
	   FROM  
			Task_IssueHistory IH   
			INNER JOIN Task_Issue I ON IH.IssueId = I.Id
			INNER JOIN Task_Sprint S ON IH.SprinttId = S.Id   
			where IH.IssueId = @IssueId
		
END  


----- EXEC SP_GetIssueHistory 1003

