/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpInfoData]'))
BEGIN
DROP PROCEDURE  GetEmpInfoData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmpInfoData] 

@empId varchar(MAX)
AS
BEGIN

	SELECT 
	EB.*,
	EC.CategoryName,
	ES.StatusName,
	SH.ShiftName,
	IB.BranchName,
	SB.SubjectName,
	SC.SectionName,
	D.DesignationName,
	V.VersionName,
	ED.DepartmentName

	FROM dbo.AspNetUsers U
	JOIN dbo.Emp_BasicInfo EB ON U.EmpId = EB.EmpBasicInfoID
	LEFT JOIN dbo.Emp_Category EC ON EB.CategoryID = EC.CategoryID
	LEFT JOIN dbo.Emp_Status ES ON EB.StatusID = ES.StatusID
	LEFT JOIN dbo.Ins_Shift SH ON EB.ShiftID = SH.ShiftId
	LEFT JOIN dbo.Ins_Section SC ON EB.SectionID = SC.SectionId
	LEFT JOIN dbo.Ins_Branch IB ON EB.BranchID = IB.BranchId
	LEFT JOIN dbo.Res_SubjectSetup SB ON EB.SubjectID = SB.SubID
	LEFT JOIN dbo.Emp_Designation D ON EB.DesignationID = D.DesignationID
	LEFT JOIN dbo.Ins_Version V ON EB.VersionID = V.VersionId
	LEFT JOIN dbo.Emp_Department ED ON EB.DepartmentID = ED.DepartmentID
	WHERE Id = @empId

--exec GetEmpInfoData 'a824790f-6be8-4218-9c10-72eea8d83f89'
END
