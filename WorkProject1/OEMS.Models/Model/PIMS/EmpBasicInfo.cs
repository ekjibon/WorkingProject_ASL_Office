using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_BasicInfo")]
    [ClassName("Emp Basic Info")]
   public class EmpBasicInfo:Entity
    {
        [Key]
        public int EmpBasicInfoID { get; set; }
        public string EmpID { get; set; }  //change after discuss with kawsar
        public string FullName { get; set; }
        public int DesignationID { get; set; }
        public bool IsClassTeacher { get; set; }
        public int TypeID { get; set; }
        public int SectionID { get; set; }
        public int BranchID { get; set; }
        public int ShiftID { get; set; }
        public int DepartmentID { get; set; }
        public int SubjectID { get; set; }
        public int CategoryID { get; set; }
        public DateTime? JoiningDate { get; set; }
        public int StatusID { get; set; }
        public byte[] Image { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public string Nationality { get; set; }
        public string Religion { get; set; }
        public string BloodGroup { get; set; }
        public string NationalID { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string Contact { get; set; }
        public string PresentAddress { get; set; }
        public string PresentPost { get; set; }
        public string PresentThana { get; set; }
        public string PresentDistrict { get; set; }
        public string PermanentAddress { get; set; }
        public string PermanentPost { get; set; }
        public string PermanentThana { get; set; }
        public string PermanentDistrict { get; set; }
        public string InstituteAccount { get; set; }
        public bool IsGovtSalaryActive { get; set; }
        public int GovtSalaryGrade { get; set; }
        public string GovtAccount { get; set; }
        public int DisOrder { get; set; }


        public string Gender { get; set; }
        public string MaritalStatus { get; set; }
       
        public string MobileNo { get; set; }
        public string Email { get; set; }
        public string SMSNotificationNo { get; set; }
       
        public string DeviceUserID { get; set; }
        public string CardNo { get; set; }
        public bool IsPermanent { get; set; }
        public DateTime? ProbationPeriodEndDate { get; set; }
        public DateTime? ConfirmationDate { get; set; }

        public string Accountname { get; set; }
        public string JoiningSalary { get; set; }
        public string ConfirmationSalary { get; set; }
        public string CurrentSalary { get; set; }
        public string AccountType { get; set; }
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public string SalaryACNo { get; set; }
        public string MPOIndexNo { get; set; }
        public string PassportNo { get; set; }
        public DateTime? PPExpireDate { get; set; }

        public string EmergencyContactName { get; set; }
        public string EmergencyContactRelation { get; set; }
        public string EmergencyContactAddress { get; set; }
        public string EmergencyTandTNo { get; set; }
        public string EmergencyContactNo { get; set; }


        public string ContactOfficeEmail { get; set; }
        public string ContactOtherEmail { get; set; }
        public string ContactHomeNo { get; set; }
        public string ContactOfficeNo { get; set; }
        public string DPSAcccountNo { get; set; }
        public string eTIN { get; set; }
        public string InstituteGrade { get; set; }
        public string PFAccountNo { get; set; }
        public int ReportingPersonID { get; set; }
        public int ReportOrderNo { get; set; }
        public int SalaryGradeID { get; set; }
        public string ShortName { get; set; }
        public DateTime? RetirementDate { get; set; }
        public string BirthRegNo { get; set; }
        public string DrivingLicenseNo { get; set; }
        public string OfficePhoneNo { get; set; }
        public string HomePhoneNo { get; set; }
        public string SpouseName { get; set; }
        public string SpouseMobile { get; set; }
        public string Child { get; set; }
        public string BirthCertificate { get; set; }
        public string DrawbackMedicine { get; set; }
        //PF Info
        public string PFACNo { get; set; }
        public string PFBankName { get; set; }
        public string PFBankBranch { get; set; }
        public string WelfareACNo { get; set; }
        public string MembershipNo { get; set; }
        public string TINNo { get; set; }
        public int? LeaveTypeId { get; set; }
        public int TeamId { get; set; }
        // Add by khaled 
        public bool? IsResignationApplied { get; set; }
        public DateTime? ServeDate { get; set; }
        public string SalaryPaymentMode { get; set; }
        public string SkypeUsername { get; set; }
        public string WhatsAppNumber { get; set; }
        //public bool? IsUnethicalExit { get; set; }
        //public DateTime? LastDayOffice { get; set; }
        //
        [NotMapped]
        public string DesignationName { get; set; }
        [NotMapped]
        public string DepartmentName { get; set; }
        [NotMapped]
        public string CategoryName { get; set; }
        [NotMapped]
        public string SectionName { get; set; }
        [NotMapped]
        public string StatusName { get; set; }
        [NotMapped]
        public string VersionName { get; set; }
        [NotMapped]
        public string SubjectName { get; set; }
        [NotMapped]
        public string ShiftName { get; set; }
        [NotMapped]
        public string TypeName { get; set; }
        [NotMapped]
        public string Reason { get; set; }
        [NotMapped]
        public string Description { get; set; }
        [NotMapped]
        public string serveDate { get; set; }
        [NotMapped]
        public string ppExpireDate { get; set; }
        [NotMapped]
        public string joiningDate { get; set; }
        [NotMapped]
        public string dateOfBirth { get; set; }
        [NotMapped]
        public string probationPeriodEndDate { get; set; }
        [NotMapped]
        public string confirmationDate { get; set; }
        //[NotMapped]
        //public string lastDayOffice { get; set; }
    }
}
