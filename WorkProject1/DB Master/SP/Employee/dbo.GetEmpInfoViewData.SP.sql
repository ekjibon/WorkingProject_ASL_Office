/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpInfoViewData]'))
BEGIN
DROP PROCEDURE  GetEmpInfoViewData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[GetEmpInfoViewData] 

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
	DE.DesignationName
	FROM  dbo.Emp_BasicInfo EB
	LEFT JOIN dbo.Emp_Category EC ON EB.CategoryID = EC.CategoryID
	LEFT JOIN dbo.Emp_Status ES ON EB.StatusID = ES.StatusID
	LEFT JOIN dbo.Ins_Shift SH ON EB.ShiftID = SH.ShiftId
	LEFT JOIN dbo.Ins_Section SC ON EB.SectionID = SC.SectionId
	LEFT JOIN dbo.Ins_Branch IB ON EB.BranchID = IB.BranchId
	LEFT JOIN dbo.Res_SubjectSetup SB ON EB.SubjectID = SB.SubID
	LEFT JOIN dbo.Emp_Designation DE ON DE.DesignationID = EB.DesignationID
	WHERE EB.EmpID = @empId

--exec GetEmpInfoViewData '180001'
END