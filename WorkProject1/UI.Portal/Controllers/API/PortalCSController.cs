using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.Accademic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using UI.Portal.Models;

namespace UI.Portal.Controllers.API
{
    public class PortalCSController : ApiController
    {
        [Route("CS/AddCS/")]
        [HttpPost]
        public IHttpActionResult AddCS(CSInfo cs)
        {
            try
            {
                CommonResponse cr = new CommonResponse();
                int SId = Convert.ToInt32(User.Identity.GetUserStudentId());
                cs.AddBy = User.Identity.Name;
                cs.AddDate = DateTime.Now;
                cs.SetDate();
                cs.ReferenceId = SId;
                cs.RefTypeId = 2;
                cs.IsDeleted = false;

                if (cs.CSType== "Donation")
                {
                    var res = DataAccess.Instance.CSInfoService.Add(cs);
                    cr.results = res;
                    cr.message = "Donation added successfully.";
                    return Json(cr);
                }
               
                else if(cs.CSType=="CS Visit Request")
                {
                    DateTime dt = cs.CSVisitDateTime ?? DateTime.Now;
                    DateTime dt2 = cs.VolunteerDate ?? DateTime.Now.AddDays(1);
                    cs.VolunteerDate = null;
                    TimeSpan timeOfDay = dt2.TimeOfDay;
                    cs.CSVisitDateTime=dt.Add(timeOfDay);
                    var res = DataAccess.Instance.CSInfoService.Add(cs);
                    cr.results = res;
                    cr.message = "Visit request submitted successfully.";
                    return Json(cr);
                }
                else
                {
                    var res = DataAccess.Instance.CSInfoService.Add(cs);
                    cr.results = res;
                    cr.message = "Volunter request submitted successfully.";
                    return Json(cr);
                }
                  
            }
            catch(Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
           
        }
    }
}
