using OEMS.AppData;
using OEMS.Models.Model;
using OEMS.Models.ViewModel.Portal;
using OEMS.Repository.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UI.Portal.Models;

namespace UI.Portal.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        public ActionResult Test()
        {
            return View();
        }
        public ActionResult Index()
        {
            var SIID = Convert.ToInt64(User.Identity.GetUserStudentId());
            var student = DataAccess.Instance.StudentBasicInfo.Filter(sb=>sb.StudentIID == SIID).FirstOrDefault();
            ViewBag.HomeWorkList = DataAccess.Instance.PortalDocumentService.Filter(p=>p.DocType==1 && p.TypeId==5 && p.SessionId == student.SessionId && p.ClassId == student.ClassId && p.BranchId ==student.BranchID  && p.ShiftId== student.ShiftID).OrderByDescending(d=>d.DocumentId).Take(5).ToList();
            User.Identity.GetUserStudentId();

            return View();
        }
        public ActionResult CS()
        {

            return View();
        }
        public ActionResult CLassRoutine()
        {

            return View();
        }
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();

        }
        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        //public FileResult NoticeDocumentDownload(int DocumentId)
        //{
        //    var DocmentModel = DataAccess.Instance.PortalDocumentService.Filter(d => d.DocumentId == DocumentId).FirstOrDefault();
        //    return File(DocmentModel.File, System.Net.Mime.MediaTypeNames.Application.Octet, DocmentModel.FileName);
        //}
        public ActionResult GetPortalDashBoardData()
        {
            PortalDashboardVM dasboard = new PortalDashboardVM();
            var SIID = User.Identity.GetUserStudentId();
            DataSet ds = DataAccess.Instance.CommonServices.GetDatasetBySp("GetPortalDashBoardData",new object[] { SIID });
            if (ds.Tables[0].Rows.Count > 0)
            {
                dasboard.TotalDue = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalDue"]);
               // dasboard.TotalPaid = Convert.ToDecimal(ds.Tables[0].Rows[0]["PaidAmount"]);
                dasboard.TotalPresent = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalPresent"]);
                dasboard.TotalAbsent = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalAbsent"]);
               // dasboard.DuePercent = Convert.ToDecimal(ds.Tables[0].Rows[0]["DuePercent"]);
               // dasboard.PaidPercent = Convert.ToDecimal(ds.Tables[0].Rows[0]["PaidPercent"]);
                dasboard.PeresentPercent = Convert.ToDecimal(ds.Tables[0].Rows[0]["PeresentPercent"]);
                dasboard.AbsentPercent = Convert.ToDecimal(ds.Tables[0].Rows[0]["AbsentPercent"]);
                dasboard.FeesMonth = ds.Tables[0].Rows[0]["FeesMonth"].ToString();
                //dasboard.FeesYear = ds.Tables[0].Rows[0]["FeesYear"].ToString();

            }
       
            if (ds.Tables[1].Rows.Count > 0)
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

            if (ds.Tables[2].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[2].Rows)
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

            if (ds.Tables[3].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[3].Rows)
                {
                    StudentNoticeBorad StudentNoticeBorad = new StudentNoticeBorad();
                    StudentNoticeBorad.DocumentId = Convert.ToInt32(dr["DocumentId"].ToString());
                    StudentNoticeBorad.FileName = dr["FileName"].ToString();
                    StudentNoticeBorad.Title = dr["Title"].ToString();
                    StudentNoticeBorad.TypeId = Convert.ToInt32(dr["TypeId"].ToString());
                    DateTime dt = Convert.ToDateTime(dr["AddDate"].ToString());
                    StudentNoticeBorad.AddDate = dt.ToString("dd-MMM-yyyy");
                    dasboard.StdNoticeList.Add(StudentNoticeBorad);
                   
                }
            }
            if (ds.Tables[4].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[4].Rows)
                {
                    dasboard.StudentAttendanceList.Add(new StudentAttendance
                    {
                        AttendId = Convert.ToInt64(dr["AttendId"].ToString()),
                        StudentId = Convert.ToInt64(dr["StudentId"].ToString()),
                        InTime = dr["InTime"].ToString(),
                        OutTime = dr["OutTime"].ToString(),
                        IsPresent = Convert.ToBoolean(dr["IsPresent"].ToString()),
                        IsLeave = Convert.ToBoolean(dr["IsLeave"].ToString())
                       

                    });
                }
            }
            if (ds.Tables[5].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[5].Rows)
                {
                    Results Resultmodel = new Results();
                    Resultmodel.PreviousYear = dr["PreviousYear"].ToString();
                    Resultmodel.ClassName = dr["ClassName"].ToString();
                    Resultmodel.StdStatus = dr["StdStatus"].ToString();
                    Resultmodel.Award = dr["Award"].ToString();
                    dasboard.ResultsList.Add(Resultmodel);
                }
            }
            for (int i = 1; i <= 12; i++)
            {
                string monthName = new DateTime(2019, i, 1).ToString("MMM", CultureInfo.InvariantCulture);
                dasboard.Attlabel.Add(monthName);
                int count = dasboard.CurrMonthAttendance.Where(e => Convert.ToDateTime(e.CalendarDate).Month == i && e.DayStaus=="P").ToList().Count;
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
    }
}