IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllIssues]'))
BEGIN
DROP PROCEDURE  GetAllIssues
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllIssues]    Script Date:17/11/2020 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- EXEC GetAllIssues
Create Procedure [dbo].GetAllIssues

As
BEGIN

	SELECT I.*, IT.IssueTypeName, P.ProjectName, C.FullName, S.SprintTitle
	FROM dbo.Task_Issue AS I

	LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
	LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
	LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
	LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 

	ORDER BY I.Id DESC
END
