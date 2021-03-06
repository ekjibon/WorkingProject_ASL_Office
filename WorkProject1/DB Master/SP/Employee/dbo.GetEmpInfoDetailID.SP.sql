/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpInfoDetailID]'))
BEGIN
DROP PROCEDURE  GetEmpInfoDetailID
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].[GetEmpInfoDetailID] 51
CREATE PROCEDURE [dbo].[GetEmpInfoDetailID] 
@EmpID int
AS
BEGIN
select EmpBasicInfoID
,eb.EmpID
,eb.FullName
,eb.DesignationID
,eb.IsClassTeacher
,eb.TypeID
,eb.SectionID
,eb.BranchID
,eb.ShiftID
,eb.DepartmentID
,eb.SubjectID
,eb.CategoryID

,eb.JoiningDate
,eb.StatusID
,eb.Image
,eb.FatherName
,eb.MotherName
,eb.Nationality
,eb.Religion
,eb.BloodGroup
,eb.NationalID
,eb.DateOfBirth
,eb.Contact
,eb.PresentAddress
,eb.PresentPost
,eb.PresentThana
,eb.PresentDistrict
,eb.PermanentAddress
,eb.PermanentPost
,eb.PermanentThana
,eb.PermanentDistrict
,eb.InstituteAccount
,eb.IsGovtSalaryActive
,eb.GovtSalaryGrade
,eb.GovtAccount
,eb.Gender
,eb.MaritalStatus
,eb.MobileNo
,eb.Email
,eb.SMSNotificationNo
,eb.DeviceUserID
,eb.CardNo
,eb.IsPermanent
,eb.ProbationPeriodEndDate
,eb.ConfirmationDate
,eb.Accountname
,eb.AccountType
,eb.BankName
,eb.SpouseName
,eb.SpouseMobile
,eb.Child
,eb.BirthCertificate
,eb.DrawbackMedicine
,empb.BranchName
,eb.MPOIndexNo
,eb.PassportNo
,eb.EmergencyContactName
,eb.EmergencyContactRelation
,eb.EmergencyContactAddress
,eb.EmergencyTandTNo
,eb.ContactOfficeEmail
,eb.ContactOtherEmail
,eb.ContactHomeNo
,eb.ContactOfficeNo
,eb.DPSAcccountNo
,eb.eTIN
,eb.InstituteGrade
,eb.PFAccountNo
,eb.ReportingPersonID
,eb.ReportOrderNo
,eb.SalaryGradeID
,eb.ShortName
,eb.IsDeleted
,eb.Status
,eb.SalaryACNo
,eb.EmergencyContactNo
,eb.RetirementDate
,eb.BirthRegNo
,eb.DrivingLicenseNo
,eb.OfficePhoneNo
,eb.HomePhoneNo
,eb.PFACNo
,eb.PFBankName
,eb.PFBankBranch
,eb.WelfareACNo
,eb.MembershipNo
,eb.TINNo
,eb.JoiningSalary
,eb.ConfirmationSalary
,eb.CurrentSalary
,eb.PPExpireDate
--Add by Khaled 
,eb.IsResignationApplied
,eb.ServeDate
,eb.SalaryPaymentMode
--,eb.IsUnethicalExit
--,eb.LastDayOffice
,eb.WhatsAppNumber
,eb.SkypeUsername
,ER.Reason
,ER.[Description]
,ET.EmpLeaveTypeId as LeaveTypeId
,ed.DesignationName,edm.DepartmentName,ec.CategoryName,sec.SectionName,st.StatusName,sbj.SubjectName,ET.TypeName
 from dbo.Emp_BasicInfo eb
 left join dbo.Emp_Designation ed on ed.DesignationID=eb.DesignationID
 left join dbo.Emp_Department edm on edm.DepartmentID=eb.DepartmentID
 left join dbo.Emp_Category ec on ec.CategoryID=eb.CategoryID
 left join dbo.Emp_Section sec on sec.SectionID=eb.SectionID

 left join dbo.Emp_Status st on st.StatusID=eb.StatusID
 left join dbo.Emp_Subject sbj on sbj.SubjectID=eb.SubjectID
  left join Ins_Branch empb on eb.BranchID=empb.BranchId
 left join dbo.Emp_LeaveType ET on ET.EmpLeaveTypeId=eb.LeaveTypeId
 left join dbo.Emp_Request ER on ER.RequestType=6 AND ER.EmpId = eb.EmpBasicInfoID

  where EmpBasicInfoID=@EmpID
 
 select ImageId,EmpID,Photo,ImageName,IsDeleted,Status from dbo.Emp_Image where EmpID=@EmpID
 select EmpJobId
,EmpId
,Companyname
,Designation
,AreaOfExperiance
, FORMAT(cast([From] as DATETIME),'dd/MM/yyyy') [From]
, FORMAT(cast([To] as DATETIME),'dd/MM/yyyy') [To]
,YearOfExperiance
,IsDeleted
,Status
 from dbo.Emp_JobHistory where EmpID=@EmpID

 select EducationalInfo_ID
,ed.EmployeeID
,ed.ExamBoard
,ed.ExamInstituteName
,ed.ExamPasYear
,ed.ExamTotal
,ed.IsDeleted
,ed.Status
,ed.ExamGroupName
,ed.ExamName
 from dbo.Emp_EducationalInfo ed  where EmployeeID=@EmpID

 select EmpNomineeID
,EmpID
,NomineeName
,DOB
,FathersName
,MothersName
,SpouseName
,PresentAddress
,PermanentAddress
,Relation
,NationalID
,BirthRegNo
,Picture
,IsDeleted
,Status
 from dbo.Emp_Nominee where EmpID=@EmpID

 select EmpTrainingID
,EmpID
,Title
,TopicsCovered
,InstituteName
,TrainingCountry
,TrainingLocation
,FromDate
,ToDate
,EmpTraining_IsContinued
,IsDeleted
,Status
 from dbo.Emp_Training where EmpID=@EmpID
END

select FORMAT(cast('2019-01-01 00:00:00.000' as DATETIME),'dd/MM/yyyy') as Dates

