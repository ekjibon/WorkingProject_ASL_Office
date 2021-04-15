using OEMS.AppData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UI.Portal.Controllers
{
    [Authorize]
    public class NoticeController : Controller
    {
        // GET: Notice
        
        public ActionResult NoticeBoard()
        {
            return View();
        }

        public ActionResult Routine()
        {
            return View();
        }
        public ActionResult Sendfeedback()
        {
            return View();
        }
        public ActionResult Homework()
        {
            return View();
        }
        public ActionResult Request()
        {
            return View();
        }
        public ActionResult ParentsMeeting()
        {
            return View();
        }
        public ActionResult Newsletter()
        {
          
            return View();
        }


    }
}