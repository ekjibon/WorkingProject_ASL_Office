using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Constant;
using OEMS.Models.Model;
using OEMS.Models.Model.Attendance;
using OEMS.Models.Model.Employee;
using OEMS.Models.ViewModel;
using OEMS.Models.ViewModel.Attendance;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Transactions;
using System.Web;
using System.Web.Http;

namespace OEMS.Api.Controllers
{
    //[ApiAuth]
    [Authorize]
    public class AttendanceController : ApiController
    {
        #region Others
        [Route("Attendance/GetAttendanceDashboardData")]
        [HttpGet]
        public IHttpActionResult GetDashboardData()
        {
            CommonResponse cr = new CommonResponse();
            ChartDataAttendanceVM[] attenLeavelist;
            ChartDataAttendanceVM[] attenLateEarlylist;
            try
            {

                DataSet ds = DataAccess.Instance.CommonServices.GetDatasetBySp("GetAttendanceDashBoardData");

                attenLeavelist = APIUitility.ConvertDataTable<ChartDataAttendanceVM>(ds.Tables[0]).ToArray();
                attenLateEarlylist = APIUitility.ConvertDataTable<ChartDataAttendanceVM>(ds.Tables[1]).ToArray();
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(new { attenLeavelist, attenLateEarlylist });
        }

        [Route("Attendance/AttendanceSearch/")]
        [HttpPost]
        public IHttpActionResult AttendanceSearch(AttendanceSearchVM ASearch)
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                //P2. GetAtteForExam is a SP that return us a searching result it have 11 paramiter 
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAtteForExam", new object[] { ASearch.FromDate, ASearch.ToDate,
                    ASearch.BranchID, ASearch.SessionId, ASearch.ShiftId, ASearch.ClassId, ASearch.SectionId, ASearch.MainExamId, ASearch.IsGrand,ASearch.SID });

                List<ExamAttendance> listAtte = APIUitility.ConvertDataTable<ExamAttendance>(dt);

                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = listAtte.Count + " Data found";
                cr.results = listAtte;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        #endregion Others










        #region LeaveType
        [Route("Attendance/AddLeaveType/")]
        [HttpPost]
        public IHttpActionResult AddLeaveType(LeaveTypes LeaveType)
        {
            CommonResponse cr = new CommonResponse();
            var exit = DataAccess.Instance.LeaveTypesService.Filter(e => e.TypeName == LeaveType.TypeName && e.Type == LeaveType.Type).ToList();
            if (exit.Count > 0)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = Constant.DATA_EXISTS;
                return Json(cr);
            }
            LeaveType.AddBy = User.Identity.Name;
            LeaveType.IsDeleted = false;
            LeaveType.Status = "A";
            LeaveType.SetDate();
            var res = DataAccess.Instance.LeaveTypesService.Add(LeaveType);
            cr.results = GetAllLeave();
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;


            cr.results = GetAllLeave();
            return Json(cr);
        }
        [Route("Attendance/GetAllLeaveType/")]
        [HttpGet]
        public IHttpActionResult GetAllLeaveType()
        {
            CommonResponse cr = new CommonResponse();
            cr.results = GetAllLeave();
            cr.httpStatusCode = cr.results != null ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = cr.results != null ? Constant.SUCCESS : Constant.FAILED;
            return Json(cr);
        }
        [Route("Attendance/GetLeaveType/{LeaveType}")]
        [HttpGet]
        public IHttpActionResult GetLeaveType(string LeaveType)
        {
            // Get Class Period
            CommonResponse cr = new CommonResponse();
            if (!String.IsNullOrWhiteSpace(LeaveType))
            {
                cr.results = GetAllLeave().Where(e => e.TypeName == LeaveType);
            }
            cr.httpStatusCode = cr.results != null ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = cr.results != null ? Constant.SUCCESS : Constant.FAILED;
            return Json(cr);
        }
        [Route("Attendance/UpdateLeaveType/")]
        [HttpPost]
        public IHttpActionResult UpdateLeaveType(LeaveTypes LeaveType)
        {
            // Update Class Period
            CommonResponse cr = new CommonResponse();
            var exit = DataAccess.Instance.LeaveTypesService.Filter(e => e.TypeName == LeaveType.TypeName && e.Type == LeaveType.Type && e.LeaveId != LeaveType.LeaveId).ToList();
            if (exit.Count > 0)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = Constant.DATA_EXISTS;
                return Json(cr);
            }
            LeaveType.UpdateBy = User.Identity.Name;
            LeaveType.SetDate();
            var res = DataAccess.Instance.LeaveTypesService.Update(LeaveType);
            cr.results = GetAllLeave();
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.UPDATED : Constant.FAILED;
            return Json(cr);
        }
        [Route("Attendance/DeleteLeaveType/{LeaveId}")]
        [HttpPost]
        public IHttpActionResult DeleteLeaveType(int LeaveId)
        {
            //// Delete Class Period by Class PeriodID
            CommonResponse cr = new CommonResponse();
            //if (DataAccess.Instance.CommonServices.IsExist("Student_BasicInfo", "SessionId", Sessionid))
            //{
            //    return BadRequest(Constant.DATA_EXISTS);
            //}
            bool res = DataAccess.Instance.LeaveTypesService.Remove(LeaveId);
            cr.results = GetAllLeave();
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            return Json(cr);
        }
        private List<LeaveTypes> GetAllLeave()
        {
            return DataAccess.Instance.LeaveTypesService.Filter(e => e.IsDeleted == false).ToList();
        }
        #endregion LeaveType



        #region Emp Roster 
        [Route("Attendance/GetEmpRosterList/")]
        [HttpPost]
        public IHttpActionResult GetEmpRosterList(EmpRosterVM empRoster)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@BranchId", empRoster.BranchId));
                param.Add(new SqlParameter("@CategoryId", empRoster.EmpCategory));
                param.Add(new SqlParameter("@CalendarId", empRoster.CalendarId));
                param.Add(new SqlParameter("@Year", empRoster.Year));
                param.Add(new SqlParameter("@MonthId", empRoster.Month));
                DataTable res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRosterList", param.ToArray());
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

        [Route("Attendance/AddEmpRoster/")]
        [HttpPost]
        public IHttpActionResult AddEmpRoster(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (empRosterlist.Count > 0)
                {

                    DataTable dt;

                    foreach (var item in empRosterlist)
                    {
                        List<SqlParameter> param = new List<SqlParameter>();
                        TimeSpan inTime = Convert.ToDateTime(item.InTime).TimeOfDay;
                        TimeSpan outTime = Convert.ToDateTime(item.OutTime).TimeOfDay;

                        param.Add(new SqlParameter("@Block", 1));
                        param.Add(new SqlParameter("@EmpId", item.EmpBasicInfoID));
                        param.Add(new SqlParameter("@EmpCategory", item.EmpCategory));
                        param.Add(new SqlParameter("@BranchId", item.BranchId));
                        param.Add(new SqlParameter("@CalendarId", item.CalendarId));
                        param.Add(new SqlParameter("@InTime", inTime));
                        param.Add(new SqlParameter("@OutTime", outTime));
                        param.Add(new SqlParameter("@AddBy", User.Identity.Name));
                        param.Add(new SqlParameter("@Remarks", item.Remarks));
                        param.Add(new SqlParameter("@Year", item.Year));
                        param.Add(new SqlParameter("@MonthId", item.Month));

                        dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertEmployeeRoster", param.ToArray());



                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }
                else
                {
                    return BadRequest("At Least One Select!");
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Attendance/AddEmpRosterTemporary/")]
        [HttpPost]
        public IHttpActionResult AddEmpRosterTemporary(EmpTempRosterVM empTemRoster)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DateTime From = Convert.ToDateTime(empTemRoster.FromDate);
                DateTime To = Convert.ToDateTime(empTemRoster.ToDate);

                foreach (var item in empTemRoster.DayList)
                {

                    List<SqlParameter> param = new List<SqlParameter>();
                    param.Add(new SqlParameter("@EmpId", empTemRoster.EmpBasicInfoID));
                    //   param.Add(new SqlParameter("@EmpCategory", empTemRoster.EmpCategory));

                    param.Add(new SqlParameter("@AddBy", User.Identity.Name));
                    param.Add(new SqlParameter("@Remarks", empTemRoster.Remarks));
                    param.Add(new SqlParameter("@FromDate", From.ToString()));
                    param.Add(new SqlParameter("@ToDate", To.ToString()));
                    TimeSpan inTime = Convert.ToDateTime(item.InTime).TimeOfDay;
                    TimeSpan outTime = Convert.ToDateTime(item.OutTime).TimeOfDay;

                    param.Add(new SqlParameter("@Day", item.Day));
                    param.Add(new SqlParameter("@InTime", inTime.ToString()));
                    param.Add(new SqlParameter("@OutTime", outTime.ToString()));
                    var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertEmployeeTeporaryRoster", param.ToArray());
                }

                cr.message = Constant.SAVED;
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Attendance/GetEmployeeRoster/")]
        [HttpPost]
        public IHttpActionResult GetEmployeeRoster(EmpRosterVM empRoster)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 2));
                param.Add(new SqlParameter("@BranchId", DBNull.Value));
                param.Add(new SqlParameter("@CategoryId", empRoster.EmpBasicInfoID));
                param.Add(new SqlParameter("@CalendarId", empRoster.CalendarId));
                param.Add(new SqlParameter("@Year", empRoster.Year));
                param.Add(new SqlParameter("@MonthId", empRoster.Month));
                cr.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRosterList", param.ToArray());
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Attendance/GetEmployeeTemporaryRoster/")]
        [HttpPost]
        public IHttpActionResult GetEmployeeTemporaryRoster(EmpRosterVM empRoster)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();

                param.Add(new SqlParameter("@BranchId", DBNull.Value));
                param.Add(new SqlParameter("@EmpID", empRoster.EmpBasicInfoID));
                param.Add(new SqlParameter("@EmpCategory", empRoster.EmpCategory));
                //  param.Add(new SqlParameter("@CalendarId", empRoster.CalendarId));
                // param.Add(new SqlParameter("@FromDate", empRoster.FromDate));
                // param.Add(new SqlParameter("@ToDate", empRoster.ToDate));
                cr.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeTemporaryRosterList", param.ToArray());
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Attendance/GetEmpRosterListForApprove/")]
        [HttpPost]
        public IHttpActionResult GetEmpRosterListForApprove(EmpRosterVM empRoster)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();

                param.Add(new SqlParameter("@EmpID", empRoster.EmpBasicInfoID));

                cr.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeTempRosterList", param.ToArray());
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        #endregion

        #region Emp Accademic Calendar
        [Route("Attendance/AccademicCalendarSetupEmp/{year}/{month}")]
        [HttpGet]
        public IHttpActionResult AccademicCalendarSetupEmp(int year, int month)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //int days = System.Globalization.CultureInfo.CurrentCulture.Calendar.GetDaysInMonth(year, month);
                //var lstSaved = DataAccess.Instance.EmpAcademicCalendarService.Filter(e => e.Year == year && e.Month == month && e.IsDeleted == false).ToList();
                //List<EmpAcademicCalendarDetails> LstClandar = new List<EmpAcademicCalendarDetails>();
                //for (int i = 1; i <= days; i++)
                //{
                //    DateTime Date = new DateTime(year, month, i);
                //    var a = Date.ToString();
                //    var exist = lstSaved.Where(e => e.Day == i).FirstOrDefault();
                //    var att = DataAccess.Instance.EmpAttendanceService.Filter(x => x.InTime == Date && x.IsPresent == true).Any();

                //    LstClandar.Add(new EmpAcademicCalendarDetails
                //    {
                //        Year = year,
                //        Month = month,
                //        Day = i,
                //        CalendarDate = Date,
                //        IsDateDisable = att,
                //        DayType = exist != null ? exist.DayType : Date.DayOfWeek == DayOfWeek.Friday ? Enums.DayType.Weekend.ToString() : Enums.DayType.Regular.ToString(),
                //        HolidayName = exist != null ? exist.HolidayName : ""
                //    });
                //}
                //cr.results = LstClandar;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Attendance/AddAccademicCalendarSetupEmp/")]
        [HttpPost]
        public IHttpActionResult AddAccademicCalendarSetupEmp(List<EmpAcademicCalendarDetails> lstAcademicCalendar)
        {
            CommonResponse cr = new CommonResponse();
            //if (!lstAcademicCalendar.Any())//Check not null input list
            //    return BadRequest();
            //var data = lstAcademicCalendar.FirstOrDefault();
            ////  Remove Exist Virtual Exam
            //bool results = false;
            //int day = 0;
            //string username = User.Identity.Name;
            //foreach (var item in lstAcademicCalendar) //add Date Exam one by one
            //{
            //    day++;
            //    var existentry = DataAccess.Instance.EmpAcademicCalendarService.Filter(e => e.Year == item.Year && e.Month == item.Month && e.Day == item.Day).FirstOrDefault();
            //    if (existentry != null)
            //    {
            //        item.AddBy = existentry.AddBy;

            //    }
            //    else
            //    {
            //        item.AddBy = username;
            //    }
            //    item.IsDeleted = false;
            //    item.Status = "A";
            //    item.SetDate();

            //    DateTime NextDay;
            //    DateTime Daylast;
            //    NextDay = item.CalendarDate.AddDays(1);
            //    Daylast = NextDay.AddSeconds(-1);
            //    var Exist = DataAccess.Instance.EmpAttendanceService.Filter(x => x.InTime >= item.CalendarDate && x.InTime <= Daylast);
            //    var r = Exist.Any();
            //    if (Exist.Any())
            //    {
            //        cr.message = "Already Attendance taken";
            //    }
            //    else
            //    {

            //        DataAccess.Instance.EmpAcademicCalendarService.RemoveRange(data.Year, data.Month, day);
            //        results = DataAccess.Instance.EmpAcademicCalendarService.Add(item);
            //    }
            //}
            //if (results)
            //{
            //    cr.httpStatusCode = HttpStatusCode.OK;
            //    cr.message = Constant.SAVED;
            //}
            //else
            //    return BadRequest();
            return Json(cr);
        }
        [Route("Attendance/GetCalendarEventsEmp/")]
        [HttpGet]
        public IHttpActionResult GetCalendarEventsEmp()
        {
            string start = HttpContext.Current.Request.Params[0].ToString();
            string end = HttpContext.Current.Request.Params[1].ToString();
            string _ = HttpContext.Current.Request.Params[2].ToString();
            CommonResponse cr = new CommonResponse();
            //DateTime FromDate = Convert.ToDateTime(start);
            //DateTime ToDate = Convert.ToDateTime(end);
            //List<object> lstRes = new List<object>();
            //var result = DataAccess.Instance.EmpAcademicCalendarService.Filter(e => e.CalendarDate >= FromDate && e.CalendarDate <= ToDate).ToList();
            //if (result.Any())
            //{
            //    foreach (var item in result)
            //    {
            //        lstRes.Add(new
            //        {
            //            title = item.DayType == Enums.DayType.Holiday.ToString() ? item.HolidayName : item.DayType
            //            ,
            //            start = item.CalendarDate.ToString("yyyy-MM-dd"),
            //            allDay = true,
            //            backgroundColor = item.ColorCode,
            //            textColor = Color.Black
            //            //rendering = item.DayType == Enums.DayType.Holiday.ToString() ? "background" : null,
            //            //overlap= item.DayType == Enums.DayType.Holiday.ToString() ? false:true,
            //            //color = "#ff9f89"
            //        });
            //    }
            //}
            // return Json(lstRes);
            return Json(cr);
        }

        // Md.Khaled 
        [Route("Attendance/AddEmpCalendar/")]
        [HttpPost]
        public IHttpActionResult AddEmpCalendar(EmpAcademicCalandar empCalendar)
        {
            // Add EmpCalendar      
            CommonResponse cr = new CommonResponse();
            try
            {
                var aCalendar = DataAccess.Instance.EmpAcademicCalandarService.Filter(e => e.IsDeleted == false && e.Status == "A").ToList();
                if (aCalendar.Any(e => e.Title == empCalendar.Title))
                {
                    throw new Exception("Calendar Title Aleardy Exits");
                }
                else if (aCalendar.Any(e => e.EmpCategory == empCalendar.EmpCategory && e.StartDate == empCalendar.StartDate && e.Title != empCalendar.Title))
                {
                    throw new Exception("Please Change your Category or Date");
                }
                empCalendar.IsDeleted = false;
                empCalendar.AddBy = User.Identity.Name;
                empCalendar.AddDate = DateTime.Now;
                empCalendar.SetDate();
                empCalendar.Status = "A";

                var res = DataAccess.Instance.EmpAcademicCalandarService.Add(empCalendar);

                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertCalenderIdOnLeaveQouta", new object[] { empCalendar.EmpCategory });

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }


        [Route("Attendance/GetEmpCalendarList/")]
        [HttpGet]
        public IHttpActionResult GetEmpCalendarList()
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalendarList");
                //var aCalendar = DataAccess.Instance.EmpAcademicCalandarService.Filter(e => e.Id== empCalendar.Id && e.IsDeleted == false).ToList();
                //if (aCalendar.Any())
                //{
                //    throw new Exception("RosterCalender Aleardy Exit");
                //}


                //  var res = DataAccess.Instance.EmpAcademicCalandarService.Filter(e=>e.IsDeleted == false);
                cr.results = results;
                //cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                //cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Attendance/GetEmpCalendarListByCategory/{EmpCategory}")]
        [HttpGet]
        public IHttpActionResult GetEmpCalendarListByCategory(int EmpCategory)
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalendarListByCategory", new object[] { EmpCategory });
                cr.results = results;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Attendance/UpdateEmpCalendar/")]
        [HttpPut]
        public IHttpActionResult UpdateEmpCalendar(EmpAcademicCalandar empCalendar)
        {
            // Update Calendar     
            CommonResponse cr = new CommonResponse();
            try
            {
                var aCalendar = DataAccess.Instance.EmpAcademicCalandarService.Filter(e => e.Id != empCalendar.Id && e.IsDeleted == false && e.Status == "A").ToList();
                if (aCalendar.Any(e => e.Title == empCalendar.Title))
                {
                    throw new Exception("Calendar Title Aleardy Exits");
                }
                else if (aCalendar.Any(e => e.EmpCategory == empCalendar.EmpCategory && e.StartDate == empCalendar.StartDate))
                {
                    throw new Exception("Please Change your Category or Date");
                }
                empCalendar.IsDeleted = false;
                empCalendar.AddBy = User.Identity.Name;
                empCalendar.AddDate = DateTime.Now;
                empCalendar.SetDate();
                empCalendar.Status = "A";

                var res = DataAccess.Instance.EmpAcademicCalandarService.Update(empCalendar);
                // var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertCalenderIdOnLeaveQouta", new object[] { empCalendar.Id });
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Attendance/DeleteEmpCalendar/")]
        [HttpPost]
        public IHttpActionResult DeleteEmpCalendar(EmpAcademicCalandar empCalendar)
        {



            CommonResponse cr = new CommonResponse();
            try
            {
                if (empCalendar != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.Att_EmpAcademicCalendarDetails", "CalendarId", empCalendar.Id);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.EmpAcademicCalandarService.Remove(empCalendar.Id);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);

        }

        //[Route("Attendance/EmpCalendarSetup/{year}/{month}/{CalendarId}")] //{CalendarId }
        //[HttpGet]
        //public IHttpActionResult EmpCalendarSetup(int year, int month, int CalendarId)
        //{
        //    // Show Calendar
        //    CommonResponse cr = new CommonResponse();
        //    try
        //    {
        //        int days = System.Globalization.CultureInfo.CurrentCulture.Calendar.GetDaysInMonth(year, month);
        //        var lstSaved = DataAccess.Instance.EmpAcademicCalandarDetailsService.Filter(e => e.Year == year && e.Month == month && e.CalendarId == CalendarId && e.IsDeleted == false).ToList();
        //        List<EmpAcademicCalendarDetails> LstClandar = new List<EmpAcademicCalendarDetails>();
        //        for (int i = 1; i <= days; i++)
        //        {
        //            DateTime Date = new DateTime(year, month, i);
        //            var a = Date.ToString();
        //            var exist = lstSaved.Where(e => e.Day == i).FirstOrDefault();
        //            var att = DataAccess.Instance.EmpAttendanceService.Filter(x => x.InTime == Date && x.IsPresent == true).Any();

        //            LstClandar.Add(new EmpAcademicCalendarDetails
        //            {
        //                Year = year,
        //                Month = month,
        //                Day = i,

        //                CalendarDate = Date,
        //                IsDateDisable = att,
        //                DayType = exist != null ? exist.DayType : (Date.DayOfWeek == DayOfWeek.Friday || Date.DayOfWeek == DayOfWeek.Saturday) ? Enums.DayType.Weekend.ToString() : Enums.DayType.Regular.ToString(),
        //                HolidayName = exist != null ? exist.HolidayName : ""
        //            });
        //        }
        //        cr.results = LstClandar;
        //    }
        //    catch (Exception ex)
        //    {
        //        return BadRequest(ex.Message);
        //    }
        //    return Json(cr);
        //}


        [Route("Attendance/EmpCalendarSetup/{year}/{month}/{CalendarId}")] //{CalendarId }
        [HttpGet]
        public IHttpActionResult EmpCalendarSetup(int year, int month, int CalendarId)
        {
            // Show Calendar
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();

                param.Add(new SqlParameter("@Block", 5));
                param.Add(new SqlParameter("@CalendarId", CalendarId));
                param.Add(new SqlParameter("@Year", year));
                param.Add(new SqlParameter("@Month", month));
                param.Add(new SqlParameter("@EmpId", DBNull.Value));
                param.Add(new SqlParameter("@AttId", DBNull.Value));
                param.Add(new SqlParameter("@DayType", DBNull.Value));
                param.Add(new SqlParameter("@InTime", DBNull.Value));
                param.Add(new SqlParameter("@OutTime", DBNull.Value));
                param.Add(new SqlParameter("@BranchId", DBNull.Value));
                param.Add(new SqlParameter("@CalendarDetailsId", DBNull.Value));


                var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalanderConfig", param.ToArray());
                if (result.Rows.Count > 0)
                {
                    cr.results = result;
                    cr.httpStatusCode = HttpStatusCode.OK;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }



        [Route("Attendance/AddEmpCalendarSetupconfig/")]
        [HttpPost]
        public IHttpActionResult AddEmpCalendarSetupconfig(List<EmpAcademicCalendarDetails> lstEmpAcademicCalendarDetails)
        {
            // Add Calendar Config
            CommonResponse cr = new CommonResponse();
            if (!lstEmpAcademicCalendarDetails.Any())//Check not null input list
                return BadRequest();
            var data = lstEmpAcademicCalendarDetails.FirstOrDefault();

            bool results = false;
            int day = 0;
            string username = User.Identity.Name;
            foreach (var item in lstEmpAcademicCalendarDetails) //add Date Exam one by one
            {
                day++;
                var existentry = DataAccess.Instance.EmpAcademicCalandarDetailsService.Filter(e => e.Year == item.Year && e.Month == item.Month && e.Day == item.Day).FirstOrDefault();
                if (existentry != null)
                {
                    item.AddBy = existentry.AddBy;

                }
                else
                {
                    item.AddBy = username;
                }
                item.Id = existentry.Id;
                item.IsDeleted = false;
                item.Status = "A";
                item.SetDate();

                //DateTime NextDay;
                //DateTime Daylast;
                //NextDay = item.CalendarDate.AddDays(1);
                //Daylast = NextDay.AddSeconds(-1);
                //var Exist = DataAccess.Instance.StudentAttendanceService.Filter(x => x.InTime >= item.CalendarDate && x.InTime <= Daylast);
                //var r = Exist.Any();
                //if (Exist.Any())
                //{
                //    cr.message = "Already Attendance taken";
                //}
                //else
                //{

                //DataAccess.Instance.EmpAcademicCalandarDetailsService.RemoveRange(data.Year, data.Month, day, data.CalendarId);
                results = DataAccess.Instance.EmpAcademicCalandarDetailsService.Update(item);
                //    }
                //}
                if (results)
                {
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = Constant.SAVED;
                }
                else
                {
                    return BadRequest();
                }

                List<SqlParameter> param = new List<SqlParameter>();

                param.Add(new SqlParameter("@Block", 4));
                param.Add(new SqlParameter("@CalendarId", data.CalendarId));
                param.Add(new SqlParameter("@Year", DBNull.Value));
                param.Add(new SqlParameter("@Month", DBNull.Value));
                param.Add(new SqlParameter("@EmpId", DBNull.Value));
                param.Add(new SqlParameter("@AttId", DBNull.Value));
                param.Add(new SqlParameter("@DayType", DBNull.Value));
                param.Add(new SqlParameter("@InTime", DBNull.Value));
                param.Add(new SqlParameter("@OutTime", DBNull.Value));
                param.Add(new SqlParameter("@BranchId", DBNull.Value));
                param.Add(new SqlParameter("@CalendarDetailsId", existentry.Id));

                var res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalanderConfig", param.ToArray());
                //if (result.Rows.Count > 0)
                //{
                //    cr.results = result;
                //    cr.httpStatusCode = HttpStatusCode.OK;
                //}

            }
            return Json(cr);
        }

        [Route("Attendance/GetEmpCalendarEvents")]
        [HttpGet]
        public IHttpActionResult GetEmpCalendarEvents()
        {
            string start = HttpContext.Current.Request.Params[1].ToString();
            string end = HttpContext.Current.Request.Params[2].ToString();
            int CaladnderId = Convert.ToInt32(HttpContext.Current.Request.Params[0].ToString());
            string _ = HttpContext.Current.Request.Params[2].ToString();
            CommonResponse cr = new CommonResponse();
            DateTime FromDate = Convert.ToDateTime(start);
            DateTime ToDate = Convert.ToDateTime(end);
            List<object> lstRes = new List<object>();
            var result = DataAccess.Instance.EmpAcademicCalandarDetailsService.Filter(e => e.CalendarId == CaladnderId && e.CalendarDate >= FromDate && e.CalendarDate <= ToDate).Distinct().ToList();
            if (result.Any())
            {
                foreach (var item in result)
                {
                    lstRes.Add(new
                    {
                        title = item.DayType == Enums.DayType.Holiday.ToString() ? item.HolidayName : item.DayType
                        ,
                        start = item.CalendarDate.ToString("yyyy-MM-dd"),
                        end = item.CalendarDate.ToString("yyyy-MM-dd"),
                        allDay = true,
                        backgroundColor = item.ColorCode,
                        textColor = Color.Black,
                        display = "background",
                        //rendering = item.DayType == Enums.DayType.Holiday.ToString() ? "background" : null,
                        //overlap= item.DayType == Enums.DayType.Holiday.ToString() ? false:true,
                        //color = "#ff9f89"
                    });
                }
            }
            return Json(lstRes);
        }
        [Route("Attendance/GetYearRange/{CalendarId}")]
        [HttpGet]
        public IHttpActionResult GetYearRange(int CalendarId)
        {
            //DateTime fDate = Convert.ToDateTime(fromDate);
            //DateTime tDate = Convert.ToDateTime(toDate);
            CommonResponse res = new CommonResponse();
            //var result = DataAccess.Instance.CommonServices.GetBySp("GetAllRosterRegular");
            DataTable result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalendarDateRange", new object[] { CalendarId, 'Y', DBNull.Value });
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }
        [Route("Attendance/GetMonthRange/{CalendarId}/{Year}")]
        [HttpGet]
        public IHttpActionResult GetMonthRange(int CalendarId, int Year)
        {
            //DateTime fDate = Convert.ToDateTime(fromDate);
            //DateTime tDate = Convert.ToDateTime(toDate);
            CommonResponse res = new CommonResponse();
            //var result = DataAccess.Instance.CommonServices.GetBySp("GetAllRosterRegular");
            DataTable result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalendarDateRange", new object[] { CalendarId, 'M', Year });
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }
        #endregion Emp Accademic Calendar

        [AllowAnonymous]
        [Route("Attendance/Zkteco/")]
        [HttpPost]
        public IHttpActionResult SaveZkteco(List<ZktecoLog> Attn) //P1. It will save or update attendance of student that is inputed
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = Attn;


            }
            catch (Exception ex)
            {


            }
            return Json(cr);
        }


        [Route("Attendance/GetEmpRosterApproveList/")]
        [HttpPost]
        public IHttpActionResult GetEmpRosterApproveList(EmpRosterVM empRosterlist)
        {

            CommonResponse res = new CommonResponse();
            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@Block", 3));
            param.Add(new SqlParameter("@BranchId", empRosterlist.BranchId));
            param.Add(new SqlParameter("@CategoryId", empRosterlist.EmpCategory));
            param.Add(new SqlParameter("@CalendarId", empRosterlist.CalendarId));
            param.Add(new SqlParameter("@Year", empRosterlist.Year));
            param.Add(new SqlParameter("@MonthId", empRosterlist.Month));

            DataTable result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRosterList", param.ToArray());
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Attendance/UpdateEmpRoster/")]
        [HttpPost]
        public IHttpActionResult UpdateEmpRoster(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpRoster empRoster;
                if (empRosterlist.Count > 0)
                {
                    empRoster = new EmpRoster();
                    foreach (var item in empRosterlist)
                    {

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateEmployeeRoster", new object[] { 1, item.EmpBasicInfoID, User.Identity.Name });
                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Attendance/RejectEmpRoster/")]
        [HttpPost]
        public IHttpActionResult RejectEmpRoster(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpRoster empRoster;
                if (empRosterlist.Count > 0)
                {
                    empRoster = new EmpRoster();
                    foreach (var item in empRosterlist)
                    {

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateEmployeeRoster", new object[] { 3, item.EmpBasicInfoID, User.Identity.Name });
                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Attendance/UpdateTemporaryEmpRoster/")]
        [HttpPost]
        public IHttpActionResult UpdateTemporaryEmpRoster(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpRoster empRoster;
                if (empRosterlist.Count > 0)
                {
                    empRoster = new EmpRoster();
                    foreach (var item in empRosterlist)
                    {

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateEmployeeRoster", new object[] { 2, item.RosterId, User.Identity.Name });
                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Attendance/RejectTemporaryEmpRoster/")]
        [HttpPost]
        public IHttpActionResult RejectTemporaryEmpRoster(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpRoster empRoster;
                if (empRosterlist.Count > 0)
                {
                    empRoster = new EmpRoster();
                    foreach (var item in empRosterlist)
                    {

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateEmployeeRoster", new object[] { 4, item.EmpBasicInfoID, User.Identity.Name });
                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }


        [Route("Attendance/UpdateModifyAttendanceApprove/")]
        [HttpPost]
        public IHttpActionResult UpdateModifyAttendanceApprove(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpRoster empRoster;
                if (empRosterlist.Count > 0)
                {
                    empRoster = new EmpRoster();
                    foreach (var item in empRosterlist)
                    {

                        //TimeSpan inTime = Convert.ToDateTime(item.InTime).TimeOfDay;
                        //TimeSpan outTime = Convert.ToDateTime(item.OutTime).TimeOfDay;

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateEmpModifyAttdance", new object[] { 3, item.AttendId, item.RequestId, User.Identity.Name, item.EmpBasicInfoID, item.InTime, item.FinalStatus });
                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Attendance/UpdateModifyAttendance/")]
        [HttpPost]
        public IHttpActionResult UpdateModifyAttendance(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpRoster empRoster;
                if (empRosterlist.Count > 0)
                {
                    empRoster = new EmpRoster();
                    foreach (var item in empRosterlist)
                    {

                        //TimeSpan inTime = Convert.ToDateTime(item.InTime).TimeOfDay;
                        //TimeSpan outTime = Convert.ToDateTime(item.OutTime).TimeOfDay;

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateEmpModifyAttdance", new object[] { 1, item.AttendId, item.RequestId, User.Identity.Name, item.EmpBasicInfoID, item.InTime, DBNull.Value });
                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Attendance/GetEmployeeRosterList/{BranchID}/{DepartmentID}/{EmpID}/{FromDate}/{TypeId}")]
        [HttpGet]
        public IHttpActionResult GetEmployeeRosterList(int? BranchID, int? DepartmentID, int? EmpID, string FromDate, int TypeId)
        {
            //DateTime searchDate = Convert.ToDateTime(FromDate);

            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllRosterRegular", new object[] { TypeId, FromDate, DBNull.Value, BranchID, DepartmentID, EmpID });
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Attendance/GetEmployeeRosterListAbsent/{BranchID}/{DepartmentID}/{EmpID}/{FromDate}")]
        [HttpGet]
        public IHttpActionResult GetEmployeeRosterListAbsent(int? BranchID, int? DepartmentID, int? EmpID, string FromDate)
        {
            //DateTime searchDate = Convert.ToDateTime(FromDate);

            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllRosterRegular", new object[] { 5, FromDate, DBNull.Value, BranchID, DepartmentID, EmpID });
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }


        [Route("Attendance/GetModifyAttendanceApprovalList/{BranchID}/{DepartmentID}/{EmpID}/{FromDate}/{typeId}")]
        [HttpGet]
        public IHttpActionResult GetModifyAttendanceApprovalList(int? BranchID, int? DepartmentID, int? EmpID, string FromDate, int typeId)
        {
            //DateTime searchDate = Convert.ToDateTime(FromDate);

            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllRosterRegular", new object[] { typeId, FromDate, DBNull.Value, BranchID, DepartmentID, EmpID });
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Attendance/GetModifyAttendanceAbsetApprovalList/{BranchID}/{DepartmentID}/{EmpID}/{FromDate}")]
        [HttpGet]
        public IHttpActionResult GetModifyAttendanceAbsetApprovalList(int? BranchID, int? DepartmentID, int? EmpID, string FromDate)
        {
            //DateTime searchDate = Convert.ToDateTime(FromDate);

            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllRosterRegular", new object[] { 6, FromDate, DBNull.Value, BranchID, DepartmentID, EmpID });
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Attendance/UpdateModifyAttendanceApproval/")]
        [HttpPost]
        public IHttpActionResult UpdateModifyAttendanceApproval(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpRoster empRoster;
                if (empRosterlist.Count > 0)
                {
                    empRoster = new EmpRoster();
                    foreach (var item in empRosterlist)
                    {

                        //TimeSpan inTime = Convert.ToDateTime(item.InTime).TimeOfDay;
                        //TimeSpan outTime = Convert.ToDateTime(item.OutTime).TimeOfDay;
                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateModifyEmpAttdance", new object[] { 1, item.AttendId, item.RequestId, User.Identity.Name, DBNull.Value, DBNull.Value, DBNull.Value });
                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Attendance/RejectModifyAttendanceApproval/")]
        [HttpPost]
        public IHttpActionResult RejectModifyAttendanceApproval(List<EmpRosterVM> empRosterlist)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpRoster empRoster;
                if (empRosterlist.Count > 0)
                {
                    empRoster = new EmpRoster();
                    foreach (var item in empRosterlist)
                    {

                        //TimeSpan inTime = Convert.ToDateTime(item.InTime).TimeOfDay;
                        //TimeSpan outTime = Convert.ToDateTime(item.OutTime).TimeOfDay;

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("RejectModifyEmpAttdance", new object[] { item.AttendId, DBNull.Value, item.FinalStatus, User.Identity.Name });
                        if (dt.Rows.Count > 0)
                        {
                            cr.message = Constant.SAVED;
                        }

                    }
                }


            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Attendance/SubmitEmployeeAttendanceList/{BranchID}/{DepartmentID}/{EmpID}/{FromDate}")]
        [HttpGet]
        public IHttpActionResult SubmitEmployeeAttendanceList(int? BranchID, int? DepartmentID, int? EmpID, string FromDate)
        {
            //DateTime searchDate = Convert.ToDateTime(FromDate);

            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllRosterRegular", new object[] { 4, FromDate, DBNull.Value, BranchID, DepartmentID, EmpID });
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Attendance/GetEmpAcademicCalendarDate/")]
        [HttpGet]
        public IHttpActionResult GetEmpAcademicCalendarDate()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("spGetEmpAcademicCalendarDate", new object[] { }).results;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        // Sourav : 10-02-21
        #region Emp Academic Calender
        [Route("Attendance/AddEmpAcademicCalendar/")]
        [HttpPost]
        public IHttpActionResult AddEmpAcademicCalendar(EmpAcademicCalandar empCalendar)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpAcademicCalandar _empCalendar = new EmpAcademicCalandar();
                _empCalendar.SetDate();

                if (empCalendar.IsUpdateExisting == false)
                {
                    bool isExist = DataAccess.Instance.CommonServices.IsExist(" [dbo].[Att_EmpAcademicCalendarDetails] ", $" CAST(CalendarDate AS DATE) BETWEEN CAST('{empCalendar.StartDate.ToString()}' AS DATE) AND CAST('{empCalendar.EndDate.ToString()}' AS DATE)");
                    if (isExist)
                    {
                        throw new Exception("Please Academic Calendar Overlapping.");
                    }
                }


                List<SqlParameter> param = new List<SqlParameter>();
                var ci = System.Globalization.CultureInfo.GetCultureInfo("en-us");
                empCalendar.InTime = new TimeSpan(Convert.ToInt32(empCalendar.In.Split('-').First()), Convert.ToInt32(empCalendar.In.Split('-').Last()), 0); // DateTime.Parse(empCalendar.In, ci).TimeOfDay;
                empCalendar.OutTime = new TimeSpan(Convert.ToInt32(empCalendar.Out.Split('-').First()), Convert.ToInt32(empCalendar.Out.Split('-').Last()), 0);

                param.Add(new SqlParameter("@Title", empCalendar.Title));
                param.Add(new SqlParameter("@StartDate", empCalendar.StartDate));
                param.Add(new SqlParameter("@EndDate", empCalendar.EndDate));
                param.Add(new SqlParameter("@EmpCategory", empCalendar.EmpCategory));
                param.Add(new SqlParameter("@EmpBranchId", empCalendar.EmpBranchId));
                param.Add(new SqlParameter("@WeekendDay", empCalendar.WeekendDay.Replace("'", "")));
                param.Add(new SqlParameter("@InTime", empCalendar.InTime));
                param.Add(new SqlParameter("@OutTime", empCalendar.OutTime));
                param.Add(new SqlParameter("@DefaultLateInTime", empCalendar.DefaultLITime));
                param.Add(new SqlParameter("@DefaultEarlyOutTime", empCalendar.DefaultEOTime));
                param.Add(new SqlParameter("@AddBy", User.Identity.Name));
                param.Add(new SqlParameter("@MacAddress", _empCalendar.MacAddress));
                param.Add(new SqlParameter("@IP", _empCalendar.IP));
                param.Add(new SqlParameter("@CalenderId", empCalendar.Id > 0 ? empCalendar.Id : 0));
                param.Add(new SqlParameter("@IsUpdateExisting", empCalendar.IsUpdateExisting));

                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("InsertIntoEmpAcademicCalender", param.ToArray());

                cr.message = empCalendar.Id > 0 ? Constant.UPDATED : Constant.SAVED;

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Attendance/GetEmpAcademicCalendarConfigDetails/")]
        [HttpPost]
        public IHttpActionResult GetEmpAcademicCalendarConfigDetails(EmpAcademicCalendarConfigDetailsVM calendarConfig)
        {
            // Show Calendar
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();

                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@CalendarId", calendarConfig.CalendarId));
                param.Add(new SqlParameter("@Year", calendarConfig.Year));
                param.Add(new SqlParameter("@Month", calendarConfig.Month));
                param.Add(new SqlParameter("@EmpId", calendarConfig.EmpId));
                param.Add(new SqlParameter("@AttId", DBNull.Value));
                param.Add(new SqlParameter("@DayType", DBNull.Value));
                param.Add(new SqlParameter("@InTime", DBNull.Value));
                param.Add(new SqlParameter("@OutTime", DBNull.Value));
                param.Add(new SqlParameter("@BranchId", DBNull.Value));
                param.Add(new SqlParameter("@CalendarDetailsId", DBNull.Value));


                var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalanderConfig", param.ToArray());
                if (result.Rows.Count > 0)
                {
                    cr.results = result;
                    cr.httpStatusCode = HttpStatusCode.OK;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Attendance/UpdateEmpCalendarConfig/")]
        [HttpPost]
        public IHttpActionResult UpdateEmpCalendarConfig(EmpAcademicCalendarConfigDetailsVM calendarConfig)
        {
            // Show Calendar
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();

                var ci = System.Globalization.CultureInfo.GetCultureInfo("en-us");
                var inTime = DateTime.Parse(calendarConfig.OfficeInTime, ci).TimeOfDay;
                var outTime = DateTime.Parse(calendarConfig.OfficeOutTime, ci).TimeOfDay;

                param.Add(new SqlParameter("@Block", 2));
                param.Add(new SqlParameter("@CalendarId", DBNull.Value));
                param.Add(new SqlParameter("@Year", DBNull.Value));
                param.Add(new SqlParameter("@Month", DBNull.Value));
                param.Add(new SqlParameter("@EmpId", DBNull.Value));
                param.Add(new SqlParameter("@AttId", calendarConfig.AttendId));
                param.Add(new SqlParameter("@DayType", calendarConfig.AttDayType));
                param.Add(new SqlParameter("@InTime", inTime));
                param.Add(new SqlParameter("@OutTime", outTime));
                param.Add(new SqlParameter("@BranchId", DBNull.Value));
                param.Add(new SqlParameter("@CalendarDetailsId", DBNull.Value));

                var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalanderConfig", param.ToArray());
                if (result.Rows.Count > 0)
                {
                    cr.results = result;
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = Constant.UPDATED;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }


        [Route("Attendance/EmpCalendarConfigBulkUpdate/")]
        [HttpPost]
        public IHttpActionResult EmpCalendarConfigBulkUpdate(EmpAcademicCalendarConfigDetailsVM calendarConfig)
        {
            // Bulk Update
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();

                var ci = System.Globalization.CultureInfo.GetCultureInfo("en-us");
                var inTime = DateTime.Parse(calendarConfig.In, ci).TimeOfDay;
                var outTime = DateTime.Parse(calendarConfig.Out, ci).TimeOfDay;

                param.Add(new SqlParameter("@Block", 3));
                param.Add(new SqlParameter("@CalendarId", calendarConfig.CalendarId));
                param.Add(new SqlParameter("@Year", DBNull.Value));
                param.Add(new SqlParameter("@Month", DBNull.Value));
                param.Add(new SqlParameter("@EmpId", calendarConfig.EmpId));
                param.Add(new SqlParameter("@AttId", DBNull.Value));
                param.Add(new SqlParameter("@DayType", DBNull.Value));
                param.Add(new SqlParameter("@InTime", inTime));
                param.Add(new SqlParameter("@OutTime", outTime));
                param.Add(new SqlParameter("@BranchId", calendarConfig.EmpBranchId));
                param.Add(new SqlParameter("@CalendarDetailsId", DBNull.Value));

                var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpCalanderConfig", param.ToArray());
                if (result.Rows.Count > 0)
                {
                    cr.results = result;
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = Constant.UPDATED;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion

        #region Sync Attendace Data
        [Route("Attendance/SyncAttDeviceData/")]
        [HttpPost]
        public IHttpActionResult SyncAttDeviceData(AttendanceDeviceSyncVM syncDevie)
        {
            // Show Calendar
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();
                var syncDate = Convert.ToDateTime(syncDevie.Date);
                var fromDate = Convert.ToDateTime(syncDevie.FromDate);
                var toDate = Convert.ToDateTime(syncDevie.ToDate);
                var userName = User.Identity.Name;

                param.Add(new SqlParameter("@Block", 1));
                param.Add(new SqlParameter("@BranchId", syncDevie.BranchId));
                param.Add(new SqlParameter("@CategoryId", syncDevie.CategoryId));
                param.Add(new SqlParameter("@DepartmentId", syncDevie.DepartmentId));
                param.Add(new SqlParameter("@DesignationId", syncDevie.DesignationId));
                param.Add(new SqlParameter("@EmpId", syncDevie.EmpId));
                param.Add(new SqlParameter("@AttDeviceId", syncDevie.AttDeviceId));
                param.Add(new SqlParameter("@Date", syncDate));
                param.Add(new SqlParameter("@FromDate", fromDate));
                param.Add(new SqlParameter("@ToDate", toDate));
                param.Add(new SqlParameter("@UserName", userName));

                var result = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_ProcessAttendance", param.ToArray());
                if (result.Rows.Count > 0)
                {
                    cr.results = result;
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Processed Successfully.";
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Attendance/SyncDeviceEmpData/")]
        [HttpPost]
        public IHttpActionResult SyncDeviceEmpData(AttendanceDeviceSyncVM syncDevie)
        {
            // Show Calendar
            CommonResponse cr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();
                var syncDate = Convert.ToDateTime(syncDevie.Date);
                var fromDate = Convert.ToDateTime(syncDevie.FromDate);
                var toDate = Convert.ToDateTime(syncDevie.ToDate);
                var userName = User.Identity.Name;

                param.Add(new SqlParameter("@Block", 2));
                param.Add(new SqlParameter("@BranchId", syncDevie.BranchId));
                param.Add(new SqlParameter("@CategoryId", syncDevie.CategoryId));
                param.Add(new SqlParameter("@DepartmentId", syncDevie.DepartmentId));
                param.Add(new SqlParameter("@DesignationId", syncDevie.DesignationId));
                param.Add(new SqlParameter("@EmpId", syncDevie.EmpId));
                param.Add(new SqlParameter("@AttDeviceId", syncDevie.AttDeviceId));
                param.Add(new SqlParameter("@Date", syncDate));
                param.Add(new SqlParameter("@FromDate", fromDate));
                param.Add(new SqlParameter("@ToDate", toDate));
                param.Add(new SqlParameter("@UserName", userName));

                var result = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_ProcessAttendance", param.ToArray());
                if (result.Rows.Count > 0)
                {
                    cr.results = result;
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Processed Successfully.";
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Attendance/GetAttdModifyLogList/{processType}")]
        [HttpGet]
        public IHttpActionResult GetAttdModifyLogList(string processType)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.ExecuteSQLQUERY($"SELECT AL.*, AU.FullName FROM Att_AttendanceLog AL INNER JOIN AspNetUsers AU ON AL.AddBy = AU.UserName WHERE AL.IsDeleted = 0 AND AL.LogType = '{ processType}' ORDER BY AL.Id DESC");
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
        #endregion


        #region Emp Leave Type Modification
        [Route("Attendance/GetAllModificationType/")]
        [HttpGet]
        public IHttpActionResult GetAllModificationType()
        {
            CommonResponse cr = new CommonResponse();
            var list = DataAccess.Instance.EmpLeaveModifyService.Filter(e => e.IsDeleted == false && e.IsAdmin == true).OrderByDescending(e => e.Id).ToList();

            cr.results = list;
            cr.httpStatusCode = cr.results != null ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = cr.results != null ? Constant.SUCCESS : Constant.FAILED;

            return Json(cr);
        }

        [Route("Attendance/GetAllModificationTypeList/")]
        [HttpGet]
        public IHttpActionResult GetAllModificationTypeList()
        {
            CommonResponse cr = new CommonResponse();
            var list = DataAccess.Instance.EmpLeaveModifyService.Filter(e => e.IsDeleted == false).OrderByDescending(e => e.Id).ToList();

            cr.results = list;
            cr.httpStatusCode = cr.results != null ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = cr.results != null ? Constant.SUCCESS : Constant.FAILED;

            return Json(cr);
        }

        [Route("Attendance/AddLeaveModificationType/")]
        [HttpPost]
        public IHttpActionResult AddLeaveModificationType(EmpLeaveModify modficationType)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.EmpLeaveModifyService.Filter(e => e.IsDeleted == false).ToList();
                if (list.Any(t => t.Title == modficationType.Title))
                {
                    throw new Exception("Title Aleardy Exits");
                }

                modficationType.AddBy = User.Identity.Name;
                modficationType.IsDeleted = false;
                modficationType.Status = "A";
                modficationType.SetDate();

                var res = DataAccess.Instance.EmpLeaveModifyService.Add(modficationType);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cr);
        }

        [Route("Attendance/UpdateLeaveModificationType/")]
        [HttpPut]
        public IHttpActionResult UpdateLeaveModificationType(EmpLeaveModify modficationType)
        {
            // Update Class Period
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.EmpLeaveModifyService.Filter(e => e.Id != modficationType.Id && e.IsDeleted == false).ToList();
                if (list.Any(t => t.Title == modficationType.Title))
                {
                    throw new Exception("Title Aleardy Exits");
                }
                modficationType.UpdateBy = User.Identity.Name;
                modficationType.SetDate();
                var res = DataAccess.Instance.EmpLeaveModifyService.Update(modficationType);

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message);
            }

            return Json(cr);
        }

        [Route("Attendance/DeleteLeaveModificationType/{modifyTypeId}")]
        [HttpDelete]
        public IHttpActionResult DeleteLeaveModificationType(int modifyTypeId)
        {
            CommonResponse cr = new CommonResponse();

            var modficationType = DataAccess.Instance.EmpLeaveModifyService.Get(modifyTypeId);

            modficationType.IsDeleted = true;
            modficationType.UpdateBy = User.Identity.Name;
            modficationType.SetDate();
            bool res = DataAccess.Instance.EmpLeaveModifyService.Update(modficationType);

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }



        #endregion LeaveType

        #region Emp Attd Modify Request
        [Route("Attendance/AddEmpAttModifyRequest/")]
        [HttpPost]
        public IHttpActionResult AddEmpAttModifyRequest(EmpRosterVM empRoster)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateEmpModifyAttdance", new object[] { 2, empRoster.AttendId, empRoster.RequestId, User.Identity.Name, empRoster.EmpBasicInfoID, empRoster.InTime, empRoster.Reason });
                if (dt.Rows.Count > 0)
                {
                    cr.message = Constant.SAVED;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Attendance/GetAllModificationTypeForEmp/")]
        [HttpGet]
        public IHttpActionResult GetAllModificationTypeForEmp()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var list = DataAccess.Instance.EmpLeaveModifyService.Filter(e => e.IsDeleted == false && e.IsEmployee == true && e.IsAdmin != true).ToList();

                cr.results = list;
                cr.httpStatusCode = cr.results != null ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = cr.results != null ? Constant.SUCCESS : Constant.FAILED;
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Attendance/GetEmpAttendanceList/")]
        [HttpGet]
        public IHttpActionResult GetEmpAttendanceList()
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                var EmpId = DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId;

                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@EmpId", EmpId));
                DataTable res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpAttendanceList", param.ToArray());
                cr.results = res;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion
    }


}
