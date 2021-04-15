using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UI.WebClients.Controllers.Client
{
    public class ClientController : Controller
    {
        // GET: Clients
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Client()
        {
            return View(); 
        }
    }
}