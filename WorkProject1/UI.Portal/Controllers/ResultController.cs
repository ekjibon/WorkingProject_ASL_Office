using OEMS.AppData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UI.Portal.Controllers
{
    [Authorize]
    public class ResultController : Controller
    {
        // GET: Result

        public ActionResult ResultView()
        {
            return View();
        }
        public ActionResult Index(string exam)
        {
            if(exam=="MainExam")
            {
                string studentid = User.Identity.Name;
                var StudentInfo=DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == studentid).FirstOrDefault();
                var examlist = DataAccess.Instance.MainExamService.Filter(e=>e.ClassId==StudentInfo.ClassId && e.SessionId==StudentInfo.SessionId &&e.IsDeleted==false).ToList();
                ViewBag.examlist = examlist;
                ViewBag.ExamType = "Main";
            }
           
            else
            {
                return RedirectToAction("Index", "Home");
            }
            string schoolshortname=System.Configuration.ConfigurationManager.AppSettings["SchoolShortName"].ToString();
            ViewBag.sitename = "http://"+ schoolshortname + ".oemsbd.com:2018";
            return View();
        }
        [HttpGet]
        public ActionResult StudentInfo()
        {
            string studentid = User.Identity.Name;
            var StudentInfo = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == studentid).FirstOrDefault();
            return Json(StudentInfo, JsonRequestBehavior.AllowGet);
        }
    }
}