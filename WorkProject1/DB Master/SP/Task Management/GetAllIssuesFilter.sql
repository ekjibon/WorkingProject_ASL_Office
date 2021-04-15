IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllIssuesFilter]'))
BEGIN
DROP PROCEDURE  GetAllIssuesFilter
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllIssuesFilter]    Script Date:17/11/2020 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- EXEC GetAllIssuesFilter Total Param 12
Create Procedure [dbo].GetAllIssuesFilter
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

	IF(@Block = 1) -- All Issue List With Filter -- EXEC GetAllIssuesFilter 1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24,NULL,NULL, '2020-12-14'
	BEGIN
		
		SELECT  I.Id,I.ProjectId,I.IssueTypeId,I.SprintId,I.AssigneeId,I.ReporterId,I.ClientId,I.Title
				,I.Description,I.Priority,I.AlertRule,ISNULL(I.DueDate,I.AddDate) AS DueDate,I.ParentId,I.IsDeleted,I.AddBy,I.AddDate,I.UpdateBy,I.UpdateDate
				,I.Remarks,I.Status,I.[IP],I.MacAddress,I.StatusId,I.StartDate,I.EndDate,P.DepartmentId
		, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId
				,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
				--, C.FullName AS ClientFullName
				INTO #tempIssueListAdmin
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			--LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					AND  I.IsDeleted = 0 AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
			ORDER BY I.Id DESC OFFSET ((@PageNo - 1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY

			SELECT * FROM #tempIssueListAdmin
	-- Sub Issue
		SELECT I.*, IT.IssueTypeName,P.DepartmentId, P.ProjectName, C.FullName, S.SprintTitle
				,U.Id AS ReporterUserId,U.FullName AS ReporterName
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
			AND I.Id IN (SELECT Id FROM #tempIssueListAdmin)
			ORDER BY I.Id DESC
	-- Issue Web Link
		SELECT * FROM dbo.Task_IssueWebLink WHERE IssueId IN (SELECT Id FROM #tempIssueListAdmin)  
	-- Issue History
		SELECT IH.Type,IH.IssueId,IH.UserId,U.FullName,(IH.Description + ' '+ FORMAT(IH.ModifyDate , 'dd-MMMM-yyyy hh:mm:tt')) AS Description FROM dbo.Task_IssueHistory IH
			INNER JOIN dbo.AspNetUsers U ON U.Id =  IH.UserId 
			WHERE IH.IssueId IN (SELECT Id FROM #tempIssueListAdmin) 
			ORDER BY IH.HistoryId ASC
	-- Issue Attachment
		SELECT * FROM dbo.Task_IssueAttachment WHERE IssueId IN (SELECT Id FROM #tempIssueListAdmin) 
	-- Issue Comment
		SELECT TC.*, U.FullName, U.Id AS UserId FROM dbo.Task_Comments TC JOIN AspNetUsers U ON U.UserName = TC.AddBy 
		WHERE IssueId IN (SELECT Id FROM #tempIssueListAdmin)
		ORDER BY TC.Id DESC

		DROP TABLE #tempIssueListAdmin
	END
	IF(@Block = 2) -- All Sub Issue List With Filter 
	BEGIN		
		SELECT I.*, IT.IssueTypeName, P.ProjectName, C.FullName, S.SprintTitle
		FROM dbo.Task_Issue AS I
		LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
		LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
		LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
		LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
		WHERE I.Priority =  ISNULL(@Priority,I.Priority) AND I.IssueTypeId =  ISNULL(@IssueTypeId,I.IssueTypeId)
				AND I.AddBy =  ISNULL(@AddBy,I.AddBy) AND I.ProjectId =  ISNULL(@ProjectId,I.ProjectId) AND I.ClientId =  ISNULL(@ClientId,I.ClientId)
				AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
				AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))
				AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
				AND  I.IsDeleted = 0 AND (I.ParentId IS NOT NULL OR I.ParentId <> 0)
		ORDER BY I.Id DESC
	END
	IF(@Block=3) -- EXEC GetAllIssuesFilter 3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	BEGIN

		SELECT P.* FROM dbo.Task_Project P 
		WHERE P.IsDeleted =  0 AND P.IsDeleted =  0
		-- Sprint 
		SELECT S.Id,S.ProjectId,S.SprintTitle,
				CONVERT(DECIMAL(7,2),(SELECT CONVERT(DECIMAL(7,2), (dbo.IssueCount(S.Id,'TTD') * 100 ) ) / CONVERT(DECIMAL(7,2), NULLIF((SELECT  COUNT(*) FROM Task_Issue I WHERE I.SprintId =S.Id AND IsDeleted=0 AND I.StatusId NOT IN (2)),0) ) ) )  AS TodoPersent,
				CONVERT(DECIMAL(7,2),(SELECT CONVERT(DECIMAL(7,2),(dbo.IssueCount(S.Id,'TIN') * 100 ) ) / CONVERT(DECIMAL(7,2),NULLIF((SELECT  COUNT(*) FROM Task_Issue I WHERE I.SprintId =S.Id AND IsDeleted=0 AND I.StatusId NOT IN (2)),0) )  ) )  AS InProPersent,
				CONVERT(DECIMAL(7,2),(SELECT CONVERT(DECIMAL(7,2),(dbo.IssueCount(S.Id,'TQ') * 100 ) ) / CONVERT(DECIMAL(7,2), NULLIF((SELECT  COUNT(*) FROM Task_Issue I WHERE I.SprintId =S.Id AND IsDeleted=0 AND I.StatusId NOT IN (2)),0) ) ))  AS QAPersent,
				CONVERT(DECIMAL(7,2), (SELECT CONVERT(DECIMAL(7,2),(dbo.IssueCount(S.Id,'TD') * 100 ) ) / CONVERT(DECIMAL(7,2),NULLIF((SELECT  COUNT(*) FROM Task_Issue I WHERE I.SprintId =S.Id AND IsDeleted=0 AND I.StatusId NOT IN (2)),0))  ) ) AS DonePersent
			FROM dbo.Task_Sprint S 
		WHERE S.IsDeleted =  0 AND S.IsDeleted =  0
	-- Sprint Assign List
		SELECT  I.*, IT.IssueTypeName, P.ProjectName
			, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,AU.FullName AS AssigneeName,TS.StatusName
				,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
				--, C.FullName AS ClientFullName
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			--LEFT JOIN dbo.CRM_Client C ON ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE ISNULL(I.Priority,0) =  ISNULL(@Priority, ISNULL(I.Priority,0)) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))				
					--AND I.ClientId =  ISNULL(@ClientId,I.ClientId)
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					AND  I.IsDeleted = 0 AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
					AND I.ParentId IS NULL
			ORDER BY I.Id ASC

	-- Sprint UnAssign List
		SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,AU.FullName AS AssigneeName,TS.StatusName
				,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			LEFT JOIN dbo.CRM_Client C ON  ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE   I.IsDeleted = 0 AND (I.SprintId IS  NULL OR I.SprintId = 0) 
		AND I.ParentId IS NULL
			ORDER BY I.Id ASC
	END
	IF(@Block = 4) -- All Issue List By UserId and Date -- EXEC GetAllIssuesFilter 4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'506e12eb-90c8-4b83-92f1-f1b76b8a5f2c',NULL
	BEGIN
		
		SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId
				,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
				--, C.FullName AS ClientFullName
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			--LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE   I.IsDeleted = 0 AND AU.Id = @UserId AND CAST(I.AddDate AS DATE)= CAST(@Date AS DATE)
		--I.Priority =  ISNULL(@Priority,I.Priority) 
					--AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					--AND I.ProjectId =  ISNULL(@ProjectId,I.ProjectId) 
					
					--AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					--AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					--AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					--AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					 --AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
			ORDER BY I.Id DESC
	-- Sub Issue
		SELECT I.*, IT.IssueTypeName, P.ProjectName, C.FullName, S.SprintTitle
				,U.Id AS ReporterUserId,U.FullName AS ReporterName
				,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE   I.IsDeleted = 0 
				--AND AU.Id = @UserId AND CAST(I.AddDate AS DATE)= CAST(@Date AS DATE)
			AND (I.ParentId IS NOT NULL OR I.ParentId <> 0)
			ORDER BY I.Id DESC
	-- Issue Web Link
		SELECT * FROM dbo.Task_IssueWebLink
	-- Issue History
		SELECT IH.Type,IH.IssueId,IH.UserId,U.FullName,(IH.Description + ' '+ FORMAT(IH.ModifyDate , 'dd-MMMM-yyyy hh:mm:tt')) AS Description FROM dbo.Task_IssueHistory IH
			INNER JOIN dbo.AspNetUsers U ON U.Id =  IH.UserId
	-- Issue Attachment
		SELECT * FROM dbo.Task_IssueAttachment
	-- Issue Comment
		SELECT * FROM dbo.Task_Comments
	END		
	IF(@Block=5) -- Board Issue List EXEC GetAllIssuesFilter 5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
		BEGIN
		DECLARE @TotalBackLog INT =0,@TotalToDo INT =0,@TotalInPro INT =0,@TotalQARev INT =0,@TotalDone INT =0

		SELECT @TotalBackLog = [dbo].[StatusWiseIssueCount](2,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date)
		SELECT @TotalToDo = [dbo].[StatusWiseIssueCount](3,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date)
		SELECT @TotalBackLog = [dbo].[StatusWiseIssueCount](4,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date)
		SELECT @TotalBackLog = [dbo].[StatusWiseIssueCount](5,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date)
		SELECT @TotalBackLog = [dbo].[StatusWiseIssueCount](6,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date)

	-- Back Log Issue List
			SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
					,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId, P.DepartmentId 
					,@TotalBackLog AS TotalBackLog
					,[dbo].[StatusWiseIssueCount](3,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalToDo
					,[dbo].[StatusWiseIssueCount](4,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalInPro
					,[dbo].[StatusWiseIssueCount](5,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalQARev
					,[dbo].[StatusWiseIssueCount](6,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalDone
					,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
					,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue
				FROM dbo.Task_Issue AS I
				LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
				LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
				LEFT JOIN dbo.CRM_Client C ON  ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
				LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
				LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
				LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
				LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
			WHERE   I.IsDeleted = 0 AND I.StatusId = 2
					AND (I.SprintId IS  NULL OR I.SprintId = 0)
					AND	I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))		
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
				ORDER BY I.Id DESC
	-- To Do Issue List
			SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
					,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId, P.DepartmentId
					,@TotalBackLog AS TotalBackLog
					,[dbo].[StatusWiseIssueCount](3,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalToDo
					,[dbo].[StatusWiseIssueCount](4,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalInPro
					,[dbo].[StatusWiseIssueCount](5,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalQARev
					,[dbo].[StatusWiseIssueCount](6,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalDone
					,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
					,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue
				FROM dbo.Task_Issue AS I
				LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
				LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
				LEFT JOIN dbo.CRM_Client C ON  ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
				LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
				LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
				LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
				LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
			WHERE   I.IsDeleted = 0 AND I.StatusId = 3	
					AND I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
				ORDER BY I.Id DESC	
	-- In-Progress Issue List
			SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
					,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId, P.DepartmentId
					,@TotalBackLog AS TotalBackLog
					,[dbo].[StatusWiseIssueCount](3,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalToDo
					,[dbo].[StatusWiseIssueCount](4,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalInPro
					,[dbo].[StatusWiseIssueCount](5,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalQARev
					,[dbo].[StatusWiseIssueCount](6,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalDone
					,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
					,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue
				FROM dbo.Task_Issue AS I
				LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
				LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
				LEFT JOIN dbo.CRM_Client C ON  ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
				LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
				LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
				LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
				LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
			WHERE   I.IsDeleted = 0 AND I.StatusId = 4	
					AND I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
				ORDER BY I.Id DESC
	-- QA Review Issue List
			SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
					,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId, P.DepartmentId
					,@TotalBackLog AS TotalBackLog
					,[dbo].[StatusWiseIssueCount](3,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalToDo
					,[dbo].[StatusWiseIssueCount](4,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalInPro
					,[dbo].[StatusWiseIssueCount](5,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalQARev
					,[dbo].[StatusWiseIssueCount](6,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalDone
					,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
					,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue
				FROM dbo.Task_Issue AS I
				LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
				LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
				LEFT JOIN dbo.CRM_Client C ON  ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
				LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
				LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
				LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
				LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
			WHERE   I.IsDeleted = 0 AND I.StatusId = 5	
					AND I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
				ORDER BY I.Id DESC
	-- Done Issue List
			SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
					,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId, P.DepartmentId
					,@TotalBackLog AS TotalBackLog
					,[dbo].[StatusWiseIssueCount](3,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalToDo
					,[dbo].[StatusWiseIssueCount](4,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalInPro
					,[dbo].[StatusWiseIssueCount](5,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalQARev
					,[dbo].[StatusWiseIssueCount](6,@ProjectId,@ClientId,@AssigneeId,@ReporteId,@Priority,@IssueTypeId,@Date) AS TotalDone
					,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
					,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue
				FROM dbo.Task_Issue AS I
				LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
				LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
				LEFT JOIN dbo.CRM_Client C ON  ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
				LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
				LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
				LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
				LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
			WHERE   I.IsDeleted = 0 AND I.StatusId = 6	
					AND I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
				ORDER BY I.Id DESC
		END
	IF(@Block=6) -- Board Issue List EXEC GetAllIssuesFilter 6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	BEGIN
					SELECT  I.Id,I.ProjectId,I.IssueTypeId,I.SprintId,I.AssigneeId,I.ReporterId,I.ClientId,I.Title
				,I.Description,I.Priority,I.AlertRule,ISNULL(I.DueDate,I.AddDate) AS DueDate,I.ParentId,I.IsDeleted,I.AddBy,I.AddDate,I.UpdateBy,I.UpdateDate
				,I.Remarks,I.Status,I.[IP],I.MacAddress,I.StatusId,I.StartDate,I.EndDate,P.DepartmentId
		, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId
				,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
				--, C.FullName AS ClientFullName
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			--LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE I.Priority =  ISNULL(@Priority,I.Priority) 
					AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
					AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
					AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
					AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
					AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporteId,ISNULL(I.ReporterId,0))
					AND ISNULL(I.SprintId,0) =  ISNULL(@SprintId,ISNULL(I.SprintId,0))			
					AND ISNULL(I.StatusId,0) =  ISNULL(@StatusId,ISNULL(I.StatusId,0))			
					AND  I.IsDeleted = 0 AND (I.SprintId IS NOT NULL OR I.SprintId <> 0)
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
			ORDER BY I.Id DESC
	-- Sub Issue
		SELECT I.*, IT.IssueTypeName,P.DepartmentId, P.ProjectName, C.FullName, S.SprintTitle
				,U.Id AS ReporterUserId,U.FullName AS ReporterName
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
			ORDER BY I.Id DESC
	-- Issue Web Link
		SELECT * FROM dbo.Task_IssueWebLink 
	-- Issue History
		SELECT IH.Type,IH.IssueId,IH.UserId,U.FullName,(IH.Description + ' '+ FORMAT(IH.ModifyDate , 'dd-MMMM-yyyy hh:mm:tt')) AS Description FROM dbo.Task_IssueHistory IH
			INNER JOIN dbo.AspNetUsers U ON U.Id =  IH.UserId 
			ORDER BY IH.HistoryId ASC
	-- Issue Attachment
		SELECT * FROM dbo.Task_IssueAttachment
	-- Issue Comment
		SELECT TC.*, U.FullName, U.Id AS UserId FROM dbo.Task_Comments TC JOIN AspNetUsers U ON U.UserName = TC.AddBy 
		ORDER BY TC.Id DESC
	END
	
	IF(@Block = 7) -- For Employee-- All Issue List With Filter -- EXEC GetAllIssuesFilter 1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,15,NULL,NULL, NULL,1,10
	BEGIN
		
		SELECT  I.Id,I.ProjectId,I.IssueTypeId,I.SprintId,I.AssigneeId,I.ReporterId,I.ClientId,I.Title
				,I.Description,I.Priority,I.AlertRule,ISNULL(I.DueDate,I.AddDate) AS DueDate,I.ParentId,I.IsDeleted,I.AddBy,I.AddDate,I.UpdateBy,I.UpdateDate
				,I.Remarks,I.Status,I.[IP],I.MacAddress,I.StatusId,I.StartDate,I.EndDate,P.DepartmentId
		, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId
				,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
				--, C.FullName AS ClientFullName
				--,DATEDIFF(DAY, DueDate, GETDATE()) AS DueFiff
				,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
						WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
					ELSE 0 END) AS IsOverDue
				--,(CASE WHEN DATEDIFF(DAY, ISNULL(DueDate,I.AddDate), GETDATE()) > 0 AND DATEDIFF(DAY, GETDATE(), I.EndDate) > 0 THEN 1 ELSE 0 END) AS IsOverDue
				--,(CASE WHEN DATEDIFF(DAY, ISNULL(DueDate,I.AddDate), GETDATE()) > 0 THEN 1 ELSE 0 END) AS IsOverDue
				--,DATEDIFF(DAY, ISNULL(DueDate,I.AddDate), GETDATE()) AS Diff
				INTO #tempIssueList
			FROM dbo.Task_Issue AS I
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			--LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
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
					AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@Date, ISNULL(I.DueDate,I.AddDate)) AS DATE))
			ORDER BY I.Id DESC OFFSET ((@PageNo - 1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY

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
		SELECT TC.*, U.FullName, U.Id AS UserId 
		FROM dbo.Task_Comments TC JOIN AspNetUsers U ON U.UserName = TC.AddBy 
		WHERE IssueId IN (SELECT Id FROM #tempIssueList) 
		ORDER BY TC.Id DESC

		DROP TABLE #tempIssueList
	END
END
