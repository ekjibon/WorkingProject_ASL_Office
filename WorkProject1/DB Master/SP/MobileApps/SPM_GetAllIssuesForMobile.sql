IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SPM_GetAllIssuesForMobile]'))
BEGIN
DROP PROCEDURE  SPM_GetAllIssuesForMobile
END
GO
/****** Object:  StoredProcedure [dbo].[SPM_GetAllIssuesForMobile]    Script Date:11/03/2021 10:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- EXEC SPM_GetAllIssuesForMobile Total Param 14
Create Procedure [dbo].SPM_GetAllIssuesForMobile
(
	@Block INT = 0,
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
	@Date DATETIME = NULL,
	@PageNo INT = NULL,
	@PageSize INT = NULL

)
As
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
	--IF(@Date IS NULL) SET @Date =  GETDATE()

	IF(@Block = 1) -- For Employee-- All Issue List With Filter -- EXEC SPM_GetAllIssuesForMobile 1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,56,NULL,NULL, '3/13/2021 11:12:12 AM',NULL,NULL
	BEGIN
		
		SELECT  I.Id,I.ProjectId,I.IssueTypeId,I.SprintId,I.AssigneeId,I.ReporterId,I.ClientId,C.FullName AS ClientFullName, I.Title
				,I.Description,I.Priority,I.AlertRule,ISNULL(I.DueDate,I.AddDate) AS DueDate,I.ParentId,I.IsDeleted,I.AddBy,I.AddDate,I.UpdateBy,I.UpdateDate
				,I.Remarks,I.Status,I.[IP],I.MacAddress,I.StatusId,I.StartDate,I.EndDate,P.DepartmentId
		, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId
				,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
				,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue				
				INTO #tempIssueList
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND (ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
								OR ISNULL(I.ReporterId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0)))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					AND  I.IsDeleted = 0 AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) BETWEEN CAST(@Date AS DATE)
																AND (CASE 
																WHEN CAST(@Date AS DATE)>CAST(GETDATE() AS DATE) THEN CAST(@Date AS DATE)  
																WHEN CAST(DATEADD(day, 1, CAST(@Date AS DATE)) AS DATE) = CAST(GETDATE() AS DATE) THEN CAST(@Date AS DATE)  
																ELSE CAST(GETDATE() AS DATE) END  
																) 
					--AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
			ORDER BY I.Id DESC --OFFSET ((@PageNo - 1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY

			SELECT * FROM #tempIssueList
	-- Sub Issue
		SELECT I.*, IT.IssueTypeName,P.DepartmentId, P.ProjectName, C.FullName, S.SprintTitle
				,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN  I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue
				,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE   I.IsDeleted = 0 AND (I.ParentId IS NOT NULL OR I.ParentId <> 0)
				AND I.ParentId IN (SELECT Id FROM #tempIssueList)
			ORDER BY I.Id DESC
	-- Issue Web Link
		SELECT * FROM dbo.Task_IssueWebLink WHERE IssueId IN (SELECT Id FROM #tempIssueList) 
	-- Issue History
		SELECT IH.Type,IH.IssueId,IH.UserId,U.FullName,(IH.Description + ' '+ FORMAT(IH.ModifyDate , 'dd-MMMM-yyyy hh:mm:tt')) AS Description 
		FROM dbo.Task_IssueHistory IH
			INNER JOIN dbo.AspNetUsers U ON U.Id =  IH.UserId 
			WHERE IH.IssueId IN (SELECT Id FROM #tempIssueList) 
			ORDER BY IH.HistoryId ASC
	-- Issue Attachment
		SELECT * FROM dbo.Task_IssueAttachment WHERE IssueId IN (SELECT Id FROM #tempIssueList) 
	-- Issue Comment
		SELECT TC.*, U.FullName, U.Id AS UserId , U.EmpId
		FROM dbo.Task_Comments TC JOIN AspNetUsers U ON U.UserName = TC.AddBy 
		WHERE IssueId IN (SELECT Id FROM #tempIssueList) 
		ORDER BY TC.Id DESC

		DROP TABLE #tempIssueList
	END
END
--select * from Task_Issue