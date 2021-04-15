using Newtonsoft.Json;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Constant;
using OEMS.Models.Model.Attendance;
using OEMS.Models.Model.Student;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Http;

using UI.Portal.Models;

namespace UI.Portal.Controllers.API
{
    public class PortalAttendenceController : ApiController
    {
        [Route("PortalAttendence/GetStudentAttendence/")]
        public IHttpActionResult GetStudentAttendence()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var StudentInsID = User.Identity.Name;
                var StudentIID = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == StudentInsID).FirstOrDefault().StudentIID;
                var data = DataAccess.Instance.StudentAttendanceService.Filter(e => e.StudentId == StudentIID).GroupBy(e=>e.InTime.Month,e=>e.StudentId,(key,g) =>new { StudentId=key, StudentAttendance=g.ToList() });
                cr.results = data;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("PortalAttendence/GetAllLeaveType/")]
        [HttpGet]
        public IHttpActionResult GetAllLeaveType()
        {
            CommonResponse cr = new CommonResponse();
            cr.results = GetAllLeave();
            cr.httpStatusCode = cr.results != null ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = cr.results != null ? Constant.SUCCESS : Constant.FAILED;
            return Json(cr);
        }

        private List<LeaveTypes> GetAllLeave()
        {
            return DataAccess.Instance.LeaveTypesService.Filter(e => e.IsDeleted == false).ToList();
        }

        [Route("PortalAttendance/GetStudentLeavesbyId/")]
        [HttpPost]
        public IHttpActionResult GetStudentLeavesbyId()
        {
            int SIID = Convert.ToInt32(User.Identity.GetUserStudentId());
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("Attendence", new object[] { 6, DBNull.Value, DBNull.Value, DBNull.Value, SIID, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value }).results;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("PortalAttendance/SaveLeaveApply/")]
        [HttpPost]
        public IHttpActionResult SaveLeaveApply()
        {
            
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["file"] : null;
            string value = HttpContext.Current.Request.Form["ApplyLeave"] ?? "";
            int SId = Convert.ToInt32(User.Identity.GetUserStudentId());
            StudentLeave leave = JsonConvert.DeserializeObject<StudentLeave>(value); //  Deserialize Form Data
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
                leave.File = data_image;
            }
            CommonResponse cr = new CommonResponse();
            try
            {
                if (leave != null)
                {
                    var dates = new List<DateTime>();
                    leave.FromDate = Convert.ToDateTime(leave.From);
                    leave.ToDate = Convert.ToDateTime(leave.To);
                    leave.RequestOn = Convert.ToDateTime(leave.Request);
                    leave.StudentIId = SId;
                    leave.UpdateBy = User.Identity.GetInsId();
                    leave.UpdateDate = DateTime.Now;
                    for (var dt = leave.FromDate; dt <= leave.ToDate; dt = dt.AddDays(1))
                    {
                        dates.Add(dt);
                    }
                    // for chack IsPresent is exist in thouse days....
                    foreach (DateTime d in dates)
                    {
                        StudentAttendance st = DataAccess.Instance.StudentAttendanceService.GetAll().FirstOrDefault(s => s.InTime == d && s.IsPresent == true && s.StudentId == SId && s.IsDeleted == false);
                        if (st != null)
                        {
                            throw new Exception("Leave can't be applicable. " + d.ToString("dd/MM/yyyy") + " already Attend");
                        }
                    }

                    List<AcademicCalendar> a = DataAccess.Instance.AcademicCalendarService.Filter(e => e.DayType != "Regular" && (e.CalendarDate == leave.FromDate || e.CalendarDate == leave.ToDate)).ToList();
                    if (a.Count != 0)
                    {
                        throw new Exception("Date Range is Not Valid.");
                    }
                    leave.Status = "Pending";
                    leave.AddBy = User.Identity.Name;
                    leave.SetDate();
                    var res = DataAccess.Instance.StudentLeaveService.Add(leave);
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("PortalAttendance/GetAttendence")]
        [HttpGet]
        public IHttpActionResult GetAttendence(int StdId, int? Month)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (Month == null)
                    Month = 0;

                var res = DataAccess.Instance.CommonServices.GetResponseBySpWithParam("GetStudentAttendence", new object[] { StdId, Month }).results;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.results = res;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
            
        }

        [Route("PortalAttendance/GetCalendarEvents/")]
        [HttpGet]
        public IHttpActionResult GetCalendarEvents()
        {
            string start = HttpContext.Current.Request.Params[0].ToString();
            string end = HttpContext.Current.Request.Params[1].ToString();
            string _ = HttpContext.Current.Request.Params[2].ToString();
            CommonResponse cr = new CommonResponse();
            DateTime FromDate = Convert.ToDateTime(start);
            DateTime ToDate = Convert.ToDateTime(end);
            List<object> lstRes = new List<object>();
            var result = DataAccess.Instance.AcademicCalendarService.Filter(e => e.CalendarDate >= FromDate && e.CalendarDate <= ToDate).ToList();
            if (result.Any())
            {
                foreach (var item in result)
                {
                    lstRes.Add(new
                    {
                        title = item.DayType == Enums.DayType.Holiday.ToString() ? item.HolidayName : item.DayType
                        ,
                        start = item.CalendarDate.ToString("yyyy-MM-dd"),
                        allDay = true,
                        backgroundColor = item.ColorCode,
                        textColor = Color.Black,
                        //rendering = item.DayType == Enums.DayType.Holiday.ToString() ? "background" : null,
                        //overlap= item.DayType == Enums.DayType.Holiday.ToString() ? false:true,
                        color = "#ff9f89"
                    });
                }
            }
            return Json(lstRes);
        }

        [Route("PortalAttendance/DeleteStudentLeavesbyId/{ID}")]
        [HttpPost]
        public IHttpActionResult DeleteStudentLeavesbyId(int ID)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var leave = DataAccess.Instance.StudentLeaveService.SingleOrDefault(s => s.LeaveId == ID);
                leave.Status = "Delete";
                leave.IsDeleted = true;
                var dates = new List<DateTime>();
                for (var dt = leave.FromDate; dt <= leave.ToDate; dt = dt.AddDays(1))
                {
                    dates.Add(dt);
                }
                foreach (DateTime d in dates)
                {
                    var attdata = DataAccess.Instance.StudentAttendanceService.Filter(e => e.InTime == d && e.StudentId == leave.StudentIId).FirstOrDefault();
                    if (attdata != null)
                    {
                        var re = DataAccess.Instance.StudentAttendanceService.Remove(attdata.AttendId);
                        cr.httpStatusCode = re ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    }
                }
                var re1 = DataAccess.Instance.StudentLeaveService.Update(leave);
                cr.message = "Delete Successfull.";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

       
    }
}
