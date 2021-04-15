
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpInfoByEmpBasicInfoIDforHold]'))
BEGIN
DROP PROCEDURE  GetEmpInfoByEmpBasicInfoIDforHold
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetEmpInfoByEmpBasicInfoIDforHold] 1119
CREATE PROCEDURE [dbo].[GetEmpInfoByEmpBasicInfoIDforHold]  
@EmpBasicInfoID int
AS
BEGIN

	SELECT 
	EB.EmpBasicInfoID, EB.EmpID, FullName, EB.DesignationID, IsClassTeacher, TypeID, EB.SectionID, EB.BranchID, EB.ShiftID, EB.DepartmentID, EB.SubjectID, EB.CategoryID, 
	CASE WHEN ISDATE(JoiningDate)=1 THEN  CONVERT(NVARCHAR(12),CAST(JoiningDate AS DATE), 106) ELSE '' END JoiningDate, EB.StatusID, Image, FatherName,
	 MotherName, Nationality, Religion, BloodGroup, NationalID, DateOfBirth, Contact, PresentAddress, 
	PresentPost, PresentThana, PresentDistrict, PermanentAddress, PermanentPost, PermanentThana, PermanentDistrict, InstituteAccount, 
	IsGovtSalaryActive, GovtSalaryGrade, GovtAccount, Gender, MaritalStatus, MobileNo, EB.Email, SMSNotificationNo, DeviceUserID, CardNo, IsPermanent, 
	CASE WHEN ISDATE(ProbationPeriodEndDate)=1 THEN  CONVERT(NVARCHAR(12),CAST(ProbationPeriodEndDate AS DATE), 106) ELSE '' END ProbationPeriodEndDate, ConfirmationDate, 
	Accountname, AccountType, BankName, EB.BranchName, MPOIndexNo, PassportNo, EmergencyContactName, 
	EmergencyContactRelation, EmergencyContactAddress, EmergencyTandTNo, ContactOfficeEmail, ContactOtherEmail, ContactHomeNo, ContactOfficeNo, 
	DPSAcccountNo, eTIN, InstituteGrade, PFAccountNo, ReportingPersonID, ReportOrderNo, SalaryGradeID, EB.ShortName,  SalaryACNo, EmergencyContactNo, RetirementDate, BirthRegNo, DrivingLicenseNo, 
	OfficePhoneNo, HomePhoneNo, TINNo, LeaveTypeId, DisOrder, SpouseName, SpouseMobile, Child, BirthCertificate, DrawbackMedicine, PPExpireDate, 
	JoiningSalary, ConfirmationSalary, CurrentSalary, PFACNo, PFBankName, PFBankBranch, WelfareACNo, MembershipNo, IsResignationApplied, 
	ServeDate, SalaryPaymentMode,EC.CategoryName,ES.StatusName,SH.ShiftName,IB.BranchName,SB.SubjectName,SC.SectionName,DE.DesignationName,(HSH.GrossSalary) AS HoldedAmount
	FROM  dbo.Emp_BasicInfo EB
	LEFT JOIN dbo.Emp_Category EC ON EB.CategoryID = EC.CategoryID
	LEFT JOIN dbo.Emp_Status ES ON EB.StatusID = ES.StatusID
	LEFT JOIN dbo.Ins_Shift SH ON EB.ShiftID = SH.ShiftId
	LEFT JOIN dbo.Ins_Section SC ON EB.SectionID = SC.SectionId
	LEFT JOIN dbo.Ins_Branch IB ON EB.BranchID = IB.BranchId
	LEFT JOIN dbo.Res_SubjectSetup SB ON EB.SubjectID = SB.SubID
	LEFT JOIN dbo.Emp_Designation DE ON DE.DesignationID = EB.DesignationID
	INNER JOIN HR_SalaryHold HSH ON HSH.EmpId =EB.EmpBasicInfoID
	WHERE EB.EmpBasicInfoID = @EmpBasicInfoID


END