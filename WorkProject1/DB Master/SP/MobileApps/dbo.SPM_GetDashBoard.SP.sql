/****** Object:  StoredProcedure [dbo].[SPM_GetDashBoard]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SPM_GetDashBoard]'))
BEGIN
DROP PROCEDURE  SPM_GetDashBoard
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 --execute [dbo].[SPM_GetDashBoard] 'e3efe1f6-1892-49ee-b982-baee347ead07'

CREATE PROCEDURE [dbo].[SPM_GetDashBoard] -- Total 13 param
	
	@UserId VARCHAR(MAX)	
AS
BEGIN	

	DECLARE @EmpId INT =0 , @TodayInTime SMALLDATETIME , @TodayOutTime SMALLDATETIME, @IsLateIn bit, @IsEarlyOut bit
		
		SELECT @EmpId= EmpId FROM AspNetUsers WHERE Id = @UserId

		SELECT  EmpId, InTime AS TodayInTime, OutTime AS  TodayOutTime, IsLate, IsEarlyOut FROM Emp_Attendance WHERE EmpId= @EmpId AND CAST(InTime AS DATE) = CAST(GETDATE() AS DATE) AND IsPresent = 1

		--SELECT @TodayInTime = InTime  FROM Emp_Attendance WHERE EmpId= @EmpId AND CAST(InTime AS DATE) = CAST(GETDATE() AS DATE)
		--SELECT @TodayOutTime = OutTime  FROM Emp_Attendance WHERE EmpId= @EmpId AND CAST(OutTime AS DATE) = CAST(GETDATE() AS DATE)
		--SELECT @EmpId AS EmpId,@TodayInTime AS TodayInTime,@TodayOutTime AS TodayOutTime

		SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
			,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId
				,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
				--, C.FullName AS ClientFullName
			FROM dbo.Task_Issue AS I
			INNER JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
			LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
			LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
			--LEFT JOIN dbo.CRM_Client C ON C.Id = I.ClientId 
			LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
			LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
			
			LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0)
		WHERE   I.IsDeleted = 0 AND AU.Id = @UserId AND CAST(I.AddDate AS DATE)= CAST(GETDATE() AS DATE)
	 
END