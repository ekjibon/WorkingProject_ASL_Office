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
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers
{
    public class AttendanceVController : BaseController
    {
        public ActionResult Dashboard()
        {
            Session["ModuleId"] = OEMSModule.Attendence;
            return View();
        }
        // GET: Attendance
        public ActionResult StdTeacherPeriodSetup()
        {
            return View();
        }

        public ActionResult StdAcademicCalendarSetup()
        {
            return View();
        }
        public ActionResult EmpAcademicCalendarSetup()
        {
            return View();
        }
        public ActionResult StdAcademicCalendarView()
        {
            return View();
        }
        public ActionResult EmpAcademicCalendarView()
        {
            return View();
        }

        public ActionResult StdLateinEarlyOut()
        {
            return View();
        }

        public ActionResult StdSectionWiseAttendance()
        {
            return View();
        }
        public ActionResult test()
        {
            return View();
        }
        public ActionResult StdPeriodWiseAttendance()
        {
            return View();
        }

        public ActionResult StdIndicatedPeriodWiseAttendance()
        {
            return View();
        }
        public ActionResult StdPeriodWiseAttnSingleDay()
        {
            return View();
        }
        public ActionResult TeacherSectiondWiseAttendance()
        {
            return View();
        }
        public ActionResult StdLeaveApply()
        {
            return View();
        }
        public ActionResult StdLeaveList()
        {
            return View();
        }

        public ActionResult StdDailyAttendanceReportPeriodWise()
        {
            return View();
        }
        public ActionResult StdLIOReport()
        {
            return View();
        }
        public ActionResult EmployeeAttendanceSummaryReport()
        {
            return View();
        }
        public ActionResult EmployeeAttendanceDetailsReport()
        {
            return View();
        }
        [HttpGet]
        public ActionResult StdAttendanceSummaryReport()
        {
            return View();
        }
        public ActionResult StdMonthlyAttendanceReport()
        {
            return View();
        }
        public ActionResult StdDynamicAttendanceReport()
        {
            return View();
        }
        public ActionResult StdAbscondingAttendance()
        {
            return View();
        }
        public ActionResult PeriodSetup()
        {
            return View();
        }
        //public ActionResult TeacherStdAttnListSectoinWise()
        //{
        //    CommonResponse cr = new CommonResponse();
        //    string treeContent = "<ul id='sitemap'>";
        //    try
        //    {
        //        var teacherId = User.Identity.GetUserId();
        //        DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("Attendence", new object[] {5,0,0,0,0,0,0,0,0,0,DBNull.Value,DBNull.Value, teacherId });
        //        List<VMTeacherMarksEntrySubjectList> lstAssignSubjectList = APIUitility.ConvertDataTable<VMTeacherMarksEntrySubjectList>(dt);               
        //        #region PrepareTree

        //        // GetVersions
        //        #region Version

        //        List<String> versionList = lstAssignSubjectList.
        //            GroupBy(i => i).
        //            Select(x => x.Key.VersionName).
        //            Distinct().ToList();

        //        if (versionList.Count > 0)
        //        {
        //            foreach (String version in versionList)
        //            {
        //                treeContent += "<li class='step1'>" + version;

        //                //Get Session
        //                #region Session

        //                List<String> sessionList = lstAssignSubjectList.
        //                    Where(b => b.VersionName.Equals(version)).
        //                    GroupBy(i => i).
        //                    Select(x => x.Key.SessionName).
        //                    Distinct().ToList();

        //                if (sessionList.Count > 0)
        //                {
        //                    treeContent += "<ul>";
        //                    foreach (String session in sessionList)
        //                    {
        //                        treeContent += "<li class='step2'>" + session;

        //                        //Get Branch
        //                        #region Branch

        //                        List<String> branchList = lstAssignSubjectList.
        //                                      Where(b =>
        //                                          b.VersionName.Equals(version) &&
        //                                          b.SessionName.Equals(session)).
        //                                      GroupBy(i => i).
        //                                      Select(x => x.Key.BranchName).
        //                                      Distinct().ToList();
        //                        if (branchList.Count > 0)
        //                        {
        //                            treeContent += "<ul>";
        //                            foreach (String branch in branchList)
        //                            {
        //                                treeContent += "<li class='step3'>" + branch;

        //                                //Get Shift
        //                                #region Shift

        //                                List<String> shiftList = lstAssignSubjectList.
        //                                    Where(b =>
        //                                        b.VersionName.Equals(version) &&
        //                                        b.SessionName.Equals(session) &&
        //                                        b.BranchName.Equals(branch)).
        //                                    GroupBy(i => i).
        //                                    Select(x => x.Key.ShiftName).
        //                                    Distinct().ToList();

        //                                if (shiftList.Count > 0)
        //                                {
        //                                    treeContent += "<ul>";
        //                                    foreach (String shift in shiftList)
        //                                    {
        //                                        treeContent += "<li class='step4'>" + shift;

        //                                        //Get Class
        //                                        #region Class

        //                                        List<String> classList = lstAssignSubjectList.
        //                                      Where(b =>
        //                                          //b.VersionName.Equals(version) &&
        //                                          b.SessionName.Equals(session) &&
        //                                          b.BranchName.Equals(branch) &&
        //                                          b.ShiftName.Equals(shift)).
        //                                      GroupBy(i => i).
        //                                      Select(x => x.Key.ClassName).
        //                                      Distinct().ToList();

        //                                        if (classList.Count > 0)
        //                                        {
        //                                            treeContent += "<ul>";

        //                                            //Get Group

        //                                            foreach (String classs in classList)
        //                                            {
        //                                                treeContent += "<li class='step5'>" + classs;

        //                                                //Get Group
        //                                                #region Group

        //                                                List<String> groupList = lstAssignSubjectList.
        //                                                             Where(b =>
        //                                                                 b.VersionName.Equals(version) &&
        //                                                                 b.SessionName.Equals(session) &&
        //                                                                 b.BranchName.Equals(branch) &&
        //                                                                 b.ShiftName.Equals(shift) &&
        //                                                                 b.ClassName.Equals(classs)).
        //                                                             GroupBy(i => i).
        //                                                             Select(x => x.Key.GroupName).
        //                                                             Distinct().ToList();

        //                                                if (groupList.Count > 0)
        //                                                {
        //                                                    treeContent += "<ul>";

        //                                                    foreach (String group in groupList)
        //                                                    {
        //                                                        treeContent += "<li class='step6'>" + group;                                                            
        //                                                                #region Subjects     
        //                                                                List<VMTeacherMarksEntrySubjectList> sectionList = new List<VMTeacherMarksEntrySubjectList>();
        //                                                                sectionList = lstAssignSubjectList.
        //                                                                     Where(b =>
        //                                                                         //b.VersionName.Equals(version) &&
        //                                                                         b.SessionName.Equals(session) &&
        //                                                                         b.BranchName.Equals(branch) &&
        //                                                                         b.ShiftName.Equals(shift) &&
        //                                                                         b.ClassName.Equals(classs) 
        //                                                                         //b.GroupName.Equals(group)
        //                                                                         ).ToList();

        //                                                                if (sectionList.Count > 0)
        //                                                                {
        //                                                                    treeContent += "<ul>";
        //                                                                    string SectionName = "";
        //                                                                    sectionList = sectionList.OrderBy(x => x.SectionName).ToList();
        //                                                                    foreach (VMTeacherMarksEntrySubjectList TeacherStdAttnList in sectionList)
        //                                                                    {
        //                                                                        if (SectionName != TeacherStdAttnList.SectionName)
        //                                                                        {                                                                                   
        //                                                                                treeContent += "<li class='step7'>" + TeacherStdAttnList.SectionName +
        //                                                                             " <a id='btnSection'  href='/AttendanceV/TeacherSectiondWiseAttendance?VersionID=" +
        //                                                                             "&SessionId=" + TeacherStdAttnList.SessionId
        //                                                                             + "&BranchID=" + TeacherStdAttnList.BranchId
        //                                                                             + "&ShiftID=" + TeacherStdAttnList.ShiftId
        //                                                                             + "&ClassId=" + TeacherStdAttnList.ClassId
        //                                                                             + "&SectionId=" + TeacherStdAttnList.SectionId
        //                                                                             + "&SessionName=" + TeacherStdAttnList.SessionName
        //                                                                             + "&BranchName=" + TeacherStdAttnList.BranchName
        //                                                                             + "&ShiftName=" + TeacherStdAttnList.ShiftName
        //                                                                             + "&ClassName=" + TeacherStdAttnList.ClassName
        //                                                                             + "&SectionName=" + TeacherStdAttnList.SectionName
        //                                                                             + "&Name=" + TeacherStdAttnList.FullName
        //                                                                             + "' class='btn btn-xs btn-info'>Take Attendance</a>";   
        //                                                                                SectionName = TeacherStdAttnList.SectionName;   
        //                                                                        }
        //                                                                    }

        //                                                                    treeContent += "</ul>";
        //                                                                }                                                                              
        //                                                                #endregion                                                                
        //                                                        treeContent += "</li>";
        //                                                    }

        //                                                    treeContent += "</ul>";
        //                                                }

        //                                                #endregion

        //                                                treeContent += "</li>";
        //                                            }

        //                                            treeContent += "</ul>";
        //                                        }

        //                                        #endregion

        //                                        treeContent += "</li>";
        //                                    }
        //                                    treeContent += "</ul>";
        //                                }

        //                                #endregion

        //                                treeContent += "</li>";
        //                            }
        //                            treeContent += "</ul>";
        //                        }

        //                        #endregion

        //                        treeContent += "</li>";
        //                    }
        //                    treeContent += "</ul>";
        //                }

        //                #endregion

        //                treeContent += "</li>";
        //            }
        //        }

        //        #endregion

        //        #endregion
        //        treeContent += "</ul>";
        //        ViewBag.EncodedHtml = MvcHtmlString.Create(treeContent);

        //    }
        //    catch (Exception ex)
        //    {
        //        ViewBag.EncodedHtml = MvcHtmlString.Create("<h1>" + ex.Message.ToString() + "</h1>");
        //    }
        //    return View();
        //}
        //
        public ActionResult AttndSummRange()
        {
            return View();
        }
        public ActionResult MonthlyAttendance()//
        {
            return View();
        }
        public ActionResult SectionWaysAbscondingLeaveAttendance()
        {
            return View();
        }
        public ActionResult DynamicReport()
        {
            return View();
        }
        public ActionResult DeviceReport()
        {
            return View();
        }
        public ActionResult SingleStudentSummeryReport()
        {
            return View();
        }
        public ActionResult StudentSummeryReportSW()
        {
            return View();
        }
        public ActionResult AttendenceReport()
        {
            return View();
        }
        public ActionResult LeaveType()
        {
            return View();
        }


        public ActionResult Halfdayleave()
        {
            return View();
        }

        public ActionResult RosterSetup()
        {
            return View();
        }
        public ActionResult EmpCalenderSetup()
        {
            return View();
        }
        public ActionResult EmpCalenderConfig()
        {
            return View();
        }

        public ActionResult RosterApproval()
        {
            return View();
        }
        public ActionResult ModifyAttendance()
        {
            return View();
        }
        public ActionResult ModifyAttendanceAbsent()
        {
            return View();
        }

        public ActionResult ModifyAttendanceApproval()
        {
            return View();
        }

        public ActionResult ModifyAttendanceAbsentApproval()
        {
            return View();
        }
        public ActionResult SubmitEmployeeAttendance()
        {
            return View();
        }
        public ActionResult EmpCalendarView(int id)
        {
            ViewBag.Id = id;
            return View();
        }
        public ActionResult DailyAttendance()
        {
            return View();
        }
        public ActionResult MonthlyStuAttendance()
        {
            return View();
        }
        public ActionResult IndividualEmployeeAttendanceReport()
        {
            return View();
        }
        public ActionResult EmpAcademicCalenderConfigDetails()
        {
            return View();
        }
        public ActionResult AttendanceDeviceSync()
        {
            return View();
        }
        public ActionResult LeaveModificationType()
        {
            return View();
        }
    }
}