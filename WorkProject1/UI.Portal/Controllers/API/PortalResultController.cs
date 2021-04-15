using OEMS.AppData;
using OEMS.Models;
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
    public class PortalResultController : ApiController
    {
        [Route("PortalResult/GetTotalResult/")]
        [HttpGet]
        public IHttpActionResult GetTotalResult()
        {
            int StudentId = Convert.ToInt32(User.Identity.GetUserStudentId());
            //StudentId = 77;
            CommonResponse cr = new CommonResponse();
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalResult",new object[]{ StudentId });
            cr.results = dt;

            return Json(cr);
        }

        [Route("PortalResult/GetSubjectWiseResult/{ExamId}")]
        [HttpGet]
        public IHttpActionResult GetSubjectWiseResult(int ExamId)
        {
            int StudentId = Convert.ToInt32(User.Identity.GetUserStudentId());
            //StudentId = 77;
            CommonResponse cr = new CommonResponse();
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalResultDetails", new object[] { StudentId, ExamId });
            cr.results = dt;

            return Json(cr);
        }
    }
}
