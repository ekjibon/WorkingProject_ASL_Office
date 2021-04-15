/****** Object:  StoredProcedure [dbo].[rptIndividualIssueList]    Script Date: 2021-01-04 12:48:41.200 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptIndividualIssueList]'))
BEGIN
DROP PROCEDURE  rptIndividualIssueList
END
GO
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rptIndividualIssueList]   --rptIndividualIssueList NULL,NULL,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL
(
	@Priority VARCHAR(MAX) = NULL,
	@IssueTypeId INT = NULL,
	@ProjectId INT =NULL ,
	@ClientId INT = NULL,
	@ReporteId INT = NULL,
	@SprintId INT = NULL,
	@StatusId INT = NULL,
	@AssigneeId INT = NULL,
	@AddBy VARCHAR(MAX) = NULL,
	@UserId VARCHAR(MAX) = NULL,
	@Date DATETIME = NULL
)
AS
BEGIN
	IF(@Priority='undefined') SET @Priority = NULL
	IF(@IssueTypeId=0) SET @IssueTypeId = NULL
	IF(@ProjectId=0) SET @ProjectId = NULL
	IF(@ClientId=0) SET @ClientId = NULL
	IF(@ReporteId=0) SET @ReporteId = NULL
	IF(@SprintId=0) SET @SprintId = NULL
	IF(@StatusId=0) SET @StatusId = NULL
	IF(@AddBy='undefined') SET @AddBy = NULL
	IF(@AssigneeId=0) SET @AssigneeId = NULL



	SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
					,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId, P.DepartmentId 
					,[dbo].[StatusWiseIssueCount](@StatusId,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalIssue
					,[dbo].[StatusWiseIssueCount](2,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalBackLog
					,[dbo].[StatusWiseIssueCount](3,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalToDo
					,[dbo].[StatusWiseIssueCount](4,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalInPro
					,[dbo].[StatusWiseIssueCount](5,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalQARev
					,[dbo].[StatusWiseIssueCount](6,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalDone
					,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
					,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue,
					ED.DepartmentName,AU.UserName AS EmpID, AU.Email, AU.MobileNo
					--,COUNT(I.Id) AS TotalIssue
				FROM dbo.Task_Issue AS I
				LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
				LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
				LEFT JOIN dbo.CRM_Client C ON  ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
				LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
				LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
				LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
				LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
				LEFT JOIN dbo.Emp_BasicInfo EB ON EB.EmpBasicInfoID = I.AssigneeId
				LEFT JOIN dbo.Emp_Department ED ON ED.DepartmentID = P.DepartmentId
			WHERE   I.IsDeleted = 0 -- AND I.StatusId = 2
					--AND (I.SprintId IS  NULL OR I.SprintId = 0)
					AND	I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))		
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
				ORDER BY EB.EmpID ASC
END



