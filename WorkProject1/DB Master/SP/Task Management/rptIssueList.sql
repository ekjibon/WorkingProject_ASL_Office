/****** Object:  StoredProcedure [dbo].[rptIssueList]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptIssueList]'))
BEGIN
DROP PROCEDURE  rptIssueList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rptIssueList]   --[rptIssueList] 3,0,0,0,0,0,NULL,NULL
	@Block int,
	@DepartmentId int,
	@ProjectId int,
	@ClientId int,
	@SprintId int,
	@IssueTypeId int,
	@FromDate DATETIME = NULL,
	@ToDate DATETIME = NULL
AS
BEGIN
	IF(@DepartmentId=0) SET @DepartmentId = NULL
	IF(@ProjectId=0) SET @ProjectId = NULL
	IF(@ClientId=0) SET @ClientId = NULL
	IF(@SprintId=0) SET @SprintId = NULL
	IF(@IssueTypeId=0) SET @IssueTypeId = NULL
	IF(@Block = 1 )
	BEGIN
		SELECT EB.FullName,   ED.DepartmentName, FORMAT( I.StartDate, 'dd-MM-yyyy') AS StartDate, FORMAT(I.EndDate, 'dd-MM-yyyy') AS EndDate, I.Priority, I.Title
				,ST.StatusName,@FromDate AS FromDate,@ToDate AS ToDate
			FROM Task_Issue I 				
				LEFT JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = I.AssigneeId
				LEFT JOIN Emp_Department ED ON ED.DepartmentID = EB.DepartmentID
				INNER JOIN dbo.Task_Status ST ON ST.Id =  I.StatusId
			WHERE	ED.DepartmentID = ISNULL(@DepartmentId,ED.DepartmentID)	
					AND ISNULL( I.ProjectId,0) = ISNULL(@ProjectId, ISNULL( I.ProjectId,0) )
					AND ISNULL( I.ClientId,0) = ISNULL(@ClientId , ISNULL( I.ClientId,0))
					AND ISNULL( I.SprintId,0) = ISNULL(@SprintId, ISNULL( I.SprintId,0))
					AND ISNULL(I.IssueTypeId,0) = ISNULL(@IssueTypeId, ISNULL(I.IssueTypeId,0))
					AND I.StatusId <> 2 AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
			--AND I.EndDate IS NOT NULL
			ORDER BY EB.DisOrder ASC
	END	
	IF(@Block = 2 )  --EXEC [rptIssueList] 1,0,0,0,0,0,'2020-11-24','2020-11-24'
	BEGIN
	create table #date
	(
		attandDate nvarchar(200)
	)
	insert into #date select datestring from DateRange_To_Table(@FromDate,@ToDate)
	--select CONVERT(Datetime, attandDate,23) 
	--	 from #date
		SELECT TI.Id,TI.Title,TI.Description,TI.Priority,TI.AssigneeId,TI.ProjectId,TI.SprintId,S.SprintTitle,P.ProjectName
			,TI.StatusId,ST.StatusName,TI.IssueTypeId,IT.IssueTypeName,EB.FullName,DDC.Text AS TeamName 
			,CAST(TI.StartDate AS DATE)	AS StartDate,CAST(TI.EndDate AS DATE) AS EndDate
			,FORMAT(CAST(d.attandDate AS DATETIME) , 'dd-MM-yyyy') AS IssueDate
			,DATENAME(WEEKDAY,d.attandDate) AS [DayName],ISNULL(CAST(DDC.Value AS INT),3333) AS SlNo
		FROM dbo.Task_Issue TI
				INNER JOIN dbo.Emp_BasicInfo EB ON EB.EmpBasicInfoID = TI.AssigneeId
				INNER JOIN dbo.Task_Sprint S ON S.Id =  TI.SprintId
				INNER JOIN dbo.Task_Project P ON P.Id =  TI.ProjectId
				INNER JOIN dbo.Task_IssueType IT ON IT.Id =  TI.IssueTypeId
				INNER JOIN dbo.Task_Status ST ON ST.Id =  TI.StatusId
				INNER JOIN dbo.Common_DropDownConfig DDC ON DDC.Type =  'Team' 
				RIGHT JOIN #date d ON CONVERT(Datetime, d.attandDate,23) = CAST(TI.AddDate AS DATE)
				AND CAST(DDC.Value AS INT) = EB.TeamId

				--WHERE CAST(TI.AddDate AS DATE) = CAST(GETDATE() AS DATE)
				ORDER BY  CONVERT(Datetime, d.attandDate,23) ASC
	DROP TABLE #date
	END	
	IF(@Block=3) --EXEC [rptIssueList] 3,0,0,0,18,0,'2020-11-24','2020-11-30'
	BEGIN
		CREATE TABLE #Temp 
			(
			   SprintId INT,
			   SprintTitle VARCHAR(MAX),
			   TotalIssue DECIMAL(10,2),
			   TotalTask DECIMAL(10,2),
			   TotalStory DECIMAL(10,2),
			   TotalBug DECIMAL(10,2),
			   TotalEpic DECIMAL(10,2),
			   TotalDone DECIMAL(10,2),
			   TotalTODO DECIMAL(10,2),
			   TotalInPro DECIMAL(10,2),
			   TotalBackLog DECIMAL(10,2),
			   TotalOverDue DECIMAL(10,2),
			   TotalQAReview DECIMAL(10,2),
			   TotalUnAssignee DECIMAL(10,2),
			   ProgressBar DECIMAL(10,2)
			)

		INSERT INTO #Temp (SprintId,SprintTitle, TotalIssue)
		SELECT  I.SprintId,S.SprintTitle,COUNT(*) AS TotalIssue   FROM dbo.Task_Issue I
		INNER JOIN dbo.Task_Sprint S ON S.Id =  I.SprintId
		WHERE
					ISNULL( I.ProjectId,0) = ISNULL(@ProjectId, ISNULL( I.ProjectId,0) )
					AND ISNULL( I.ClientId,0) = ISNULL(@ClientId , ISNULL( I.ClientId,0))
					AND ISNULL( I.SprintId,0) = ISNULL(@SprintId, ISNULL( I.SprintId,0))
					AND ISNULL(I.IssueTypeId,0) = ISNULL(@IssueTypeId, ISNULL(I.IssueTypeId,0))
				AND	I.IsDeleted = 0  AND I.SprintId = ISNULL(@SprintId,I.SprintId )
		GROUP BY  I.SprintId,S.SprintTitle


		UPDATE   T SET T.TotalTask = [dbo].[IssueCount] (T.SprintId,'TT'),
				 T.TotalStory = [dbo].[IssueCount] (T.SprintId,'TS'),
				 T.TotalBug = [dbo].[IssueCount] (T.SprintId,'TB'),
				 T.TotalEpic = [dbo].[IssueCount] (T.SprintId,'TE'),
				 T.TotalDone = [dbo].[IssueCount] (T.SprintId,'TD'),
				 T.TotalTODO = [dbo].[IssueCount] (T.SprintId,'TTD'),
				 T.TotalInPro = [dbo].[IssueCount] (T.SprintId,'TIN'),
				 T.TotalBackLog = [dbo].[IssueCount] (T.SprintId,'TBL')	,			 
				 T.TotalOverDue = [dbo].[IssueCount] (T.SprintId,'ODue'),
				 T.TotalQAReview = [dbo].[IssueCount] (T.SprintId,'TQ'),
				 T.TotalUnAssignee = [dbo].[IssueCount] (T.SprintId,'TUA')
		FROM #Temp T
		-- Progress Bar
		UPDATE #Temp SET ProgressBar = CAST(((TotalDone/TotalIssue) * 100) AS DECIMAL(10,2)) 

		SELECT * FROM #Temp

		-- Developer wise Issue Status
		SELECT  EB.FullName,I.AssigneeId,COUNT(*) AS TotalIssue   
		,(SELECT COUNT(*) FROM dbo.Task_Issue WHERE AssigneeId =  I.AssigneeId AND ISNULL( SprintId,0) = ISNULL(@SprintId, ISNULL(SprintId,0)) AND StatusId = 6) AS TotalDone
		,(SELECT COUNT(*) FROM dbo.Task_Issue WHERE AssigneeId =  I.AssigneeId AND ISNULL( SprintId,0) = ISNULL(@SprintId, ISNULL(SprintId,0)) AND StatusId = 4) AS TotalInPro
		,(SELECT COUNT(*) FROM dbo.Task_Issue WHERE AssigneeId =  I.AssigneeId AND ISNULL( SprintId,0) = ISNULL(@SprintId, ISNULL(SprintId,0)) AND (ISNULL(DueDate,AddDate) < GETDATE() AND EndDate <GETDATE() AND StatusId != 6 )) AS OverDue
		FROM dbo.Task_Issue I
		INNER JOIN dbo.Emp_BasicInfo EB ON EB.EmpBasicInfoID =  I.AssigneeId
		WHERE EB.DepartmentID = ISNULL(@DepartmentId,EB.DepartmentID)	
					AND ISNULL( I.ProjectId,0) = ISNULL(@ProjectId, ISNULL( I.ProjectId,0) )
					AND ISNULL( I.ClientId,0) = ISNULL(@ClientId , ISNULL( I.ClientId,0))
					AND ISNULL( I.SprintId,0) = ISNULL(@SprintId, ISNULL( I.SprintId,0))
					AND ISNULL(I.IssueTypeId,0) = ISNULL(@IssueTypeId, ISNULL(I.IssueTypeId,0))
			AND	I.IsDeleted = 0  AND I.AssigneeId IS NOT NULL 
		GROUP BY  I.AssigneeId,EB.FullName

		-- Developer wise Issue Details 
		SELECT EB.FullName,   ED.DepartmentName, FORMAT( I.StartDate, 'dd-MM-yyyy hh:mm tt') AS StartDate, FORMAT(I.EndDate, 'dd-MM-yyyy hh:mm tt') AS EndDate, I.Priority,
		I.Title + ' (' + CAST(I.Id AS VARCHAR(MAX)) + ')' AS Title
				,ST.StatusName
			FROM Task_Issue I 				
				LEFT JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = I.AssigneeId
				LEFT JOIN Emp_Department ED ON ED.DepartmentID = EB.DepartmentID
				INNER JOIN dbo.Task_Status ST ON ST.Id =  I.StatusId
			WHERE	ED.DepartmentID = ISNULL(@DepartmentId,ED.DepartmentID)	
					AND ISNULL( I.ProjectId,0) = ISNULL(@ProjectId, ISNULL( I.ProjectId,0) )
					AND ISNULL( I.ClientId,0) = ISNULL(@ClientId , ISNULL( I.ClientId,0))
					AND ISNULL( I.SprintId,0) = ISNULL(@SprintId, ISNULL( I.SprintId,0))
					AND ISNULL(I.IssueTypeId,0) = ISNULL(@IssueTypeId, ISNULL(I.IssueTypeId,0))
					AND I.StatusId <> 2 AND	I.IsDeleted = 0
			--AND I.EndDate IS NOT NULL
			ORDER BY EB.DisOrder ASC

		-- Line Chart 
		SELECT CAST(AddDate AS DATE) AS AddDate,COUNT(*) AS NotDone  FROM dbo.Task_Issue 
		WHERE StatusId <> 2 AND StatusId <> 6 AND SprintId = ISNULL(@SprintId,SprintId) AND IsDeleted = 0
		GROUP BY CAST(AddDate AS DATE)

		DROP TABLE #Temp

	END
END



