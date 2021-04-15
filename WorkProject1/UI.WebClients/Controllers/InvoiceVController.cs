using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers
{
    public class InvoiceVController : Controller
    {
        // GET: InvoiceServiceV
        public ActionResult Dashboard()
        {
            Session["ModuleId"] = OEMSModule.Invoice;
            return View();
        }
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult InvoiceService()
        {
            return View();
        }

        public ActionResult InvoiceBillingHead()
        {
            return View();
        }

        public ActionResult InvoiceBillingMethod()
        {
            return View();
        }

        public ActionResult BillingHeadConfig()
        {
            return View();
        }
      
        public ActionResult DatabaseConfig()
        {
            return View();
        }
        public ActionResult BillingProcessPanel()
        {
            return View();
        }
        public ActionResult InvoiceGeneratePanel()
        {
            return View();
        }
        public ActionResult InvoiceModification()
        {
            return View();
        }
        public ActionResult InvoicePayment()
        {
            return View();
        }
        public ActionResult Collection()
        {
            return View();
        }
        public ActionResult PhoneCallMaintain()
        {
            return View();
        }
        public ActionResult MoneyReceiptGenerate()
        {
            return View();
        }
        public ActionResult InvoiceDiscount()
        {
            return View();
        }
        public ActionResult InvoiceSearch()
        {
            return View();
        }

    }
}
