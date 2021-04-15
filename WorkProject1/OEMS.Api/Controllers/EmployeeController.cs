using Microsoft.AspNet.Identity;
using Newtonsoft.Json;

using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Company;
using OEMS.Models.Model.Attendance;

using OEMS.Models.Model.Employee;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Models.Model.Student;
using OEMS.Models.ViewModel;

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;

using System.Web;
using System.Web.Http;
//using System.Web.Mvc;
using static OEMS.Models.Constant.Enums;
using OEMS.Models.ViewModel.Employee;
using OEMS.Models.ViewModel.SetUp;

namespace OEMS.Api.Controllers
{
    public class EmployeeController : ApiController
    {
        #region employeeBasic
        [Route("Employee/GetEmployeeInfo/{EmpID}")]
        [HttpGet]
        public IHttpActionResult GetEmployeeInfo(int? EmpID)
        {
            if (EmpID == 0)
            {
                CommonResponse cr = new CommonResponse();
                try
                {
                    var userid = User.Identity.GetUserId();
                    var EmpId = DataAccess.Instance.Users.Filter(e => e.Id == userid).FirstOrDefault().EmpId;
                    cr.results = DataAccess.Instance.EmpBasicInfoService.GetEmployeeDetail(EmpId);
                }
                catch (Exception ex)
                {
                    return BadRequest(ex.Message);
                }
                return Json(cr);
            }
            else
            {
                CommonResponse cr = new CommonResponse();
                try
                {
                    cr.results = DataAccess.Instance.EmpBasicInfoService.GetEmployeeDetail(EmpID);
                }
                catch (Exception ex)
                {
                    return BadRequest(ex.Message);
                }
                return Json(cr);
            }

        }
        [Route("Employee/GetEmployeeById/{EmpId}")]
        [HttpGet]
        public IHttpActionResult GetEmployeeById(int EmpId)
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.EmpBasicInfoService.GetEmployeeDetail(EmpId);
            return Json(cr);
        }

        [Route("Employee/LockUser/")]
        [HttpPost]
        public IHttpActionResult LockUser(EmpBasicInfo emp, int StatusID)
        {
            EmpBasicInfo Emp1 = DataAccess.Instance.EmpBasicInfoService.Filter(x => x.EmpID == emp.EmpID).FirstOrDefault();

            //EmpStatus Status1 = DataAccess.Instance.EmpStatusService.Filter(x => x.StatusName == "Active").FirstOrDefault();
            //EmpStatus Status2 = DataAccess.Instance.EmpStatusService.Filter(x => x.StatusName == "InActive").FirstOrDefault();


            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            //if (Emp1.StatusID== Status1.StatusID)
            //{

            Emp1.StatusID = StatusID;
            var y = DataAccess.Instance.EmpBasicInfoService.Update(Emp1);
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSingleSearchEmpInfo", Emp1.EmpID);

            //}
            //else
            //{
            //    Emp1.StatusID = Status1.StatusID;
            //    cr.results = DataAccess.Instance.EmpBasicInfoService.Update(Emp1);
            //    dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSingleSearchEmpInfo", Emp1.EmpID);
            //}

            cr.results = dt;
            return Json(cr);
        }
        //Edit
        [Route("Employee/GetSingleEmployeeInfo/{EmpBasicInfoID}")]
        [HttpGet]
        public IHttpActionResult GetSingleEmployeeInfo(int EmpBasicInfoID)
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpBasicInfoID == EmpBasicInfoID).FirstOrDefault();
            return Json(cr);
        }
        [Route("Employee/UpdateEmployeeStatus/{EmpId}/{Stat}")]
        [HttpPut]
        public IHttpActionResult UpdateEmployeeStatus(string EmpId, string Stat)
        {
            var emp = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == EmpId).FirstOrDefault();
            if (Stat == "Active")
            {
                Stat = "A";
            }
            else
            {
                Stat = "D";
            }
            emp.Status = Stat;
            emp.SetDate();
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.EmpBasicInfoService.Update(emp);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }
        [Route("Employee/InactiveEmp/{EmpId}/{Stat}/{Remarks}")]
        [HttpPut]
        public IHttpActionResult InactiveEmp(int EmpId, string Stat, string Remarks)
        {
            var emp = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpBasicInfoID == EmpId).FirstOrDefault();
            emp.Status = Stat;
            emp.Remarks = Remarks;
            emp.SetDate();
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.EmpBasicInfoService.Update(emp);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }
        [Route("Employee/UpdateEmployee")]
        [HttpPut]
        public IHttpActionResult UpdateEmployee(EmpBasicInfo Emp)
        {
            Emp.UpdateBy = User.Identity.Name;
            Emp.SetDate();
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.EmpBasicInfoService.Update(Emp);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }
        [Route("Employee/SearchEmployee/{srhtext}")]
        [HttpGet]
        public IHttpActionResult SearchEmployee(string srhtext) //point 1: This method will Search Employee by Employee ID , name etc Information  by Evan
        {

            CommonResponse cr = new CommonResponse();
            // cr.results = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID.Contains(srhtext) || e.FullName.Contains(srhtext))
            //     .Select(e => new { Name = e.FullName + " (" + e.EmpID + ")", id = e.EmpBasicInfoID }).ToList();

            cr.results = DataAccess.Instance.EmpBasicInfoService.SearchEmployee(srhtext).ToList();
            return Json(cr);

        }
        [Route("Employee/SearchEmpFromASPNetUsers/{srhtext}")]
        [HttpGet]
        public IHttpActionResult SearchEmpFromASPNetUsers(string srhtext)
        {

            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.EmpBasicInfoService.SearchEmpFromASPNetUsers(srhtext).ToList();
            return Json(cr);

        }
        [Route("Employee/SearchAllEmployee/{srhtext}")]
        [HttpGet]
        public IHttpActionResult SearchAllEmployee(string srhtext) //point 1: This method will Search Employee by Employee ID , name etc Information  by Evan
        {

            CommonResponse cr = new CommonResponse();
            // cr.results = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID.Contains(srhtext) || e.FullName.Contains(srhtext))
            //     .Select(e => new { Name = e.FullName + " (" + e.EmpID + ")", id = e.EmpBasicInfoID }).ToList();

            cr.results = DataAccess.Instance.EmpBasicInfoService.SearchAllEmployee(srhtext).ToList();
            return Json(cr);

        }
        [Route("Employee/SearchTeacher/{srhtext}/{Type}")]
        [HttpGet]
        public IHttpActionResult SearchTeacher(string srhtext, int Type) //point 1: This method will Search Employee by Employee ID , name etc Information  by Evan
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.EmpBasicInfoService.SearchTeacher(srhtext, Type).ToList();
            return Json(cr);
        }
        [Route("Employee/EmployeeListForFeesReport/")]
        [HttpGet]
        public IHttpActionResult EmployeeList()
        {

            CommonResponse cr = new CommonResponse();
            // cr.results = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID.Contains(srhtext) || e.FullName.Contains(srhtext))
            //     .Select(e => new { Name = e.FullName + " (" + e.EmpID + ")", id = e.EmpBasicInfoID }).ToList();
            cr.results = DataAccess.Instance.CommonServices.ExecuteSQLQUERY("SELECT B.EmpBasicInfoID, U.FullName AS UserFullName FROM Emp_BasicInfo AS B INNER JOIN AspNetUsers AS U ON B.EmpBasicInfoID = U.EmpId");
            //cr.results = DataAccess.Instance.EmpBasicInfoService.Filter(e=>e.IsDeleted==false).ToList();
            return Json(cr);

        }
        public class xyz
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int PID { get; set; }
            public string Type { get; set; }
        }

        [Route("Employee/GetEmployeeInfo/")]
        [HttpPost]
        public IHttpActionResult GetEmployeeInfo(EmpBasicInfo Info)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            var param = new object[] {Info.EmpID, Info.BranchID,
                Info.DesignationID, Info.CategoryID, Info.StatusID, Info.ShiftID, Info.DepartmentID,
                Info.SubjectID, Info.SectionID, Info.IsClassTeacher,Info.DateOfBirth,Info.ConfirmationDate,Info.JoiningDate,Info.Status };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SearchEmpInfo", param);
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Employee/GetEmployeeList/")]
        [HttpGet]
        public IHttpActionResult GetEmployeeList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dt = new DataTable();

                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllEmpList");
                if (dt.Rows.Count > 0)
                {
                    cr.results = dt;
                    cr.message = dt.Rows.Count + " Data found";
                    cr.httpStatusCode = HttpStatusCode.OK;
                }
                else
                {
                    cr.message = "No Data Found";
                    cr.httpStatusCode = HttpStatusCode.OK;
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }

            return Json(cr);
        }


        [Route("Employee/GetEmployeeInfo/")]
        [HttpGet]
        public IHttpActionResult GetEmployeeInfos(EmpBasicInfo Info)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            var param = new object[] {Info.EmpID, Info.BranchID,
                Info.DesignationID, Info.CategoryID, Info.StatusID, Info.ShiftID, Info.DepartmentID,
                Info.SubjectID, Info.SectionID, Info.IsClassTeacher,Info.DateOfBirth,Info.ConfirmationDate,Info.JoiningDate,Info.Status };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SearchEmpInfo", param);
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Employee/GetEmployeeForSubjectMapping/{versionId}/{branchId}/{shiftId}")]
        [HttpGet]
        public IHttpActionResult GetEmployeeForSubjectMapping(int branchId, int shiftId)    // Using for MainExam Marks Entry page Subject Dropdown
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //var res = from t in DataAccess.Instance.EmpBasicInfoService.Filter(e => e.VersionID == versionID && e.BranchID == branchId && e.ShiftID == shiftId).ToList()
                //          select new { t.EmpBasicInfoID, TName = t.EmpID + " " + t.FullName };
                var res = from t in DataAccess.Instance.EmpBasicInfoService.Filter(e => e.IsDeleted == false).ToList()
                          select new { t.EmpBasicInfoID, TName = t.EmpID + " " + t.FullName };
                cr.results = res;
                cr.httpStatusCode = res.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res.Any() ? res.Any() + " Record have been found" : "Record not found";

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }

            return Json(cr);
        }
        //basicInfo Info
        [Route("Employee/GetEmployeeID/")]
        [HttpPost]
        public IHttpActionResult GetEmployeeID(EmpBasicInfo Info)
        {
            CommonResponse res = new CommonResponse();

            DateTime JoinDate = Convert.ToDateTime(Info.JoiningDate);
            int DesignationID = Info.DesignationID;

            var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpID", new object[] { DesignationID, JoinDate });

            return Json(result);

        }
        // Add by azmal
        [Route("Employee/GetEmpInfoByEmpBasicInfoID/{EmpBasicInfoID}")]
        [HttpGet]
        public IHttpActionResult GetEmpInfoByEmpBasicInfoID(int EmpBasicInfoID)
        {
            CommonResponse res = new CommonResponse();

            res.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpInfoByEmpBasicInfoID", new object[] { EmpBasicInfoID });

            return Json(res);

        }
        [Route("Employee/GetEmpInfoByEmpBasicInfoIDForHold/{EmpBasicInfoID}")]
        [HttpGet]
        public IHttpActionResult GetEmpInfoByEmpBasicInfoIDForHold(int EmpBasicInfoID)
        {
            CommonResponse res = new CommonResponse();

            res.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpInfoByEmpBasicInfoIDforHold", new object[] { EmpBasicInfoID });

            return Json(res);

        }
        // Add by azmal
        [Route("Employee/GetEmpInfoForResultPublish")]
        [HttpGet]
        public IHttpActionResult GetEmpInfoForResultPublish()
        {
            CommonResponse res = new CommonResponse();
            int EmpBasicInfoID = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);
            res.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpInfoByEmpBasicInfoID", new object[] { EmpBasicInfoID });

            return Json(res);

        }

        [Route("Employee/GetEmployeeID/{Id}")]
        [HttpGet]
        public IHttpActionResult GetEmployeeID(int Id)
        {
            CommonResponse res = new CommonResponse();
            res.results = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpBasicInfoID == Id);
            return Json(res);
        }
        //Empolyee Auto Ge ID  Khaled
        [Route("Employee/GetEmployeeAutoGenID")]
        [HttpGet]
        public IHttpActionResult GetEmployeeAutoGenID()
        {
            CommonResponse res = new CommonResponse();
            //var EmpAutoGenID = DataAccess.Instance.EmpBasicInfoService.GetAll().ToList().LastOrDefault().EmpID;
            var EmpAutoGenID = DataAccess.Instance.EmpBasicInfoService.GetAll().ToList().OrderByDescending(e => e.EmpBasicInfoID).Take(1).LastOrDefault().EmpID;

            if (DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == EmpAutoGenID).Any())
            {
                throw new Exception(" Employee Id Already Exist");
            }

            res.results = Convert.ToInt32(EmpAutoGenID) + 1;
            return Json(res);
        }
        //Add Employee
        [Route("Employee/AddEmployee/")]    ///  StudentAcademicInfo Add With Image , Kawsar Ahmed , 8-April-2017
        [HttpPost]
        public IHttpActionResult AddEmployee()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["Img"] : null;
                string value = HttpContext.Current.Request.Form["studentBasicInfo"] ?? "";
                if (string.IsNullOrEmpty(value))
                    return BadRequest("EmpBasic info is incorrect.");
                EmpBasicInfo EmpBasicInfo = JsonConvert.DeserializeObject<EmpBasicInfo>(value);

                if (string.IsNullOrEmpty(EmpBasicInfo.EmpID))
                {
                    throw new Exception(" Employee Id Not Valid");
                }
                if (DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == EmpBasicInfo.EmpID).Any())
                {
                    throw new Exception(" Employee Id Already Exist");
                }

                if (EmpBasicInfo.joiningDate.ToString() == "1/1/0001 12:00:00 AM")
                    throw new Exception("Joining Date have been not supplied");
                //if (EmpBasicInfo.RetirementDate.ToString() == "1/1/0001 12:00:00 AM")
                //{
                //    EmpBasicInfo.RetirementDate = null;
                //}

                //if (EmpBasicInfo.ProbationPeriodEndDate.ToString() == "1/1/0001 12:00:00 AM")
                //    throw new Exception("Probation Period End Date have been not supplied");
                //if (DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == EmpBasicInfo.EmpID).Any())
                //    throw new Exception("Employee Id Already Exist");


                if (EmpBasicInfo.dateOfBirth.ToString() == "1/1/0001 12:00:00 AM")
                    throw new Exception("DateOfBirth of Birth has been not supplied");
                EmpBasicInfo.DateOfBirth = Convert.ToDateTime(EmpBasicInfo.dateOfBirth);
                EmpBasicInfo.JoiningDate = Convert.ToDateTime(EmpBasicInfo.joiningDate);
                //EmpBasicInfo.PPExpireDate = EmpBasicInfo.PPExpireDate == null ? DateTime.Now : Convert.ToDateTime(EmpBasicInfo.ppExpireDate);
                //EmpBasicInfo.PPExpireDate = EmpBasicInfo.PPExpireDate;
                EmpBasicInfo.IsDeleted = false;
                EmpBasicInfo.AddBy = User.Identity.Name;
                EmpBasicInfo.Status = "A";
                EmpBasicInfo.SetDate();
                if (file != null)
                {
                    EmpBasicInfo.Image = APIUitility.ToByte(file);
                }
                else
                {
                    EmpBasicInfo.Image = APIUitility.ToByte(System.Web.Hosting.HostingEnvironment.MapPath(Constant.NoImage));
                }
                var res = DataAccess.Instance.EmpBasicInfoService.Add(EmpBasicInfo);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : "Failed! Something is worng please check and try again";
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        //Update
        [Route("Employee/UpdateEmployeeBasic/")]
        [HttpPut]
        public IHttpActionResult UpdateEmployeeBasic(EmpBasicInfo Info)
        {
            CommonResponse cr = new CommonResponse();

            //DateTime serveDate = Convert.ToDateTime(Info.serveDate);
            //DateTime ppExpireDate = Convert.ToDateTime(Info.ppExpireDate);
            DateTime joiningDate = Convert.ToDateTime(Info.joiningDate);
            DateTime dateOfBirth = Convert.ToDateTime(Info.dateOfBirth);
            //DateTime probationPeriodEndDate = Convert.ToDateTime(Info.probationPeriodEndDate);
            //DateTime confirmationDate = Convert.ToDateTime(Info.confirmationDate);


            var Empdata = DataAccess.Instance.EmpBasicInfoService.Get(Info.EmpBasicInfoID);
            Empdata.EmpID = Info.EmpID;
            if (Info.ppExpireDate != null)
            {
                Empdata.PPExpireDate = Convert.ToDateTime(Info.ppExpireDate);
            }
            if (Info.probationPeriodEndDate != null)
            {
                Empdata.ProbationPeriodEndDate = Convert.ToDateTime(Info.probationPeriodEndDate);
            }
            if (Info.confirmationDate != null)
            {
                Empdata.ConfirmationDate = Convert.ToDateTime(Info.confirmationDate);
            }
            if (Info.serveDate != null)
            {
                Empdata.ServeDate = Convert.ToDateTime(Info.serveDate);
            }
            //if (Info.lastDayOffice != null)
            //{
            //    Empdata.LastDayOffice = Convert.ToDateTime(Info.lastDayOffice);
            //}
            Empdata.FullName = Info.FullName;
            Empdata.DesignationID = Info.DesignationID;
            Empdata.IsClassTeacher = Info.IsClassTeacher;
            Empdata.TypeID = Info.TypeID;
            Empdata.SectionID = Info.SectionID;
            Empdata.BranchID = Info.BranchID;
            Empdata.ShiftID = Info.ShiftID;
            Empdata.DepartmentID = Info.DepartmentID;
            Empdata.SubjectID = Info.SubjectID;
            Empdata.CategoryID = Info.CategoryID;
            Empdata.TeamId = Info.TeamId;
            Empdata.JoiningDate = joiningDate;
            Empdata.StatusID = Info.StatusID;
            Empdata.FatherName = Info.FatherName;
            Empdata.MotherName = Info.MotherName;
            Empdata.Nationality = Info.Nationality;
            Empdata.Religion = Info.Religion;
            Empdata.BloodGroup = Info.BloodGroup;
            Empdata.NationalID = Info.NationalID;
            Empdata.DateOfBirth = dateOfBirth;
            Empdata.Contact = Info.Contact;
            Empdata.PresentAddress = Info.PresentAddress;
            Empdata.PresentPost = Info.PresentPost;
            Empdata.PresentThana = Info.PresentThana;
            Empdata.PresentDistrict = Info.PresentDistrict;
            Empdata.PermanentAddress = Info.PermanentAddress;
            Empdata.PermanentPost = Info.PermanentPost;
            Empdata.PermanentThana = Info.PermanentThana;
            Empdata.PermanentDistrict = Info.PermanentDistrict;
            Empdata.GovtSalaryGrade = Info.GovtSalaryGrade;
            Empdata.GovtAccount = Info.GovtAccount;
            Empdata.Gender = Info.Gender;
            Empdata.MaritalStatus = Info.MaritalStatus;
            Empdata.SpouseName = Info.SpouseName;
            Empdata.SpouseMobile = Info.SpouseMobile;
            Empdata.BirthCertificate = Info.BirthCertificate;
            Empdata.DrawbackMedicine = Info.DrawbackMedicine;
            Empdata.Child = Info.Child;
            Empdata.MobileNo = Info.MobileNo;
            Empdata.Email = Info.Email;
            Empdata.SMSNotificationNo = Info.SMSNotificationNo;
            Empdata.DeviceUserID = Info.DeviceUserID;
            Empdata.CardNo = Info.CardNo;
            Empdata.IsPermanent = Info.IsPermanent;
            Empdata.Accountname = Info.Accountname;
            Empdata.AccountType = Info.AccountType;
            Empdata.BankName = Info.BankName;
            Empdata.BranchName = Info.BranchName;
            Empdata.SalaryACNo = Info.SalaryACNo;
            Empdata.MPOIndexNo = Info.MPOIndexNo;
            Empdata.PassportNo = Info.PassportNo;
            Empdata.EmergencyContactName = Info.EmergencyContactName;
            Empdata.EmergencyContactRelation = Info.EmergencyContactRelation;
            Empdata.EmergencyContactAddress = Info.EmergencyContactAddress;
            Empdata.EmergencyTandTNo = Info.EmergencyTandTNo;
            Empdata.EmergencyContactNo = Info.EmergencyContactNo;
            Empdata.Accountname = Info.InstituteAccount;
            Empdata.ContactOfficeEmail = Info.ContactOfficeEmail;
            Empdata.ContactOtherEmail = Info.ContactOtherEmail;
            Empdata.ContactHomeNo = Info.ContactHomeNo;
            Empdata.ContactOfficeNo = Info.ContactOfficeNo;
            Empdata.DPSAcccountNo = Info.DPSAcccountNo;
            Empdata.eTIN = Info.eTIN;
            Empdata.InstituteGrade = Info.InstituteGrade;
            Empdata.PFAccountNo = Info.PFAccountNo;
            Empdata.ReportingPersonID = Info.ReportingPersonID;
            Empdata.ReportOrderNo = Info.ReportOrderNo;
            Empdata.SalaryGradeID = Info.SalaryGradeID;
            Empdata.ShortName = Info.ShortName;
            Empdata.RetirementDate = Info.RetirementDate;
            Empdata.BirthRegNo = Info.BirthRegNo;
            Empdata.DrivingLicenseNo = Info.DrivingLicenseNo;
            Empdata.OfficePhoneNo = Info.OfficePhoneNo;
            Empdata.HomePhoneNo = Info.HomePhoneNo;
            Empdata.PFACNo = Info.PFACNo;
            Empdata.PFBankName = Info.PFBankName;
            Empdata.PFBankBranch = Info.PFBankBranch;
            Empdata.WelfareACNo = Info.WelfareACNo;
            Empdata.MembershipNo = Info.MembershipNo;
            // Add by khaled 
            Empdata.IsResignationApplied = Info.IsResignationApplied;
            Empdata.SalaryPaymentMode = Info.SalaryPaymentMode;
            //Empdata.IsUnethicalExit = Info.IsUnethicalExit;
            //
            Empdata.TINNo = Info.TINNo;
            Empdata.JoiningSalary = Info.JoiningSalary;
            Empdata.ConfirmationSalary = Info.ConfirmationSalary;
            Empdata.CurrentSalary = Info.CurrentSalary;
            Empdata.LeaveTypeId = Info.LeaveTypeId;
            Empdata.IsDeleted = false;
            Empdata.UpdateBy = User.Identity.GetUserId();
            Empdata.SetDate();
            var res = DataAccess.Instance.EmpBasicInfoService.Update(Empdata);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
            return Json(cr);
        }

        [Route("Employee/GetStudentRequestList/")]
        [HttpGet]
        public IHttpActionResult GetStudentRequestList()
        {
            CommonResponse cr = new CommonResponse();
            var userid = User.Identity.GetUserId();
            var EmpId = DataAccess.Instance.Users.Filter(e => e.Id == userid).FirstOrDefault().EmpId;
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpStudentList", EmpId);
            cr.results = dt;
            return Json(cr);
        }


        #endregion employeeBasic
        #region Teacher




        #endregion Teacher
        #region EmployeeEdu
        [Route("Employee/AddEmployeeEdu/")]
        [HttpPut]
        public IHttpActionResult AddEmployeeEdu(EmployeeEducationalInfo Info)

        //point 1: This method will update Employee other Information by Evan
        {
            CommonResponse cr = new CommonResponse();
            var res = false;
            if (Info.EducationalInfo_ID > 0)
            {
                var Empdata = DataAccess.Instance.EmployeeEducationalInfoService.Get(Info.EducationalInfo_ID);
                Empdata.ExamBoard = Info.ExamBoard;
                Empdata.ExamInstituteName = Info.ExamInstituteName;
                Empdata.ExamPasYear = Info.ExamPasYear;
                Empdata.ExamTotal = Info.ExamTotal;
                Empdata.ExamName = Info.ExamName;
                Empdata.ExamGroupName = Info.ExamGroupName;
                Empdata.IsDeleted = false;
                Empdata.UpdateBy = User.Identity.GetUserId();
                Empdata.SetDate();
                res = DataAccess.Instance.EmployeeEducationalInfoService.Update(Empdata);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
            }
            else
            {
                Info.IsDeleted = false;
                Info.AddBy = User.Identity.GetUserId();
                Info.SetDate();
                res = DataAccess.Instance.EmployeeEducationalInfoService.Add(Info);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            return Json(cr);
        }
        #endregion EmployeeEdu
        #region EmployeeJOB
        [Route("Employee/AddEmployeeJob/")]
        [HttpPut]
        public IHttpActionResult AddEmployeeJob(EmpJobHistory JOB)
        {
            CommonResponse cr = new CommonResponse();
            var res = false;
            DateTime zeroTime = new DateTime(1, 1, 1);
            DateTime fromdate = Convert.ToDateTime(JOB.From);
            DateTime todate = Convert.ToDateTime(JOB.To);
            DateTime a = new DateTime(fromdate.Year, fromdate.Month, fromdate.Day);
            DateTime b = new DateTime(todate.Year, todate.Month, todate.Day);

            TimeSpan span = b - a;
            // Because we start at year 1 for the Gregorian
            // calendar, we must subtract a year here.
            int years = (zeroTime + span).Year - 1;
            int months = (zeroTime + span).Month - 1;
            int yearInMonth = years * 12;
            int days = (zeroTime + span).Day;
            if (JOB.EmpJobId > 0)
            {
                var Empdata = DataAccess.Instance.EmpJobHistoryService.Get(JOB.EmpJobId);
                Empdata.Companyname = JOB.Companyname;
                Empdata.Designation = JOB.Designation;
                Empdata.AreaOfExperiance = JOB.AreaOfExperiance;
                Empdata.From = JOB.From;
                Empdata.To = JOB.To;
                Empdata.YearOfExperiance = Convert.ToString(years + " year(s) " + months + " month(s) " + days + " day(s)");
                Empdata.IsDeleted = false;
                Empdata.UpdateBy = User.Identity.GetUserId();
                Empdata.SetDate();
                res = DataAccess.Instance.EmpJobHistoryService.Update(Empdata);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
            }
            else
            {
                JOB.IsDeleted = false;
                JOB.AddBy = User.Identity.GetUserId();
                //JOB.YearOfExperiance = Convert.ToString(years);
                JOB.YearOfExperiance = Convert.ToString(years + " year(s) " + months + " month(s) " + days + " day(s)");
                JOB.SetDate();
                res = DataAccess.Instance.EmpJobHistoryService.Add(JOB);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            return Json(cr);
        }
        #endregion EmployeeJoB
        #region EmpTraining
        [Route("Employee/AddEmpTraining/")]
        [HttpPut]
        public IHttpActionResult AddEmpTraining(EmpTraining empTraining)
        {
            CommonResponse cr = new CommonResponse();
            var res = false;
            if (empTraining.EmpTrainingID > 0)
            {
                var Empdata = DataAccess.Instance.EmpTrainingService.Get(empTraining.EmpTrainingID);
                Empdata.EmpTraining_IsContinued = empTraining.EmpTraining_IsContinued;
                Empdata.FromDate = empTraining.FromDate;
                Empdata.InstituteName = empTraining.InstituteName;
                Empdata.Title = empTraining.Title;
                Empdata.ToDate = empTraining.ToDate;
                Empdata.TrainingCountry = empTraining.TrainingCountry;
                Empdata.TrainingLocation = empTraining.TrainingLocation;
                Empdata.IsDeleted = false;
                Empdata.UpdateBy = User.Identity.GetUserId();
                Empdata.SetDate();
                res = DataAccess.Instance.EmpTrainingService.Update(Empdata);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
            }
            else
            {
                empTraining.IsDeleted = false;
                empTraining.AddBy = User.Identity.GetUserId();
                empTraining.SetDate();
                res = DataAccess.Instance.EmpTrainingService.Add(empTraining);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            return Json(cr);
        }
        #endregion EmpTraining
        #region EmpLeaveType
        [Route("Employee/GetAllEmpLeaveType/")]
        [HttpGet]
        public IHttpActionResult GetAllEmpLeaveType()
        {
            // Get All Version
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.EmpLeaveTypeService.Filter(e => e.IsDeleted == false).ToList();
            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.INVAILD_DATA);
            }

        }
        [Route("Employee/AddEmpLeaveType/")]
        [HttpPost]
        public IHttpActionResult AddEmpLeaveType(EmpLeaveType empLeaveType)
        {
            // Add Shift 
            CommonResponse cr = new CommonResponse();
            EmpLeaveType oEmpLeaveType = new EmpLeaveType();
            try
            {
                if (empLeaveType.EmpLeaveTypeId > 0)
                {
                    var empLeaveTypeinfo = DataAccess.Instance.EmpLeaveTypeService.Filter(e => e.IsDeleted == false && e.EmpLeaveTypeId != empLeaveType.EmpLeaveTypeId);

                    if (empLeaveTypeinfo.Where(e => e.TypeName == empLeaveType.TypeName).Any())
                    {
                        throw new Exception("Type Name Aleardy Exit");
                    }
                    if (empLeaveTypeinfo.Where(e => e.Code == empLeaveType.Code).Any())
                    {
                        throw new Exception("Type Code Aleardy Exit");
                    }
                    oEmpLeaveType.EmpLeaveTypeId = empLeaveType.EmpLeaveTypeId;
                    oEmpLeaveType.TypeName = empLeaveType.TypeName;
                    oEmpLeaveType.Code = empLeaveType.Code;
                    oEmpLeaveType.Remarks = empLeaveType.Remarks;

                    oEmpLeaveType.IsDeleted = false;
                    oEmpLeaveType.Status = "A";
                    oEmpLeaveType.UpdateBy = User.Identity.Name;
                    oEmpLeaveType.SetDate();

                    var res = DataAccess.Instance.EmpLeaveTypeService.Update(oEmpLeaveType);

                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                }
                else
                {
                    var empLeaveTypeinfo = DataAccess.Instance.EmpLeaveTypeService.Filter(e => e.IsDeleted == false);
                    if (empLeaveTypeinfo.Where(e => e.TypeName == empLeaveType.TypeName && e.Code == empLeaveType.Code).Any())
                    {
                        throw new Exception("TypeName Aleardy Exit");
                    }
                    if (empLeaveTypeinfo.Where(e => e.TypeName == empLeaveType.TypeName).Any())
                    {
                        throw new Exception("Type Name Aleardy Exit");
                    }
                    if (empLeaveTypeinfo.Where(e => e.Code == empLeaveType.Code).Any())
                    {
                        throw new Exception("Type Code Aleardy Exit");
                    }
                    oEmpLeaveType.EmpLeaveTypeId = empLeaveType.EmpLeaveTypeId;
                    oEmpLeaveType.TypeName = empLeaveType.TypeName;
                    oEmpLeaveType.Code = empLeaveType.Code;
                    oEmpLeaveType.Remarks = empLeaveType.Remarks;

                    oEmpLeaveType.IsDeleted = false;
                    oEmpLeaveType.Status = "A";
                    oEmpLeaveType.AddBy = User.Identity.Name;
                    oEmpLeaveType.SetDate();

                    var res = DataAccess.Instance.EmpLeaveTypeService.Add(oEmpLeaveType);

                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Employee/DeleteEmpLeaveType/")]
        [HttpPost]
        public IHttpActionResult DeleteEmpLeaveType(EmpLeaveType empLeaveType)
        {
            // Delete Version by VersionID
            CommonResponse cr = new CommonResponse();
            var res = false;
            try
            {
                if (DataAccess.Instance.EmpBasicInfoService.Filter(e => e.LeaveTypeId == empLeaveType.EmpLeaveTypeId && e.IsDeleted == false).Any())
                    throw new Exception("Leave Type use in Employee Info");

                res = DataAccess.Instance.EmpLeaveTypeService.Remove(empLeaveType.EmpLeaveTypeId);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion EmpLeaveType

        //Update
        [Route("Employee/UpdateAllOthers/")]
        [HttpPut]
        public IHttpActionResult UpdateAllOthers(EmpBasicInfo Info)  //point 1: This method will update Employee other Information by Evan
        {
            CommonResponse cr = new CommonResponse();
            var oldprofile = DataAccess.Instance.EmpBasicInfoService.Get(Info.EmpBasicInfoID);
            Info.AddBy = oldprofile.AddBy;
            Info.AddDate = oldprofile.AddDate;
            Info.UpdateBy = User.Identity.Name;
            Info.Image = oldprofile.Image;
            Info.Status = oldprofile.Status;
            Info.IsDeleted = false;
            Info.SetDate();
            var res = DataAccess.Instance.EmpBasicInfoService.Update(Info);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        [Route("Employee/AddEducationalInfo/")]
        [HttpPost]
        public IHttpActionResult AddEducationalInfo(List<EmployeeEducationalInfo> Info) //point 1: This method will Add Employee Education Information by Evan
        {
            CommonResponse cr = new CommonResponse();

            var res = DataAccess.Instance.EmployeeEducationalInfoService.AddRange(Info);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        [Route("Employee/GetExamName/")]
        [HttpGet]
        public IHttpActionResult GetExamName()  //point 1: This method will return Exam Name by Evan
        {
            CommonResponse res = new CommonResponse();

            var ExamNames = DataAccess.Instance.EmployeeExamService.GetAll();

            res.results = ExamNames;
            res.httpStatusCode = HttpStatusCode.OK;

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Employee/GetEmpExamGroup/")]
        [HttpGet]
        public IHttpActionResult GetEmpExamGroup()  //point 1: This method will return Emp Exam Group by Evan
        {
            CommonResponse res = new CommonResponse();

            var result = DataAccess.Instance.EmployeeExamGroupService.GetAll();

            res.results = result;
            res.httpStatusCode = HttpStatusCode.OK;

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Employee/GetEmpExamBoard/")]
        [HttpGet]
        public IHttpActionResult GetEmpExamBoard()  //point 1: This method will return Emp Exam board by Evan
        {
            CommonResponse res = new CommonResponse();

            var result = DataAccess.Instance.EmployeeExamBoardService.GetAll();

            res.results = result;
            res.httpStatusCode = HttpStatusCode.OK;

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }

        //Get Categories
        #region Categories
        [Route("Employee/GetCategories/")]
        [HttpGet]
        public IHttpActionResult GetCategories() //point 1: This method will return Emp category by Evan
        {
            CommonResponse res = new CommonResponse();
            res.results = DataAccess.Instance.EmpCategoryService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.CategoryID));
            return Json(res);
        }

        //Get All Categories
        [Route("Employee/GetAllCategories/")]
        [HttpGet]
        public IHttpActionResult GetAllCategories()  //point 1: This method will return Emp all category 
        {
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.EmpCategoryService.GetAll().Where(a => a.IsDeleted == false);
            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.INVAILD_DATA);
            }

        }

        //add categories
        [Route("Employee/AddCategory/")]
        [HttpPost]
        public IHttpActionResult AddCategory(EmpCategory category)  //point 1: This method will add Emp category 
        {
            CommonResponse cr = new CommonResponse();
            EmpCategory aCategory = new EmpCategory();
            aCategory.CategoryName = category.CategoryName;
            aCategory.CategoryIsTeacher = category.CategoryIsTeacher;

            aCategory.IsDeleted = false;
            aCategory.AddBy = User.Identity.Name;
            aCategory.Remarks = category.Remarks;
            aCategory.Status = "A";
            aCategory.SetDate();
            var res = DataAccess.Instance.EmpCategoryService.Add(aCategory);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }
        //update Categories
        [Route("Employee/UpdateCategory/")]
        [HttpPut]
        public IHttpActionResult UpdateCategory(EmpCategory category)  //point 1: This method will update Emp category 
        {
            CommonResponse cr = new CommonResponse();

            category.UpdateBy = User.Identity.Name;
            category.SetDate();

            var res = DataAccess.Instance.EmpCategoryService.Update(category);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }

        //Delete Categories
        [Route("Employee/DeleteCategory/{CategoryID}")]
        [HttpDelete]
        public IHttpActionResult DeleteCategory(int CategoryID)  //point 1: This method will delete Emp category
        {
            CommonResponse cr = new CommonResponse();
            EmpCategory EmpCategory = new EmpCategory();
            EmpCategory = DataAccess.Instance.EmpCategoryService.Get(CategoryID);
            EmpCategory.UpdateBy = User.Identity.Name;
            EmpCategory.SetDate();
            EmpCategory.IsDeleted = true;
            var res = DataAccess.Instance.EmpCategoryService.Update(EmpCategory);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }
        #endregion Categories

        //-----------------------------------------------------------------------------------//

        //Employee Designation crud Area by Abul Hasan
        [Route("Employee/GetDesignations/")]
        [HttpGet]
        public IHttpActionResult GetDesignations()  //point 1: This method will give Emp Designations
        {
            CommonResponse res = new CommonResponse();
            res.results = DataAccess.Instance.EmpDesignationtService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.DesignationID)).ToList();
            return Json(res);

        }

        //Add Designation
        [Route("Employee/AddDesignation/")]
        [HttpPost]
        public IHttpActionResult AddDesignation(EmpDesignation designation)  //point 1: This method will add Emp Designations
        {
            CommonResponse cr = new CommonResponse();
            EmpDesignation aDes = new EmpDesignation();
            try
            {

                var designationInfo = DataAccess.Instance.EmpDesignationtService.Filter(e => e.IsDeleted == false && e.DesignationID != designation.DesignationID);
                if (designationInfo.Where(le => le.DesignationOrder == designation.DesignationOrder && le.DesignationOrder > 0).Any())
                {
                    throw new Exception("Designation Order Aleardy Exists");
                }
                aDes.DesignationName = designation.DesignationName;
                aDes.DesignationOrder = designation.DesignationOrder;
                aDes.CategoryID = designation.CategoryID;
                aDes.IsDeleted = false;
                aDes.AddBy = User.Identity.Name;
                aDes.Remarks = designation.Remarks;
                aDes.Status = "A";
                aDes.SetDate();
                var res = DataAccess.Instance.EmpDesignationtService.Add(aDes);

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        //Update Designation
        [Route("Employee/UpdateDesignation/")]
        [HttpPut]
        public IHttpActionResult UpdateDesignation(EmpDesignation Designation)  //point 1: This method will update Emp Designations
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var designationInfo = DataAccess.Instance.EmpDesignationtService.Filter(e => e.IsDeleted == false && e.DesignationID != Designation.DesignationID);
                if (designationInfo.Where(le => le.DesignationOrder == Designation.DesignationOrder && le.DesignationOrder > 0).Any())
                {
                    throw new Exception("Designation Order Aleardy Exists");
                }
                Designation.UpdateBy = User.Identity.Name;
                Designation.SetDate();
                var res = DataAccess.Instance.EmpDesignationtService.Update(Designation);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        //Delete Designation
        [Route("Employee/DeleteDesignation/{DesignationID}")]
        [HttpDelete]
        public IHttpActionResult DeleteDesignation(int DesignationID)  //point 1: This method will Delete Emp Designations
        {
            CommonResponse cr = new CommonResponse();
            EmpDesignation Designation = new EmpDesignation();
            Designation = DataAccess.Instance.EmpDesignationtService.Get(DesignationID);
            Designation.UpdateBy = User.Identity.Name;
            Designation.IsDeleted = true;
            Designation.SetDate();
            var res = DataAccess.Instance.EmpDesignationtService.Update(Designation);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        //-----------------------------------------------------------------------------------//
        //Employee Subject crud Area by Abul Hasan
        [Route("Employee/GetSubjects/")]
        [HttpGet]
        public IHttpActionResult GetSubjects()  //point 1: This method will give  Emp Subject
        {
            CommonResponse res = new CommonResponse();
            res.results = DataAccess.Instance.EmpSubjectService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.SubjectID));
            return Json(res);
        }

        //Add Subject
        [Route("Employee/AddSubject/")]
        [HttpPost]
        public IHttpActionResult AddSubject(EmpSubject aSubject)  //point 1: This method will add  Emp Subject
        {
            CommonResponse cr = new CommonResponse();
            EmpSubject aDes = new EmpSubject();

            aDes.SubjectName = aSubject.SubjectName;
            aDes.IsDeleted = false;
            aDes.AddBy = User.Identity.Name;
            aDes.Remarks = aSubject.Remarks;
            aDes.Status = "A";
            aDes.SetDate();
            var res = DataAccess.Instance.EmpSubjectService.Add(aDes);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        //Update Subject
        [Route("Employee/UpdateSubject/")]
        [HttpPut]
        public IHttpActionResult UpdateSubject(EmpSubject aSubject) //point 1: This method will update  Emp Subject
        {
            CommonResponse cr = new CommonResponse();
            aSubject.UpdateBy = User.Identity.Name;
            aSubject.SetDate();
            var res = DataAccess.Instance.EmpSubjectService.Update(aSubject);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }

        //Delete Subject
        [Route("Employee/DeleteSubject/{SubjectID}")]
        [HttpDelete]
        public IHttpActionResult DeleteSubject(int SubjectID)   //point 1: This method will Delete  Emp Subject
        {
            CommonResponse cr = new CommonResponse();
            EmpSubject Asub = new EmpSubject();

            Asub = DataAccess.Instance.EmpSubjectService.Get(SubjectID);

            Asub.UpdateBy = User.Identity.Name;
            Asub.IsDeleted = true;
            Asub.SetDate();
            var res = DataAccess.Instance.EmpSubjectService.Update(Asub);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        //-----------------------------------------------------------------------------------//

        //Employee department crud Area by Abul Hasan
        [Route("Employee/GetDepartments/")]
        [HttpGet]
        public IHttpActionResult GetDepartments()  //point 1: This method will give  Emp Department
        {
            CommonResponse res = new CommonResponse();
            res.results = DataAccess.Instance.EmpDepartmentService.Filter(e => e.IsDeleted == false).OrderByDescending(d => d.DepartmentID);
            return Json(res);
        }

        //Add Subject
        [Route("Employee/AddDepartment/")]
        [HttpPost]
        public IHttpActionResult AddDepartment(EmpDepartment aDepartment)  //point 1: This method will add  Emp Department
        {
            CommonResponse cr = new CommonResponse();
            EmpDepartment aDes = new EmpDepartment();
            try
            {
                var Empinfo = DataAccess.Instance.EmpDepartmentService.Filter(e => e.IsDeleted == false);
                if (Empinfo.Where(e => e.DepartmentName == aDepartment.DepartmentName).Any())
                {
                    throw new Exception("Department Name  Aleardy Exit");
                }
                aDes.DepartmentName = aDepartment.DepartmentName;
                aDes.DisOrder = aDepartment.DisOrder;
                aDes.IsDeleted = false;
                aDes.AddBy = User.Identity.Name;
                aDes.Remarks = aDepartment.Remarks;
                aDes.Status = "A";
                aDes.SetDate();
                var res = DataAccess.Instance.EmpDepartmentService.Add(aDes);

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        //Update Subject
        [Route("Employee/UpdateDepartment/")]
        [HttpPut]
        public IHttpActionResult UpdateDepartment(EmpDepartment aDepartment)  //point 1: This method will Update  Emp Department
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var Empinfo = DataAccess.Instance.EmpDepartmentService.Filter(e => e.IsDeleted == false && e.DepartmentID != aDepartment.DepartmentID);
                if (Empinfo.Where(e => e.DepartmentName == aDepartment.DepartmentName).Any())
                {
                    throw new Exception("Department Name  Aleardy Exit");
                }
                if (Empinfo.Where(e => e.DisOrder == aDepartment.DisOrder).Any())
                {
                    throw new Exception("Display Order Aleardy Exit");
                }
                aDepartment.UpdateBy = User.Identity.Name;
                aDepartment.SetDate();
                var res = DataAccess.Instance.EmpDepartmentService.Update(aDepartment);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cr);
        }

        //Delete Subject
        [Route("Employee/DeleteDepartment/{DepartmentID}")]
        [HttpDelete]
        public IHttpActionResult DeleteDepartment(int DepartmentID) //point 1: This method will Delete  Emp Department
        {
            CommonResponse cr = new CommonResponse();
            EmpDepartment Adep = new EmpDepartment();
            Adep = DataAccess.Instance.EmpDepartmentService.Get(DepartmentID);
            Adep.UpdateBy = User.Identity.Name;
            Adep.IsDeleted = true;
            Adep.SetDate();
            var res = DataAccess.Instance.EmpDepartmentService.Update(Adep);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        //-----------------------------------------------------------------------------------//

        //Employee Status crud Area by Abul Hasan
        [Route("Employee/GetStatus/")]
        [HttpGet]
        public IHttpActionResult GetStatus() //point 1: This method will give   Emp Status
        {
            CommonResponse res = new CommonResponse();
            res.results = DataAccess.Instance.EmpStatusService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.StatusID));
            return Json(res);
        }

        //Add Subject
        [Route("Employee/AddStatus/")]
        [HttpPost]
        public IHttpActionResult AddStatus(EmpStatus aEmpStatus)  //point 1: This method will add   Emp Status
        {
            CommonResponse cr = new CommonResponse();
            EmpStatus aDes = new EmpStatus();

            aDes.StatusName = aEmpStatus.StatusName;

            aDes.IsDeleted = false;
            aDes.AddBy = User.Identity.Name;
            aDes.Remarks = aEmpStatus.Remarks;
            aDes.Status = "A";
            aDes.SetDate();
            var res = DataAccess.Instance.EmpStatusService.Add(aDes);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }

        //Update Subject
        [Route("Employee/UpdateStatus/")]
        [HttpPut]
        public IHttpActionResult UpdateStatus(EmpStatus aEmpStatus)  //point 1: This method will update   Emp Status
        {
            CommonResponse cr = new CommonResponse();
            aEmpStatus.UpdateBy = User.Identity.Name;
            aEmpStatus.SetDate();
            var res = DataAccess.Instance.EmpStatusService.Update(aEmpStatus);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }
        //Delete Subject
        [Route("Employee/DeleteStatus/{StatusID}")]
        [HttpDelete]
        public IHttpActionResult DeleteStatus(int StatusID)   //point 1: This method will Delete Emp Status
        {
            CommonResponse cr = new CommonResponse();
            EmpStatus Adep = new EmpStatus();

            Adep = DataAccess.Instance.EmpStatusService.Get(StatusID);
            Adep.UpdateBy = User.Identity.Name;
            Adep.IsDeleted = true;
            Adep.SetDate();
            var res = DataAccess.Instance.EmpStatusService.Update(Adep);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }





        [Route("Employee/GetTeacher/")]
        [HttpGet]
        public IHttpActionResult GetTeacher()   //Get Teacher 
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.CategoryID == 1);
            return Json(cr);
        }


        [Route("Employee/AddClassTeacherSetup/")]
        [HttpPost]
        public IHttpActionResult AddClassTeacherSetup(ClassTeacher aClassTeacher)  //Add Class Teacher
        {
            CommonResponse cr = new CommonResponse();

            bool res = false;
            try
            {
                if (aClassTeacher.ID == 0)
                {
                    if (DataAccess.Instance.CommonServices.IsExist("Emp_ClassTeacher", " SessionId=" + aClassTeacher.SessionId + " AND BranchId=" + aClassTeacher.BranchId + " AND ShiftId=" + aClassTeacher.ShiftId + " AND ClassId=" + aClassTeacher.ClassId + " AND SectionId=" + aClassTeacher.SectionId + " AND IsDeleted=" + 0))
                    {
                        throw new Exception("Session,Branch,Shift,Class and Section Already Exist");
                    }
                    if (aClassTeacher.TeacherId == 0)
                    {
                        throw new Exception("Please Select Employee.");
                    }

                    aClassTeacher.IsDeleted = false;
                    aClassTeacher.AddBy = User.Identity.Name;
                    aClassTeacher.Status = "A";
                    aClassTeacher.SetDate();

                    res = DataAccess.Instance.aClassTeacherService.Add(aClassTeacher);

                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }

                else
                {

                    aClassTeacher.UpdateBy = User.Identity.Name;
                    aClassTeacher.SetDate();
                    res = DataAccess.Instance.aClassTeacherService.Update(aClassTeacher);
                    cr.message = Constant.UPDATED;
                    cr.httpStatusCode = HttpStatusCode.OK;
                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }



        [Route("Employee/getClassTeacherSetupInfo/")]
        [HttpGet]
        public IHttpActionResult getClassTeacherSetupInfo()   //Get Teacher 
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.CommonServices.GetBySpWithParam("getClassTeacher", new object[] { 1, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value });
            cr.results = res;
            if (res.Rows.Count > 0)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = res.Rows.Count + " Record Found";
            }
            else
                cr.message = Constant.NOT_FOUND;
            return Json(cr);
        }


        [Route("Employee/SearchClassTeacherSetupInfo/")]
        [HttpPost]
        public IHttpActionResult SearchClassTeacherSetupInfo(ClassTeacher fill)   //Get Teacher by filter
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.CommonServices.GetBySpWithParam("getClassTeacher", new object[] { 2, fill.SessionId, fill.BranchId, fill.ShiftId, fill.ClassId, fill.SectionId });
            cr.results = res;
            if (res.Rows.Count > 0)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = res.Rows.Count + " Record Found";
            }
            else
                cr.message = Constant.NOT_FOUND;
            return Json(cr);
        }


        [Route("Employee/deleteClassTeacherSetup/{id}")]
        [HttpDelete]
        public IHttpActionResult deleteClassTeacherSetup(int id)
        {
            CommonResponse cr = new CommonResponse();
            bool results = DataAccess.Instance.aClassTeacherService.Remove(id);
            if (results)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.DELETED;
            }
            else
                return BadRequest();
            return Json(cr);
        }


        // Get Employee basic Info
        [Route("Employee/GetEmpInfo/")]
        [HttpGet]
        public IHttpActionResult GetEmpInfo()  //point 1: This method will give  Single Employee by id  by Biplob
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var empId = User.Identity.GetUserId();
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpInfoData", new object[] { empId });
                //var Stu = CommonRepository.ConvertDataTable<EmpBasicInfo>(dt).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);

        }

        // Get Employee basic Info for admin view
        [Route("Employee/GetEmpInfoForView/{EmpId}")]
        [HttpGet]
        public IHttpActionResult GetEmpInfoView(string EmpId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpInfoViewData", new object[] { EmpId });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);

        }

        [Route("Employee/ProfileImageUpdate/")]
        [HttpPost]
        public IHttpActionResult ProfileImageUpdate()
        {
            CommonResponse cr = new CommonResponse();

            var file = HttpContext.Current.Request.Files[0].InputStream;
            var EmpId = HttpContext.Current.Request["EmpId"];
            int EmpID = Convert.ToInt32(EmpId);
            var emp = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpBasicInfoID == EmpID).FirstOrDefault();
            if (emp != null)
            {
                Stream fs = file;
                BinaryReader br = new BinaryReader(fs);
                byte[] bytes = br.ReadBytes((Int32)fs.Length);
                emp.Image = bytes;
                var res = DataAccess.Instance.EmpBasicInfoService.Update(emp);
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                //cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
                return Json(cr);
            }
            //var f=RequestContext.fi
            cr.httpStatusCode = HttpStatusCode.BadRequest;
            return Json(cr);
        }

        [Route("Employee/EmployeeDocument/")]
        [HttpPost]
        public IHttpActionResult EmployeeDocument()
        {
            CommonResponse cr = new CommonResponse();
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["pdf"] : null;
            string value = HttpContext.Current.Request.Form["EmployeeDocument"] ?? ""; // Get form data
            if (string.IsNullOrEmpty(value))
                return BadRequest("Student info is incorrect.");
            EmpDocumentArchive empDocumentArchive = JsonConvert.DeserializeObject<EmpDocumentArchive>(value); // DeSerialize form data
            var res = false;

            if (empDocumentArchive.EmpDocumentID > 0)
            {
                if (file != null)
                {
                    empDocumentArchive.File = APIUitility.ToByte(file);
                }

                var Empdata = DataAccess.Instance.EmpDocumentArchiveService.Get(empDocumentArchive.EmpDocumentID);
                Empdata.DocumentName = empDocumentArchive.DocumentName;
                //Empdata.IsDeleted = false;
                Empdata.UpdateBy = User.Identity.GetUserId();
                Empdata.SetDate();
                res = DataAccess.Instance.EmpDocumentArchiveService.Update(Empdata);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
            }
            else
            {
                if (file != null)
                {
                    empDocumentArchive.File = APIUitility.ToByte(file);
                }
                else
                {
                    empDocumentArchive.File = APIUitility.ToByte(System.Web.Hosting.HostingEnvironment.MapPath(Constant.NOT_FOUND));
                }
                empDocumentArchive.IsDeleted = false;
                empDocumentArchive.AddBy = User.Identity.GetUserId();
                empDocumentArchive.SetDate();
                res = DataAccess.Instance.EmpDocumentArchiveService.Add(empDocumentArchive);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            return Json(cr);
        }
        [Route("Employee/EmployeeNominee/")]
        [HttpPost]
        public IHttpActionResult EmployeeNominee()
        {
            CommonResponse cr = new CommonResponse();
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["Img"] : null;
            string value = HttpContext.Current.Request.Form["EmployeeNominee"] ?? ""; // Get form data
            if (string.IsNullOrEmpty(value))
                return BadRequest("Student info is incorrect.");
            EmpNominee empNominee = JsonConvert.DeserializeObject<EmpNominee>(value); // DeSerialize form data
            var res = false;

            if (empNominee.EmpNomineeID > 0)
            {
                if (file != null)
                {
                    empNominee.Picture = APIUitility.ToByte(file);
                }
                var Empdata = DataAccess.Instance.EmpNomineeService.Get(empNominee.EmpNomineeID);
                Empdata.NomineeName = empNominee.NomineeName;
                Empdata.DOB = empNominee.DOB;
                Empdata.FathersName = empNominee.FathersName;
                Empdata.MothersName = empNominee.MothersName;
                Empdata.SpouseName = empNominee.SpouseName;
                Empdata.PresentAddress = empNominee.PresentAddress;
                Empdata.PermanentAddress = empNominee.PermanentAddress;
                Empdata.Relation = empNominee.Relation;
                Empdata.NationalID = empNominee.NationalID;
                Empdata.IsDeleted = false;
                Empdata.UpdateBy = User.Identity.GetUserId();
                Empdata.SetDate();
                res = DataAccess.Instance.EmpNomineeService.Update(Empdata);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
            }
            else
            {
                if (file != null)
                {
                    empNominee.Picture = APIUitility.ToByte(file);
                }
                else
                {
                    empNominee.Picture = APIUitility.ToByte(System.Web.Hosting.HostingEnvironment.MapPath(Constant.NoImage));
                }
                empNominee.IsDeleted = false;
                empNominee.AddBy = User.Identity.GetUserId();
                empNominee.SetDate();
                res = DataAccess.Instance.EmpNomineeService.Add(empNominee);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            return Json(cr);
        }
        [Route("Employee/DeleteEmployee/")]
        [HttpPut]
        public IHttpActionResult DeleteEmployee(EmpNominee empNominee)
        {
            CommonResponse cr = new CommonResponse();
            var res = false;
            try
            {
                res = DataAccess.Instance.EmpNomineeService.Remove(empNominee.EmpNomineeID);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Employee/EmployeeDisplayOrderChange/")]
        [HttpPut]
        public IHttpActionResult EmployeeDisplayOrder(int EmpId, int EmpOrder)
        {
            CommonResponse cr = new CommonResponse();
            var emp = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.DisOrder == EmpOrder).ToList();
            if (emp.Count == 0)
            {
                try
                {
                    var empupdate = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpBasicInfoID == EmpId).FirstOrDefault();
                    empupdate.DisOrder = EmpOrder;
                    var res = DataAccess.Instance.EmpBasicInfoService.Update(empupdate);
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    return Json(cr);
                }
                catch (Exception ex)
                {
                    return BadRequest(ex.Message);
                }
            }
            else
            {
                if (emp[0].DisOrder == 0)
                {
                    try
                    {
                        var empupdate = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpBasicInfoID == EmpId).FirstOrDefault();
                        empupdate.DisOrder = EmpOrder;
                        var res = DataAccess.Instance.EmpBasicInfoService.Update(empupdate);
                        cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                        cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                        return Json(cr);
                    }
                    catch (Exception ex)
                    {
                        return BadRequest(ex.Message);
                    }
                }
                else
                {
                    return BadRequest("Order already assigned");
                }
            }

        }


        #region Add Salary Grade by......... sorowar

        [Route("Employee/AddSalaryGrade/")]
        [HttpPost]
        public IHttpActionResult AddSalaryGrade(SalaryGrade empSalary)
        {

            CommonResponse cmr = new CommonResponse();


            try
            {
                List<SalaryGrade> list = DataAccess.Instance.SalaryGradeService.Filter(s => s.IsDeleted == false && s.Status == "A").ToList();
                if (list.Any(s => s.Code == empSalary.Code))
                {
                    throw new Exception(empSalary.Code + " Code is Already Exists.");
                }

                if (empSalary != null || empSalary.SalaryGradeId == 0)
                {
                    empSalary.Status = "A";
                    empSalary.IsDeleted = false;
                    empSalary.AddBy = User.Identity.Name;
                    empSalary.AddDate = DateTime.Now;
                    empSalary.SetDate();
                    var res = DataAccess.Instance.SalaryGradeService.Add(empSalary);
                    cmr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                }



            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);

        }


        [Route("Employee/GetSalaryGrade/")]
        [HttpGet]

        public IHttpActionResult GetSalaryGrade()
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                List<SalaryGrade> list = DataAccess.Instance.SalaryGradeService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.SalaryGradeId)).ToList();
                if (list.Count() > 0)
                {
                    cmr.results = list;
                }
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }


        }


        [Route("Employee/DeleteSalaryGrade/{gradeId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryGrade(int gradeId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {


                SalaryGrade EmpSalaryGrade = new SalaryGrade();
                EmpSalaryGrade = DataAccess.Instance.SalaryGradeService.Get(gradeId);
                EmpSalaryGrade.UpdateBy = User.Identity.Name;
                EmpSalaryGrade.IsDeleted = true;
                EmpSalaryGrade.SetDate();

                var resp = DataAccess.Instance.SalaryGradeService.Update(EmpSalaryGrade);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }


        [Route("Employee/UpdateSalaryGrade/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryGrade(SalaryGrade empSalary)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                List<SalaryGrade> list = DataAccess.Instance.SalaryGradeService.Filter(s => s.IsDeleted == false && s.Status == "A" && s.Code != empSalary.Code).ToList();
                if (list.Any(s => s.Code == empSalary.Code))
                {
                    throw new Exception(empSalary.Code + " Code is Already Exists.");
                }
                if (empSalary.SalaryGradeId != 0)
                {
                    empSalary.UpdateBy = User.Identity.Name;
                    empSalary.UpdateDate = DateTime.Now;
                    var res = DataAccess.Instance.SalaryGradeService.Update(empSalary);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        #endregion

        #region Leave Quota by ...sorowar

        [Route("Employee/AddLeaveQuota/")]
        [HttpPost]
        public IHttpActionResult AddLeaveQuota(LeaveQuota leaveQuota)
        {

            CommonResponse cmr = new CommonResponse();
            LeaveQuota lq = new LeaveQuota();
            try
            {
                var exist = DataAccess.Instance.LeaveQuotaService.Filter(id => id.LeaveTypeId == leaveQuota.LeaveTypeId && id.LeaveCatgoryId == leaveQuota.LeaveCatgoryId && id.IsDeleted == false).Count();
                if (exist <= 0)
                {
                    lq.AddBy = User.Identity.Name;
                    lq.LeaveTypeId = leaveQuota.LeaveTypeId;
                    lq.LeaveCatgoryId = leaveQuota.LeaveCatgoryId;
                    lq.NoOfDay = leaveQuota.NoOfDay;
                    lq.IsCarryForward = leaveQuota.IsCarryForward;
                    lq.IsDeleted = false;

                    lq.SetDate();
                    var response = DataAccess.Instance.LeaveQuotaService.Add(lq);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }

                else
                {
                    throw new Exception("Leave Quota already Exist..!");
                }

            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);

        }

        [Route("Employee/GetAllLeaveQuota/")]
        [HttpGet]

        public IHttpActionResult GetAllLeaveQuota()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllLeaveQuota", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("Employee/DeleteLeaveQuota/{quotaId}")]
        [HttpDelete]

        public IHttpActionResult DeleteLeaveQuota(int quotaId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                LeaveQuota leaveQuota = new LeaveQuota();
                leaveQuota = DataAccess.Instance.LeaveQuotaService.Get(quotaId);
                leaveQuota.UpdateBy = User.Identity.Name;
                leaveQuota.IsDeleted = true;
                leaveQuota.SetDate();

                var resp = DataAccess.Instance.LeaveQuotaService.Update(leaveQuota);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [Route("Employee/UpdateLeaveQuota/")]
        [HttpPut]

        public IHttpActionResult UpdateLeaveQuota(LeaveQuota leaveQuota)
        {
            CommonResponse cmr = new CommonResponse();
            var exist = DataAccess.Instance.LeaveQuotaService.Filter(id => id.LeaveTypeId == leaveQuota.LeaveTypeId && id.LeaveCatgoryId == leaveQuota.LeaveCatgoryId && id.IsDeleted == false).Count();

            if (exist <= 0)
            {
                try
                {
                    var quotaInfo = DataAccess.Instance.LeaveQuotaService.Filter(e => e.IsDeleted == false && e.LeaveQuotaId == leaveQuota.LeaveQuotaId).FirstOrDefault();
                    quotaInfo.LeaveTypeId = leaveQuota.LeaveTypeId;
                    quotaInfo.UpdateBy = User.Identity.Name;
                    quotaInfo.SetDate();
                    quotaInfo.LeaveCatgoryId = leaveQuota.LeaveCatgoryId;
                    quotaInfo.NoOfDay = leaveQuota.NoOfDay;
                    quotaInfo.IsCarryForward = leaveQuota.IsCarryForward;
                    var res = DataAccess.Instance.LeaveQuotaService.Update(quotaInfo);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
                catch (Exception ex)
                {
                    return BadRequest(ex.Message);
                }
            }
            else
            {
                cmr.httpStatusCode = HttpStatusCode.UseProxy;
                cmr.message = Constant.DATA_EXISTS;
            }

            return Json(cmr);
        }

        [Route("Employee/GetEmpLeaveQuotaList/")]
        [HttpPost]
        public IHttpActionResult GetEmpRosterList(EmpLeaveQuotaVM empLeaveQuota)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                LeaveQuota _leaveQuota = new LeaveQuota();
                _leaveQuota.SetDate();
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@BranchId", empLeaveQuota.BranchId));
                param.Add(new SqlParameter("@DepartmentId", empLeaveQuota.DepartmentId));
                param.Add(new SqlParameter("@CalenderId", empLeaveQuota.CalenderId));
                param.Add(new SqlParameter("@DesignationId", empLeaveQuota.DesignationId));
                param.Add(new SqlParameter("@Addby", User.Identity.Name));
                param.Add(new SqlParameter("@IP", _leaveQuota.IP));
                param.Add(new SqlParameter("@MacAddress", _leaveQuota.MacAddress));
                DataTable res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeLeaveQoutaList", param.ToArray());
                if (res.Rows.Count > 0)
                {
                    cr.results = res;

                }
                else
                {
                    throw new Exception("Please Calendar Setup");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Employee/AddEmpLeaveQuota/")]
        [HttpPost]
        public IHttpActionResult AddEmpLeaveQuota(List<EmpLeaveQuotaVM> empLeaveQuotalist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                //if (empLeaveQuotalist.Count > 0)
                //{
                EmpLeaveQuota _entity = new EmpLeaveQuota();
                _entity.SetDate();
                DataTable dt;

                foreach (var item in empLeaveQuotalist)
                {
                    List<SqlParameter> param = new List<SqlParameter>();

                    param.Add(new SqlParameter("@EmpLeaveQuotaId", item.EmpLeaveQuotaId));
                    param.Add(new SqlParameter("@AnnualLeaveDay", item.AnnualLeaveDay));
                    param.Add(new SqlParameter("@SickLeaveDay", item.SickLeaveDay));
                    param.Add(new SqlParameter("@AdvanceLeaveDay", item.AdvanceLeaveDay));
                    param.Add(new SqlParameter("@MaternityLeaveDay", item.MaternityLeaveDay));
                    param.Add(new SqlParameter("@RoutingId", item.RoutingId));
                    param.Add(new SqlParameter("@AddBy", User.Identity.Name));
                    param.Add(new SqlParameter("@BranchId", item.BranchId));
                    param.Add(new SqlParameter("@DeptId", item.DepartmentId));
                    param.Add(new SqlParameter("@DesignationId",item.DesignationId));
                    param.Add(new SqlParameter("@CalendarId", item.CalenderId));                    
                    param.Add(new SqlParameter("@EmpBasicInfoID", item.EmpBasicInfoID));
                    param.Add(new SqlParameter("@IP", _entity.IP));
                    param.Add(new SqlParameter("@MacAddress", _entity.MacAddress));

                    dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertEmployeeLeaveQouta", param.ToArray());



                    if (dt.Rows.Count > 0)
                    {
                        cr.message = Constant.SAVED;
                    }

                }
                //}
                //else
                //{
                //    return BadRequest("At Least One Select!");
                //}


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        #endregion

        #region Salary Tax Year by.........sorowar

        [Route("Employee/AddSalaryTaxYear/")]
        [HttpPost]
        public IHttpActionResult AddSalaryTaxYear(SalaryTaxYear salaryTaxYear)
        {
            CommonResponse cmr = new CommonResponse();
            SalaryTaxYear sTax = new SalaryTaxYear();

            try
            {
                var exist = DataAccess.Instance.SalaryTaxYearService.Filter(id => id.YearName == salaryTaxYear.YearName && id.IsDeleted == false).Count();
                if (exist <= 0)
                {
                    sTax.AddBy = User.Identity.Name;
                    sTax.Status = "A";
                    sTax.YearName = salaryTaxYear.YearName;
                    sTax.FromDate = Convert.ToDateTime(salaryTaxYear.fromDate);
                    sTax.ToDate = Convert.ToDateTime(salaryTaxYear.toDate);
                    sTax.IsDeleted = false;
                    //   sTax.SetDate();
                    sTax.AddDate = DateTime.Now;
                    var response = DataAccess.Instance.SalaryTaxYearService.Add(sTax);
                    var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertSalaryTaxYearIdOnEmpTaxSetup", new object[] { });
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;

                }

                else
                {
                    throw new Exception("Salary Tax already Exist..!");
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);

        }

        //Add by Khaled
        [Route("Employee/GetAllSalaryTaxYear/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryTaxYear()
        {
            CommonResponse cmr = new CommonResponse();
            cmr.results = DataAccess.Instance.SalaryTaxYearService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.Id)).ToList();
            return Json(cmr);
        }


        [Route("Employee/DeleteSalaryTaxYear/{taxId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryTaxYear(int taxId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var SalaryPeriod = DataAccess.Instance.SalaryPeriodService.Filter(st => st.IsDeleted == false && st.Status == "A" && st.SalaryTaxYearId == taxId).ToList();
                if (SalaryPeriod.Any())
                {
                    throw new Exception("Tax Year Already Exist. in Salary Period!");
                }
                SalaryTaxYear salaryTaxYear = new SalaryTaxYear();
                salaryTaxYear = DataAccess.Instance.SalaryTaxYearService.Get(taxId);
                salaryTaxYear.UpdateBy = User.Identity.Name;
                salaryTaxYear.IsDeleted = true;
                // salaryTaxYear.SetDate();

                var resp = DataAccess.Instance.SalaryTaxYearService.Update(salaryTaxYear);
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("DeleteTaxYearIdOnTaxConfig", new object[] { taxId });
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }


        [Route("Employee/UpdateSalaryTaxYear/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryTaxYear(SalaryTaxYear salaryTaxYear)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.SalaryTaxYearService.Filter(st => st.IsDeleted == false && st.Status == "A" && st.Id != salaryTaxYear.Id).ToList();
                if (list.Any(s => s.YearName == salaryTaxYear.YearName))
                {
                    throw new Exception("Year Name Already Exist.");
                }



                var SalaryPeriod = DataAccess.Instance.SalaryPeriodService.Filter(st => st.IsDeleted == false && st.Status == "A" && st.SalaryTaxYearId == salaryTaxYear.Id).ToList();
                if (SalaryPeriod.Any())
                {
                    throw new Exception("Tax Year Already Exist. in Salary Period!");
                }
                if (salaryTaxYear.Id != 0)
                {
                    salaryTaxYear.UpdateBy = User.Identity.Name;
                    salaryTaxYear.UpdateDate = DateTime.Now;

                    var res = DataAccess.Instance.SalaryTaxYearService.Update(salaryTaxYear);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        #endregion

        #region Salary Year add by.........Azmal

        [Route("Employee/AddSalaryYear/")]
        [HttpPost]
        public IHttpActionResult AddSalaryYear(SalaryYear salaryYear)
        {
            CommonResponse cmr = new CommonResponse();
            SalaryYear Year = new SalaryYear();

            try
            {

                var exist = DataAccess.Instance.SalaryYearService.Filter(id => id.YearName == salaryYear.YearName && id.IsDeleted == false).Count();
                if (exist <= 0)
                {

                    Year.AddBy = User.Identity.Name;
                    Year.Status = "A";
                    Year.YearName = salaryYear.YearName;
                    Year.FromDate = Convert.ToDateTime(salaryYear.fromDate);
                    Year.ToDate = Convert.ToDateTime(salaryYear.toDate);
                    Year.IsDeleted = false;
                    // Year.SetDate();
                    Year.AddDate = DateTime.Now;
                    var response = DataAccess.Instance.SalaryYearService.Add(Year);
                    // var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertSalaryTaxYearIdOnEmpTaxSetup", new object[] { salaryYear.Id });
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }

                else
                {
                    throw new Exception("Salary Year already Exist..!");
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);

        }


        //Add by azmal

        [Route("Employee/GetAllSalaryYear/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryYear()
        {
            CommonResponse cmr = new CommonResponse();
            cmr.results = DataAccess.Instance.SalaryYearService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.Id)).ToList();
            return Json(cmr);
        }

        [Route("Employee/GetAllSalaryPeriodByYearId/{YearId}")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryPeriodByYearId(int YearId)
        {
            CommonResponse crs = new CommonResponse();
            //try
            //{
            var dt = DataAccess.Instance.SalaryPeriodService.Filter(s => s.SalaryYearId == YearId && s.IsDeleted == false && s.Status == "A").ToList();
            crs.results = dt;
            crs.httpStatusCode = HttpStatusCode.OK;
            crs.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            //}
            //catch (Exception ex)
            //{
            //    cr.httpStatusCode = HttpStatusCode.BadRequest;
            //    cr.message = ex.Message.ToString();
            //}
            return Json(crs);
        }

        [Route("Employee/DeleteSalaryYear/{Id}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryYear(int Id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var SalaryPeriod = DataAccess.Instance.SalaryPeriodService.Filter(st => st.IsDeleted == false && st.Status == "A" && st.SalaryYearId == Id).ToList();
                if (SalaryPeriod.Any())
                {
                    throw new Exception("Year Name Already Exist. in Salary Period!");
                }
                SalaryYear salaryYear = new SalaryYear();
                salaryYear = DataAccess.Instance.SalaryYearService.Get(Id);
                salaryYear.UpdateBy = User.Identity.Name;
                salaryYear.IsDeleted = true;
                salaryYear.SetDate();

                var resp = DataAccess.Instance.SalaryYearService.Update(salaryYear);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }


        [Route("Employee/UpdateSalaryYear/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryYear(SalaryYear salaryYear)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.SalaryYearService.Filter(st => st.IsDeleted == false && st.Status == "A" && st.Id != salaryYear.Id).ToList();
                if (list.Any(s => s.YearName == salaryYear.YearName))
                {
                    throw new Exception("Year Name Already Exist.");
                }
                var SalaryPeriod = DataAccess.Instance.SalaryPeriodService.Filter(st => st.IsDeleted == false && st.Status == "A" && st.SalaryYearId == salaryYear.Id).ToList();
                if (SalaryPeriod.Any())
                {
                    throw new Exception("Year Name Already Exist. in Salary Period!");
                }
                if (salaryYear.Id != 0)
                {
                    salaryYear.UpdateBy = User.Identity.Name;
                    salaryYear.UpdateDate = DateTime.Now;

                    var res = DataAccess.Instance.SalaryYearService.Update(salaryYear);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        #endregion

        #region Salary head by.......Khaled
        [Route("Employee/GetHeadLedger/")]
        [HttpGet]
        public IHttpActionResult GetHeadLedger()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllLedgerList", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/GetSubCategory/{ledgerId}")]
        [HttpGet]
        public IHttpActionResult GetSubCategory(int ledgerId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllSubCategoryList", ledgerId);
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/GetSubSubCategory/{ledgerId}")]
        [HttpGet]
        public IHttpActionResult GetSubSubCategory(int ledgerId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllSubSubCategoryList", ledgerId);
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("Employee/AddSalaryHead/")]
        [HttpPost]
        public IHttpActionResult AddSalaryHead(SalaryHead salaryHead)
        {
            CommonResponse cmr = new CommonResponse();
            int exist = 0;
            string message = "";
            try
            {
                //if (!DataAccess.Instance.SalaryHeadService.GetAll().Any())
                //{
                //    List<SalaryHead> SalaryHeads = new List<SalaryHead>();
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Basic Salary",HeadCode = "Basic" ,IsBasic=true,Category=(int)SalaryHeadType.Earning,DisplayOrder=1});
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "House Rent", HeadCode = "House", IsBasic=false,Category=(int)SalaryHeadType.Earning, DisplayOrder = 2 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Medical Allowance", HeadCode = "Medical", IsBasic= false, Category=(int)SalaryHeadType.Earning, DisplayOrder = 3 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Dearness Allowance", HeadCode = "Dearness", IsBasic= false, Category=(int)SalaryHeadType.Earning, DisplayOrder = 4 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Provident Fund ", HeadCode = "Provident", IsBasic= false, Category=(int)SalaryHeadType.Deduction, DisplayOrder = 5 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Interest on Loan", HeadCode = "Interest", IsBasic= false, Category=(int)SalaryHeadType.Deduction, DisplayOrder = 6 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Loan Refund/Repay", HeadCode = "Refund", IsBasic= false, Category=(int)SalaryHeadType.Deduction, DisplayOrder = 6 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Late Fine", HeadCode = "LateFine", IsBasic= false, Category=(int)SalaryHeadType.Deduction, DisplayOrder = 6 });
                //}
                if (salaryHead.AccHeadId == 0)
                {
                    exist = DataAccess.Instance.SalaryHeadService.Filter(id => id.HeadName == salaryHead.HeadName && id.IsDeleted == false).Count();
                    message = "Salary Head already Exist..!";
                }
                if (salaryHead.AccHeadId == 0)
                {
                    exist = DataAccess.Instance.SalaryHeadService.Filter(id => id.DisplayOrder == salaryHead.DisplayOrder && id.IsDeleted == false).Count();
                    message = "Display order already Exist..!";
                }


                if (exist <= 0)
                {
                    if (salaryHead.IsAccLedger == null)
                    {
                        salaryHead.IsAccLedger = false;
                    }
                    //if (salaryHead.IsBasic == null)
                    //{
                    //    salaryHead.IsBasic = false;
                    //}
                    salaryHead.IsEdit = false;
                    salaryHead.AddBy = User.Identity.Name;
                    salaryHead.IsDeleted = false;
                    salaryHead.SetDate();
                    var response = DataAccess.Instance.SalaryHeadService.Add(salaryHead);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }

                else
                {
                    throw new Exception(message);
                }
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }


        [Route("Employee/GetAllSalaryHead/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryHead()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //if (!DataAccess.Instance.SalaryHeadService.GetAll().Any())
                //{
                //    List<SalaryHead> SalaryHeads = new List<SalaryHead>();
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Basic Salary", HeadCode = "Basic", IsBasic = true, Category = (int)SalaryHeadType.Earning, DisplayOrder = 1 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "House Rent", HeadCode = "House", IsBasic = false, Category = (int)SalaryHeadType.Earning, DisplayOrder = 2 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Conveyance", HeadCode = "Conveyance", IsBasic = false, Category = (int)SalaryHeadType.Earning, DisplayOrder = 3 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Medical Allowance", HeadCode = "Medical", IsBasic = false, Category = (int)SalaryHeadType.Earning, DisplayOrder = 4 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Dearness Allowance", HeadCode = "Dearness", IsBasic = false, Category = (int)SalaryHeadType.Earning, DisplayOrder = 5 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Provident Fund ", HeadCode = "Provident", IsBasic = false, Category = (int)SalaryHeadType.Deduction, DisplayOrder = 6 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Interest on Loan", HeadCode = "Interest", IsBasic = false, Category = (int)SalaryHeadType.Deduction, DisplayOrder = 7 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Loan Refund/Repay", HeadCode = "Refund", IsBasic = false, Category = (int)SalaryHeadType.Deduction, DisplayOrder = 8 });
                //    SalaryHeads.Add(new SalaryHead() { HeadName = "Late Fine", HeadCode = "LateFine", IsBasic = false, Category = (int)SalaryHeadType.Deduction, DisplayOrder = 9 });
                // var res=   DataAccess.Instance.SalaryHeadService.AddRange(SalaryHeads);
                //    cr.message = res ? Constant.SAVED: Constant.SAVED_ERROR;
                //}
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllSalaryHeadaList", new object[] { 1 }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/DeleteSalaryHead/{salaryId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryHead(int salaryId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.SalaryHeadWiseConfigService.Filter(s => s.HeadId == salaryId && s.IsDeleted == false).ToList();
                if (list.Count() > 0)
                {
                    throw new Exception("Data Exist in Salary Head Wise Config.");
                }
                SalaryHead salaryHead = new SalaryHead();
                salaryHead = DataAccess.Instance.SalaryHeadService.Get(salaryId);
                salaryHead.UpdateBy = User.Identity.Name;
                salaryHead.IsDeleted = true;
                salaryHead.SetDate();

                var resp = DataAccess.Instance.SalaryHeadService.Update(salaryHead);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }


        [Route("Employee/UpdateSalaryHead/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryHead(SalaryHead salaryHead)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var salaryInfo = DataAccess.Instance.SalaryHeadService.Filter(e => e.IsDeleted == false && e.Id == salaryHead.Id).FirstOrDefault();
                salaryInfo.AccHeadId = salaryHead.AccHeadId;
                salaryInfo.UpdateBy = User.Identity.Name;
                salaryInfo.HeadCode = salaryHead.HeadCode;
                salaryInfo.HeadName = salaryHead.HeadName;
                salaryInfo.IsBasic = salaryHead.IsBasic;
                salaryInfo.DisplayOrder = salaryHead.DisplayOrder;
                salaryInfo.SetDate();
                salaryInfo.Category = salaryHead.Category;
                salaryInfo.IsAccLedger = salaryHead.IsAccLedger;

                var res = DataAccess.Instance.SalaryHeadService.Update(salaryInfo);
                cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }
        #endregion

        #region Salary Increment by.........sorowar

        [Route("Employee/GetAllEmployeeList/")]
        [HttpGet]
        public IHttpActionResult GetAllEmployeeList()
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.CommonServices.ExecuteSQLQUERY("select distinct  b.EmpBasicInfoID,b.FullName from Emp_BasicInfo b where b.IsDeleted=0 ");
            return Json(cr);
        }

        [Route("Employee/GetSalaryIncrementList/")]
        [HttpPost]
        public IHttpActionResult GetSalaryIncrementList(SalaryIncrementVM salaryIncrement)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //int EmpIDs = 0;
                //if(salaryIncrement.EmpId != null)
                //{
                //    EmpIDs = salaryIncrement.EmpId;
                //}
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@EmpBasicInfoID", salaryIncrement.EmpId));
                param.Add(new SqlParameter("@BranchId", salaryIncrement.BranchId));
                param.Add(new SqlParameter("@CategoryId", salaryIncrement.EmpCategory));

                DataTable res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeListForIncrement", param.ToArray());
                if (res.Rows.Count > 0)
                {
                    cr.results = res;
                }
                //else
                //{
                //    throw new Exception("");
                //}
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Employee/AddSalaryIncrement/")]
        [HttpPost]
        public IHttpActionResult AddSalaryIncrement(List<SalaryIncrementVM> salaryIncrementlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (salaryIncrementlist.Count <= 0)
                {
                    throw new Exception("At least One Select.");
                }

                DataTable dt;

                foreach (var item in salaryIncrementlist)
                {
                    List<SqlParameter> param = new List<SqlParameter>();
                    param.Add(new SqlParameter("@EmpId", item.EmpBasicInfoID));
                    param.Add(new SqlParameter("@Amount", item.Amount));
                    param.Add(new SqlParameter("@IsPercentage", item.IsPercentage));
                    param.Add(new SqlParameter("@GrossSalary", item.GrossSalary));
                    param.Add(new SqlParameter("@AmountAfterIncrement", item.AmountAfterIncrement));
                    param.Add(new SqlParameter("@Remarks", item.Remarks));
                    param.Add(new SqlParameter("@AddBy", User.Identity.Name));
                    dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_InsertSalaryIncrement", param.ToArray());

                    if (dt.Rows.Count > 0)
                    {
                        cr.message = Constant.SAVED;
                    }

                }
                //}
                //else
                //{
                //    return BadRequest("At Least One Select!");
                //}


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        [Route("Employee/GetAllSalaryIncrement/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryIncrement()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllSalaryIncrementList", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/DeleteSalaryIncrement/{incrementId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryIncrement(int incrementId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                SalaryIncrement salaryIncrement = new SalaryIncrement();
                salaryIncrement = DataAccess.Instance.SalaryIncrementService.Get(incrementId);
                salaryIncrement.UpdateBy = User.Identity.Name;
                salaryIncrement.IsDeleted = true;
                salaryIncrement.SetDate();

                var resp = DataAccess.Instance.SalaryIncrementService.Update(salaryIncrement);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [Route("Employee/UpdateSalaryIncrement/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryIncrement(SalaryIncrement salaryIncrement)
        {
            CommonResponse cmr = new CommonResponse();


            try
            {
                var salaryInfolist = DataAccess.Instance.SalaryIncrementService.Filter(e => e.IsDeleted == false && e.EmpId != salaryIncrement.EmpId).ToList();
                if (salaryInfolist.Any(s => s.EmpId == salaryIncrement.EmpId))
                {
                    throw new Exception("Employee Exist");
                }
                if (salaryIncrement.IsPercentage == null)
                {
                    salaryIncrement.IsPercentage = false;
                }


                salaryIncrement.UpdateDate = DateTime.Now;
                salaryIncrement.UpdateBy = User.Identity.Name;
                var res = DataAccess.Instance.SalaryIncrementService.Update(salaryIncrement);
                cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = res ? Constant.UPDATED : Constant.FAILED;


            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }



            return Json(cmr);
        }






        #endregion

        #region Salary Structure by......sorowar
        [Route("Employee/AddSalaryStructure/")]
        [HttpPost]
        public IHttpActionResult AddSalaryStructure(List<SalaryStructureVM> SalaryStrucList)
        {

            SalaryStructure salaryStructure;
            CommonResponse cmr = new CommonResponse();
            try
            {
                salaryStructure = new SalaryStructure();
                if (SalaryStrucList.Count() > 0)
                {
                    bool IsExist = DataAccess.Instance.CommonServices.IsExist("HR_SalaryStructure", "EmpId", SalaryStrucList[0].EmpId);
                    if (IsExist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    foreach (var item in SalaryStrucList)
                    {
                        salaryStructure.EmpId = item.EmpId;
                        salaryStructure.HeadId = item.HeadId;
                        salaryStructure.TaxYearId = item.TaxYearId;
                        salaryStructure.GradeId = item.GradeId;
                        salaryStructure.Amount = item.Amount;
                        salaryStructure.AddBy = User.Identity.Name;
                        salaryStructure.AddDate = DateTime.Now;
                        salaryStructure.SetDate();
                        salaryStructure.Status = "A";
                        salaryStructure.IsDeleted = false;
                        var res = DataAccess.Instance.SalaryStructureService.Add(salaryStructure);
                    }
                    cmr.message = Constant.SAVED;
                }

            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }


        [Route("Employee/GetAllSalaryStructure")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryStructure()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySp("GetEmpSalaryStructureList");
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("Employee/DeleteSalaryStructure/{structureId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryStructure(int structureId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                SalaryStructure salaryStructure = new SalaryStructure();
                salaryStructure = DataAccess.Instance.SalaryStructureService.Get(structureId);
                salaryStructure.UpdateBy = User.Identity.Name;
                salaryStructure.IsDeleted = true;
                salaryStructure.SetDate();

                var resp = DataAccess.Instance.SalaryStructureService.Update(salaryStructure);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }


        [Route("Employee/UpdateSalaryStructure/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryStructure(List<SalaryStructureVM> SalaryStrucList)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                List<SalaryStructure> salaryStructurelist = new List<SalaryStructure>();
                if (SalaryStrucList[0].SalaryStructureId == 0)
                {
                    throw new Exception(Constant.FAILED);
                }
                if (SalaryStrucList.Count() > 0)
                {
                    foreach (var item in SalaryStrucList)
                    {
                        SalaryStructure salaryStructure = DataAccess.Instance.SalaryStructureService.Filter(s => s.Id == item.SalaryStructureId && s.EmpId == item.EmpId && s.IsDeleted == false && s.Status == "A").FirstOrDefault();
                        salaryStructurelist.Add(salaryStructure);
                    }
                    foreach (var item in salaryStructurelist)
                    {
                        foreach (var s in SalaryStrucList)
                        {
                            if (item.Id == s.SalaryStructureId)
                            {
                                item.EmpId = s.EmpId;
                                item.Amount = s.Amount;
                                item.TaxYearId = s.TaxYearId;
                                item.GradeId = s.GradeId;
                                item.HeadId = s.HeadId;
                                item.UpdateBy = User.Identity.Name;
                                item.UpdateDate = DateTime.Now;
                                DataAccess.Instance.SalaryStructureService.Update(item);
                            }
                        }
                    }
                    cmr.message = Constant.UPDATED;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cmr);
        }

        #endregion

        #region Salary Period by.......sorowar

        [Route("Employee/AddSalaryPeriod/")]
        [HttpPost]
        public IHttpActionResult AddSalaryPeriod(SalaryPeriod salaryPeriod)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {

                DateTime startDate = Convert.ToDateTime(salaryPeriod.startDate);
                DateTime endDate = Convert.ToDateTime(salaryPeriod.endDate);
                DateTime PstartDate = Convert.ToDateTime(salaryPeriod.periodstartDate);
                DateTime PendDate = Convert.ToDateTime(salaryPeriod.periodendDate);
                var exist = DataAccess.Instance.SalaryPeriodService.Filter(id => id.PeriodName == salaryPeriod.PeriodName && id.IsDeleted == false && id.Status == "A").Count();
                if (exist <= 0)
                {
                    if (salaryPeriod.IsLock == null)
                    {
                        salaryPeriod.IsLock = 0;
                    }
                    salaryPeriod.PeriodStartDate = PstartDate;
                    salaryPeriod.PeriodEndDate = PendDate;
                    salaryPeriod.StartDate = startDate;
                    salaryPeriod.EndDate = endDate;
                    salaryPeriod.Status = "A";
                    salaryPeriod.AddDate = DateTime.Now;
                    salaryPeriod.AddBy = User.Identity.Name;
                    salaryPeriod.IsDeleted = false;
                    // salaryPeriod.SetDate();
                    var response = DataAccess.Instance.SalaryPeriodService.Add(salaryPeriod);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }

                else
                {
                    throw new Exception("Salary Period already Exist..!");
                }

            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);

        }


        [Route("Employee/GetAllSalaryPeriod/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryPeriod()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllSalaryPeriod", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("Employee/GetSalaryPeriodByCategoryIDSalaryYearId/")]
        [HttpPost]
        public IHttpActionResult GetSalaryPeriodByCategoryIDSalaryYearId(GeneratePayrolVM salaryReports)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //if (salaryReports.CategoryID != 0)
                //{
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSalaryPeriodByCategorySalaryYear", new object[] { salaryReports.CategoryID, salaryReports.SalaryYearId, 1 });
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                if (res.Rows.Count <= 0)
                {
                    cr.message = "No Process found";
                }

                //}
                //else
                //{
                //    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSalaryPeriodByCategorySalaryYear", new object[] { DBNull.Value, salaryReports.SalaryYearId });
                //    cr.results = res;
                //    cr.httpStatusCode = HttpStatusCode.OK;
                //    if (res.Rows.Count <= 0)
                //    {
                //        cr.message = "No Process found";
                //    }
                //}

            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Employee/GetSalaryPeriodByCategoryIDSalaryYearIdForHoldRefund/")]
        [HttpPost]
        public IHttpActionResult GetSalaryPeriodByCategoryIDSalaryYearIdForHoldRefund(GeneratePayrolVM salaryReports)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //if (salaryReports.CategoryID != 0)
                //{
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSalaryPeriodByCategorySalaryYear", new object[] { salaryReports.CategoryID, salaryReports.SalaryYearId, 2 });
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                if (res.Rows.Count <= 0)
                {
                    cr.message = "No Process found";
                }

                //}
                //else
                //{
                //    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSalaryPeriodByCategorySalaryYear", new object[] { DBNull.Value, salaryReports.SalaryYearId });
                //    cr.results = res;
                //    cr.httpStatusCode = HttpStatusCode.OK;
                //    if (res.Rows.Count <= 0)
                //    {
                //        cr.message = "No Process found";
                //    }
                //}

            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Employee/DeleteSalaryPeriod/{periodId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryPeriod(int periodId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var proce = DataAccess.Instance.SalaryStructurePeriodService.Filter(pro => pro.PeriodId == periodId && pro.IsDeleted == false).Count();
                if (proce > 0)
                {
                    throw new Exception("Period Already processed.");
                }
                SalaryPeriod salaryPeriod = new SalaryPeriod();
                salaryPeriod = DataAccess.Instance.SalaryPeriodService.Get(periodId);
                salaryPeriod.UpdateBy = User.Identity.Name;
                salaryPeriod.IsDeleted = true;
                salaryPeriod.SetDate();

                var resp = DataAccess.Instance.SalaryPeriodService.Update(salaryPeriod);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }


        [Route("Employee/UpdateSalaryPeriod/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryPeriod(SalaryPeriod salaryPeriod)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                DateTime startDate = Convert.ToDateTime(salaryPeriod.startDate);
                DateTime endDate = Convert.ToDateTime(salaryPeriod.endDate);
                DateTime PstartDate = Convert.ToDateTime(salaryPeriod.periodstartDate);
                DateTime PendDate = Convert.ToDateTime(salaryPeriod.periodendDate);
                var list = DataAccess.Instance.SalaryPeriodService.Filter(p => p.Id != salaryPeriod.Id && p.IsDeleted == false && p.Status == "A").ToList();
                if (list.Any(s => s.PeriodName == salaryPeriod.PeriodName))
                {
                    throw new Exception("Period Name Already Exist.");
                }
                var proce = DataAccess.Instance.SalaryStructurePeriodService.Filter(pro => pro.PeriodId == salaryPeriod.Id && pro.IsDeleted == false).Count();
                if (proce > 0)
                {
                    throw new Exception("Period Already processed.");
                }
                if (salaryPeriod.Id != 0)
                {
                    salaryPeriod.PeriodStartDate = PstartDate;
                    salaryPeriod.PeriodEndDate = PendDate;
                    salaryPeriod.StartDate = startDate;
                    salaryPeriod.EndDate = endDate;
                    salaryPeriod.UpdateBy = User.Identity.Name;
                    salaryPeriod.UpdateDate = DateTime.Now;
                    var res = DataAccess.Instance.SalaryPeriodService.Update(salaryPeriod);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
                else
                {
                    throw new Exception(Constant.UPDATED_ERROR);
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        #endregion

        #region Advance Salary by.......Azmal

        [Route("Employee/AddAdvanceSalary/")]
        [HttpPost]
        public IHttpActionResult AddAdvanceSalary(AdvanceSalary advanceSalary)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var invoiceNo = 100000001;
                var advanceSalaryInfo = DataAccess.Instance.AdvanceSalaryService.Filter(e => e.IsDeleted == false).ToList();

                if (advanceSalaryInfo.Any())
                {
                    var invoiceNoInfo = DataAccess.Instance.AdvanceSalaryService.Filter(e => e.IsDeleted == false).LastOrDefault();
                    invoiceNo = Convert.ToInt32(invoiceNoInfo.InvoiceNumber) + 1;
                }

                DateTime SanctionDate = Convert.ToDateTime(advanceSalary.SanctionDate);

                advanceSalary.SanctionDate = SanctionDate;
                advanceSalary.InstallmentAmount = advanceSalary.AdvanceAmount / advanceSalary.NoOfInstallment;
                advanceSalary.HeadId = 1014;
                advanceSalary.InvoiceNumber = invoiceNo;
                advanceSalary.Status = "A";
                advanceSalary.AddDate = DateTime.Now;
                advanceSalary.AddBy = User.Identity.Name;
                advanceSalary.IsDeleted = false;
                advanceSalary.SetDate();
                var response = DataAccess.Instance.AdvanceSalaryService.Add(advanceSalary);
                cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = response ? Constant.SAVED : Constant.FAILED;


            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);

        }


        [Route("Employee/GetAllAdvanceSalary/")]
        [HttpGet]

        public IHttpActionResult GetAllAdvanceSalary()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllAdvanceSalary", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("Employee/DeleteAdvanceSalary/{Id}")]
        [HttpDelete]

        public IHttpActionResult DeleteAdvanceSalary(int Id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var Transactionresult = DataAccess.Instance.AdvanceSalaryPaymentService.Filter(r => r.IsDeleted == false);
                if (Transactionresult.Where(a => a.AdvanceSalaryId == Id).Any())
                {
                    throw new Exception("Advance Payment Aleardy Exist");
                }
                AdvanceSalary advanceSalary = new AdvanceSalary();
                advanceSalary = DataAccess.Instance.AdvanceSalaryService.Get(Id);
                advanceSalary.UpdateBy = User.Identity.Name;
                advanceSalary.IsDeleted = true;
                advanceSalary.SetDate();

                var resp = DataAccess.Instance.AdvanceSalaryService.Update(advanceSalary);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }


        [Route("Employee/UpdateAdvanceSalary/")]
        [HttpPut]

        public IHttpActionResult UpdateAdvanceSalary(AdvanceSalary advanceSalary)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var Transactionresult = DataAccess.Instance.AdvanceSalaryPaymentService.Filter(r => r.IsDeleted == false);
                if (Transactionresult.Where(a => a.AdvanceSalaryId == advanceSalary.Id).Any())
                {
                    throw new Exception("Advance Payment Aleardy Exist");
                }

                if (advanceSalary.Id != 0)
                {
                    DateTime SanctionDate = Convert.ToDateTime(advanceSalary.SanctionDate);

                    advanceSalary.SanctionDate = SanctionDate;
                    advanceSalary.InstallmentAmount = advanceSalary.AdvanceAmount / advanceSalary.NoOfInstallment;
                    advanceSalary.UpdateBy = User.Identity.Name;
                    advanceSalary.UpdateDate = DateTime.Now;
                    var res = DataAccess.Instance.AdvanceSalaryService.Update(advanceSalary);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
                else
                {
                    throw new Exception(Constant.UPDATED_ERROR);
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        #endregion

        #region Salary Hold by.......Azmal

        [Route("Employee/AddSalaryHold/")]
        [HttpPost]
        public IHttpActionResult AddSalaryHold(SalaryHold salaryHold)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {

                var row = DataAccess.Instance.SalaryHoldService.Filter(s => s.EmpId == salaryHold.EmpId).Count();

                if (row > 0)
                {
                    throw new Exception("Employee Already Exist !!");
                }

                //DateTime HoldDate = Convert.ToDateTime(salaryHold.HoldDate);

                //salaryHold.HoldDate = HoldDate;
                salaryHold.HoldPerMonthAmount = salaryHold.GrossSalary / salaryHold.NoOfInstallment;
                salaryHold.HeadId = 1013;

                salaryHold.Status = "A";
                salaryHold.AddDate = DateTime.Now;
                salaryHold.AddBy = User.Identity.Name;
                salaryHold.IsDeleted = false;
                salaryHold.SetDate();
                var response = DataAccess.Instance.SalaryHoldService.Add(salaryHold);
                cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = response ? Constant.SAVED : Constant.FAILED;


            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);

        }


        [Route("Employee/GetAllSalaryHold/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryHold()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllSalaryHold", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("Employee/DeleteSalaryHold/{Id}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryHold(int Id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var Transactionresult = DataAccess.Instance.SalaryHoldPaymentService.Filter(r => r.IsDeleted == false);
                if (Transactionresult.Where(a => a.SalaryHoldId == Id).Any())
                {
                    throw new Exception("Salry Hold Payment Aleardy Exist");
                }
                SalaryHold salaryHold = new SalaryHold();
                salaryHold = DataAccess.Instance.SalaryHoldService.Get(Id);
                salaryHold.UpdateBy = User.Identity.Name;
                salaryHold.IsDeleted = true;
                salaryHold.SetDate();

                var resp = DataAccess.Instance.SalaryHoldService.Update(salaryHold);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }


        [Route("Employee/UpdateSalaryHold/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryHold(SalaryHold salaryHold)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var Transactionresult = DataAccess.Instance.SalaryHoldPaymentService.Filter(r => r.IsDeleted == false);
                if (Transactionresult.Where(a => a.SalaryHoldId == salaryHold.Id).Any())
                {
                    throw new Exception("Aleardy Exist in Salary Processed");
                }

                if (salaryHold.Id != 0)
                {
                    //DateTime HoldDate = Convert.ToDateTime(salaryHold.HoldDate);

                    //salaryHold.HoldDate = HoldDate;
                    salaryHold.HoldPerMonthAmount = salaryHold.GrossSalary / salaryHold.NoOfInstallment;
                    salaryHold.UpdateBy = User.Identity.Name;
                    salaryHold.UpdateDate = DateTime.Now;
                    var res = DataAccess.Instance.SalaryHoldService.Update(salaryHold);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
                else
                {
                    throw new Exception(Constant.UPDATED_ERROR);
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        #endregion

        #region Salary head wise config by......Khaled
        [Route("Employee/AddSalarySalaryHeadWiseConfig/")]
        [HttpPost]
        public IHttpActionResult AddSalarySalaryHeadWiseConfig(SalaryHeadWiseConfig salaryHeadWiseConfig)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                if (salaryHeadWiseConfig != null || salaryHeadWiseConfig.Id == 0)
                {
                    var Category = DataAccess.Instance.SalaryHeadWiseConfigService.Filter(e => e.IsDeleted == false);
                    if (Category.Where(e => e.CategoryID == salaryHeadWiseConfig.CategoryID && e.HeadId == salaryHeadWiseConfig.HeadId).Any())
                    {
                        throw new Exception("Category/Head Already Exist");
                    }


                    salaryHeadWiseConfig.IsPercentage = true;
                    salaryHeadWiseConfig.AddBy = User.Identity.Name;
                    salaryHeadWiseConfig.AddDate = DateTime.Now;
                    salaryHeadWiseConfig.Status = "A";
                    salaryHeadWiseConfig.IsDeleted = false;
                    // salaryHeadWiseConfig.SetDate();
                    var response = DataAccess.Instance.SalaryHeadWiseConfigService.Add(salaryHeadWiseConfig);

                    var param = new object[] {
                                                salaryHeadWiseConfig.CategoryID
                                               ,salaryHeadWiseConfig.HeadId
                                               ,salaryHeadWiseConfig.Amount
                                               ,salaryHeadWiseConfig.AddBy
                                             };
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertSalaryStructure", param);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }


            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);

        }
        [Route("Employee/UpdateSalaryHeadWiseConfig/")]
        [HttpPut]

        public IHttpActionResult UpdateSalaryHeadWiseConfig(SalaryHeadWiseConfig salaryHeadWiseConfig)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                if (salaryHeadWiseConfig.Id != 0)
                {
                    salaryHeadWiseConfig.UpdateBy = User.Identity.Name;
                    salaryHeadWiseConfig.UpdateDate = DateTime.Now;
                    var response = DataAccess.Instance.SalaryHeadWiseConfigService.Update(salaryHeadWiseConfig);

                    var param = new object[] {
                                                salaryHeadWiseConfig.CategoryID
                                               ,salaryHeadWiseConfig.HeadId
                                               ,salaryHeadWiseConfig.Amount
                                               ,salaryHeadWiseConfig.AddBy
                                             };
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertSalaryStructure", param);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }


            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        [Route("Employee/DeleteSalaryHeadWiseConfig/{conifgId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryHeadWiseConfig(int conifgId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                SalaryHeadWiseConfig salaryHeadWiseConfig = new SalaryHeadWiseConfig();
                salaryHeadWiseConfig = DataAccess.Instance.SalaryHeadWiseConfigService.Get(conifgId);
                salaryHeadWiseConfig.UpdateBy = User.Identity.Name;
                salaryHeadWiseConfig.IsDeleted = true;
                salaryHeadWiseConfig.SetDate();

                var resp = DataAccess.Instance.SalaryHeadWiseConfigService.Update(salaryHeadWiseConfig);

                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }
        #endregion
        #region Reward......Khaled
        [Route("Employee/GetRewardentryList/{BranchId}/{FromDate}/{ToDate}")]
        [HttpPost]
        public IHttpActionResult GetRewardentryList(int BranchId, string FromDate, string ToDate)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@BranchId", BranchId));
                param.Add(new SqlParameter("@CategoryId", FromDate));
                param.Add(new SqlParameter("@CalenderId", ToDate));
                DataTable res = DataAccess.Instance.CommonServices.GetBySpWithParam("FullAttendanceAward", param.ToArray());

                cr.results = res;


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Employee/AddEmpReward/")]
        [HttpPost]
        public IHttpActionResult AddEmpReward(List<EmpRewardVM> empRewardList)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                //if (empLeaveQuotalist.Count > 0)
                //{

                DataTable dt;

                foreach (var item in empRewardList)
                {
                    List<SqlParameter> param = new List<SqlParameter>();



                    param.Add(new SqlParameter("@EmpId", item.EmpBasicInfoID));
                    param.Add(new SqlParameter("@RewardAmount", item.RewardAmount));
                    param.Add(new SqlParameter("@AddBy", User.Identity.Name));



                    dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertEmployeeReward", param.ToArray());



                    if (dt.Rows.Count > 0)
                    {
                        cr.message = Constant.SAVED;
                    }

                }
                //}
                //else
                //{
                //    return BadRequest("At Least One Select!");
                //}


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        #endregion
        #region Salary Hold Refund......Khaled
        [Route("Employee/AddSalaryHoldRefund/")]
        [HttpPost]
        public IHttpActionResult AddSalaryHoldRefund(SalaryHoldRefundVM holdRefund)
        {
            CommonResponse cmr = new CommonResponse();

            try
            {
                bool response = false;
                if (holdRefund.PeriodList.Count > 0)
                {
                    int i = 0;
                    foreach (var item in holdRefund.PeriodList)
                    {
                        if (item.IsChecked == true)
                        {
                            i = i + 1;
                            SalaryHoldRefund allow = new SalaryHoldRefund();
                            allow.EmpId = holdRefund.EmpId;
                            allow.SalaryPeriodId = item.Id;
                            allow.SalaryYearId = holdRefund.SalaryYearId;
                            allow.Installment = holdRefund.Installment;
                            allow.InstallmentAmount = holdRefund.InstallmentAmount;
                            allow.HoldedAmount = holdRefund.HoldedAmount;
                            allow.Status = "Pending";
                            allow.Remarks = i.ToString();
                            allow.IsDeleted = false;
                            allow.AddBy = User.Identity.Name;
                            allow.AddDate = DateTime.Now;
                            allow.SetDate();
                            response = DataAccess.Instance.SalaryHoldRefundService.Add(allow);
                        }

                    }
                }

                cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = response ? Constant.SAVED : Constant.FAILED;


            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);

        }
        [Route("Employee/GetAllSalaryHoldRefund/")]
        [HttpGet]
        public IHttpActionResult GetAllSalaryHoldRefund()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySp("GetAllSalaryHoldRefund");
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Employee/GetSalaryHoldRefund/{EmpId}/{SalaryYearId}")]
        [HttpGet]

        public IHttpActionResult GetSalaryHoldRefund(int EmpId, int SalaryYearId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.SalaryHoldRefundService.Filter(s => s.EmpId == EmpId && s.SalaryYearId == SalaryYearId && s.IsDeleted == false).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Employee/UpdateSpecialAllowance/")]
        [HttpPut]
        public IHttpActionResult UpdateSpecialAllowance(SalaryHoldRefundVM holdRefund)
        {
            CommonResponse cmr = new CommonResponse();

            try
            {
                bool response = false;
                if (holdRefund.PeriodList.Count > 0)
                {
                    foreach (var item in holdRefund.PeriodList)
                    {
                        if (item.IsChecked == true)
                        {
                            var check = DataAccess.Instance.SalaryHoldRefundService.Filter(e => e.EmpId == holdRefund.EmpId && e.Status == "Refund" && e.IsDeleted == false).Count();
                            if (check > 0)
                            {
                                throw new Exception("Can't Update Because Hold Refund Already Processed !!");
                            }

                            var obje = DataAccess.Instance.SalaryHoldRefundService.Filter(e => e.EmpId == holdRefund.EmpId && e.SalaryPeriodId == item.Id).FirstOrDefault();

                            if (obje != null)
                            {
                                obje.SalaryPeriodId = item.Id;
                                obje.Installment = holdRefund.Installment;
                                obje.InstallmentAmount = holdRefund.InstallmentAmount;
                                obje.UpdateBy = User.Identity.Name;
                                obje.UpdateDate = DateTime.Now;
                                DataAccess.Instance.SalaryHoldRefundService.Update(obje);
                            }
                            else
                            {
                                SalaryHoldRefund allow = new SalaryHoldRefund();
                                allow.EmpId = holdRefund.EmpId;
                                allow.SalaryYearId = holdRefund.SalaryYearId;
                                allow.SalaryPeriodId = item.Id;
                                allow.Installment = holdRefund.Installment;
                                allow.InstallmentAmount = holdRefund.InstallmentAmount;
                                allow.Status = "Pending";
                                allow.IsDeleted = false;
                                allow.AddBy = User.Identity.Name;
                                allow.AddDate = DateTime.Now;
                                allow.SetDate();
                                response = DataAccess.Instance.SalaryHoldRefundService.Add(allow);
                            }

                        }
                        else
                        {
                            var obje = DataAccess.Instance.SalaryHoldRefundService.Filter(e => e.EmpId == holdRefund.EmpId && e.SalaryPeriodId == item.Id).FirstOrDefault();

                            if (obje != null)
                            {
                                DataAccess.Instance.SalaryHoldRefundService.Remove(obje.Id);
                            }
                        }

                    }
                }

                cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = response ? Constant.SAVED : Constant.FAILED;


            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);

        }

        [Route("Employee/DeleteHoldRefund/{EmpId}")]
        [HttpDelete]

        public IHttpActionResult DeleteHoldRefund(int EmpId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var check = DataAccess.Instance.SalaryHoldRefundService.Filter(e => e.EmpId == EmpId && e.Status == "Refund" && e.IsDeleted == false).Count();
                if (check > 0)
                {
                    throw new Exception("Can't Update Because Hold Refund Already Processed !!");
                }

                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("DeleteORForfeitHoldRefund", new object[] { EmpId, 1 });
                cmr.results = dt;
                cmr.httpStatusCode = HttpStatusCode.OK;
                cmr.message = "Deleted Successfully !";

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        [Route("Employee/ForfeitHoldRefund/{EmpId}")]
        [HttpPost]

        public IHttpActionResult ForfeitHoldRefund(int EmpId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var check = DataAccess.Instance.SalaryHoldRefundService.Filter(e => e.EmpId == EmpId && e.Status == "Pending" && e.IsDeleted == false).Count();
                if (check > 0)
                {
                    throw new Exception("Installments Pending!!");
                }

                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("DeleteORForfeitHoldRefund", new object[] { EmpId, 2 });
                cmr.results = dt;
                cmr.httpStatusCode = HttpStatusCode.OK;
                cmr.message = "Forfeit Successfully !";

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        #endregion


        [Route("Employee/GetAllSalaryHeadWiseConfig/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryHeadWiseConfig()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllSalaryHeadaList", new object[] { 2 }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/GetAllSalaryHeadWiseConfigWithPercentage/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryHeadWiseConfigWithPercentage()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllSalaryHeadListWithPercentage", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/GetEmployeeSalaryHeadwiseList/{EmpID}")]
        [HttpGet]

        public IHttpActionResult GetEmployeeSalaryHeadwiseList(int EmpID)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetEmployeeWithSalaryPersentage", new object[] { EmpID }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"Data Found" : "Please Set Gross Salary Or Update the Salary Percentage";
                //  cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [HttpPost]
        [Route("Employee/UpdateEmployeeWiseSalaryStructure/")]
        public IHttpActionResult UpdateCollectionDiscout(List<SalaryStructure> employeeStructureList)
        {
            CommonResponse cr = new CommonResponse();
            var res = false;
            try
            {

                foreach (var item in employeeStructureList)
                {
                    var data = DataAccess.Instance.SalaryStructureService.Filter(e => e.Id == item.Id && e.HeadId == item.HeadId).FirstOrDefault();
                    data.Amount = item.Amount;
                    data.IsDeleted = false;
                    data.Status = "A";
                    data.UpdateBy = User.Identity.Name;
                    data.SetDate();
                    res = DataAccess.Instance.SalaryStructureService.Update(data);


                }
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;


            }

            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Json(cr);
        }






        #region Salary Employee by ..........sorowar
        [Route("Employee/AddSalaryEmployee/")]
        [HttpPost]
        public IHttpActionResult AddSalaryEmployee(SalaryEmployee salaryEmployee)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var exist = DataAccess.Instance.SalaryEmployeeService.Filter(id => id.HeadId == salaryEmployee.HeadId && id.EmpId == salaryEmployee.EmpId && id.IsDeleted == false).Count();
                if (exist <= 0)
                {
                    salaryEmployee.AddBy = User.Identity.Name;
                    salaryEmployee.IsDeleted = false;
                    salaryEmployee.SetDate();
                    var response = DataAccess.Instance.SalaryEmployeeService.Add(salaryEmployee);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }
                else
                {
                    throw new Exception("Salary Employee already Exist..!");
                }
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        [Route("Employee/GetAllSalaryEmployee/")]
        [HttpGet]
        public IHttpActionResult GetAllSalaryEmployee()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllSalaryEmployee", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/DeleteSalaryEmployee/{salaryId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryEmployee(int salaryId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                SalaryEmployee salaryEmployee = new SalaryEmployee();
                salaryEmployee = DataAccess.Instance.SalaryEmployeeService.Get(salaryId);
                salaryEmployee.UpdateBy = User.Identity.Name;
                salaryEmployee.IsDeleted = true;
                salaryEmployee.SetDate();

                var resp = DataAccess.Instance.SalaryEmployeeService.Update(salaryEmployee);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("Employee/UpdateSalaryEmployee/")]
        [HttpPut]
        public IHttpActionResult UpdateSalaryEmployee(SalaryEmployee salaryEmployee)
        {
            CommonResponse cmr = new CommonResponse();
            var exist = DataAccess.Instance.SalaryEmployeeService.Filter(id => id.HeadId == salaryEmployee.HeadId && id.EmpId == salaryEmployee.EmpId && id.IsDeleted == false).Count();
            if (exist <= 0)
            {
                try
                {
                    var salaryInfo = DataAccess.Instance.SalaryEmployeeService.Filter(e => e.IsDeleted == false && e.Id == salaryEmployee.Id).FirstOrDefault();
                    salaryInfo.EmpId = salaryEmployee.EmpId;
                    salaryInfo.UpdateBy = User.Identity.Name;
                    salaryInfo.HeadId = salaryEmployee.HeadId;
                    salaryInfo.GradeId = salaryEmployee.GradeId;
                    salaryInfo.TaxYearId = salaryEmployee.TaxYearId;
                    salaryInfo.Amount = salaryEmployee.Amount;
                    salaryInfo.SalaryPeriodId = salaryEmployee.SalaryPeriodId;
                    salaryInfo.SetDate();
                    salaryInfo.IsDeleted = false;

                    var res = DataAccess.Instance.SalaryEmployeeService.Update(salaryInfo);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
                catch (Exception ex)
                {
                    return BadRequest(ex.Message);
                }
            }
            else
            {
                cmr.httpStatusCode = HttpStatusCode.UseProxy;
                cmr.message = Constant.DATA_EXISTS;
            }
            return Json(cmr);
        }
        #endregion

        #region Leave Application by.......sorowar
        [Route("Employee/AddLeaveApplication/")]
        [HttpPost]
        public IHttpActionResult AddLeaveApplication(LeaveApplication leaveApplication)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                //var exist = DataAccess.Instance.SalaryGradeService.Filter(id => id.BranchId == empSalary.BranchId).Count();
                //if (exist <= 0)
                if (true)
                {
                    if (leaveApplication.IsReApplied == null)
                    {
                        leaveApplication.IsReApplied = false;
                    }
                    leaveApplication.AddBy = User.Identity.Name;
                    leaveApplication.IsDeleted = false;
                    leaveApplication.SetDate();
                    var response = DataAccess.Instance.LeaveApplicationService.Add(leaveApplication);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }
                else
                {
                    throw new Exception("Leave application already Exist..!");
                }
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }


        [Route("Employee/GetAllLeaveApplication/")]
        [HttpGet]
        public IHttpActionResult GetAllLeaveApplication()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllLeaveApplication", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/DeleteLeaveApplication/{leaveId}")]
        [HttpDelete]

        public IHttpActionResult DeleteLeaveApplication(int leaveId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                LeaveApplication leaveApplication = new LeaveApplication();
                leaveApplication = DataAccess.Instance.LeaveApplicationService.Get(leaveId);
                leaveApplication.UpdateBy = User.Identity.Name;
                leaveApplication.IsDeleted = true;
                leaveApplication.SetDate();

                var resp = DataAccess.Instance.LeaveApplicationService.Update(leaveApplication);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [Route("Employee/UpdateLeaveApplication/")]
        [HttpPut]
        public IHttpActionResult UpdateLeaveApplication(LeaveApplication leaveApplication)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var leaveInfo = DataAccess.Instance.LeaveApplicationService.Filter(e => e.IsDeleted == false && e.Id == leaveApplication.Id).FirstOrDefault();
                leaveInfo.EmpId = leaveApplication.EmpId;
                leaveInfo.LeaveTypeId = leaveApplication.LeaveTypeId;
                leaveInfo.UpdateBy = User.Identity.Name;
                leaveInfo.FromDate = leaveApplication.FromDate;
                leaveInfo.ToDate = leaveApplication.ToDate;
                leaveInfo.TotalDays = leaveApplication.TotalDays;
                leaveInfo.TotalEffectDays = leaveApplication.TotalEffectDays;
                leaveInfo.Reason = leaveApplication.Reason;
                leaveInfo.Attachment = leaveApplication.Attachment;
                leaveInfo.IsReApplied = leaveApplication.IsReApplied;
                leaveInfo.BalanceLeave = leaveApplication.BalanceLeave;
                leaveInfo.SetDate();
                leaveInfo.IsDeleted = false;

                var res = DataAccess.Instance.LeaveApplicationService.Update(leaveInfo);
                cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }

        [Route("Employee/GetLeaveBalanceByEmpid/{empId}/{typeId}")]
        [HttpGet]

        public IHttpActionResult GetLeaveBalanceByEmpid(int empId, int typeId)
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                var dt1 = DataAccess.Instance.CommonServices.GetBySpWithParam("GetLeaveBalance", new object[] { empId, typeId }).Rows;
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetLeaveBalance", new object[] { empId, typeId }).Rows[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                // cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        #endregion


        #region Reject Or Approve leave Application by.....sorowar
        [Route("Employee/GetAllLeaveApplicationList/")]
        [HttpGet]
        public IHttpActionResult GetAllLeaveApplicationList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                int Type = 6; //Only Leave List from Employee Portal
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRequestList", new object[] { DBNull.Value, Type });

                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/EmpLeaveStatus/")]
        [HttpPut]
        public IHttpActionResult EmpLeaveStatus(EmpLeaveVM empleave)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                LeaveApplication leaveApp = new LeaveApplication();
                EmpRequest empr = DataAccess.Instance.EmpRequestService.Filter(e => e.Id == empleave.LeaveId).FirstOrDefault();
                leaveApp.Reason = empr.Description;
                leaveApp.FromDate = Convert.ToDateTime(empr.FromDate);
                leaveApp.ToDate = Convert.ToDateTime(empr.ToDate);
                leaveApp.Attachment = empr.File;
                leaveApp.LeaveTypeId = Convert.ToInt32(empr.LeaveCategoryId);
                leaveApp.ApproveBy = User.Identity.Name;
                leaveApp.EmpId = empr.EmpId;
                leaveApp.TotalDays = empr.Duration;
                //new dev for half day leave : 04-02-2021
                //leaveApp.BalanceLeave = Convert.ToDecimal(leaveApp.BalanceLeave - empr.Duration);
                leaveApp.ApproveDate = Convert.ToDateTime(empleave.Date);
                leaveApp.IsDeleted = false;
                leaveApp.Status = "Approved";
                leaveApp.AddBy = User.Identity.Name;
                leaveApp.AddDate = DateTime.Now;
                leaveApp.SetDate();
                leaveApp.UpdateBy = User.Identity.Name;
                leaveApp.ApproveComments = empleave.Comments;

                empr.Status = "Approved";


                empr.Remarks = empleave.Comments + " by " + User.Identity.Name + " at " + Convert.ToDateTime(empleave.Date).ToString("dd/MM/yyyy");
                empr.UpdateBy = User.Identity.Name;
                empr.UpdateDate = DateTime.Now;
                var res = DataAccess.Instance.LeaveApplicationService.Add(leaveApp);
                if (res)
                {
                    var r = DataAccess.Instance.EmpRequestService.Update(empr);
                }
                cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = res ? Constant.SUCCESS : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }
        [Route("Employee/EmpLeaveRejected/")]
        [HttpPut]
        public IHttpActionResult EmpLeaveRejected(EmpLeaveVM empleave)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                LeaveApplication leaveApp = new LeaveApplication();
                EmpRequest empr = DataAccess.Instance.EmpRequestService.Filter(e => e.Id == empleave.LeaveId).FirstOrDefault();
                leaveApp.Reason = empr.Description;
                leaveApp.FromDate = Convert.ToDateTime(empr.FromDate);
                leaveApp.ToDate = Convert.ToDateTime(empr.ToDate);
                leaveApp.Attachment = empr.File;
                leaveApp.LeaveTypeId = Convert.ToInt32(empr.LeaveCategoryId);
                leaveApp.RejectedBy = User.Identity.Name;
                leaveApp.EmpId = empr.EmpId;
                leaveApp.TotalDays = Convert.ToInt32(empr.Duration);

                leaveApp.IsDeleted = false;

                leaveApp.AddBy = User.Identity.Name;
                leaveApp.AddDate = DateTime.Now;
                leaveApp.SetDate();
                leaveApp.UpdateBy = User.Identity.Name;
                leaveApp.Status = "Rejected";
                leaveApp.RejectedComments = empleave.Comments;
                leaveApp.RejectedDate = Convert.ToDateTime(empleave.Date);

                empr.Status = "Rejected";
                empr.Remarks = empleave.Comments + " by " + User.Identity.Name + " at " + Convert.ToDateTime(empleave.Date).ToString("dd/MM/yyyy");
                empr.UpdateBy = User.Identity.Name;
                empr.UpdateDate = DateTime.Now;
                var res = DataAccess.Instance.LeaveApplicationService.Add(leaveApp);
                if (res)
                {
                    var r = DataAccess.Instance.EmpRequestService.Update(empr);
                }
                cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = res ? Constant.SUCCESS : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }
        #endregion

        #region Leave Category by ............sorowar
        [Route("Employee/AddLeaveCategory/")]
        [HttpPost]
        public IHttpActionResult AddLeaveCategory(LeaveCategory leaveCategory)
        {

            CommonResponse cmr = new CommonResponse();
            try
            {
                var exist = DataAccess.Instance.LeaveCategoryService.Filter(id => id.CategoryName == leaveCategory.CategoryName && id.IsDeleted == false).Count();
                if (exist <= 0)
                {
                    leaveCategory.AddBy = User.Identity.Name;
                    leaveCategory.IsDeleted = false;
                    leaveCategory.SetDate();
                    var response = DataAccess.Instance.LeaveCategoryService.Add(leaveCategory);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }
                else
                {
                    throw new Exception("Leave Category already Exist..!");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);

        }



        [Route("Employee/GetAllLeaveCategory/")]
        [HttpGet]

        public IHttpActionResult GetAllLeaveCategory()
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                cmr.results = DataAccess.Instance.LeaveCategoryService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.Id)).ToList();
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("Employee/DeleteLeaveCategory/{categoryId}")]
        [HttpDelete]

        public IHttpActionResult DeleteLeaveCategory(int categoryId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                LeaveCategory leaveCategory = new LeaveCategory();
                leaveCategory = DataAccess.Instance.LeaveCategoryService.Get(categoryId);
                leaveCategory.UpdateBy = User.Identity.Name;
                leaveCategory.IsDeleted = true;
                leaveCategory.SetDate();

                var resp = DataAccess.Instance.LeaveCategoryService.Update(leaveCategory);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [Route("Employee/UpdateLeaveCategory/")]
        [HttpPut]

        public IHttpActionResult UpdateLeaveCategory(LeaveCategory leaveCategory)
        {
            CommonResponse cmr = new CommonResponse();
            var exist = DataAccess.Instance.LeaveCategoryService.Filter(id => id.CategoryName == leaveCategory.CategoryName && id.IsDeleted == false).Count();

            if (exist <= 0)
            {
                try
                {
                    var categoryInfo = DataAccess.Instance.LeaveCategoryService.Filter(e => e.IsDeleted == false && e.Id == leaveCategory.Id).FirstOrDefault();
                    categoryInfo.CategoryName = leaveCategory.CategoryName;
                    categoryInfo.UpdateBy = User.Identity.Name;
                    categoryInfo.SetDate();

                    var res = DataAccess.Instance.LeaveCategoryService.Update(categoryInfo);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
                catch (Exception ex)
                {
                    return BadRequest(ex.Message);
                }
            }

            else
            {
                cmr.httpStatusCode = HttpStatusCode.UseProxy;
                cmr.message = Constant.DATA_EXISTS;
            }

            return Json(cmr);
        }
        #endregion


        #region Salary Period Details by......... 


        [Route("Employee/AddSalaryPayDetails/")]
        [HttpPost]
        public IHttpActionResult AddSalaryPayDetails(SalaryPayDetails salaryPayDetails)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var exist = DataAccess.Instance.SalaryPayDetailsService.Filter(e => e.IsDeleted == false && e.EmpId == salaryPayDetails.EmpId).Count();
                if (exist <= 0)
                {


                    salaryPayDetails.Status = "A";
                    salaryPayDetails.AddDate = DateTime.Now;
                    salaryPayDetails.AddBy = User.Identity.Name;
                    salaryPayDetails.IsDeleted = false;
                    salaryPayDetails.SetDate();
                    var response = DataAccess.Instance.SalaryPayDetailsService.Add(salaryPayDetails);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }

                else
                {
                    throw new Exception("Employee Name already Exist..!");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }


        [Route("Employee/GetAllSalaryPayDetails/")]
        [HttpGet]

        public IHttpActionResult GetAllSalaryPayDetails()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAllSalaryPayDetailsList", new object[] { }).Tables[0];
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/DeleteSalaryPayDetails/{SalaryId}")]
        [HttpDelete]

        public IHttpActionResult DeleteSalaryPayDetails(int SalaryId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                SalaryPayDetails salaryPayDetails = new SalaryPayDetails();
                salaryPayDetails = DataAccess.Instance.SalaryPayDetailsService.Get(SalaryId);
                salaryPayDetails.UpdateBy = User.Identity.Name;
                salaryPayDetails.IsDeleted = true;
                salaryPayDetails.UpdateDate = DateTime.Now;
                salaryPayDetails.SetDate();

                var resp = DataAccess.Instance.SalaryPayDetailsService.Update(salaryPayDetails);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [Route("Employee/UpdateSalarySalaryPayDetails/")]
        [HttpPut]

        public IHttpActionResult UpdateSalarySalaryPayDetails(SalaryPayDetails salaryPayDetails)
        {
            CommonResponse cmr = new CommonResponse();


            try
            {
                var salaryInfolist = DataAccess.Instance.SalaryPayDetailsService.Filter(e => e.IsDeleted == false && e.Id != salaryPayDetails.Id).ToList();
                if (salaryInfolist.Any(s => s.EmpId == salaryPayDetails.EmpId))
                {
                    throw new Exception("Employee Exist");
                }

                if (salaryPayDetails.Id != 0)
                {
                    salaryPayDetails.UpdateDate = DateTime.Now;
                    salaryPayDetails.UpdateBy = User.Identity.Name;
                    var res = DataAccess.Instance.SalaryPayDetailsService.Update(salaryPayDetails);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.FAILED;
                }


            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }






        #endregion


        #region  Salary Process  
        [Route("Employee/ProcessSalary/")]
        [HttpPost]
        public IHttpActionResult ProcessSalary(SalaryProcessVM salaryProcess)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                cmr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("SP_ProcessEmpSalary", new object[] { salaryProcess.PeriodId });
                cmr.message = Constant.SAVED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        [Route("Employee/processClear/")]
        [HttpPost]
        public IHttpActionResult processClear(SalaryProcessVM processClear)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                // var chk = DataAccess.Instance.SalaryPayDetailsService.Filter(e => e.).Count
                cmr = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("SP_processClear", new object[] { processClear.PeriodId });
                cmr.message = Constant.SAVED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        [Route("Employee/SearchGeneratePayrol/")]
        [HttpPost]
        public IHttpActionResult SearchGeneratePayrol(GeneratePayrolVM generatePayrol)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                if (generatePayrol.BranchID != 0)
                {
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPayrolList", new object[] { generatePayrol.CategoryID, generatePayrol.BranchID, generatePayrol.PeriodId, 1 });
                    cmr.results = res;
                    cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : Constant.NOT_FOUND;
                }
                else
                {
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPayrolList", new object[] { DBNull.Value, DBNull.Value, generatePayrol.PeriodId, 2 });
                    cmr.results = res;
                    cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : Constant.NOT_FOUND;

                }


            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        [Route("Employee/SearchGenerateSalaryHold/")]
        [HttpPost]
        public IHttpActionResult SearchGenerateSalaryHold(GeneratePayrolVM generateSalaryHold)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetSalaryHoldReportList", new object[] { generateSalaryHold.CategoryID, generateSalaryHold.BranchID });
                cmr.results = res;
                cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : Constant.NOT_FOUND;

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }


        [Route("Employee/SearchSalaryViewNEW")]
        [HttpPost]
        public IHttpActionResult SearchSalaryViewNEW(GeneratePayrolVM salaryView)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var data = DataAccess.Instance.SalaryPayDetailsService.Filter(e => e.SalaryPeriodId == salaryView.PeriodId).Count();
                if (data <= 0)
                {
                    throw new Exception("Salary process doesn't found !!");
                }
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSalaryviewList", new object[] { salaryView.CategoryID, salaryView.BranchID, salaryView.PeriodId });
                cmr.results = res;

                cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : "Already Comfirmed";
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        [Route("Employee/SalaryModify")]
        [HttpPost]
        public IHttpActionResult SalaryModify(SalaryModifyVM salaryModify)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (salaryModify != null)
                {
                    var res = true;

                    var row = DataAccess.Instance.SalaryPayDetailsService.Filter(p => p.Id == salaryModify.Id).Count();
                    if (row > 0)
                    {
                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SalaryModifyLog", new object[] { salaryModify.Id, salaryModify.CategoryID, salaryModify.EmpId, salaryModify.SalaryPeriodId });

                        SalaryPayDetails salaryPayDetails = new SalaryPayDetails();
                        salaryPayDetails.Id = salaryModify.Id;
                        salaryPayDetails.CategoryID = salaryModify.CategoryID;
                        salaryPayDetails.EmpId = salaryModify.EmpId;
                        salaryPayDetails.SalaryPeriodId = salaryModify.SalaryPeriodId;
                        salaryPayDetails.GrossAmount = salaryModify.GrossAmount;
                        salaryPayDetails.NetAmount = salaryModify.NetAmount;
                        salaryPayDetails.IsModified = true;
                        salaryPayDetails.UpdateBy = User.Identity.Name;
                        // salaryPayDetails.SetDate();
                        bool re = DataAccess.Instance.SalaryPayDetailsService.Update(salaryPayDetails);
                    }
                    else
                    {
                        throw new Exception("Paydetails id Not Found");
                    }







                    foreach (var item in salaryModify.AdditionDeductionVm)
                    {
                        var data = DataAccess.Instance.SalaryStructurePeriodService.Filter(p => p.Id == item.SalaryStructurePeriodId).ToList().FirstOrDefault();


                        data.Amount = item.Amount;
                        data.Remarks = item.Remarks;
                        data.IsModified = true;
                        data.UpdateBy = User.Identity.Name;
                        // data.SetDate();
                        bool re = DataAccess.Instance.SalaryStructurePeriodService.Update(data);

                    }


                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cr.results = res;
                    //}

                    //else
                    //{
                    //    cr.message = "Allready Adjusted";
                    //}
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Employee/ConfrimSalary")]
        [HttpPost]
        public IHttpActionResult ConfrimSalary(GeneratePayrolVM confirmSalary)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                //var ammount = DataAccess.Instance.LedgersService.Filter(l => l.LedgerId == 1677).FirstOrDefault().CurrentBalance;
                //if (ammount < confirmSalary.TotalSalary)
                //{
                //    throw new Exception("Insufficient funds");
                //}
                var addBy = User.Identity.Name;
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("Transactiondetailinsert_SalaryPayment", new object[] { confirmSalary.PeriodId, confirmSalary.BranchID, addBy });
                cmr.results = res;

                cmr.message = "Confirm Successfully";
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        [Route("Employee/SalaryDetailsEmpWise")]
        [HttpPost]
        public IHttpActionResult SalaryDetailsEmpWise(GeneratePayrolVM salarydetails)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSalaryDetailsEmpWise", new object[] { salarydetails.Id });
                cmr.results = res;

                cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : Constant.NOT_FOUND;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        [Route("Employee/PayslipListByEmpId")]
        [HttpPost]
        public IHttpActionResult PayslipListByEmpId()
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                int EmpId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("PayslipListByEmpId", new object[] { EmpId });
                cmr.results = res;

                cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : Constant.NOT_FOUND;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        #endregion


        #region Employee Request 
        [HttpGet]
        [Route("Employee/GetAllRequestList/")]
        public IHttpActionResult GetAllRequestList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var EmpId = DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId;

                var isLeaveQuataExists = DataAccess.Instance.CommonServices.IsExist("HR_EmpLeaveQuota", $" EmpId = {EmpId} AND IsDeleted = 0 AND RoutingId <> 0");
                if (!isLeaveQuataExists)
                {
                    throw new Exception("Your Leave Quota is not Set, Please Contact with HR/Administrator");
                }
                int Type = 2;                          // All Request List By EmpId
                //int EmpId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);

                var results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRequestList", new object[] { EmpId, Type });

                cr.results = results;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [HttpGet]
        [Route("Employee/GetAllCategory/")]
        public IHttpActionResult GetAllCategory()
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.EmpCategoryService.Filter(e => e.IsDeleted == false);
            return Json(cr);
        }

        [HttpPost]
        [Route("Employee/GetEmpLeaveBalance/")]
        public IHttpActionResult GetEmpLeaveBalance(EmpRequestVM empRequest)
        {
            CommonResponse cr = new CommonResponse();
            int EmpBasicInfoId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);
            var fromDate = Convert.ToDateTime(empRequest.From);
            var toDate = Convert.ToDateTime(empRequest.To);

            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@Block", 1));
            param.Add(new SqlParameter("@EmpBasicInfoId", EmpBasicInfoId));
            param.Add(new SqlParameter("@LeaveCategoryId", empRequest.LeaveCategoryId));
            param.Add(new SqlParameter("@FromDate", fromDate));
            param.Add(new SqlParameter("@ToDate", toDate));

            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpLeaveBalance", param.ToArray());
            cr.results = dt;
            return Json(cr);
        }

        [Route("Employee/GetLeaveQuota/")]
        [HttpGet]
        public IHttpActionResult GetLeaveQuota()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var EmpId = DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId;
                var leaveQuota = DataAccess.Instance.EmpLeaveQuotaService.Filter(e => e.EmpId == EmpId).Select(a => new { a.AnnualLeaveDay, a.SickLeaveDay, a.MaternityLeaveDay, a.AdvanceLeaveDay }).FirstOrDefault();
                if (leaveQuota == null || leaveQuota.AdvanceLeaveDay < 1 || leaveQuota.AnnualLeaveDay < 1 || leaveQuota.SickLeaveDay < 1 || leaveQuota.MaternityLeaveDay < 1)
                {
                    cr.results = null;
                }
                cr.results = leaveQuota;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                return Json(cr);
            }
            return Json(cr);

        }


        [Route("Employee/AddRequest/")]
        [HttpPost]
        public IHttpActionResult AddRequest()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["file"] : null;
                string value = HttpContext.Current.Request.Form["Request"] ?? "";

                var EmpId = DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId;
                var isLeaveQuataExists = DataAccess.Instance.CommonServices.IsExist("HR_EmpLeaveQuota", $" EmpId = {EmpId} AND IsDeleted = 0 AND RoutingId <> 0");
                if (!isLeaveQuataExists)
                {
                    throw new Exception("Your Leave Quota is not Set, Please Contact with HR/Administrator");
                }
                EmpRequest empRequest = JsonConvert.DeserializeObject<EmpRequest>(value); //  Deserialize Form Data

                if (empRequest.RequestType != 5)
                {
                    file = null;
                    empRequest.FromDate = DateTime.Now;
                    empRequest.ToDate = DateTime.Now;
                }
                else if (empRequest.RequestType == 5)
                {

                    if (empRequest.LeaveTypeCategory == "FD")
                    {
                        empRequest.FromDate = Convert.ToDateTime(empRequest.From);
                        empRequest.ToDate = Convert.ToDateTime(empRequest.To);
                    }
                    else
                    {
                        empRequest.FromDate = Convert.ToDateTime(empRequest.HalfDayDate);
                        empRequest.ToDate = Convert.ToDateTime(empRequest.HalfDayDate);
                    }
                    var dates = new List<DateTime>();

                    for (var dt = empRequest.FromDate; dt <= empRequest.ToDate; dt = dt.AddDays(1))
                    {
                        dates.Add(dt);
                    }
                }

                if (file != null)
                {
                    Image bm = Image.FromStream(file.InputStream);
                    Bitmap result = new Bitmap(bm.Width, bm.Height);
                    using (Graphics g = Graphics.FromImage((Image)result))
                        g.DrawImage(bm, 0, 0, bm.Width, bm.Height);
                    Byte[] data_image;
                    using (var memoryStream = new MemoryStream())
                    {
                        result.Save(memoryStream, ImageFormat.Bmp);
                        data_image = memoryStream.ToArray();
                    }
                    empRequest.File = data_image;
                }
                if (empRequest != null)
                {
                    empRequest.Date = DateTime.Now;
                    empRequest.EmpId = Convert.ToInt32(EmpId);
                    empRequest.UpdateBy = User.Identity.Name;
                    empRequest.UpdateDate = DateTime.Now;
                    empRequest.IsDeleted = false;
                    empRequest.Status = "Pending";
                    empRequest.SetDate();
                    empRequest.AddBy = User.Identity.Name;

                    empRequest.AddDate = DateTime.Now;
                    var res = DataAccess.Instance.EmpRequestService.Add(empRequest);
                    var id = empRequest.Id;
                    if (empRequest.Id > 0)
                    {
                        List<SqlParameter> param = new List<SqlParameter>();
                        param.Add(new SqlParameter("@LeaveId", empRequest.Id));
                        param.Add(new SqlParameter("@AddBy", User.Identity.Name));
                        param.Add(new SqlParameter("@IP", empRequest.IP));
                        param.Add(new SqlParameter("@MacAddress", empRequest.MacAddress));

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_LeaveRoutingHistory", param.ToArray());
                    }
                   
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    return Json(cr);
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                return Json(cr);
            }
            return Json(cr);

        }

        [Route("Employee/UpdateRequest/")]
        [HttpPost]
        public IHttpActionResult UpdateRequest()
        {
            CommonResponse cr = new CommonResponse();
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["file"] : null;
            string value = HttpContext.Current.Request.Form["Request"] ?? "";
            int EmpId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);

            EmpRequest empRequest = JsonConvert.DeserializeObject<EmpRequest>(value); //  Deserialize Form Data
            //empRequest.GetTime = empRequest.GetTime.AddHours(6);
            EmpRequest data = new EmpRequest();
            try
            {
                data = DataAccess.Instance.EmpRequestService.Filter(s => s.IsDeleted == false && s.Status == "Pending" && s.Id == empRequest.Id).FirstOrDefault();
                if (data != null)
                {
                    if (empRequest.RequestType == 2)
                    {
                        data.Date = empRequest.Date;
                        data.Description = empRequest.Description;
                    }
                    if (empRequest.RequestType == 7)
                    {
                        data.Date = empRequest.Date;

                    }
                    if (empRequest.RequestType == 4)
                    {
                        data.RequestType = empRequest.RequestType;
                        data.Reason = empRequest.Reason;
                        data.Description = empRequest.Description;

                    }
                    if (empRequest.RequestType == 6)
                    {
                        data.RequestType = empRequest.RequestType;
                        data.Reason = empRequest.Reason;
                        data.Description = empRequest.Description;

                    }
                    if (empRequest.RequestType == 3)
                    {
                        data.RequestType = empRequest.RequestType;
                        data.NOCType = empRequest.NOCType;
                        data.TravelDesination = empRequest.TravelDesination;
                        data.TravelFrom = empRequest.TravelFrom;
                        data.TravelTo = empRequest.TravelTo;
                        data.Description = empRequest.Description;
                    }
                    if (empRequest.RequestType != 5)
                    {
                        file = null;
                        data.FromDate = data.FromDate;
                        data.ToDate = data.ToDate;
                        data.RequestOn = data.RequestOn;
                    }
                    else if (empRequest.RequestType == 5)
                    {
                        data.RequestType = empRequest.RequestType;
                        data.FromDate = Convert.ToDateTime(empRequest.From);
                        data.ToDate = Convert.ToDateTime(empRequest.To);
                        data.RequestOn = Convert.ToDateTime(empRequest.Request);
                        data.Description = empRequest.Description;
                        var dates = new List<DateTime>();

                        for (var dt = data.FromDate; dt <= data.ToDate; dt = dt.AddDays(1))
                        {
                            dates.Add(dt);
                        }
                        // for chack IsPresent is exist in thouse days....
                        //foreach (DateTime d in dates)
                        //{
                        //    StudentAttendance st = DataAccess.Instance.StudentAttendanceService.GetAll().FirstOrDefault(s => s.InTime == d && s.IsPresent == true && s.StudentId == data.StudentId && s.IsDeleted == false);
                        //    if (st != null)
                        //    {
                        //        throw new Exception("Leave can't be applicable. " + d.ToString("dd/MM/yyyy") + " already Attend");
                        //    }
                        //}

                        List<EmpAcademicCalendarDetails> a = DataAccess.Instance.EmpAcademicCalandarDetailsService.Filter(e => e.DayType != "Regular" && (e.CalendarDate == data.FromDate || e.CalendarDate == data.ToDate)).ToList();
                        if (a.Count != 0)
                        {
                            throw new Exception("Date Range is Not Valid.");
                        }
                        int y = Convert.ToInt32(data.RequestOn.Value.ToString("yyyy"));
                        int M = Convert.ToInt32(data.RequestOn.Value.ToString("MM"));
                        List<EmpAcademicCalendarDetails> list = DataAccess.Instance.EmpAcademicCalandarDetailsService.Filter(c => c.IsDeleted == false && c.Year == y && c.Month == M && (c.DayType == "Weekend" || c.DayType == "Holiday")).ToList();
                        // DateTime d = new DateTime(empRequest.Date);
                        if (list.Count() > 0)
                        {
                            foreach (var item in list)
                            {

                                if (item.CalendarDate.ToString("MM/dd/yyyy") == data.RequestOn.Value.ToString("MM/dd/yyyy"))
                                {
                                    //cr.message = "You holiday Select.";
                                    return Json(0);
                                }
                            }
                        }
                        else
                        {
                            return Json(2); //Academic Clander does not Set up.
                        }
                        if (file != null)
                        {
                            Image bm = Image.FromStream(file.InputStream);
                            Bitmap result = new Bitmap(bm.Width, bm.Height);
                            using (Graphics g = Graphics.FromImage((Image)result))
                                g.DrawImage(bm, 0, 0, bm.Width, bm.Height);
                            Byte[] data_image;
                            using (var memoryStream = new MemoryStream())
                            {
                                result.Save(memoryStream, ImageFormat.Bmp);
                                data_image = memoryStream.ToArray();
                            }
                            data.File = data_image;
                        }

                    }


                    if (data != null)
                    {
                        if (data.RequestType == 1 || data.RequestType == 2)
                        {
                            if (data.RequestType == 1)
                            {
                                if (data.Time != empRequest.Time)
                                {
                                    if (empRequest.Time.Value.Hour < 11)
                                    {
                                        data.Time = empRequest.Time.Value.AddHours(-6);
                                        empRequest.Time = empRequest.Time.Value.AddHours(6);
                                    }
                                    else
                                    {
                                        data.Time = empRequest.Time.Value.AddHours(6);
                                        empRequest.Time = empRequest.Time.Value.AddHours(-6);

                                    }
                                }
                                //if (empRequest.CategoryId == 5)
                                //{
                                //    EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == empRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                                //    var st = empMeeting.StartTime.Value.Hour; //10 11
                                //    var et = empMeeting.EndTime.Value.Hour; //2
                                //    if (st > empRequest.Time.Value.Hour || empRequest.Time.Value.Hour > et)
                                //    {
                                //        cr.results = 3;
                                //        throw new Exception("Invalid Time");
                                //    }
                                //}
                                data.CategoryId = empRequest.CategoryId;
                                data.Reason = empRequest.Reason;
                                data.Date = empRequest.Date;
                                data.RequestType = empRequest.RequestType;

                            }

                            int y = Convert.ToInt32(empRequest.Date.Value.ToString("yyyy"));
                            int M = Convert.ToInt32(empRequest.Date.Value.ToString("MM"));
                            List<EmpAcademicCalendarDetails> list = DataAccess.Instance.EmpAcademicCalandarDetailsService.Filter(c => c.IsDeleted == false && c.Year == y && c.Month == M && (c.DayType == "Weekend" || c.DayType == "Holiday")).ToList();
                            // DateTime d = new DateTime(empRequest.Date);
                            if (list.Count() > 0)
                            {
                                foreach (var item in list)
                                {

                                    if (item.CalendarDate.ToString("MM/dd/yyyy") == empRequest.Date.Value.ToString("MM/dd/yyyy"))
                                    {
                                        //cr.message = "You holiday Select.";
                                        return Json(0);
                                    }
                                }
                            }
                            else
                            {
                                return Json(2); //Academic Clander does not Set up.
                            }

                        }
                        data.Date = Convert.ToDateTime(empRequest.date);
                        data.EmpId = data.EmpId;
                        data.UpdateBy = User.Identity.Name;
                        data.UpdateDate = DateTime.Now;

                        empRequest.IsDeleted = data.IsDeleted;
                        empRequest.Status = data.Status;
                        empRequest.SetDate();

                        var res = DataAccess.Instance.EmpRequestService.Update(data);
                        cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                        return Json(cr);
                    }
                }
                else
                {
                    cr.message = Constant.FAILED;
                    return Json(cr);
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                return Json(cr);
            }
            return Json(cr);

        }

        [HttpPost]
        [Route("Employee/DeleteRequest/{Id}")]
        public IHttpActionResult DeleteRequest(int Id)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.ExecuteSQLQUERY(@"SELECT LH.* FROM  HR_LeaveRoutingHistory LH INNER JOIN HR_LeaveRoutingConfigDetails RD ON RD.DetailsId = LH.RoutingId 
                                                                        WHERE  LH.LeaveId = " + Id + " AND RD.IsMandatory = 1 AND(LH.IsApprove = 1 OR LH.IsReject = 1)");
                if (dt.Rows.Count > 0)
                {
                    throw new Exception("Your Leave Application Already Received. ");
                }
                var res = DataAccess.Instance.EmpRequestService.Remove(Id);
                cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
            }
            catch (Exception ex)
            {
                cr.message = ex.Message;
            }
            return Json(cr);
        }
        #endregion

        #region  Employee Document List 
        [Route("Employee/GetDocumentList/")]
        [HttpGet]
        public IHttpActionResult GetDocumentList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalDocumentList", new object[] { 7, DBNull.Value, DBNull.Value, DBNull.Value });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);

        }

        [Route("Employee/GetNoticDocumentList/")]
        [HttpGet]
        public IHttpActionResult GetNoticDocumentList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var userName = User.Identity.GetUserName();
                int branchid = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == userName).FirstOrDefault().BranchID;
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalDocumentList", new object[] { 9, branchid, DBNull.Value, DBNull.Value });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);

        }

        #endregion

        // Get Employee basic Info for admin view
        [Route("Employee/GetEmpParrentMeetingList/")]
        [HttpGet]
        public IHttpActionResult GetEmpParrentMeetingList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var userid = User.Identity.GetUserId();
                var EmpId = DataAccess.Instance.Users.Filter(e => e.Id == userid).FirstOrDefault().EmpId;
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeMeetingList", new object[] { EmpId });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);

        }
        //


        [Route("Employee/AddEmpLIEO/")]
        [HttpPost]
        public IHttpActionResult AddEmpLIEO(EmpLIEO empLIEO)
        {
            CommonResponse cr = new CommonResponse();
            var ci = System.Globalization.CultureInfo.GetCultureInfo("en-us");

            try
            {

                empLIEO.EarlyOutTime = DateTime.Parse(empLIEO.EarlyOut, ci).TimeOfDay;
                empLIEO.EndTime = DateTime.Parse(empLIEO.End, ci).TimeOfDay;
                empLIEO.LateInTime = DateTime.Parse(empLIEO.LateIn, ci).TimeOfDay;
                empLIEO.StartTime = DateTime.Parse(empLIEO.Start, ci).TimeOfDay;
                //check already added or not

                var data1 = DataAccess.Instance.EmpLIFOService.Filter(e => e.EmpId == empLIEO.EmpId && e.IsDeleted == false).Any();
                if (data1)
                {
                    throw new Exception("Teacher Data Exist");
                }
                else
                {
                    empLIEO.AddBy = User.Identity.Name;
                    empLIEO.SetDate();
                    empLIEO.Status = "A";
                    empLIEO.IsDeleted = false;
                    var res = DataAccess.Instance.EmpLIFOService.Add(empLIEO);
                    cr.results = res;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                }

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                cr.ttype = "info";
                var re = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("Attendence", new object[] { 2, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value }).results;
                cr.results = re;
            }
            return Json(cr);
        }

        [Route("Employee/GetEmpLIEO/")]
        [HttpGet]
        public IHttpActionResult GetEmpLIEO()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeLIFOList", new object[] { });
                //var res = DataAccess.Instance.EmpLIFOService.Filter(e=>e.IsDeleted==false).ToList();
                cr.message = dt.Rows.Count.ToString() + " data found";
                cr.results = dt;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                cr.ttype = "info";
            }
            return Json(cr);
        }

        [Route("Employee/GetLIEOById/{LIEOId}")]
        [HttpGet]
        public IHttpActionResult GetLIEOById(int LIEOId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeLIFOList", new object[] { LIEOId });
                var dt = DataAccess.Instance.EmpLIFOService.SingleOrDefault(x => x.LIEOId == LIEOId);
                cr.results = dt;
                cr.httpStatusCode = dt != null ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = dt != null ? Constant.DATA_EXISTS : Constant.NOT_FOUND;

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                cr.ttype = "info";
            }

            return Json(cr);
        }

        [Route("Employee/EditEmployeeLIEO/")]
        [HttpPost]
        public IHttpActionResult EditEmployeeLIEO(EmpLIEO empLIEO)
        {
            CommonResponse cr = new CommonResponse();
            var ci = System.Globalization.CultureInfo.GetCultureInfo("en-us");
            //EmpLIEO empLIEO = DataAccess.Instance.EmpLIFOService.SingleOrDefault(x => x.LIEOId == empLIEO.LIEOId);
            try
            {

                empLIEO.EarlyOutTime = DateTime.Parse(empLIEO.EarlyOut, ci).TimeOfDay;
                empLIEO.EndTime = DateTime.Parse(empLIEO.End, ci).TimeOfDay;
                empLIEO.LateInTime = DateTime.Parse(empLIEO.LateIn, ci).TimeOfDay;
                empLIEO.StartTime = DateTime.Parse(empLIEO.Start, ci).TimeOfDay;
                //check already added or not

                //var data1 = DataAccess.Instance.EmpLIFOService.Filter(e => e.EmpId == empLIEO.EmpId && e.IsDeleted == false).Any();
                //if (data1)
                //{
                //    throw new Exception("Teacher Data Exist");
                //}
                //else
                //{
                empLIEO.UpdateBy = User.Identity.Name;
                empLIEO.SetDate();
                empLIEO.Status = "A";
                empLIEO.IsDeleted = false;
                var res = DataAccess.Instance.EmpLIFOService.Update(empLIEO);
                cr.results = res;
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                //}

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                cr.ttype = "info";
                //var re = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("Attendence", new object[] { 2, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value }).results;
                //cr.results = re;
            }
            return Json(cr);
        }

        [Route("Employee/DeleteEmployeeLIEO/{LIEOId}")]
        [HttpPost]
        public IHttpActionResult DeleteEmployeeLIEO(int LIEOId)
        {
            CommonResponse cr = new CommonResponse();
            bool res = DataAccess.Instance.EmpLIFOService.Remove(Convert.ToInt64(LIEOId)); cr.results = res;
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }


        [Route("Employee/ShowStudentAttendenceByClassTeacher/{date}")]
        [HttpGet]
        public IHttpActionResult ShowStudentAttendenceByClassTeacher(string date)
        {
            string UserId = User.Identity.GetUserId();
            DateTime Date = Convert.ToDateTime(date);

            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("StudentAttendenceByClassTeacher", new object[] { UserId, Date }).results;
                if (res.Rows.Count > 0)
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.results = res;
                }
                else
                {
                    throw new Exception("No Data Found");
                }
                //cr.httpStatusCode = HttpStatusCode.OK;
                //cr.results = res;
                //cr.message= Constant.SAVED ;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }


            return Json(cr);
        }



        #region HR Payroll 

        [Route("Employee/AllEmployeeRequest/")]
        [HttpGet]
        public IHttpActionResult GetAllEmployeeRequest()
        {
            CommonResponse cr = new CommonResponse();
            int Type = 8;
            //int EmpId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);

            var results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRequestList", new object[] { DBNull.Value, Type });

            cr.results = results;
            return Json(cr);
        }

        [Route("Employee/UpdateStatus/{Id}/{Status}")]
        [HttpPost]
        public IHttpActionResult UpdateStatusAllEmployeeRequest(int Id, string Status)
        {
            LeaveCategory leaveCategory = new LeaveCategory();
            CommonResponse cr = new CommonResponse();
            EmpRequest empRequest = DataAccess.Instance.EmpRequestService.SingleOrDefault(x => x.Id == Id);

            if (empRequest.RequestType == 5)
            {
                empRequest.LeaveCategoryId = leaveCategory.Id;
                empRequest.Status = Status;
                empRequest.IsDeleted = false;
                var res = DataAccess.Instance.EmpRequestService.Update(empRequest);
                if (res)
                {
                    empRequest.Status = Status;
                }
                else
                {
                    cr.message = Constant.UPDATED_ERROR;
                    return Json(cr);
                }

            }

            if (empRequest.RequestType == 3 || empRequest.RequestType == 4 || empRequest.RequestType == 6)
            {
                empRequest.Status = Status;
                empRequest.IsDeleted = false;
                var res = DataAccess.Instance.EmpRequestService.Update(empRequest);
                if (res)
                {
                    empRequest.Status = Status;
                }
                else
                {
                    cr.message = Constant.UPDATED_ERROR;
                    return Json(cr);
                }
            }

            empRequest.UpdateBy = User.Identity.GetUserId();
            empRequest.UpdateDate = DateTime.Now;
            var results = DataAccess.Instance.EmpRequestService.Update(empRequest);
            cr.message = results ? Constant.UPDATED : Constant.UPDATED_ERROR;
            return Json(cr);
        }

        [Route("Employee/GetEmployeeRequestByMeeting/")]
        [HttpGet]
        public IHttpActionResult GetEmployeeRequestByMeeting()
        {
            CommonResponse cr = new CommonResponse();
            int Type = 7;
            //int EmpId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);

            //var results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRequestList", new object[] { null, Type });
            var results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRequestList", new object[] { DBNull.Value, Type });
            cr.results = results;
            return Json(cr);
        }

        [Route("Employee/UpdateStatusMeeting/{Id}/{Status}")]
        [HttpPost]
        public IHttpActionResult UpdateStatusMeetingRequest(int Id, string Status)
        {
            CommonResponse cr = new CommonResponse();
            EmpRequest empRequest = DataAccess.Instance.EmpRequestService.SingleOrDefault(x => x.Id == Id);

            if (empRequest.RequestType == 1)
            {
                empRequest.Status = Status;
                empRequest.IsDeleted = false;
                var res = DataAccess.Instance.EmpRequestService.Add(empRequest);
                if (res)
                {
                    empRequest.Status = Status;
                }
                else
                {
                    cr.message = Constant.UPDATED_ERROR;
                    return Json(cr);
                }
            }

            empRequest.UpdateBy = User.Identity.GetUserId();
            empRequest.UpdateDate = DateTime.Now;
            var results = DataAccess.Instance.EmpRequestService.Update(empRequest);
            cr.message = results ? Constant.UPDATED : Constant.UPDATED_ERROR;
            return Json(cr);
        }

        [Route("Employee/GetEmployeeLeaveRequestList/")]
        [HttpPost]
        public IHttpActionResult GetEmployeeLeaveRequestList(LeaveInfoVM leaveInfo)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();
                
                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@FromDate", leaveInfo.FromDate));
                param.Add(new SqlParameter("@ToDate", leaveInfo.ToDate));
                param.Add(new SqlParameter("@UserId", User.Identity.GetUserId()));
                param.Add(new SqlParameter("@CalendarId ", leaveInfo.CalendarId));
                param.Add(new SqlParameter("@Status ", leaveInfo.Status));

                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeLeaveRequestList", param.ToArray());

                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Employee/LeaveDetailsEmpWise")]
        [HttpPost]
        public IHttpActionResult LeaveDetailsEmpWise(LeaveInfoVM leavedetails)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();

                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@ID", leavedetails.EmpRequestId));
                param.Add(new SqlParameter("@EmpId", leavedetails.EmpId));
                param.Add(new SqlParameter("@UserId", DBNull.Value));

                DataSet ds = DataAccess.Instance.CommonServices.GetDatasetBySp("GetLeaveDetailsEmpWise", param.ToArray());

                LeaveInfoDetailsVM _leaveDetails = new LeaveInfoDetailsVM();
                _leaveDetails = APIUitility.ConvertDataTable<LeaveInfoDetailsVM>(ds.Tables[0]).FirstOrDefault();
                List<LeaveRequestDetail> _leaveRequestList = new List<LeaveRequestDetail>();
                _leaveRequestList = APIUitility.ConvertDataTable<LeaveRequestDetail>(ds.Tables[1]).ToList();
                List<LeaveRoutingHistoryVM> _leaveRoutingHistoryList = new List<LeaveRoutingHistoryVM>();
                _leaveRoutingHistoryList = APIUitility.ConvertDataTable<LeaveRoutingHistoryVM>(ds.Tables[2]).ToList();

                _leaveDetails.LeaveRequestDetailsList = _leaveRequestList;
                _leaveDetails.LeaveRoutingHistoryList = _leaveRoutingHistoryList;
                cmr.results = _leaveDetails;

                //cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : Constant.NOT_FOUND;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        [Route("Employee/ViewLeaveDetailsEmpWise")]
        [HttpPost]
        public IHttpActionResult ViewLeaveDetailsEmpWise(LeaveInfoVM leavedetails)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();

                var userId = User.Identity.GetUserId();

                param.Add(new SqlParameter("@Block", 2));
                param.Add(new SqlParameter("@ID", leavedetails.EmpRequestId));
                param.Add(new SqlParameter("@EmpId", leavedetails.EmpId));
                param.Add(new SqlParameter("@UserId", userId));

                DataSet ds = DataAccess.Instance.CommonServices.GetDatasetBySp("GetLeaveDetailsEmpWise", param.ToArray());

                LeaveInfoDetailsVM _leaveDetails = new LeaveInfoDetailsVM();
                _leaveDetails = APIUitility.ConvertDataTable<LeaveInfoDetailsVM>(ds.Tables[0]).FirstOrDefault();

                List<LeaveRequestDetail> _leaveRequestList = new List<LeaveRequestDetail>();
                _leaveRequestList = APIUitility.ConvertDataTable<LeaveRequestDetail>(ds.Tables[1]).ToList();

                List<LeaveRoutingHistoryVM> _leaveRoutingHistoryList = new List<LeaveRoutingHistoryVM>();
                _leaveRoutingHistoryList = APIUitility.ConvertDataTable<LeaveRoutingHistoryVM>(ds.Tables[2]).ToList();

                List<LeaveQuotaVM> _leaveQuotaList = new List<LeaveQuotaVM>();
                _leaveQuotaList = APIUitility.ConvertDataTable<LeaveQuotaVM>(ds.Tables[3]).ToList();

                _leaveDetails.LeaveRequestDetailsList = _leaveRequestList;
                _leaveDetails.LeaveRoutingHistoryList = _leaveRoutingHistoryList;
                _leaveDetails.LeaveQuotaList = _leaveQuotaList;

                cmr.results = _leaveDetails;
                //cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : Constant.NOT_FOUND;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }


        [Route("Employee/LeaveSummaryEmpWise")]
        [HttpPost]
        public IHttpActionResult LeaveSummaryEmpWise(LeaveInfoVM leaveSummary)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetLeaveSummaryEmpWise", new object[] { leaveSummary.EmpId });
                cmr.results = res;

                cmr.message = res.Rows.Count > 0 ? res.Rows.Count + " Data Found." : Constant.NOT_FOUND;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        [Route("Employee/LeaveApproveEmpWise")]
        [HttpPost]
        public IHttpActionResult LeaveApproveEmpWise(LeaveInfoDetailsVM leaveSummary)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {

                var ApproveBy = User.Identity.Name;
                List<LeaveRequestDetails> list = new List<LeaveRequestDetails>();


                //if (leaveSummary.LeaveRequestDetailsList.Any(e=>e.AdjustLeave==0))
                //{
                //    foreach (var item in leaveSummary.LeaveRequestDetailsList)
                //    {
                //        if (item.AdjustLeave > 0)
                //        {
                //            break;
                //        }
                //    }

                //    if (leaveSummary.WithOutpay==0 || leaveSummary.Withpay == 0)
                //    {
                //        throw new Exception("Unadjusted Leave Not Found!");
                //    }
                //    throw new Exception("Adjusted Leave Not Found!");
                //}
                foreach (var item in leaveSummary.LeaveRequestDetailsList)
                {
                    list.Add(new LeaveRequestDetails()
                    {
                        LeaveId = item.LeaveId,
                        EmpId = item.EmpId,
                        EligibleLeave = item.EligibleDays,
                        LeaveAvailable = item.LeaveAvailed,
                        LeaveInHand = item.LeaveInHand,
                        WithPayLeave = leaveSummary.Withpay,
                        WithoutPayLeave = leaveSummary.WithOutpay,
                        LeaveCategoryId = item.LeaveCategoryId,
                        AdjustLeave = item.AdjustLeave,
                        AddBy = User.Identity.Name,
                        AddDate = DateTime.Now,
                        Status = "A",
                        IsDeleted = false
                    });
                }

                DataAccess.Instance.LeaveRequestDetailsService.AddRange(list);

                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_ApproveLeave", new object[] { leaveSummary.EmpRequestId, leaveSummary.Adjustable, leaveSummary.Unadjusted, leaveSummary.Withpay, leaveSummary.WithOutpay, leaveSummary.MaternityLeaveType, ApproveBy,leaveSummary.LeaveHistoryId,leaveSummary.Comments });
                cmr.results = res;
                cmr.message = " Request Successfull.";

     
                //var data = DataAccess.Instance.CommonServices.GetBySpWithParam("Sandwichleave", new object[] { leaveSummary.EmpRequestId });
                //if (data.Rows.Count > 0)
                //{
                //    leaveSummary.Adjustable = data.Rows[0].Field<int>("Adjustable");
                //    leaveSummary.Unadjusted = data.Rows[0].Field<int>("Unadjusted");
                //    leaveSummary.WithOutpay = data.Rows[0].Field<int>("Unadjusted");

                //    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_ApproveLeave", new object[] { leaveSummary.EmpRequestId, leaveSummary.Adjustable, leaveSummary.Unadjusted, leaveSummary.Withpay, leaveSummary.WithOutpay, leaveSummary.MaternityLeaveType, ApproveBy });
                //    cmr.results = res;

                //    cmr.message = " Request Successfull.";

                //}
                //else
                //{
                //    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_ApproveLeave", new object[] { leaveSummary.EmpRequestId, leaveSummary.Adjustable, leaveSummary.Unadjusted, leaveSummary.Withpay, leaveSummary.WithOutpay, leaveSummary.MaternityLeaveType, ApproveBy });
                //    cmr.results = res;
                //    cmr.message = " Request Successfull.";
                //}


            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        [Route("Employee/LeaveRejectEmpWise")]
        [HttpPost]
        public IHttpActionResult LeaveRejectEmpWise(LeaveInfoDetailsVM leaveSummary)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                //var ApproveBy = User.Identity.Name;
                //var res = DataAccess.Instance.EmpRequestService.Filter(e => e.Id == leaveReject.EmpRequestId).Count();
                //if (res < 0)
                //{
                //    throw new Exception("Request Id Not Found");
                //}
                //else
                //{

                //    var result = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RejectLeave", new object[] { leaveReject.EmpRequestId, ApproveBy });
                //    cmr.results = result;

                //    cmr.message = " Request Successfull.";

                //}
                var ApproveBy = User.Identity.Name;
                List<LeaveRequestDetails> list = new List<LeaveRequestDetails>();

                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RejectLeave", new object[] { leaveSummary.EmpRequestId, leaveSummary.Adjustable, leaveSummary.Unadjusted, leaveSummary.Withpay, leaveSummary.WithOutpay, leaveSummary.MaternityLeaveType, ApproveBy, leaveSummary.LeaveHistoryId, leaveSummary.Comments });
                cmr.results = res;
                cmr.message = " Request Successfull.";

                foreach (var item in leaveSummary.LeaveRequestDetailsList)
                {
                    list.Add(new LeaveRequestDetails()
                    {
                        LeaveId = item.LeaveId,
                        EmpId = item.EmpId,
                        EligibleLeave = item.EligibleDays,
                        LeaveAvailable = item.LeaveAvailed,
                        LeaveInHand = item.LeaveInHand,
                        WithPayLeave = leaveSummary.Withpay,
                        WithoutPayLeave = leaveSummary.WithOutpay,
                        LeaveCategoryId = item.LeaveCategoryId,
                        AdjustLeave = item.AdjustLeave,
                        AddBy = User.Identity.Name,
                        AddDate = DateTime.Now,
                        Status = "A",
                        IsDeleted = false
                    });
                }

                DataAccess.Instance.LeaveRequestDetailsService.AddRange(list);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }
        [Route("Employee/GetEmpIncometaxList/")]
        [HttpPost]
        public IHttpActionResult GetEmpIncometaxList(EmpTaxListVM empTaxList)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable res;
                List<SqlParameter> param = new List<SqlParameter>();
                if (empTaxList.TaxYearId == 0)
                {
                    throw new Exception("Please Select Tax year");
                }

                param.Add(new SqlParameter("@TaxYearId", empTaxList.TaxYearId));
                param.Add(new SqlParameter("@CategoryId", empTaxList.CategoryID));
                param.Add(new SqlParameter("@EmpId", empTaxList.EmpId));
                param.Add(new SqlParameter("@BranchID", empTaxList.BranchID));
                res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeTaxList", param.ToArray());

                if (res.Rows.Count > 0)
                {
                    cr.results = res;

                }
                else
                {
                    throw new Exception("Please Setup Tax Year");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Employee/AddEmpTaxList/")]
        [HttpPost]
        public IHttpActionResult AddEmpTaxList(List<EmpTaxListVM> empTaxList)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dt;

                foreach (var item in empTaxList)
                {
                    List<SqlParameter> param = new List<SqlParameter>();



                    param.Add(new SqlParameter("@EmpId", item.EmpBasicInfoID));
                    param.Add(new SqlParameter("@EmpCategory", item.CategoryID));
                    param.Add(new SqlParameter("@CurrentSalary", item.CurrentSalary));
                    param.Add(new SqlParameter("@TaxAmount", item.TaxAmount));
                    param.Add(new SqlParameter("@TaxYearId", item.TaxYearId));
                    param.Add(new SqlParameter("@AddBy", User.Identity.Name));



                    dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertEmpTaxList", param.ToArray());



                    if (dt.Rows.Count > 0)
                    {
                        cr.message = Constant.SAVED;
                    }

                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        #endregion

        #region Leave Config
        [Route("Employee/GetAllLeaveRoutingConfig/")]
        [HttpGet]
        public IHttpActionResult GetAllLeaveRoutingConfig()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySp("GetLeaveRoutingConfigList");
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("Employee/GetLeaveRoutingConfigDetailsById/{routingId}")]
        [HttpGet]
        public IHttpActionResult GetLeaveRoutingConfigDetailsById(int routingId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetLeaveRoutingConfigDetails", new object[] { 1, routingId });
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Employee/AddLeaveRoutingConfig")]
        [HttpPost]
        public IHttpActionResult AddLeaveRoutingConfig(LeaveRoutingConfig routeConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (routeConfig != null && routeConfig.LeaveRoutingConfigDetailsList.Count > 0)
                {
                    routeConfig.AddDate = DateTime.Now;
                    routeConfig.AddBy = User.Identity.Name;
                    routeConfig.IsDeleted = false;
                    routeConfig.Status = "A";
                    routeConfig.SetDate();
                    var res = DataAccess.Instance.LeaveRoutingConfigService.Add(routeConfig);
                    List<LeaveRoutingConfigDetails> _list = new List<LeaveRoutingConfigDetails>();

                    if (res)
                    {
                        foreach (var item in routeConfig.LeaveRoutingConfigDetailsList)
                        {
                            LeaveRoutingConfigDetails _routeConfigDetails = new LeaveRoutingConfigDetails();
                            _routeConfigDetails.RoutingId = routeConfig.RoutingId;
                            _routeConfigDetails.NextApproval = item.NextApproval;
                            _routeConfigDetails.SerialNo = item.SerialNo;
                            _routeConfigDetails.IsMandatory = item.IsMandatory;
                            _routeConfigDetails.IsFinalApprove = item.IsFinalApprove;
                            _routeConfigDetails.Status = "A";
                            _routeConfigDetails.AddBy = User.Identity.Name;
                            _routeConfigDetails.AddDate = DateTime.Now;
                            _routeConfigDetails.IsDeleted = false;
                            _routeConfigDetails.SetDate();
                            _list.Add(_routeConfigDetails);
                        }
                        DataAccess.Instance.LeaveRoutingConfigDetailsService.AddRange(_list);
                    }
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cr.ttype = res ? "success" : "error";
                    cr.results = res;
                }
                else
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Employee/AddLeaveRoutingConfigDetails")]
        [HttpPost]
        public IHttpActionResult AddLeaveRoutingConfigDetails(LeaveRoutingConfigDetails routeConfigDetails)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (routeConfigDetails != null && routeConfigDetails.RoutingId != 0)
                {
                    routeConfigDetails.AddDate = DateTime.Now;
                    routeConfigDetails.AddBy = User.Identity.Name;
                    routeConfigDetails.IsDeleted = false;
                    routeConfigDetails.Status = "A";
                    routeConfigDetails.SetDate();
                    var res = DataAccess.Instance.LeaveRoutingConfigDetailsService.Add(routeConfigDetails);
                    if (res)
                    {
                        cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                        cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                        cr.ttype = res ? "success" : "error";
                        cr.results = res;
                    }
                }
                else
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Employee/UpdateLeaveRoutingConfig")]
        [HttpPut]
        public IHttpActionResult UpdateLeaveRoutingConfig(LeaveRoutingConfig routeConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (routeConfig != null && routeConfig.LeaveRoutingConfigDetailsList.Count > 0 && routeConfig.RoutingId > 0)
                {
                    LeaveRoutingConfig _routeConfig = new LeaveRoutingConfig();
                    _routeConfig = DataAccess.Instance.LeaveRoutingConfigService.Filter(e => e.RoutingId == routeConfig.RoutingId && e.IsDeleted == false).FirstOrDefault();
                    _routeConfig.RouteName = routeConfig.RouteName;
                    _routeConfig.UpdateBy = User.Identity.Name;
                    _routeConfig.UpdateDate = DateTime.Now;
                    _routeConfig.SetDate();
                    DataAccess.Instance.LeaveRoutingConfigService.Update(_routeConfig);

                    bool res = false;

                    foreach (var item in routeConfig.LeaveRoutingConfigDetailsList)
                    {
                        LeaveRoutingConfigDetails _routeConfigDetails = DataAccess.Instance.LeaveRoutingConfigDetailsService.Filter(e => e.DetailsId == item.DetailsId).FirstOrDefault();
                        if(_routeConfigDetails == null)
                        {
                            LeaveRoutingConfigDetails _routeConfigDetailsNew = new LeaveRoutingConfigDetails();
                            _routeConfigDetailsNew.RoutingId = routeConfig.RoutingId;
                            _routeConfigDetailsNew.NextApproval = item.NextApproval;
                            _routeConfigDetailsNew.SerialNo = item.SerialNo;
                            _routeConfigDetailsNew.IsMandatory = item.IsMandatory;
                            _routeConfigDetailsNew.IsFinalApprove = item.IsFinalApprove;
                            _routeConfigDetailsNew.Status = "A";
                            _routeConfigDetailsNew.AddBy = User.Identity.Name;
                            _routeConfigDetailsNew.AddDate = DateTime.Now;
                            _routeConfigDetailsNew.IsDeleted = false;
                            _routeConfigDetailsNew.SetDate();
                            res = DataAccess.Instance.LeaveRoutingConfigDetailsService.Add(_routeConfigDetailsNew);
                        }
                        else
                        {
                            _routeConfigDetails.RoutingId = routeConfig.RoutingId;
                            _routeConfigDetails.NextApproval = item.NextApproval;
                            _routeConfigDetails.SerialNo = item.SerialNo;
                            _routeConfigDetails.IsMandatory = item.IsMandatory;
                            _routeConfigDetails.IsFinalApprove = item.IsFinalApprove;
                            _routeConfigDetails.Status = "A";
                            _routeConfigDetails.AddBy = User.Identity.Name;
                            _routeConfigDetails.AddDate = DateTime.Now;
                            _routeConfigDetails.IsDeleted = false;
                            _routeConfigDetails.SetDate();
                            res = DataAccess.Instance.LeaveRoutingConfigDetailsService.Update(_routeConfigDetails);
                        }                       
                    }
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    cr.ttype = res ? "success" : "error";
                    cr.results = res;
                }
                else
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Employee/DeleteLeaveRoutingConfig/{routingId}")]
        [HttpDelete]
        public IHttpActionResult DeleteLeaveRoutingConfig(int routingId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                LeaveRoutingConfig routeConfig = new LeaveRoutingConfig();
                routeConfig = DataAccess.Instance.LeaveRoutingConfigService.Get(routingId);

                if (routeConfig != null && routeConfig.RoutingId > 0)
                {
                    bool res = false;
                    routeConfig.UpdateBy = User.Identity.Name;
                    routeConfig.IsDeleted = true;
                    routeConfig.SetDate();
                    
                    if (routingId > 0)
                    {
                        List<LeaveRoutingConfigDetails> leaveRouteConfigDetailsList = new List<LeaveRoutingConfigDetails>();
                        leaveRouteConfigDetailsList = DataAccess.Instance.LeaveRoutingConfigDetailsService.Filter(e => e.RoutingId == routingId).ToList();
                        if (leaveRouteConfigDetailsList.Count > 0)
                        {                            
                            foreach (var item in leaveRouteConfigDetailsList)
                            {
                                var isLeaveQuataExists = DataAccess.Instance.CommonServices.IsExist("HR_LeaveRoutingHistory", $" RoutingId = {item.DetailsId} AND IsDeleted = 0");
                                if (isLeaveQuataExists)
                                {
                                    throw new Exception("Leave Exist Under this Route!!");
                                }
                                item.IsDeleted = true;
                                item.UpdateBy = User.Identity.Name;
                                item.UpdateDate = DateTime.Now;
                            }
                            var detailResponse = DataAccess.Instance.LeaveRoutingConfigDetailsService.UpdateRange(leaveRouteConfigDetailsList);
                        }                        
                    }
                    res = DataAccess.Instance.LeaveRoutingConfigService.Update(routeConfig);
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    return Json(cr);
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("Employee/DeleteLeaveRoutingConfigDetails/{detailsId}")]
        [HttpDelete]
        public IHttpActionResult DeleteLeaveRoutingConfigDetails(int detailsId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                LeaveRoutingConfigDetails routeConfigDetails = new LeaveRoutingConfigDetails();
                routeConfigDetails = DataAccess.Instance.LeaveRoutingConfigDetailsService.Get(detailsId);
                var isLeaveQuataExists = DataAccess.Instance.CommonServices.IsExist("HR_LeaveRoutingHistory", $" RoutingId = {detailsId} AND IsDeleted = 0");
                if (isLeaveQuataExists)
                {
                    throw new Exception("Leave Exist Under this Route!!");
                }

                if (routeConfigDetails != null && routeConfigDetails.DetailsId > 0)
                {
                    bool res = false;
                    routeConfigDetails.UpdateDate = DateTime.Now;
                    routeConfigDetails.UpdateBy = User.Identity.Name;
                    routeConfigDetails.IsDeleted = true;
                    routeConfigDetails.SetDate();
                    res = DataAccess.Instance.LeaveRoutingConfigDetailsService.Update(routeConfigDetails);
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    return Json(cr);
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("Employee/GetEmpByDesignation/{designationId}")]
        [HttpGet]
        public IHttpActionResult GetEmpByDesignation(int designationId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpByDesignation", new object[] { 1, designationId });
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Employee/getDeginationByDesig/{designationId}")]
        [HttpGet]
        public IHttpActionResult getDeginationByDesig(int designationId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpByDesignation", new object[] { 2, designationId });
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Employee/UpdateLeaveRoutingConfigDetails")]
        [HttpPut]
        public IHttpActionResult UpdateLeaveRoutingConfigDetails(LeaveRoutingConfigDetails routeConfigDetails)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                LeaveRoutingConfigDetails _routeConfigDetails = new LeaveRoutingConfigDetails();
                _routeConfigDetails = DataAccess.Instance.LeaveRoutingConfigDetailsService.Get(routeConfigDetails.DetailsId);
                if (_routeConfigDetails != null)
                {
                    //var list = DataAccess.Instance.LeaveRoutingConfigDetailsService.Filter(e => e.DetailsId != routeConfigDetails.DetailsId && e.IsDeleted == false).ToList();


                    _routeConfigDetails.NextApproval = routeConfigDetails.NextApproval;
                    _routeConfigDetails.SerialNo = routeConfigDetails.SerialNo;
                    _routeConfigDetails.IsMandatory = routeConfigDetails.IsMandatory;
                    _routeConfigDetails.IsFinalApprove = routeConfigDetails.IsFinalApprove;

                    _routeConfigDetails.UpdateBy = User.Identity.Name;
                    _routeConfigDetails.UpdateDate = DateTime.Now;
                    _routeConfigDetails.SetDate();

                    var response = DataAccess.Instance.LeaveRoutingConfigDetailsService.Update(_routeConfigDetails);

                    cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = response ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    cr.ttype = response ? "success" : "error";
                    cr.results = response;
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        [Route("Employee/LeaveRouteApprove")]
        [HttpPut]
        public IHttpActionResult LeaveRouteApprove(LeaveInfoVM routeConfigDetails)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                LeaveRoutingHistory _routeConfigDetails = new LeaveRoutingHistory();
                _routeConfigDetails = DataAccess.Instance.LeaveRoutingHistoryService.Get(routeConfigDetails.LeaveHistoryId);
                if (_routeConfigDetails != null)
                {
                    _routeConfigDetails.Comments = routeConfigDetails.Comments;
                    _routeConfigDetails.UpdateBy = User.Identity.Name;
                    _routeConfigDetails.UpdateDate = DateTime.Now;
                    if (routeConfigDetails.LeaveStatus=="A")
                    {
                        _routeConfigDetails.IsApprove = true;
                        _routeConfigDetails.IsReject = false;                    

                    }
                    else if (routeConfigDetails.LeaveStatus == "R")
                    {
                        _routeConfigDetails.IsReject = true;
                        _routeConfigDetails.IsApprove = false;
                        _routeConfigDetails.RejectedBy = User.Identity.Name;
                    }

                    var response = DataAccess.Instance.LeaveRoutingHistoryService.Update(_routeConfigDetails);
                    if (response)
                    {
                        var empId = DataAccess.Instance.EmpRequestService.Filter(e => e.Id == _routeConfigDetails.LeaveId).FirstOrDefault().EmpId;                
                        CommunicationService.PushNotification(empId, 2, routeConfigDetails.LeaveHistoryId + " - " + routeConfigDetails.LeaveStatus, "Leave Status", 0, 0, 0);
                    }
                    cr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = response ? Constant.UPDATED : Constant.UPDATED_ERROR;
                    cr.ttype = response ? "success" : "error";
                    cr.results = response;
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        #endregion

       

    }
}

