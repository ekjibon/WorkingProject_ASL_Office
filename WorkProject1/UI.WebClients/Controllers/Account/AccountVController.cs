using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Reporting.WebForms;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using System;
using System.Collections.Generic;
using System.Data;

using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers.Account
{
    public class AccountVController : BaseController
    {
        public ActionResult Dashboard()
        {
            Session["ModuleId"] = OEMSModule.Accounts;
            return View();
        }
        public ActionResult Ledger()
        {
            return View();
        }
        public ActionResult Entries()
        {
            return View();
        }
        public ActionResult EntryType()
        {
            return View();
        }
        public ActionResult AccountsSetting()
        {
            return View();
        }
        public ActionResult FiscalYearSetup()
        {
            return View();
        }
        public ActionResult AcBranchSetup()
        {
            return View();
        }
        public ActionResult AcGroupSetup()
        {
            return View();
        }
        public ActionResult AcLedgerSetup()
        {
            return View();
        }
        public ActionResult COA()
        {
            return View();
        }
        public ActionResult CodeSetup()
        {
            return View();
        }
        public ActionResult Receive()
        {
            return View();
        }
        public ActionResult Payment()
        {
            return View();
        }
        public ActionResult Contra()
        {
            return View();
        }
        public ActionResult Journal()
        {
            return View();
        }
        public ActionResult TransactionList()
        {
            return View();
        }
        public ActionResult PaymentTransactionList()
        {
            string userId = User.Identity.GetUserId();
            DataTable results = null; 
            results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAssignRoleList", new object[] { userId });


            foreach (DataRow item in results.Rows)
            {
                ViewBag.roleNames = item.ItemArray[1];
            }
            return View();
        }
        public ActionResult ReceiveTransactionList()
        {
            string userId = User.Identity.GetUserId();
            DataTable results = null;
            results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAssignRoleList", new object[] { userId });
            

            foreach (DataRow item in results.Rows)
            {
                ViewBag.roleNames = item.ItemArray[1];
            }

            return View();
        }
        public ActionResult ContraTransactionList()
        {
            string userId = User.Identity.GetUserId();
            DataTable results = null;
            results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAssignRoleList", new object[] { userId });


            foreach (DataRow item in results.Rows)
            {
                ViewBag.roleNames = item.ItemArray[1];
            }
            return View();
        }
        public ActionResult JournalTransactionList()
        {
            string userId = User.Identity.GetUserId();
            DataTable results = null;
            results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAssignRoleList", new object[] { userId });


            foreach (DataRow item in results.Rows)
            {
                ViewBag.roleNames = item.ItemArray[1];
            }
            return View();
        }
        public ActionResult Reports()
        {
            return View();
        }

        public ActionResult AccountsReport()
        {
            return View();
        }
        public ActionResult LedgerCoa()
        {
            return View();
        }
        public ActionResult AccountsIntegration()
        {
            return View();
        }
        private string GetHeader(string ImgType)
        {
            ReportHeader Header = DataAccess.Instance.RepHeaderImgService.Filter(e => e.IsDeleted == false).ToList().FirstOrDefault();
            if (Header != null)
            {
                if (ImgType == "LegalLandscape")
                {
                    return Convert.ToBase64String(Header.LegalLandscape);
                }
                else if (ImgType == "LegalPortrait")
                {
                    return Convert.ToBase64String(Header.LegalPortrait);
                }
                else if (ImgType == "A4Landscape")
                {
                    return Convert.ToBase64String(Header.A4Landscape);
                }
                else //if (ImgType == "A4Portrait")
                {
                    return Convert.ToBase64String(Header.A4Portrait);
                }
                //else
                //{                    
                //    return Convert.ToBase64String(System.IO.File.ReadAllBytes(Server.MapPath("~/assets/global/no image.jpg")));
                //}
            }
            //return Convert.ToBase64String(System.IO.File.ReadAllBytes(Server.MapPath("~/assets/global/no image.jpg")));
            return null;
        }

        //Accounts Report
        public FileResult ViewReport(int FiscalYear, int ReportType,int ReportTypeId)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            var fisInfo = DataAccess.Instance.FiscalYearService.Filter(f =>f.Id==FiscalYear && f.IsDeleted == false).FirstOrDefault();
            System.Data.DataSet dt = new System.Data.DataSet();
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            if (ReportType == 1 && ReportTypeId == 1)
            {
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetBalanceSheet");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPliabilitis", dt.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPAsset", dt.Tables[1]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptBalanceSheetSummary.rdlc");

            }
            else if (ReportType == 1 && ReportTypeId == 2)
            {
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetBalanceSheet");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPliabilitis", dt.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPAsset", dt.Tables[1]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptBalanceSheet.rdlc");
                //dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetBalanceSheetDetails");
                //rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPliabilitis", dt.Tables[0]));
                //rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPAsset", dt.Tables[1]));
                //rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptBalanceSheetdetails.rdlc");
            }
            else if (ReportType == 2 && ReportTypeId == 1)
            {
                parameters.Add(new ReportParameter("CurrentDate", DateTime.Now.ToString("dd/MM/yyyy")));
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetProfitLoss", new object[] { FiscalYear });
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPIncome", dt.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPExpense", dt.Tables[1]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptProfitLoss.rdlc");
            }
            else if (ReportType == 2 && ReportTypeId == 2)
            {
                parameters.Add(new ReportParameter("CurrentDate", DateTime.Now.ToString("dd/MM/yyyy")));
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetProfitLossDetails", new object[] { FiscalYear });
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPIncome", dt.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPExpense", dt.Tables[1]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptProfitLossDetails.rdlc");
            }
           
            else if (ReportType == 3)
            {
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetPaymentReceipts");
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptReceiptPayment.rdlc");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPReceipt", dt.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPPayment", dt.Tables[1]));
            }
            else if (ReportType == 4)
            {
                parameters.Add(new ReportParameter("CurrentDate", DateTime.Now.ToString("dd/MM/yyyy")));
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetTrailBalance", new object[] { FiscalYear });
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptTrialBalance.rdlc");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt.Tables[0]));
            }
            else if (ReportType == 5)
            {
                //dt = DataAccess.Instance.CommonServices.GetDatasetBySp("GetPaymentReceipts");
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptCashFlow", new object[] { FiscalYear });
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptCashFlow.rdlc");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPReceiptOp", dt.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPPaymentOp", dt.Tables[1]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPReceiptInv", dt.Tables[2]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPPaymentInv", dt.Tables[3]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPReceiptFi", dt.Tables[4]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPPaymentFi", dt.Tables[5]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPIncreaseDecrease", dt.Tables[6]));
            }
 
           
            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            parameters.Add(new ReportParameter("FromDate", fisInfo.StartDate.ToString("dd/MM/yyyy")));
            parameters.Add(new ReportParameter("ToDate", fisInfo.EndDate.ToString("dd/MM/yyyy")));
            
            rptViewer.LocalReport.SetParameters(parameters);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }


        public FileResult ViewCashBankBookReport(int FiscalYear, int ReportType, int ReportMonth)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            var fisInfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").FirstOrDefault();
            System.Data.DataSet dt = new System.Data.DataSet();
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            string fullMonthName = new DateTime(2015, ReportMonth, 1).ToString("MMMM");
            if (ReportType == 6)
            {
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptCashBook", new object[] { FiscalYear, ReportMonth });
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptCashBook.rdlc");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt.Tables[0]));
            }
            else 
            {
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptBankBook", new object[] { FiscalYear, ReportMonth });
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptBankBook.rdlc");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt.Tables[0]));
            }
            

         

            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            //parameters.Add(new ReportParameter("FromDate", fisInfo.StartDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("ToDate", fisInfo.EndDate.ToString("dd/MM/yyyy")));
            parameters.Add(new ReportParameter("FiscalYear", FiscalYear.ToString()));
            parameters.Add(new ReportParameter("ReportMonth", fullMonthName));
            rptViewer.LocalReport.SetParameters(parameters);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }
        public FileResult ViewSubLedgerReport(string FormDate, string ToDate, int? BranchId, int LedgerId)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
           // var fisInfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").FirstOrDefault();
            //System.Data.DataSet dt = new System.Data.DataSet();
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            //DateTime fdate = Convert.ToDateTime(FormDate);
            //DateTime tdate = Convert.ToDateTime(ToDate);

            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetSubLedger", new object[] { LedgerId, FormDate, ToDate, BranchId});
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptGetSubLedger.rdlc");
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt));



            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            //parameters.Add(new ReportParameter("FromDate", fisInfo.StartDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("ToDate", fisInfo.EndDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("FromDate", Convert.ToDateTime(FormDate).ToString()));
            //parameters.Add(new ReportParameter("ToDate", Convert.ToDateTime(ToDate).ToString()));
           
            rptViewer.LocalReport.SetParameters(parameters);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }
        public FileResult ViewSubLedgerReportCostCenter(string FormDate, string ToDate, int BranchId, int LedgerId)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            // var fisInfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").FirstOrDefault();
            //System.Data.DataSet dt = new System.Data.DataSet();
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            //DateTime fdate = Convert.ToDateTime(FormDate);
            //DateTime tdate = Convert.ToDateTime(ToDate);

            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetSubLedgerForCC", new object[] { LedgerId, FormDate, ToDate, BranchId });
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptGetSubLedgerForCC.rdlc");
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt));



            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            //parameters.Add(new ReportParameter("FromDate", fisInfo.StartDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("ToDate", fisInfo.EndDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("FromDate", Convert.ToDateTime(FormDate).ToString()));
            //parameters.Add(new ReportParameter("ToDate", Convert.ToDateTime(ToDate).ToString()));

            rptViewer.LocalReport.SetParameters(parameters);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }

        public FileResult ViewReportCostCenter(int FiscalYear, int ReportType)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            var fisInfo = DataAccess.Instance.FiscalYearService.Filter(f => f.Id == FiscalYear && f.IsDeleted == false).FirstOrDefault();
            System.Data.DataSet dt = new System.Data.DataSet();
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            if (ReportType == 1)
            {
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetBalanceSheetForCC");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPliabilitis", dt.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPAsset", dt.Tables[1]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptBalanceSheeForCC.rdlc");

            }
            else if (ReportType == 2)
            {
                parameters.Add(new ReportParameter("CurrentDate", DateTime.Now.ToString("dd/MM/yyyy")));
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetProfitLossForCC", new object[] { FiscalYear });
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPIncome", dt.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPExpense", dt.Tables[1]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptProfitLossForCC.rdlc");
            }

            else if (ReportType == 3)
            {
                parameters.Add(new ReportParameter("CurrentDate", DateTime.Now.ToString("dd/MM/yyyy")));
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetTrailBalanceForCC", new object[] { FiscalYear });
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptTrialBalanceForCC.rdlc");
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt.Tables[0]));
            }



            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            parameters.Add(new ReportParameter("FromDate", fisInfo.StartDate.ToString("dd/MM/yyyy")));
            parameters.Add(new ReportParameter("ToDate", fisInfo.EndDate.ToString("dd/MM/yyyy")));

            rptViewer.LocalReport.SetParameters(parameters);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }

        public FileResult ViewCostCenterSummeryReport(string FormDate, string ToDate, int BranchId)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();


            // var fisInfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").FirstOrDefault();
            //System.Data.DataSet dt = new System.Data.DataSet();
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            DataTable dt;
            //DateTime fdate = Convert.ToDateTime(FormDate);
            //DateTime tdate = Convert.ToDateTime(ToDate);
            if (BranchId!=0)
            {
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptCostCenterSummary", new object[] { FormDate, ToDate, BranchId });
            }
            else
            {
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptCostCenterSummary", new object[] { FormDate, ToDate, DBNull.Value });
            }
                
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptCostCenterSummary.rdlc");
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt));



            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            //parameters.Add(new ReportParameter("FromDate", fisInfo.StartDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("ToDate", fisInfo.EndDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("FromDate", Convert.ToDateTime(FormDate).ToString()));
            //parameters.Add(new ReportParameter("ToDate", Convert.ToDateTime(ToDate).ToString()));

            rptViewer.LocalReport.SetParameters(parameters);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }
        public FileResult ViewCostCenterDetailsReport(string FormDate, string ToDate, int BranchId)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            // var fisInfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").FirstOrDefault();
            //System.Data.DataSet dt = new System.Data.DataSet();
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            //DateTime fdate = Convert.ToDateTime(FormDate);
            //DateTime tdate = Convert.ToDateTime(ToDate);
            DataTable dt;
            if (BranchId != 0)
            {
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptCostCenterDetails", new object[] { FormDate, ToDate, BranchId });
            }
            else
            {
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptCostCenterDetails", new object[] { FormDate, ToDate, DBNull.Value });
            }
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptCostCenterDetails.rdlc");
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt));



            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            //parameters.Add(new ReportParameter("FromDate", fisInfo.StartDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("ToDate", fisInfo.EndDate.ToString("dd/MM/yyyy")));
            //parameters.Add(new ReportParameter("FromDate", Convert.ToDateTime(FormDate).ToString()));
            //parameters.Add(new ReportParameter("ToDate", Convert.ToDateTime(ToDate).ToString()));

            rptViewer.LocalReport.SetParameters(parameters);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }


        public FileResult AccountViewReport(int RootGroup)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            var fisInfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").FirstOrDefault();
           
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
           
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetLedgerBalance",new object[]{ RootGroup });
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptLedgerBalance.rdlc");

          
           

            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            parameters.Add(new ReportParameter("FromDate", fisInfo.StartDate.ToString("dd/MM/yyyy")));
            parameters.Add(new ReportParameter("ToDate", fisInfo.EndDate.ToString("dd/MM/yyyy")));
            rptViewer.LocalReport.SetParameters(parameters);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }


        public ActionResult CostCategory()
        {
            return View();
        }

        public ActionResult CostCenter()
        {
            return View();
        }
        public ActionResult CostCenterReports()
        {
            return View();
        }
    }
}
