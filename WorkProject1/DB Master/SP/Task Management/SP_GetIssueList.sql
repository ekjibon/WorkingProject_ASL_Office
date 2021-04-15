IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetIssueList]'))
BEGIN
DROP PROCEDURE  [GetIssueList]
END
GO

/****** Object:  StoredProcedure [dbo].[GetIssueList]    Script Date: 11/17/2020 2:17:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

			-- GetIssueList 2, 147
CREATE PROCEDURE [dbo].[GetIssueList] 
(

	@Block INT,
	@IssueId INT

)
AS
BEGIN
	IF(@Block = 1)  ---- GetIssueList 1, null
		BEGIN
			SELECT I.Id, I.ProjectId, P.ProjectName , I.SprintId, I.AssigneeId, I.ReporterId, I.ClientId, I.Title, I.Description, I.Priority, I.AlertRule, I.DueDate,
			I.ProjectId,I.StatusId, I.IssueTypeId,  IT.IssueTypeName, I.IsDeleted
			FROM Task_Issue I 
			LEFT JOIN Task_Project P ON p.Id = I.ProjectId
			LEFT JOIN Task_IssueType IT ON I.IssueTypeId = IT.Id
			WHERE I.ParentId IS NULL AND I.IsDeleted = 0
		END
	IF(@Block = 2)   -- GetIssueList 2, 147
		BEGIN
			SELECT 	      --Index - 0
					I.*,					
					IT.IssueTypeName,					
					P.ProjectName,					
					U.FullName AS AssigneeName,					
					U1.FullName AS ReporterName,					
					TS.StatusName,					
					C.FullName,
					S.SprintTitle 
			FROM Task_Issue I LEFT  JOIN Task_IssueType IT ON I.IssueTypeId = IT.Id
							  LEFT  JOIN Task_Project P ON I.ProjectId = P.Id
							  LEFT  JOIN CRM_Client C ON I.ClientId = C.Id
							  LEFT  JOIN Task_Sprint S ON I.SprintId = S.Id
							  --LEFT OUTER JOIN Task_TaskActivityLog tl ON I.Id = tl.RefId
							  LEFT  JOIN Task_Status TS ON TS.Id = I.StatusId
							  LEFT  JOIN  AspNetUsers U ON I.AssigneeId = U.EmpId
							  LEFT  JOIN  AspNetUsers U1 ON I.ReporterId = U1.EmpId
			WHERE I.Id =@IssueId


			--SubIssue List --Index - 1
			SELECT 	I.*,
					IT.IssueTypeName,
					U.FullName AS AssigneeName,
					U1.FullName AS ReporterName,
					TS.Id AS StatusId, --StatusId need Migrate
					TS.StatusName  
					FROM Task_Issue I 
							LEFT  JOIN Task_IssueType IT ON I.IssueTypeId = IT.Id
							  LEFT  JOIN Task_Status TS ON I.StatusId = TS.Id
							  LEFT  JOIN  AspNetUsers U ON I.AssigneeId = U.EmpId
							  LEFT  JOIN  AspNetUsers U1 ON I.ReporterId = U1.EmpId
						Where I.ParentId = @IssueId
		

			--Comments
			SELECT TC.*,  U.Id AS UserId,  U.FullName
			FROM Task_Comments TC			
			LEFT JOIN AspNetUsers U ON U.UserName = TC.AddBy
			WHERE TC.IssueId = @IssueId
			ORDER BY TC.Id DESC
			--Work Log


			--Attachment List --Index - 3
			SELECT  [AttachmentId] ,[IssueId]  ,[FileName] ,[FileType] ,[ImageUrl] FROM Task_IssueAttachment WHERE [IssueId] = @IssueId

			--Web Link List --Index - 4
			SELECT Id, IssueId,  Description, Url  FROM Task_IssueWebLink WHERE IssueId = @IssueId

			--Issue Hostory List --Index - 5
					SELECT IH.IssueId,IH.UserId,U.FullName AS [Type],(IH.Description + ' '+ FORMAT(IH.ModifyDate , 'dd-MMMM-yyyy hh:mm:tt')) AS Description --IH.Type,
					FROM dbo.Task_IssueHistory IH
							INNER JOIN dbo.AspNetUsers U ON U.Id =  IH.UserId
					WHERE IH.IssueId = @IssueId
					ORDER BY IH.HistoryId DESC
		END

END


GO

