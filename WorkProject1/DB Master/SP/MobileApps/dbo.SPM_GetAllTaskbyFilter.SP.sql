/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SPM_GetAllTaskbyFilter]'))
BEGIN
DROP PROCEDURE  SPM_GetAllTaskbyFilter
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -- execute [dbo].[SPM_GetAllTaskbyFilter] 0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL

 --execute [dbo].[SPM_GetAllTaskbyFilter] 'e3efe1f6-1892-49ee-b982-baee347ead07','',NULL,NULL

CREATE PROCEDURE [dbo].[SPM_GetAllTaskbyFilter] -- Total 13 param
	
	@UserId VARCHAR(MAX),
	@Date SMALLDATETIME NULL,
	@Year INT NULL,
	@Month INT NULL
	
AS
BEGIN	

	DECLARE @EmpId INT =0 , @TodayInTime SMALLDATETIME , @TodayOutTime SMALLDATETIME
		
	SELECT @EmpId= EmpId FROM AspNetUsers WHERE Id = @UserId

	SELECT 	      --Index - 0
					I.Id,
					I.Title,
					I.Description,
					I.IssueTypeId,
					IT.IssueTypeName,
					I.Priority,
					I.ProjectId,
					P.ProjectName,
					I.AssigneeId,
					U.FullName AS AssigneeName,
					I.ReporterId ,
					U1.FullName AS ReporterName,
					I.StatusId, --StatusId need Migrate
					TS.StatusName,
					I.ClientId,
					C.FullName,
					I.SprintId,
					S.SprintTitle ,
					I.DueDate
			FROM Task_Issue I LEFT  JOIN Task_IssueType IT ON I.IssueTypeId = IT.Id
							  LEFT  JOIN Task_Project P ON I.ProjectId = P.Id
							  LEFT  JOIN CRM_Client C ON I.ClientId = C.Id
							  LEFT  JOIN Task_Sprint S ON I.SprintId = S.Id
							  --LEFT OUTER JOIN Task_TaskActivityLog tl ON I.Id = tl.RefId
							  LEFT  JOIN Task_Status TS ON TS.Id = I.StatusId
							  LEFT  JOIN  AspNetUsers U ON I.AssigneeId = U.EmpId
							  LEFT  JOIN  AspNetUsers U1 ON I.ReporterId = U1.EmpId
	WHERE I.IsDeleted = 0 AND I.AssigneeId= @EmpId AND
	  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) BETWEEN CAST(@Date AS DATE)  AND CAST(GETDATE() AS DATE)
	  ORDER BY I.DueDate DESC
	 
END