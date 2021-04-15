using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Constant;
using OEMS.Models.Model;
using OEMS.Models.ViewModel;
using OEMS.Repository.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;

using System.Web;
using System.Web.Mvc;
using UI.WebClients.Models;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers
{
    [Authorize]
    public class HomeController : BaseController
    {
        public ActionResult Index()
        {   
            var pages = DataAccess.Instance.PageRole.GetByUserId(User.Identity.GetUserId(), 0).ToList();
            Session["Pages"] = pages;
            if (User.Identity.GetRoleName().ToString() == "Employee")
            {
                return RedirectToAction("Dashboard", "Employee");
            }
            else
            {
                return RedirectToAction("Dashboard", "Employee");
            }
        }
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";
            return View();
        }
        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
            return View();
        }
        [HttpGet]
        public ActionResult GetHeaderMenu()
        {
            List<AspNetPage> pages = new List<AspNetPage>();
             
            if (User.Identity.GetRoleName().ToString() != "Employee")
            {
                pages = DataAccess.Instance.PageRole.GetModuleByUserId(User.Identity.GetUserId()).ToList();
               
                //pages = DataAccess.Instance.AspNetPage.Filter(e => e.IsModule == true && e.ModuleId != 12).ToList();
            }
            return View(pages);
        }
        [HttpGet]
        public ActionResult GetMenu()
        {
            List<AspNetPage> pages = new List<AspNetPage>();                           
            if (User.Identity.GetRoleName().ToString() == "Employee")
            {
                //pages = DataAccess.Instance.AspNetPage.GetEMPAll().ToList();
                DataSet dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetEmpTeacherList");
                pages = CommonRepository.ConvertDataTable<AspNetPage>(dt.Tables[0]);
            }
            else
            {
                int ModuleId = System.Web.HttpContext.Current.Session["ModuleId"] == null ? 1 : (int)System.Web.HttpContext.Current.Session["ModuleId"];
                var pagess = System.Web.HttpContext.Current.Session["Pages"];
                if (Session["Pages"] != null)
                {
                    pages = ((List<AspNetPage>)System.Web.HttpContext.Current.Session["Pages"]).OrderBy(e => e.PageID).Where(e => e.ModuleId == ModuleId).ToList();
                }
            }
            return View(pages);
        }
        [AllowAnonymous]
        public ActionResult SendMail()
        {
            EmailData frm = new EmailData();
            frm.Name = "Kawsar Ahemd";
            frm.Description = "Welcome to addie soft! Your Account has been Created.<br/>";
            frm.Description += "User Name : " + "kkk" + "<br/>";
            frm.Description += "Password:<strong> " + "fghgfhgfh" + "</strong><br/>";
            frm.Description += "Please Click for confim your Account.";
            frm.Description = HttpUtility.HtmlDecode(frm.Description);

            frm.HasButton = true;
            frm.ButtonText = "Confirm";
            frm.ButtonLink = "#";

            string body = Uitility.ViewToHtml("EmailTemplate", new ViewDataDictionary<EmailData>(frm), this.ControllerContext);

            body = HttpUtility.HtmlDecode(body);
            MailMessage email = new MailMessage();
            email.To.Add(new MailAddress("kawsar.sbc@gmail.com"));

            email.Subject = "Account Confirmation";
            email.Body = body;
            email.IsBodyHtml = true;

            SmtpClient client = new SmtpClient();
            client.Send(email);


            return Json(true, JsonRequestBehavior.AllowGet);
            //EmailService. 
        }

        public ActionResult GetDashBoardData()
        {
            
            CommonResponse cr = new CommonResponse();
            DashboardVM dashboard = new DashboardVM();

            DataSet ds = DataAccess.Instance.CommonServices.GetDatasetBySp("GetDashBoardData");
            if (ds.Tables[0].Rows.Count > 0)
            {
                dashboard.TotalStudent = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalStudent"]);
                dashboard.TotalCollection = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalCollection"]);
                dashboard.TotalSentSMS = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalSentSMS"]);
                dashboard.TotalPresent = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalPresent"]);
            }
            if (ds.Tables[1].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[1].Rows)
                {
                    dashboard.CurrMonthTrans.Add(new MonthTrans() { Amount = Convert.ToDecimal(dr["Amount"]), PaymentDate = dr["PaymentDate"].ToString() });
                }
            }
            if (ds.Tables[2].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[2].Rows)
                {
                    dashboard.ClasswisePresent.Add(new ClassAtten() { ClassName = dr["ClassName"].ToString(), PresentStudent = Convert.ToInt32(dr["PresentStudent"].ToString()) });
                }
            }

            return Json(dashboard, JsonRequestBehavior.AllowGet);
        }


    }
}