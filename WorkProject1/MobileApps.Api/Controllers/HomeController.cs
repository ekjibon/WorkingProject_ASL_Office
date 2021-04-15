using OEMS.AppData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace MobileApps.Api.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";

            return View();
        }

        
        [Route("ImageByEmpId/{empId}")]
        [HttpGet]
        public FileContentResult ImageByEmpId(int empId)
        {
            try
            {
                byte[] empImage = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.IsDeleted == false && e.Status == "A" && e.EmpBasicInfoID == empId).FirstOrDefault().Image;
                return new FileContentResult(empImage, "image/jpeg");
            }
            catch (Exception)
            {

                return new FileContentResult(APIUitility.ToByte(Server.MapPath("~/Content/no_image.png")), "image/jpeg");
            }
           
           
        }

        [Route("EmpRequestFile/{reqId}")]
        [HttpGet]
        public FileContentResult EmpRequestFile(int reqId)
        {
            try
            {
                var file = DataAccess.Instance.EmpRequestService.Filter(e => e.Id == reqId && e.IsDeleted == false).FirstOrDefault().File;
                return new FileContentResult(file, "image/jpeg");
            }
            catch (Exception)
            {

                return new FileContentResult(APIUitility.ToByte(Server.MapPath("~/Content/no_image.png")), "image/jpeg");
            }


        }

        [Route("EmpNoticeFile/{docId}")]
        [HttpGet]
        public FileContentResult EmpNoticeFile(int docId)
        {
            try
            {
                byte[] file = DataAccess.Instance.PortalDocumentService.Filter(e => e.IsDeleted == false && e.DocumentId == docId).FirstOrDefault().File;   
                return new FileContentResult(file, "application/pdf");
                //return File(file, "application/pdf", "PdfFile");
            }
            catch (Exception)
            {

                return new FileContentResult(APIUitility.ToByte(Server.MapPath("~/Content/no_image.png")), "image/jpeg");
            }


        }
    }
}
