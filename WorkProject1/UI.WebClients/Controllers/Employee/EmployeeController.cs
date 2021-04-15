using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using OEMS.Api;
using OEMS.Api.Providers;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Employee;
using OEMS.Models.ViewModel;
using OEMS.Service.Services;
using System.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static OEMS.Models.Constant.Enums;
using OEMS.Models.Model.Document;
using OEMS.Models.ViewModel.Employee;
using System.Globalization;

namespace UI.WebClients.Controllers.Employee
{
    [ViewAuth]
    public class EmployeeController : BaseController
    {

        public ActionResult GetEmpPortalDashBoardData()
        {
            PortalEmpDashboardVM dasboard = new PortalEmpDashboardVM();
            var userid = User.Identity.GetUserId();
            var EmpUser = DataAccess.Instance.Users.Filter(e => e.Id == userid).FirstOrDefault().EmpId;
            int BasicInfoId = Convert.ToInt32(EmpUser);
            DataSet ds = DataAccess.Instance.CommonServices.GetDatasetBySp("GetEmpPortalDashBoardData", new object[] { BasicInfoId });
            if (ds.Tables[1].Rows.Count > 0)
            {
                dasboard.TotalPresent = Convert.ToInt32(ds.Tables[1].Rows[0]["TotalPresent"]);
                dasboard.TotalAbsent = Convert.ToInt32(ds.Tables[1].Rows[0]["TotalAbsent"]);
                dasboard.PeresentPercent = Convert.ToDecimal(ds.Tables[1].Rows[0]["PeresentPercent"]);
                dasboard.AbsentPercent = Convert.ToDecimal(ds.Tables[1].Rows[0]["AbsentPercent"]);
                //dasboard.FeesMonth = ds.Tables[0].Rows[0]["FeesMonth"].ToString();

            }
            if (ds.Tables[2].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[1].Rows)
                {
                    dasboard.SMSList.Add(new SMSList
                    {
                        SendDateTime = dr["SendDateTime"].ToString(),
                        SMSBody = dr["SMSBody"].ToString()
                    });
                }
            }
            if (ds.Tables[3].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[3].Rows)
                {
                    dasboard.CurrMonthAttendance.Add(new MonthlyAttendance
                    {
                        CalendarDate = dr["CalendarDate"].ToString(),
                        ClassName = dr["ClassName"].ToString(),
                        DayStaus = dr["DayStaus"].ToString(),
                        DayType = dr["DayType"].ToString(),
                        HolidayName = dr["HolidayName"].ToString(),
                        EarlyOut = dr["EO"].ToString(),
                        LateIN = dr["LI"].ToString(),
                    });
                }
            }
            if (ds.Tables[4].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[4].Rows)
                {
                    EmpNoticeBorad StudentNoticeBorad = new EmpNoticeBorad();
                    StudentNoticeBorad.DocumentId = Convert.ToInt32(dr["DocumentId"].ToString());
                    StudentNoticeBorad.FileName = dr["FileName"].ToString();
                    StudentNoticeBorad.Title = dr["Title"].ToString();
                    StudentNoticeBorad.TypeId = Convert.ToInt32(dr["TypeId"].ToString());
                    DateTime dt = Convert.ToDateTime(dr["AddDate"].ToString());
                    StudentNoticeBorad.AddDate = dt.ToString("dd-MMM-yyyy");
                    dasboard.EmpNoticeList.Add(StudentNoticeBorad);

                }
            }
            if (ds.Tables[5].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[5].Rows)
                {
                    dasboard.EmpAttendanceList.Add(new EmployeeAttendance
                    {
                        AttendId = Convert.ToInt64(dr["AttendId"].ToString()),
                        EmpId = Convert.ToInt64(dr["EmpId"].ToString()),
                        InTime = dr["InTime"].ToString(),
                        OutTime = dr["OutTime"].ToString(),
                        IsPresent = Convert.ToBoolean(dr["IsPresent"].ToString()),
                        IsLeave = Convert.ToBoolean(dr["IsLeave"].ToString())


                    });
                }
            }

            for (int i = 1; i <= 12; i++)
            {
                string monthName = new DateTime(2019, i, 1).ToString("MMM", CultureInfo.InvariantCulture);
                dasboard.Attlabel.Add(monthName);
                int count = dasboard.CurrMonthAttendance.Where(e => Convert.ToDateTime(e.CalendarDate).Month == i && e.DayStaus == "P").ToList().Count;
                dasboard.AttPreDay.Add(count);
                count = dasboard.CurrMonthAttendance.Where(e => Convert.ToDateTime(e.CalendarDate).Month == i && e.DayStaus == "A").ToList().Count;
                dasboard.AttAbsentDay.Add(count);
                count = dasboard.CurrMonthAttendance.Where(e => Convert.ToDateTime(e.CalendarDate).Month == i && e.DayType == "Regular").ToList().Count;
                dasboard.AttWorkingDay.Add(count);
                count = dasboard.CurrMonthAttendance.Where(e => Convert.ToDateTime(e.CalendarDate).Month == i && (e.DayStaus == "W" || e.DayStaus == "H")).ToList().Count;
                dasboard.Holliday.Add(count);
                count = dasboard.CurrMonthAttendance.Where(e => Convert.ToDateTime(e.CalendarDate).Month == i && e.LateIN == "LI").ToList().Count;
                dasboard.LateIN.Add(count);
                count = dasboard.CurrMonthAttendance.Where(e => Convert.ToDateTime(e.CalendarDate).Month == i && e.EarlyOut == "EO").ToList().Count;
                dasboard.EarlyOut.Add(count);
            }

            return Json(dasboard, JsonRequestBehavior.AllowGet);

        }
        public ActionResult Dashboard()
        {
            Session["ModuleId"] = OEMSModule.HR_Payrol;
            return View();
        }

        public ActionResult PortalDashboard()

        {

            var userid = User.Identity.GetUserId();
            var EmpUser = DataAccess.Instance.Users.Filter(e => e.Id == userid).FirstOrDefault().EmpId;
            int BasicInfoId = Convert.ToInt32(EmpUser);
            EmpBasicInfo EmpBasicInfo = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpBasicInfoID == BasicInfoId).FirstOrDefault();
            if (EmpBasicInfo == null)
                return HttpNotFound();
            ViewBag.EmpBasicInfo = EmpBasicInfo;
            return View();
        }
        public ActionResult GetMenuEmp()
        {

            return View();
        }
        public ActionResult EmployeeList()
        {
            return View();
        }

        // GET: Employee
        public ActionResult Designation()
        {
            return View();
        }
        public ActionResult QuickAddEmployee()
        {
            return View();
        }
        //Category
        public ActionResult Category()
        {
            return View();
        }

        public ActionResult Subject()
        {
            return View();
        }

        public ActionResult Department()
        {
            return View();
        }

        public ActionResult Status()
        {
            return View();
        }

        public ActionResult AddEmployeeInfo()
        {
            return View();
        }
        public ActionResult EmployeeIdCard()
        {
            return View();
        }
        public ActionResult TeacherSubjectList()
        {
            return View();
        }
        /// <summary>
        /// Get 
        /// </summary>
        /// <returns></returns>

        /// <summary>
        /// Get 
        /// </summary>
        /// <returns></returns>




        public ActionResult SubjectAssesment()
        {
            return View();
        }

        public ActionResult SubjectComments()
        {
            return View();
        }
        public ActionResult ClassAssesment()
        {
            return View();
        }
        public ActionResult ClassComments()
        {
            return View();
        }
        public ActionResult ClassHeadTeacherComments()
        {
            var userid = User.Identity.GetUserId();
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetMenuEmployee", new object[] { userid });
            ViewBag.IsClassTeacher = Convert.ToBoolean(dt.Rows[0]["IsClsTeacher"]);
            ViewBag.IsSubTeacher = Convert.ToBoolean(dt.Rows[0]["IsSubTeacher"]);
            ViewBag.IsHeadTecaher = Convert.ToBoolean(dt.Rows[0]["IsHeadTecaher"]);
            ViewBag.IsCoordinator = Convert.ToBoolean(dt.Rows[0]["IsCoordinator"]);
            return View();
        }
        public ActionResult ClassTeacherAssign()
        {
            return View();
        }
        public ActionResult MeetingPersonAssign()
        {
            return View();
        }
        public ActionResult SalaryEmployee()
        {
            return View();
        }
        public ActionResult SalaryGrade()
        {
            return View();
        }
        public ActionResult SalaryHead()
        {
            return View();
        }
        public ActionResult SalaryHeadWiseConfig()
        {
            return View();
        }
        public ActionResult EmployeewiseConfig()
        {
            return View();
        }
        public ActionResult SalaryIncrement()
        {
            return View();
        }
        public ActionResult SalarySheet()
        {
            return View();
        }
        public ActionResult SalaryPayDetails()
        {
            return View();
        }
        public ActionResult SalaryPeriod()
        {
            return View();
        }
        public ActionResult SalaryStructure()
        {
            return View();
        }
        public ActionResult SalaryTax()
        {
            return View();
        }
        public ActionResult IncomeTaxConfig()
        {
            return View();
        }
        public ActionResult SalaryYear()
        {
            return View();
        }

        public ActionResult UpdateEmployeeProfile()
        {
            return View();
        }
        public ActionResult Leave()
        {
            return View();
        }
        public ActionResult EmpLateinEarlyOut()
        {
            return View();
        }
        public ActionResult LeaveApplication()
        {
            return View();
        }
        public ActionResult LeaveCategory()
        {
            return View();
        }
        public ActionResult ApproveOrRejectLvApp()
        {
            return View();
        }
        public ActionResult LeaveQuota()
        {
            return View();
        }
        public ActionResult LeaveApporval()
        {
            return View();
        }
        public ActionResult SalaryProcess()
        {
            return View();
        }
        public ActionResult AdvanceSalary()
        {
            return View();
        }
        public ActionResult SalaryHold()
        {
            return View();
        }
        public ActionResult SalaryViewAndModification()
        {
            return View();
        }
        public ActionResult GeneratePayrol()
        {
            return View();
        }
        public ActionResult SalaryReportChequePayment()
        {
            return View();
        }
        public ActionResult SalaryDeductionReport()
        {
            return View();
        }
        public ActionResult SalaryAdviceReport()
        {
            return View();
        }
        public ActionResult AppraisalSalaryReport()
        {
            return View();
        }
        public ActionResult SalaryHoldReport()
        {
            return View();
        }
        public ActionResult SalaryHoldCombindReport()
        {
            return View();
        }
        public ActionResult EmployeeProfileEdit(int EmpId)
        {
            ViewBag.EmpId = EmpId;
            ViewBag.UserName = User.Identity.Name;
            return View();
        }
        public ActionResult EmpProfileView(int? EmpId)
        {
            if (EmpId == null)
            {
                ViewBag.EmpId = 0;
            }
            else
            {
                ViewBag.EmpId = EmpId;
            }
            return View();
        }
        public ActionResult EmployeeProfile(int? EmpId)
        {
            if (EmpId == null)
            {
                ViewBag.EmpId = 0;
            }
            else
            {
                ViewBag.EmpId = EmpId;
            }
            ViewBag.UserName = User.Identity.Name;
            return View();
        }
        public ActionResult EmployeeRequest()
        {
            return View();
        }
        public ActionResult EmployeeRequestForAdmin()
        {
            return View();
        }
        public ActionResult ParentsMeeting()
        {

            return View();
        }
        public ActionResult Routine()
        {

            return View();
        }
        public ActionResult Payroll()
        {
            return View();
        }



        public ActionResult EmpNewsletter()
        {
            var userName = User.Identity.GetUserName();
            int branchId = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == userName).FirstOrDefault().BranchID;
            ViewBag.BranchId = branchId;
            return View();
        }
        public ActionResult EmployeeECA()
        {

            return View();
        }
        public ActionResult CS()
        {

            return View();
        }
        public ActionResult EmpAttendance()
        {
            return View();
        }
        public ActionResult StdentTCRequest()
        {

            return View();
        }
        public ActionResult EmpNotice()
        {

            return View();
        }

        public ActionResult EmpApprisal()
        {

            return View();
        }

        public ActionResult GetAllEmployeeRequest()
        {
            return View();
        }

        //public ActionResult GetAllEmployeeRequestByMeeting()
        public ActionResult MeetingList()
        {
            return View();
        }
        public ActionResult TermResult()
        {
            return View();
        }

        public ActionResult ShowStudentsAttendance()
        {
            string UserId = User.Identity.GetUserId();
            ViewBag.UserId = UserId;
            return View();
        }
        public ActionResult GenerateResultClassWise()
        {
            return View();
        }
        public ActionResult UnethicalExitReport()
        {
            return View();
        }

        public ActionResult RewardEntry()
        {
            return View();
        }
        public ActionResult SalaryHoldRefund()
        {
            return View();
        }
        public ActionResult SalaryHoldRefundReports()
        {
            return View();
        }

        public ActionResult IssueList()
        {
            return View();
        }
        public ActionResult MyAttendance()
        {
            return View();
        }
        public ActionResult LeaveRoutingConfig()
        {
            return View();
        }
    }
}