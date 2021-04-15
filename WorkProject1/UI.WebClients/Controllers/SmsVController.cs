using OEMS.Api;
using OEMS.AppData;
using OEMS.Models.ViewModel;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers
{
    public class SmsVController : BaseController
    {
        // GET: SmsV
        public ActionResult Dashboard()
        {
            Session["ModuleId"] = OEMSModule.SMS;
            return View();
        }
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult GetSmsSettings()
        {
            return View();
        }
        public ActionResult DynamicSmsSend()
        {
            return View();
        }
        public ActionResult SmsTemplate()
        {
            return View();
        }
        public ActionResult SmsTemplateList()
        {
            return View();
        }
        public ActionResult StaticSendSMS()
        {
            return View();
        }
        public ActionResult StaticSMSExcel()
        {
            return View();
        }
        public ActionResult ScheduleSMSConfig()
        {
            return View();
        }
        public ActionResult AutoSMSConfig()
        {
            return View();
        }
        public ActionResult SmsHistoryReport()
        {
            return View();
        }
        public ActionResult SMSRecharge()
        {
            return View();
        }
        public ActionResult FilteredSendSMS()
        {
            return View();
        }
        public ActionResult DownloadUpdateExcel()
        {

            MemoryStream memStream;
            using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("BulkStudentForID");

                worksheet.Cells["A1"].Value = "Name";
                worksheet.Cells["B1"].Value = "Mobile No";
                var rngTable = worksheet.Cells["A1:B1"];
                rngTable.Style.Fill.PatternType = ExcelFillStyle.Solid;
                rngTable.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(253, 233, 217));
                rngTable.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                memStream = new MemoryStream(package.GetAsByteArray());
            }

            Random rand = new Random();
            string r = rand.Next(10000, 999999).ToString();

            return File(memStream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "BulkStudentIdGen" + r + ".xlsx");



            return null;
        }
    }
}