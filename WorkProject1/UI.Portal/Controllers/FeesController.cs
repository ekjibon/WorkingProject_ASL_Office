using OEMS.Api;
using OEMS.AppData;
using OEMS.Models.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UI.Portal.Controllers
{
    [Authorize]
    public class FeesController : Controller
    {
        // GET: Fees

        public ActionResult Fees()
        {
            return View();
        }
        public ActionResult FeesPayment()
        {
                return View();
        }
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult PaymentFees()
        {
            FeesSetting fs = new FeesSetting();
            fs =  DataAccess.Instance.FeesSettingService.GetAll().FirstOrDefault();
            return View(fs);
        }
        public ActionResult FeesHistory()
        {
            return View();
        }
        public ActionResult FeesSuccess()
        {
            return View();
        }
        public ActionResult FeesFail(string msg)
        {
            ViewBag.msg = msg;
            return View();
        }
        public ActionResult FeesCancel()
        {
            return View();
        }
        public ActionResult FeesDetail()
        {
            return View();
        }
        public ActionResult Payment()
        {
            DataTable dt = new DataTable();
            DataTable dtStu = new DataTable();
            List<FeesStudent> FeesStudent = new List<FeesStudent>();
            var StudentInsID = User.Identity.Name;
            var StudentIID = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentInsID == StudentInsID).FirstOrDefault().StudentIID;
            int Month = DateTime.Now.Month;
            int Year = DateTime.Now.Year;
            Decimal Amount = 0;
            string AmountString = string.Empty;

            try
            {
                // Check BarCode is StudentId Or Fees Book
                dtStu = DataAccess.Instance.CommonServices.GetBySpWithParam("rpt_GetStudentInfoByIID", StudentIID);
                // Check Exits
                var datas = DataAccess.Instance.FeesStudentService.Filter(e => e.FeesStudentId == StudentIID && e.IsCompleted == true).ToList();
                if (datas.Count != 0)
                {
                    throw new Exception("Already Collected");
                }
                // Get Fees Student Data By studentId Or FeesBook
                DataTable dtCollec = new DataTable();
                dtCollec = DataAccess.Instance.CommonServices.GetBySpWithParam("GetFeesCollectionByStudentId", new object[] { 1, StudentIID, DBNull.Value, Month, Year - 1, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value });
                List<FeesStudent> lstFeesStudent = APIUitility.ConvertDataTable<FeesStudent>(dtCollec);
                Amount= lstFeesStudent.Sum(e => e.TotalAmount);
                AmountString = Amount.ToString() + "(TK)";
            }
            catch (Exception ex)
            {
               
            }
            ViewBag.AppId = User.Identity.Name;
            ViewBag.Amount = Amount;
            ViewBag.AmountString = AmountString;
            ViewBag.InstitureName = "";
            return View();
        }

        public ActionResult FeesDashboard()
        {
            return View();
        }
        public ActionResult PaymentYearly()
        {
            return View();
        }
        public ActionResult PaymentHistory()
        {
            return View();
        }
        public ActionResult FAQ()
        {
            return View();
        }
        public ActionResult PaymentProcessFlow()
        {
            return View();
        }
    }
}