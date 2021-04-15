using OEMS.AppData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UI.Portal.Models;

namespace UI.Portal.Controllers
{
    [Authorize]
    public class ECAController : Controller
    {
        // GET: ECA
        
        public ActionResult ECAList()
        {
            var StuClub = DataAccess.Instance.StudentClubsService.GetAll();
            ViewBag.ClubName = null;
            long stuId = Convert.ToInt64(User.Identity.GetUserStudentId());
            ViewBag.ApplyCount = DataAccess.Instance.StudentClubsService.Filter(e => e.StudentId == stuId).Count();
            if (StuClub.Any(e=>e.StudentId== stuId && e.Status=="Approved"))
            {
                var clubid = StuClub.Where(e => e.StudentId == stuId && e.Status == "Approved").FirstOrDefault().ClubId;
                ViewBag.ClubName = DataAccess.Instance.ECAClubService.Filter(c => c.ClubId == clubid && c.IsDeleted == false).FirstOrDefault().ClubName;
                
            }
          
            return View();
        }
        public ActionResult AddECA()
        {
            long studId = Convert.ToInt64(User.Identity.GetUserStudentId());
            var portalDocument = DataAccess.Instance.PortalDocumentService.GetAll();
            var sb = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == studId).FirstOrDefault();
            if (portalDocument.Any(e => e.TypeId == 3 && e.IsDeleted == false && e.Status == "A" && e.SessionId== sb.SessionId))
            {
                ViewBag.DocumentId = DataAccess.Instance.PortalDocumentService.Filter(e => e.TypeId == 3 && e.IsDeleted == false && e.Status == "A" && e.SessionId == sb.SessionId).FirstOrDefault().DocumentId;

            }
            else
            {
                ViewBag.DocumentId = 0;
            }
            return View();
        }

    }
}