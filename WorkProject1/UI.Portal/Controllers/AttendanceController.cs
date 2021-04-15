
using Microsoft.Owin.Security.Infrastructure;
using OEMS.AppData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mime;
using System.Web;
using System.Web.Mvc;
using UI.Portal.Models;

namespace UI.Portal.Controllers
{
    [Authorize]
    public class AttendanceController : Controller
    {
        // GET: Attendance

        public ActionResult AttendanceDetails()
        {
            return View();
        }

        public ActionResult Attendance()
        {
            return View();
        }
        public ActionResult Leave()
        {
            return View();
        }
        public FileResult DownloadImage(int LeaveId)
        {
            byte[] bytes = DataAccess.Instance.StudentLeaveService.Filter(e => e.LeaveId == LeaveId).FirstOrDefault().File;
            return File(bytes, "image/png");

        }

        public FileResult Download(int DocumentId)
        {
            byte[] bytes = DataAccess.Instance.PortalDocumentService.Filter(e => e.DocumentId == DocumentId).FirstOrDefault().File;
            return File(bytes, "application/pdf");
        }
    }
}