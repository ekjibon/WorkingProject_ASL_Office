using Newtonsoft.Json;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.Attendance;
using OEMS.Models.Model.Employee;
using OEMS.Models.Model.Student;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using UI.Portal.Models;

namespace UI.Portal.Controllers.API
{
    public class PortalRequestController : ApiController
    {
        [HttpGet]
        [Route("PortalRequest/GetAllCategory/")]
        public IHttpActionResult GetAllCategory()
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.EmpCategoryService.Filter(e=> e.IsDeleted==false);
            return Json(cr);
        }
        [HttpGet]
        [Route("PortalRequest/GetAllDesignation/{Id}")]
        public IHttpActionResult GetAllDesignation(string Id)
        {
            CommonResponse cr = new CommonResponse();
            cr.results = DataAccess.Instance.EmpDesignationtService.Filter(e => e.IsDeleted == false && e.CategoryID== Id);
            return Json(cr);
        }

        
        [Route("PortalRequest/AddRequest/")]
        [HttpPost]
        public IHttpActionResult AddRequest()
        {
            CommonResponse cr = new CommonResponse();
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["file"] : null;
            string value = HttpContext.Current.Request.Form["Request"] ?? "";
            int SId = Convert.ToInt32(User.Identity.GetUserStudentId());

            var studentd = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == SId).FirstOrDefault();
            StudentRequest studentRequest = JsonConvert.DeserializeObject<StudentRequest>(value); //  Deserialize Form Data



            if (studentRequest.RequestType ==4)
            {
                studentRequest.Remarks = "Pending";
            }
            if (studentRequest.RequestType!=5)
            {
                file = null;
                studentRequest.FromDate = DateTime.Now;
                studentRequest.ToDate = DateTime.Now;
                //studentRequest.RequestOn = DateTime.Now;
            }
            else if (studentRequest.RequestType == 5)
            {
                studentRequest.FromDate = Convert.ToDateTime(studentRequest.From);
                studentRequest.ToDate = Convert.ToDateTime(studentRequest.To);
                //studentRequest.RequestOn = Convert.ToDateTime(studentRequest.Request);
                var dates = new List<DateTime>();

                for (var dt = studentRequest.FromDate; dt <= studentRequest.ToDate; dt = dt.AddDays(1))
                {
                    dates.Add(dt);
                }
                // for chack IsPresent is exist in thouse days....
                foreach (DateTime d in dates)
                {
                    StudentAttendance st = DataAccess.Instance.StudentAttendanceService.GetAll().FirstOrDefault(s => s.InTime == d && s.IsPresent == true && s.StudentId == studentRequest.StudentId && s.IsDeleted == false);
                    if (st != null)
                    {
                        throw new Exception("Leave can't be applicable. " + d.ToString("dd/MM/yyyy") + " already Attend");
                    }
                }

                List<AcademicCalendar> a = DataAccess.Instance.AcademicCalendarService.Filter(e => e.DayType != "Regular" && (e.CalendarDate == studentRequest.FromDate || e.CalendarDate == studentRequest.ToDate)).ToList();
                if (a.Count != 0)
                {
                    throw new Exception("Date Range is Not Valid.");
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
                studentRequest.File = data_image;
            }
          
            try
            {
                if (studentRequest != null)
                {
                    if (studentRequest.RequestType==1 || studentRequest.RequestType==2)
                    {
                        studentRequest.Date = Convert.ToDateTime(studentRequest.MDate);

                        int y = Convert.ToInt32(studentRequest.Date.Value.ToString("yyyy"));
                        int M = Convert.ToInt32(studentRequest.Date.Value.ToString("MM"));
                        List<AcademicCalendar> list = DataAccess.Instance.AcademicCalendarService.Filter(c => c.IsDeleted == false && c.Year == y && c.Month == M && (c.DayType == "Weekend" || c.DayType == "Holiday")).ToList();
                        // DateTime d = new DateTime(studentRequest.Date);
                        if (list.Count()>0)
                        {
                            foreach (var item in list)
                            {

                                if (item.CalendarDate.ToString("MM/dd/yyyy") == studentRequest.Date.Value.ToString("MM/dd/yyyy"))
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
                    if (studentRequest.RequestType == 1)
                    {
                   
                        if (studentRequest.Time.Value.Hour > 11)
                        {
                            studentRequest.Time = studentRequest.Time.Value.AddHours(-6);
                        }
                        else
                        {
                            studentRequest.Time = studentRequest.Time.Value.AddHours(6);
                        }
                        if (studentRequest.CategoryId==5)
                        {
                            
                            EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted ==false && e.Status=="A" && e.BranchId==studentd.BranchID && e.ClassId == studentd.ClassId).FirstOrDefault();
                            var st = empMeeting.StartTime.Value.Hour; //10 11
                            var et = empMeeting.EndTime.Value.Hour; //2
                            var stm = empMeeting.StartTime.Value.Minute;
                            var etm = empMeeting.EndTime.Value.Minute;
                            if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour > et)
                            {
                                cr.results = 3;
                                throw new Exception("Invalid Time");

                            }
                            //if (stm > studentRequest.Time.Value.Minute || studentRequest.Time.Value.Minute > etm)
                            //{
                            //    cr.results = 3;
                            //    throw new Exception("Invalid Time");
                            //}
                        }
                        //Developed by Khaled
                        // Start
                        if (studentRequest.CategoryId == 1)
                        {

                            EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                            var st = empMeeting.StartTime.Value.Hour; //10 11
                            var et = empMeeting.EndTime.Value.Hour; //2
                            var stm = empMeeting.StartTime.Value.Minute;
                            var etm = empMeeting.EndTime.Value.Minute;

                            if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour >= et)
                            {
                                cr.results = 3;
                                throw new Exception("Invalid Time");

                            }
                            //if (stm > studentRequest.Time.Value.Minute || studentRequest.Time.Value.Minute > etm)
                            //{
                            //    cr.results = 3;
                            //    throw new Exception("Invalid Time");
                            //}
                        }
                        if (studentRequest.CategoryId == 2)
                        {

                            EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                            var st = empMeeting.StartTime.Value.Hour; //10 11
                            var et = empMeeting.EndTime.Value.Hour; //2
                            var stm = empMeeting.StartTime.Value.Minute;
                            var etm = empMeeting.EndTime.Value.Minute;
                            if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour >= et)
                            {

                                cr.results = 3;
                                throw new Exception("Invalid Time");

                            }
                            //if (stm > studentRequest.Time.Value.Minute || studentRequest.Time.Value.Minute > etm)
                            //{
                            //    cr.results = 3;
                            //    throw new Exception("Invalid Time");
                            //}
                            if (stm >= studentRequest.Time.Value.Minute)
                            {
                                cr.results = 3;
                                throw new Exception("Invalid Time");
                            }


                        }


                        if (studentRequest.CategoryId == 3)
                        {

                            EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A" ).FirstOrDefault();
                            var st = empMeeting.StartTime.Value.Hour; //10 11
                            var et = empMeeting.EndTime.Value.Hour; //2
                            var stm = empMeeting.StartTime.Value.Minute;
                            var etm = empMeeting.EndTime.Value.Minute;
                            if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour >= et)
                            {
                                cr.results = 3;
                                throw new Exception("Invalid Time");

                            }
                            //if (stm > studentRequest.Time.Value.Minute || studentRequest.Time.Value.Minute > etm)
                            //{
                            //    cr.results = 3;
                            //    throw new Exception("Invalid Time");
                            //}
                        }

                        if (studentRequest.CategoryId == 4)
                        {

                            EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                            var st = empMeeting.StartTime.Value.Hour; //10 11
                            var et = empMeeting.EndTime.Value.Hour; //2
                            var stm = empMeeting.StartTime.Value.Minute;
                            var etm = empMeeting.EndTime.Value.Minute;
                            if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour >= et)
                            {
                                cr.results = 3;
                                throw new Exception("Invalid Time");

                            }
                            //if (stm > studentRequest.Time.Value.Minute || studentRequest.Time.Value.Minute > etm)
                            //{
                            //    cr.results = 3;
                            //    throw new Exception("Invalid Time");
                            //}
                        }

                        if (studentRequest.CategoryId == 6)
                        {

                            EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                            var st = empMeeting.StartTime.Value.Hour; //10 11
                            var et = empMeeting.EndTime.Value.Hour; //2
                            var stm = empMeeting.StartTime.Value.Minute;
                            var etm = empMeeting.EndTime.Value.Minute;
                            if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour >= et)
                            {
                                cr.results = 3;
                                throw new Exception("Invalid Time");

                            }
                            //if (stm > studentRequest.Time.Value.Minute || studentRequest.Time.Value.Minute > etm)
                            //{
                            //    cr.results = 3;
                            //    throw new Exception("Invalid Time");
                            //}
                        }

                        if (studentRequest.CategoryId == 7)
                        {

                            EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                            var st = empMeeting.StartTime.Value.Hour; //10 11
                            var et = empMeeting.EndTime.Value.Hour; //2
                            var stm = empMeeting.StartTime.Value.Minute;
                            var etm = empMeeting.EndTime.Value.Minute;
                            if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour >= et)
                            {
                                cr.results = 3;
                                throw new Exception("Invalid Time");
                            }
                            //if (stm > studentRequest.Time.Value.Minute || studentRequest.Time.Value.Minute > etm)
                            //{
                            //    cr.results = 3;
                            //    throw new Exception("Invalid Time");
                            //}
                        }

                        //End

                        //for (int i = st; i < et; i++)
                        //{
                        //    if (studentRequest.Time.Value.Hour != i)
                        //    {
                        //        cr.results = 3;
                        //        throw new Exception("InValid Time");
                        //    }
                        //}


                    }
                    studentRequest.StudentId = SId;
                    studentRequest.UpdateBy = User.Identity.GetInsId();
                    studentRequest.UpdateDate = DateTime.Now;
                    
                    studentRequest.IsDeleted = false;
                    studentRequest.Status = "Pending";
                    studentRequest.SetDate();
                    studentRequest.AddBy = User.Identity.GetInsId();
                  
                    studentRequest.AddDate = DateTime.Now;
                    var res = DataAccess.Instance.StudentRequestService.Add(studentRequest);
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
        [Route("PortalRequest/UpdateRequest/")]
        [HttpPost]
        public IHttpActionResult UpdateRequest()
        {
            CommonResponse cr = new CommonResponse();
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["file"] : null;
            string value = HttpContext.Current.Request.Form["Request"] ?? "";
            int SId = Convert.ToInt32(User.Identity.GetUserStudentId());
            StudentRequest studentRequest = JsonConvert.DeserializeObject<StudentRequest>(value); //  Deserialize Form Data
            //studentRequest.GetTime = studentRequest.GetTime.AddHours(6);
            StudentRequest data = new StudentRequest();
            try
            {
                data = DataAccess.Instance.StudentRequestService.Filter(s => s.IsDeleted == false && s.Status == "Pending" && s.Id == studentRequest.Id).FirstOrDefault();
                if (data!=null)
                {
                    if (studentRequest.RequestType==2)
                    {
                        // data.Date = Convert.ToDateTime(studentRequest.MDate);
                        data.Date = studentRequest.Date;
                    }
                    if (studentRequest.RequestType == 4)
                    {
                        data.RequestType = studentRequest.RequestType;
                        data.Reason = studentRequest.Reason;
                        data.Description = studentRequest.Description;
                        data.LeaveDate = studentRequest.LeaveDate;
                        int y = Convert.ToInt32(studentRequest.LeaveDate.Value.ToString("yyyy"));
                        int M = Convert.ToInt32(studentRequest.LeaveDate.Value.ToString("MM"));
                        List<AcademicCalendar> list = DataAccess.Instance.AcademicCalendarService.Filter(c => c.IsDeleted == false && c.Year == y && c.Month == M && (c.DayType == "Weekend" || c.DayType == "Holiday")).ToList();
                        // DateTime d = new DateTime(studentRequest.Date);
                        if (list.Count() > 0)
                        {
                            foreach (var item in list)
                            {

                                if (item.CalendarDate.ToString("MM/dd/yyyy") == studentRequest.LeaveDate.Value.ToString("MM/dd/yyyy"))
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
                    if (studentRequest.RequestType==3)
                    {
                        data.RequestType = studentRequest.RequestType;
                        data.NOCType = studentRequest.NOCType;
                        data.TravelDesination = studentRequest.TravelDesination;
                        data.TravelFrom = studentRequest.TravelFrom;
                        data.TravelTo = studentRequest.TravelTo;
                        data.Description = studentRequest.Description;
                    }
                    if (studentRequest.RequestType != 5)
                    {
                        file = null;
                        data.FromDate = data.FromDate;
                        data.ToDate = data.ToDate;
                        data.RequestOn = data.RequestOn;
                    }
                    else if (studentRequest.RequestType == 5)
                    {
                        data.RequestType = studentRequest.RequestType;
                        data.FromDate = Convert.ToDateTime(studentRequest.From);
                        data.ToDate = Convert.ToDateTime(studentRequest.To);
                        data.RequestOn = Convert.ToDateTime(studentRequest.Request);
                        data.Description = studentRequest.Description;
                        var dates = new List<DateTime>();

                        for (var dt = data.FromDate; dt <= data.ToDate; dt = dt.AddDays(1))
                        {
                            dates.Add(dt);
                        }
                        // for chack IsPresent is exist in thouse days....
                        foreach (DateTime d in dates)
                        {
                            StudentAttendance st = DataAccess.Instance.StudentAttendanceService.GetAll().FirstOrDefault(s => s.InTime == d && s.IsPresent == true && s.StudentId == data.StudentId && s.IsDeleted == false);
                            if (st != null)
                            {
                                throw new Exception("Leave can't be applicable. " + d.ToString("dd/MM/yyyy") + " already Attend");
                            }
                        }

                        List<AcademicCalendar> a = DataAccess.Instance.AcademicCalendarService.Filter(e => e.DayType != "Regular" && (e.CalendarDate == data.FromDate || e.CalendarDate == data.ToDate)).ToList();
                        if (a.Count != 0)
                        {
                            throw new Exception("Date Range is Not Valid.");
                        }
                       // data.Date = Convert.ToDateTime(studentRequest.MDate);
                        int y = Convert.ToInt32(studentRequest.RequestOn.Value.ToString("yyyy"));
                        int M = Convert.ToInt32(studentRequest.RequestOn.Value.ToString("MM"));
                        List<AcademicCalendar> list = DataAccess.Instance.AcademicCalendarService.Filter(c => c.IsDeleted == false && c.Year == y && c.Month == M && (c.DayType == "Weekend" || c.DayType == "Holiday")).ToList();
                        // DateTime d = new DateTime(studentRequest.Date);
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
                                if (data.Time !=studentRequest.Time)
                                {
                                    if (studentRequest.Time.Value.Hour < 11)
                                    {
                                        data.Time = studentRequest.Time.Value.AddHours(-6);
                                        studentRequest.Time = studentRequest.Time.Value.AddHours(6);
                                    }
                                    else
                                    {
                                        data.Time = studentRequest.Time.Value.AddHours(6);
                                        studentRequest.Time = studentRequest.Time.Value.AddHours(-6);

                                    }
                                }
                                if (studentRequest.CategoryId == 5)
                                {
                                    EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                                    var st = empMeeting.StartTime.Value.Hour; //10 11
                                    var et = empMeeting.EndTime.Value.Hour; //2
                                    if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour > et)
                                    {
                                        cr.results = 3;
                                        throw new Exception("Invalid Time");
                                    }
                                }

                                //Developed by Khaled
                                // Start
                                if (studentRequest.CategoryId == 1)
                                {

                                    EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                                    var st = empMeeting.StartTime.Value.Hour; //10 11
                                    var et = empMeeting.EndTime.Value.Hour; //2
                                    if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour > et)
                                    {
                                        cr.results = 3;
                                        throw new Exception("Invalid Time");
                                    }
                                }

                                if (studentRequest.CategoryId == 2)
                                {

                                    EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A" ).FirstOrDefault();
                                    var st = empMeeting.StartTime.Value.Hour; //10 11
                                    var et = empMeeting.EndTime.Value.Hour; //2
                                    if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour > et)
                                    {
                                        cr.results = 3;
                                        throw new Exception("Invalid Time");
                                    }
                                }


                                if (studentRequest.CategoryId == 3)
                                {

                                    EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A" ).FirstOrDefault();
                                    var st = empMeeting.StartTime.Value.Hour; //10 11
                                    var et = empMeeting.EndTime.Value.Hour; //2
                                    if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour > et)
                                    {
                                        cr.results = 3;
                                        throw new Exception("Invalid Time");
                                    }
                                }

                                if (studentRequest.CategoryId == 4)
                                {

                                    EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                                    var st = empMeeting.StartTime.Value.Hour; //10 11
                                    var et = empMeeting.EndTime.Value.Hour; //2
                                    if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour > et)
                                    {
                                        cr.results = 3;
                                        throw new Exception("Invalid Time");
                                    }
                                }

                                if (studentRequest.CategoryId == 6)
                                {

                                    EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                                    var st = empMeeting.StartTime.Value.Hour; //10 11
                                    var et = empMeeting.EndTime.Value.Hour; //2
                                    if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour > et)
                                    {
                                        cr.results = 3;
                                        throw new Exception("Invalid Time");
                                    }
                                }

                                if (studentRequest.CategoryId == 7)
                                {

                                    EmpMeetingConfig empMeeting = DataAccess.Instance.EmpMeetingConfigService.Filter(e => e.EmpCategoryId == studentRequest.CategoryId.ToString() && e.IsDeleted == false && e.Status == "A").FirstOrDefault();
                                    var st = empMeeting.StartTime.Value.Hour; //10 11
                                    var et = empMeeting.EndTime.Value.Hour; //2
                                    if (st > studentRequest.Time.Value.Hour || studentRequest.Time.Value.Hour > et)
                                    {
                                        cr.results = 3;
                                        throw new Exception("Invalid Time");
                                    }
                                }

                                data.CategoryId = studentRequest.CategoryId;
                                data.Reason = studentRequest.Reason;
                                data.Date = Convert.ToDateTime(studentRequest.MDate);
                                data.RequestType = studentRequest.RequestType;
                              
                            }
                           
                            int y = Convert.ToInt32(studentRequest.Date.Value.ToString("yyyy"));
                            int M = Convert.ToInt32(studentRequest.Date.Value.ToString("MM"));
                            List<AcademicCalendar> list = DataAccess.Instance.AcademicCalendarService.Filter(c => c.IsDeleted == false && c.Year == y && c.Month == M && (c.DayType == "Weekend" || c.DayType == "Holiday")).ToList();
                            // DateTime d = new DateTime(studentRequest.Date);
                            if (list.Count() > 0)
                            {
                                foreach (var item in list)
                                {

                                    if (item.CalendarDate.ToString("MM/dd/yyyy") == studentRequest.Date.Value.ToString("MM/dd/yyyy"))
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
                     
                        data.StudentId = data.StudentId;
                        data.UpdateBy = User.Identity.GetInsId();
                        data.UpdateDate = DateTime.Now;

                        studentRequest.IsDeleted = data.IsDeleted;
                        studentRequest.Status = data.Status;
                        studentRequest.SetDate();
                        
                        var res = DataAccess.Instance.StudentRequestService.Update(data);
                        cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                        return Json(cr);
                    }
                }
                else {
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
        [Route("PortalRequest/GetMeetingListCo/")]
        [HttpGet]
        public IHttpActionResult GetMeetingListCo()
        {
            CommonResponse cr = new CommonResponse();
            long StuId = Convert.ToInt64(User.Identity.GetUserStudentId());
            var studentd = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == StuId).FirstOrDefault();
            var res = DataAccess.Instance.CommonServices.GetBySp("GetEmpMeetingList");

             cr.results = from d in res.AsEnumerable() where d.Field<int>("ClassId") == studentd.ClassId
                        select new
                        {
                            DayId = d.Field<int>("DayId"),
                            ClassId = d.Field<int>("ClassId"),
                            FirstEmpId = d.Field<int>("FirstEmpId"),
                            StartTime = d.Field<DateTime>("StartTime"),
                            EndTime = d.Field<DateTime>("EndTime"),
                            EmpCategoryId = d.Field<string>("EmpCategoryId"),
                            DayName = d.Field<string>("DayName")

                        };
            //cr.results = res;
            return Json(cr);
        }

        //Developed By Khaled

        [Route("PortalRequest/GetMeetingList/")]
        [HttpGet]
        public IHttpActionResult GetMeetingList()
        {
            CommonResponse cr = new CommonResponse();
            long StuId = Convert.ToInt64(User.Identity.GetUserStudentId());
            var studentd = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == StuId).FirstOrDefault();
            var res = DataAccess.Instance.CommonServices.GetBySp("GetEmpMeetingList");

            //cr.results = from d in res.AsEnumerable()
            //             where d.Field<int>("ClassId") == studentd.ClassId
            //             select new
            //             {
            //                 DayId = d.Field<int>("DayId"),
            //                 ClassId = d.Field<int>("ClassId"),
            //                 FirstEmpId = d.Field<int>("FirstEmpId"),
            //                 StartTime = d.Field<DateTime>("StartTime"),
            //                 EndTime = d.Field<DateTime>("EndTime"),
            //                 EmpCategoryId = d.Field<string>("EmpCategoryId")

            //             };
            cr.results = res;
            return Json(cr);
        }

        //
        [HttpGet]
        [Route("PortalRequest/GetAllRequestList/")]
        public IHttpActionResult GetAllRequestList()
        {
            CommonResponse cr = new CommonResponse();
            int Type = 1;
            int StudentId = Convert.ToInt32(User.Identity.GetUserStudentId());

            var results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentRequestList",new object[] { StudentId, Type });

            cr.results = results;
            return Json(cr);
        }
        [HttpGet]
        [Route("PortalRequest/GetForMeetingList/")]
        public IHttpActionResult GetForMeetingList()
        {
            CommonResponse cr = new CommonResponse();
            int Type = 5;
            int StudentId = Convert.ToInt32(User.Identity.GetUserStudentId());

            var results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentRequestList", new object[] { StudentId, Type });

            cr.results = results;
            return Json(cr);
        }
        [HttpPost]
        [Route("PortalRequest/DeleteRequest/{Id}")]
        public IHttpActionResult DeleteRequest(int Id) 
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.StudentRequestService.Remove(Id);
            cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
            return Json(cr);
        }

        [HttpPost]
        [Route("PortalRequest/UpdateStatusForParrentsMeeting/{Id}/{Status}")]
        public IHttpActionResult UpdateStatusForParrentsMeeting(int Id,string Status)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                StudentRequest sr = new StudentRequest();
                sr = DataAccess.Instance.StudentRequestService.Filter(e => e.Id == Id && e.IsDeleted == false).FirstOrDefault();
                if (sr!=null)
                {
                    sr.Status = Status;
                    sr.UpdateBy = User.Identity.Name;
                    sr.UpdateDate = DateTime.Now;
                    var res = DataAccess.Instance.StudentRequestService.Update(sr);
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                }
                
               
            }
            catch (Exception ex)
            {

                throw;
            }
            return Json(cr);
        }

    }
}
