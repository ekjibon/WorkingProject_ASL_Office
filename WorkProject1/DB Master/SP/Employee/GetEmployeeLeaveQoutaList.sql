IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeLeaveQoutaList]'))
BEGIN
DROP PROCEDURE  [GetEmployeeLeaveQoutaList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Arifur 
-- Create date: 
-- Description:	
-- =============================================

CREATE PROCEDURE [dbo].[GetEmployeeLeaveQoutaList]
	@Block INT, 
	@BranchId INT,
	@DepartmentId INT,
	@CalenderId INT,
	@DesignationId INT,
	@Addby VARCHAR(MAX),
	@IP VARCHAR(MAX),
	@MacAddress VARCHAR(MAX)
AS
BEGIN
 IF(@Block=1)  
 -- execute [dbo].[GetEmployeeLeaveQoutaList] 1,10,4,1,0,'','',''
 -- execute [dbo].[GetEmployeeLeaveQoutaList] 1,10,3,37,19
 BEGIN
  IF(@DesignationId = 0)
  BEGIN
	SET @DesignationId = null
  END

 SELECT DISTINCT EB.EmpBasicInfoID
        ,EB.EmpID
		,EB.FullName
		,ED.DesignationName
		,ED.DesignationID
		,D.DepartmentID
		,D.DepartmentName
		,B.BranchId
		,B.BranchName
		,ELQ.AnnualLeaveDay
		,ELQ.SickLeaveDay
		,ELQ.AdvanceLeaveDay
		,ELQ.MaternityLeaveDay
		,@CalenderId AS CalenderId
		,ISNULL(ELQ.RoutingId,0) AS RoutingId
		,ISNULL(ELQ.EmpLeaveQuotaId,0) AS EmpLeaveQuotaId
		,EAC.Title

	FROM [dbo].[Emp_BasicInfo] EB
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN dbo.Emp_Department D ON D.DepartmentID = EB.DepartmentID
	LEFT JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
    LEFT JOIN [dbo].[HR_EmpLeaveQuota] ELQ ON ELQ.EmpId = EB.EmpBasicInfoID --AND ELQ.CalenderId = @CalenderId
	INNER JOIN Att_EmpAcademicCalendar EAC ON EAC.Id = @CalenderId
	 
	WHERE EB.BranchID = @BranchId AND EB.DepartmentID = @DepartmentId AND ED.DesignationID = ISNULL(@DesignationId,EB.DesignationID) AND EB.Status='A' AND EB.IsDeleted=0  
 END


END