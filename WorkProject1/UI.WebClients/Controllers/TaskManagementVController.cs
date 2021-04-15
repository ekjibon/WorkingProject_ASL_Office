using OEMS.AppData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers
{
    public class TaskManagementVController : Controller
    {
        // GET: TaskManagementV

        public ActionResult Board()
        {
            Session["ModuleId"] = OEMSModule.TaskManagement;
            return View();
        }

        //[CustomAuthorize(Roles = (Role.Admin + "," + Role.Developer + "," + Role.Manager))]
        public ActionResult Project()
        {
            return View();
        }
        public ActionResult ProjectCategory()
        {
            return View();
        }

        //[CustomAuthorize(Roles = (Role.Admin + "," + Role.Developer + "," + Role.Manager))]
        public ActionResult Sprint()
        {
          return View();
        }

        public ActionResult MyTask()
        {
            return View();
        }
        public ActionResult Issue()
        {
            return View();
        }

        public ActionResult IssueHistory()
        {
            return View();
        }
        public ActionResult IssueWebLink()
        {
            return View();
        }
        public ActionResult IssueBackLog()
        {
            return View();
        }

        public ActionResult Comments()
        {
            return View();
        }

        public ActionResult IssueReport()
        {
            return View();
        }

        public FileContentResult GetImage(string userId)
        {
            var user = DataAccess.Instance.Users.Filter(u => u.Id == userId).FirstOrDefault();
            if (user!=null)
            {
                 var emp = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpBasicInfoID == user.EmpId).FirstOrDefault();
                if (emp!=null && emp.Image != null)
                {
                    return new FileContentResult(emp.Image, "image/jpeg");
                }
            }

             byte[] byteArray = Uitility.ToByteFromPath(System.Web.Hosting.HostingEnvironment.MapPath("~\\assets\\img\\no_image.png"));
            return new FileContentResult(byteArray, "image/jpeg");
        }
    }
}