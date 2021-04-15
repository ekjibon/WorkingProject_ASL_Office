using Microsoft.AspNet.Identity;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.Accademic;
using OEMS.Models.Model.Document;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using UI.Portal.Models;

namespace UI.Portal.Controllers.API
{
    public class PortalNoticeController : ApiController
    {
        [Route("PortalNotice/GetAllNotice/")]
        [HttpGet]
        public IHttpActionResult GetAllNotice()
        {
            int TargetType = 1;
            CommonResponse cr = new CommonResponse();
            int StdId = Convert.ToInt32(User.Identity.GetUserStudentId());
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllNoticeList", new object[] { StdId, TargetType });
            cr.results = dt;
            return Json(cr);
        }

        [Route("PortalNotice/GetDocumentList/")]
        [HttpPost]
        public IHttpActionResult GetDocumentList(PortalDocument PortalDocument)
        {
            DataTable res;
            CommonResponse cr = new CommonResponse();
            int SId = Convert.ToInt32(User.Identity.GetUserStudentId());
            if (PortalDocument.TypeId==1)
            {
                 res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalDocumentList", new object[] { 2, DBNull.Value, DBNull.Value, SId }); //Academic Calander list

            }
            else if(PortalDocument.TypeId == 2)
            {
                 res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalDocumentList", new object[] { 3, PortalDocument.SessionId, PortalDocument.Month, SId}); // Newsletter List

            }
            else if (PortalDocument.TypeId == 4)
            {
                res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalDocumentList", new object[] { 8, DBNull.Value, DBNull.Value, SId }); // General Notice List
            }
            else if (PortalDocument.TypeId == 5)
            {
                res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalDocumentList", new object[] { 5, DBNull.Value, DBNull.Value, SId }); // General Notice List
            }
            else
            {
                res = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalDocumentList", new object[] { 4, DBNull.Value, DBNull.Value, DBNull.Value }); // ECA NOtice List

            }
            cr.results = res;
            return Json(cr);
        }


    }
}
