using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UI.WebClients.Controllers
{
    public class CommonController : Controller
    {
        // GET: Commpn
        public ActionResult DropDownConfig()
        {
            return View();
        }

        public ActionResult AlertSetting()
        {
            return View();
        }

    }
}
