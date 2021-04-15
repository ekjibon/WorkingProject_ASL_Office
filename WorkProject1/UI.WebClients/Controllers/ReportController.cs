using Microsoft.Reporting.WebForms;
using OEMS.AppData;
using OEMS.Models.Model;
using OEMS.Models.ViewModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using Microsoft.Ajax.Utilities;
using System.Configuration;
using OEMS.Models.Migrations;
using OEMS.Models.Model.Employee;
using OEMS.Models;
using ZXing.Common;
using ZXing;
using ZXing.QrCode;
using System.Drawing;
using System.Web.Hosting;
using OEMS.Api.Providers;
using System.Text.RegularExpressions;
using OEMS.Models.Constant;
using System.Reflection;
using OEMS.Models.Constant;
using OEMS.Api;
using System.Net;
using System.Transactions;
using Microsoft.AspNet.Identity;
using OEMS.Repository.Repositories;
using System.Text;
using Newtonsoft.Json;
using System.Globalization;
using System.Data.SqlClient;
using OEMS.Models.ViewModel.Attendance;
using OEMS.Models.ViewModel.TaskManagement;
using System.Net.Mail;

namespace UI.WebClients.Controllers
{
    //[ViewAuth]
    public class ReportController : BaseController
    {

        #region Private Methods
        private byte[] GetPdf(ReportViewer rpt)
        {
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            return rpt.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
        }
        #endregion

        public FileResult EmployeeSalarySheet(int PeriodId, int BranchID, int MonthId, int SalaryYearId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();


            var param = new object[] { PeriodId, BranchID, MonthId, SalaryYearId };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetSalarySheet", param);

            //var param = new object[] { PeriodId, Month, DepartmentID,DBNull.Value };

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmployeeSalarySheet.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult EmployeeSalaryDeduction(int PeriodId, int BranchID)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();


            var param = new object[] { PeriodId, BranchID };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTGetSalarySheetDeduction", param);

            //var param = new object[] { PeriodId, Month, DepartmentID,DBNull.Value };

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmployeeDeductionSalary.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult EmployeeSalaryTaxDeduction(int PeriodId, int BranchID)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();


            var param = new object[] { PeriodId, BranchID };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTGetSalarySheetTaxDeduction", param);

            //var param = new object[] { PeriodId, Month, DepartmentID,DBNull.Value };

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmpTaxDeduction.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult EmployeeNOC(string EmpId, string IssueDate, string TravelType, string Destination, string TravelFromDate, string TravelToDate)
        {
            string date = IssueDate.Substring(4, 11);
            IssueDate = DateTime.ParseExact(date, "MMM dd yyyy", CultureInfo.InvariantCulture).ToString("dd.MM.yyyy");

            if (TravelType == "1")
            {
                date = TravelFromDate.Substring(4, 11);
                TravelFromDate = DateTime.ParseExact(date, "MMM dd yyyy", CultureInfo.InvariantCulture).ToString("MM.dd.yyyy");

                date = TravelToDate.Substring(4, 11);
                TravelToDate = DateTime.ParseExact(date, "MMM dd yyyy", CultureInfo.InvariantCulture).ToString("MM.dd.yyyy");

            }

            var param = new object[] { Convert.ToInt32(EmpId), 0, 0, 0, 0, 0, 0, 0, 0, 0, null, null, null, null };
            System.Data.DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SearchEmpInfo", param);

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            if (TravelType == "1")
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/EmployeeTravellingNOC.rdlc");
            }
            else
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/EmployeeNotTravellingNOC.rdlc");

            }

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            string SchoolName = ConfigurationManager.AppSettings["SchoolName"];

            List<ReportParameter> parameters = new List<ReportParameter>();
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            parameters.Add(new ReportParameter("SchoolName", SchoolName));
            parameters.Add(new ReportParameter("IssueDate", IssueDate));
            parameters.Add(new ReportParameter("TravelType", TravelType));
            parameters.Add(new ReportParameter("Destination", Destination));
            parameters.Add(new ReportParameter("TravelFromDate", TravelFromDate));
            parameters.Add(new ReportParameter("TravelToDate", TravelToDate));
            rptViewer.LocalReport.SetParameters(parameters);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult EmployeeReleaseLetter(string EmpId, string IssueDate, string ReleaseDate)
        {
            string date = IssueDate.Substring(4, 11);
            IssueDate = DateTime.ParseExact(date, "MMM dd yyyy", CultureInfo.InvariantCulture).ToString("dd MMMM yyyy");

            //date = ApplyDate.Substring(4, 11);
            //ApplyDate = DateTime.ParseExact(date, "MMM dd yyyy", CultureInfo.InvariantCulture).ToString("dd MMMM yyyy");

            date = ReleaseDate.Substring(4, 11);
            ReleaseDate = DateTime.ParseExact(date, "MMM dd yyyy", CultureInfo.InvariantCulture).ToString("dd MMMM yyyy");

            var param = new object[] { Convert.ToInt32(EmpId), 0, 0, 0, 0, 0, 0, 0, 0, 0, null, null, null, null, 2 };
            System.Data.DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetEmpReqInfo", param);

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/EmployeeReleaseLetter.rdlc");

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            string SchoolName = ConfigurationManager.AppSettings["SchoolName"];

            List<ReportParameter> parameters = new List<ReportParameter>();
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            parameters.Add(new ReportParameter("SchoolName", SchoolName));
            parameters.Add(new ReportParameter("IssueDate", IssueDate));
            //parameters.Add(new ReportParameter("ApplyDate", ApplyDate));
            parameters.Add(new ReportParameter("ReleaseDate", ReleaseDate));
            rptViewer.LocalReport.SetParameters(parameters);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult EmployeeExprienceCertificate(string EmpId, string IssueDate)
        {
            string date = IssueDate.Substring(4, 11);
            IssueDate = DateTime.ParseExact(date, "MMM dd yyyy", CultureInfo.InvariantCulture).ToString("dd MMMM yyyy");

            var param = new object[] { Convert.ToInt32(EmpId), 0, 0, 0, 0, 0, 0, 0, 0, 0, null, null, null, null, 1 };
            System.Data.DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetEmpReqInfo", param);

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/EmployeeExperienceCertificate.rdlc");

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            string SchoolName = ConfigurationManager.AppSettings["SchoolName"];

            List<ReportParameter> parameters = new List<ReportParameter>();
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            parameters.Add(new ReportParameter("SchoolName", SchoolName));
            parameters.Add(new ReportParameter("IssueDate", IssueDate));
            rptViewer.LocalReport.SetParameters(parameters);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult EmployeeIdCard(string EmpIds)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            //var emp = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == EmpIds).FirstOrDefault();

            var param = new object[] { EmpIds };

            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpInfoByIDs", param);

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptIDCardLP42.rdlc");

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            string SchoolName = ConfigurationManager.AppSettings["SchoolName"];

            List<ReportParameter> parameters = new List<ReportParameter>();
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            parameters.Add(new ReportParameter("SchoolName", SchoolName));
            rptViewer.LocalReport.SetParameters(parameters);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        //by evan for report of AccdemicUseVairousType
        
        //Virtual Exam report by Abul Hasan
        public FileResult VirtualExamSetupReport(int GroupId, int ClassId, int MainExamId, int Versionid, int SessionId, int SubjectID)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var param = new object[] { Versionid, SessionId, ClassId, GroupId, MainExamId, SubjectID };

            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetSubExamForVirtual", param);
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Results/Setup/VirtualExamSetup.rdlc");

            //rptViewer.LocalReport.ReportPath = Path.Combine("EmployeeList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);

            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            //rptViewer.ServerReport.DisplayName = "Your File Name Goes Here";
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        
      
        // GET: Report
        public static int vID { get; set; }
        public static int sessID { get; set; }
        public static int cID { get; set; }
       
      
        
      
        [HttpPost]
       
        public List<SchoolSetup> GetHeader()
        {
            List<SchoolSetup> schoolSetup = new List<SchoolSetup>();
            schoolSetup.Add(DataAccess.Instance.SchoolSetupService.GetAll().FirstOrDefault());
            return schoolSetup;
        }
      public ActionResult ReportHeader()
        {
            ReportHeader GetHeader = DataAccess.Instance.RepHeaderImgService.Filter(e => e.IsDeleted == false).ToList().FirstOrDefault();
            if (GetHeader == null)
            {
                GetHeader = new ReportHeader();
            }
            return View(GetHeader);
        }
        [Route("Report/ReportHeader/")]
        [HttpPost]
        public ActionResult ReportHeader(HttpPostedFileBase LegalLandscapeImg,
        HttpPostedFileBase LegalPortraitImg, HttpPostedFileBase A4LandscapeImg, HttpPostedFileBase A4PortraitImg)
        {
            ReportHeader GetHeader = new ReportHeader();
            //existing checking
            var aa = DataAccess.Instance.RepHeaderImgService.GetAll().ToList();

            ReportHeader header = DataAccess.Instance.RepHeaderImgService.Filter(e => e.IsDeleted == false).ToList().FirstOrDefault();
            if (LegalLandscapeImg != null)
            {

                using (Stream inputStream = LegalLandscapeImg.InputStream)
                {
                    MemoryStream memoryStream = inputStream as MemoryStream;
                    if (memoryStream == null)
                    {
                        memoryStream = new MemoryStream();
                        inputStream.CopyTo(memoryStream);
                    }
                    if (header != null)
                    {
                        if (LegalLandscapeImg != null)
                        {
                            header.LegalLandscape = memoryStream.ToArray();
                        }
                    }
                    else
                    {
                        if (LegalLandscapeImg != null)
                        {
                            GetHeader.LegalLandscape = memoryStream.ToArray();
                        }
                    }
                }
            }
            if (LegalPortraitImg != null)
            {
                using (Stream inputStream = LegalPortraitImg.InputStream)
                {
                    MemoryStream memoryStream = inputStream as MemoryStream;
                    if (memoryStream == null)
                    {
                        memoryStream = new MemoryStream();
                        inputStream.CopyTo(memoryStream);
                    }
                    if (header != null)
                    {
                        if (LegalPortraitImg != null)
                        {
                            header.LegalPortrait = memoryStream.ToArray();
                        }
                    }
                    else
                    {
                        if (LegalLandscapeImg != null)
                        {
                            GetHeader.LegalLandscape = memoryStream.ToArray();
                        }
                    }
                }
            }
            if (A4LandscapeImg != null)
            {
                using (Stream inputStream = A4LandscapeImg.InputStream)
                {
                    MemoryStream memoryStream = inputStream as MemoryStream;
                    if (memoryStream == null)
                    {
                        memoryStream = new MemoryStream();
                        inputStream.CopyTo(memoryStream);
                    }
                    if (header != null)
                    {
                        if (A4LandscapeImg != null)
                        {
                            header.A4Landscape = memoryStream.ToArray();
                        }
                    }
                    else
                    {
                        if (LegalLandscapeImg != null)
                        {
                            GetHeader.LegalLandscape = memoryStream.ToArray();
                        }
                    }
                }
            }
            if (A4PortraitImg != null)
            {
                using (Stream inputStream = A4PortraitImg.InputStream)
                {
                    MemoryStream memoryStream = inputStream as MemoryStream;
                    if (memoryStream == null)
                    {
                        memoryStream = new MemoryStream();
                        inputStream.CopyTo(memoryStream);
                    }
                    if (header != null)
                    {
                        if (A4PortraitImg != null)
                        {
                            header.A4Portrait = memoryStream.ToArray();
                        }
                    }
                    else
                    {
                        if (LegalLandscapeImg != null)
                        {
                            GetHeader.LegalLandscape = memoryStream.ToArray();
                        }
                    }
                }
            }
            if (!DataAccess.Instance.RepHeaderImgService.GetAll().Any())
            {
                DataAccess.Instance.RepHeaderImgService.Add(GetHeader);
            }
            else
            {
                var x = DataAccess.Instance.RepHeaderImgService.Update(header);
            }
            GetHeader = DataAccess.Instance.RepHeaderImgService.Get(1);
            return RedirectToAction("ReportHeader", GetHeader);
            //return View("ReportHeader");
        }
             
        [HttpGet]
        public FileResult TotListRepot(int verisonId, int sessionId, int branchId, int shiftId, int ClassId, int SectionId, int GroupId)
        {
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptTotListReport", new object[] { verisonId, sessionId, branchId, shiftId, ClassId, GroupId, SectionId });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/StudentBasic/rptTotList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", branchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        
        [HttpGet]
       
        #region Handleler
        void SubreportProcessingEventHandler(object sender, SubreportProcessingEventArgs e)
        {
            DataTable gdt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetGrades", new object[] { vID, sessID, cID });
            e.DataSources.Add(new ReportDataSource("GradeResults", gdt));
        }
        #endregion
        private string GetHeader(string ImgType, int? BranchId = 8)
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
                    return Convert.ToBase64String(Header.LegalLandscape);
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
          
      

        #region Accounts


        public FileResult ReportDebitCreditByFiscalYear(int? Id) //Ayesha
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("spGetDebitCreditByFiscalYear", new object[] { Id });
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptDebitCreditByFiscalYear.rdlc");
            //
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("spGetDebitCreditByFiscalYear", dt));
            //List<ReportParameter> parameters = new List<ReportParameter>(); //;
            //parameters.Add(new ReportParameter("Date", ""));
            //parameters.Add(new ReportParameter("PayTo","Ayesha"));
            //parameters.Add(new ReportParameter("Description",""));
            //rptViewer.LocalReport.SetParameters(parameters);
            ///
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult GetAllTransactionList(int TransactionId, int TypeId) //Khaled
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@TransactionId", TransactionId));
            if (TransactionId > 0)
            {
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetAllTransaction", param.ToArray());
            }
            if (TypeId == 1)
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptCheque.rdlc");
            }
            else if (TypeId == 2)
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptCashDebit.rdlc");
            }
            else if (TypeId == 3)
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptChequeCredit.rdlc");
            }
            else if (TypeId == 4)
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptChequeDebit.rdlc");
            }
            else if (TypeId == 5)
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Accounts/rptJournal.rdlc");
            }

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTrial", dt));

            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        #endregion

        #region Leave Report
        //by evan for report of AttndSummaryDay
        [HttpGet]
        public FileResult AttndSummaryDay(int SessionID, int ShiftID, string FromDate)
        {
            // DateTime FromDateCon = Convert.ToDateTime(FromDate);
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            //    var param = new object[] { VersionId, SessionId, 0, ShiftID, 0, 0, 0, 0, FromDate, FromDate, 1 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionID, ShiftID, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, FromDate, DBNull.Value, 1 });
            // dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", param);

            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/AttndSummaryDay.rdlc");

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);

            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
            //return File(bytes, "application/vnd.ms-excel", "Report.xls");
            //return File(bytes, "application/vnd.ms-word", "Report.doc");
        }
        public FileResult StdDailyAtteneanceInfoSectionWays(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, string date)
        {
            // DateTime Date = new DateTime(y, m, d); VersionID	SessionId BranchID ShiftID	ClassId	GroupId	SectionId @PeriodId @FromDate @ToDate @BlockNo
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, date, date, 2 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptStdDailyAtteneanceInfoSectionWays.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult ReportWithMissPreiod(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, string date)
        {
            // DateTime Date = new DateTime(y, m, d); VersionID	SessionId BranchID ShiftID	ClassId	GroupId	SectionId @PeriodId @FromDate @ToDate @BlockNo
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, date, date, 2 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptReportWithMissPreiod.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult LIEO(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, string date)
        {
            // DateTime Date = new DateTime(y, m, d);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, date, DBNull.Value, 2 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptLIEOReport.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult StudentAttendanceSummaryRange(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, string FromDate, string ToDate)
        {
            DateTime From = Convert.ToDateTime(FromDate);
            DateTime To = Convert.ToDateTime(ToDate);// DateTime Date = new DateTime(y, m, d);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, From, To, 4 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptAttndSummRange.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult StudentDailyAttendanceSummary(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, string FromDate) //for single date
        {
            //Khaled

            DateTime From = Convert.ToDateTime(FromDate);
            //  DateTime To = Convert.ToDateTime(ToDate);// DateTime Date = new DateTime(y, m, d);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, From, DBNull.Value, 4 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptDailyAttndSumm.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult StudentMonthlyAttendanceSummary(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, string FromDate, string ToDate) //for date range
        {
            //Khaled 
            DateTime From = Convert.ToDateTime(FromDate);
            DateTime To = Convert.ToDateTime(ToDate);// DateTime Date = new DateTime(y, m, d);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, From, To, 15 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptMonthlyAttndSumm.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult StdMonthlyAttendanceReport(int SessionId, int BranchId, int ShiftId, string FromDate, string ToDate)
        {
            DateTime From = Convert.ToDateTime(FromDate);
            DateTime To = Convert.ToDateTime(ToDate);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, DBNull.Value, DBNull.Value, DBNull.Value, From, To, 6 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptAttndSummaryMonthly(ShiftWays).rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult MonthlyAttendance(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, string Date)
        {
            // DateTime Date = new DateTime(y, m, d);  VersionID	SessionId	BranchID	ShiftID	ClassId	GroupId	SectionId PeriodId FromDate FromDate BlockNo
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, Date, Date, 3 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptMonthly.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult SectionWaysReport(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, DateTime FromDate, DateTime ToDate)
        {
            // DateTime Date = new DateTime(y, m, d);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, FromDate, ToDate, 7 });
            // DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { VersionId, SessionId, BranchId, ShiftId, ClassId, GroupId, SectionId, DBNull.Value, FromDate, ToDate, 7 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptAttndSectionWays.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult AbscondingReport(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, DateTime FromDate, DateTime ToDate)
        {
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, FromDate, ToDate, 13 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptAbsconding.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult LeaveReport(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, DateTime FromDate, DateTime ToDate)
        {
            // DateTime Date = new DateTime(y, m, d);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, FromDate, ToDate, 8 });
            // DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { VersionId, SessionId, BranchId, ShiftId, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, 2 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptAttndLeave.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult DeviceReport(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId)
        {

            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, DBNull.Value, DBNull.Value, 10 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptDeviceReport.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult StudentSummeryReportSW(int SessionId, int BranchId, int ShiftId, int ClassId, int SectionId, string FromDate, string ToDate)
        {
            DateTime From = Convert.ToDateTime(FromDate);
            DateTime To = Convert.ToDateTime(ToDate);// DateTime Date = new DateTime(y, m, d);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { SessionId, BranchId, ShiftId, ClassId, SectionId, DBNull.Value, From, To, 12 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptSectionWiseAttendentSummery.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult EmployeeAttendanceSummery(int BranchId, DateTime FromDate, int? DepartmentID)
        {
            DateTime From = Convert.ToDateTime(FromDate);// DateTime Date = new DateTime(y, m, d);
            //DateTime To = Convert.ToDateTime(ToDate);
            List<SqlParameter> param = new List<SqlParameter>();

            param.Add(new SqlParameter("@SessionId", DBNull.Value));
            param.Add(new SqlParameter("@BranchId", BranchId));
            param.Add(new SqlParameter("@ShiftId", DBNull.Value));
            param.Add(new SqlParameter("@ClassId", DBNull.Value));
            param.Add(new SqlParameter("@SectionId", DBNull.Value));
            param.Add(new SqlParameter("@PeriodId", DBNull.Value));
            param.Add(new SqlParameter("@FromDate", From));
            param.Add(new SqlParameter("@ToDate", From));
            param.Add(new SqlParameter("@DepartmentID", DepartmentID));
            param.Add(new SqlParameter("@BlockNo", 14));
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", param.ToArray());
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptEmployeeAttendanceSummary.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult EmployeeAttendanceSummeryDateRange(int BranchId, string FromDate, string ToDate, int ? DepartmentID)
        {
            //DateTime From = Convert.ToDateTime(FromDate);
            // DateTime To = Convert.ToDateTime(ToDate);// DateTime Date = new DateTime(y, m, d);
            List<SqlParameter> param = new List<SqlParameter>();


            param.Add(new SqlParameter("@BranchId", BranchId));
            param.Add(new SqlParameter("@FromDate", FromDate));
            param.Add(new SqlParameter("@ToDate", ToDate));
            param.Add(new SqlParameter("@DepartmentID", DepartmentID));

            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptEMPAttendanceSummary", param.ToArray());
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptEmpAttendanceSummaryDateRange.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult EmployeeAttendanceDetailsDateRange(int BranchId, string FromDate, string ToDate)
        {
            DateTime From = Convert.ToDateTime(FromDate);
            DateTime To = Convert.ToDateTime(ToDate);// DateTime Date = new DateTime(y, m, d);
            List<SqlParameter> param = new List<SqlParameter>();


            param.Add(new SqlParameter("@BranchId", BranchId));
            param.Add(new SqlParameter("@FromDate", From));
            param.Add(new SqlParameter("@ToDate", To));

            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptEMPAttendanceDetails", param.ToArray());
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptEmpAttendanceDetailsDateRange.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult UnethicalExitReport(int BranchId, int EmpId)
        {

            List<SqlParameter> param = new List<SqlParameter>();


            param.Add(new SqlParameter("@BranchId", BranchId));
            param.Add(new SqlParameter("@EmpId", EmpId));


            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptUnethicalExitReport", param.ToArray());
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptUnethicalExitReport.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult IndiVidualEmployeeAttendanceDateRange(int EmpId, string FromDate, string ToDate)
        {
            var From = Convert.ToDateTime(FromDate).ToString("yyyy-MM-dd");
            var To = Convert.ToDateTime(ToDate).ToString("yyyy-MM-dd");// DateTime Date = new DateTime(y, m, d);
            List<SqlParameter> param = new List<SqlParameter>();


            param.Add(new SqlParameter("@EmpId", EmpId));
            param.Add(new SqlParameter("@FromDate", From));
            param.Add(new SqlParameter("@ToDate", To));
            DataSet ds = new DataSet();
            ds = DataAccess.Instance.CommonServices.getDatasetResponseBySp("rptEmpIndividualAttendance", param.ToArray()).results;
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptIndividualEmployeeAttendance.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", ds.Tables[0]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResultsDetails", ds.Tables[1]));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult SingleStudentSummeryReport(string FromDate, string ToDate)
        {
            DateTime From = Convert.ToDateTime(FromDate);
            DateTime To = Convert.ToDateTime(ToDate);// DateTime Date = new DateTime(y, m, d);
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, From, To, 11 });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptStudentWiseAttendentSummery.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        #endregion

        #region Attendance Report
        [HttpGet]
        public FileResult AttendanceReport(int VersionId, int sessionId, int branchId, int shiftId, int ClassId, int GroupId, int SectionId, int Wise, int Type, string StartDay, string EndDay)
        {

            DateTime fd = Convert.ToDateTime(StartDay);
            DateTime td = Convert.ToDateTime(EndDay);
            string Where = @"AND B.Status='A' ";
            if (Wise == 7)
            {
                Where += "  AND  B.SessionId=" + sessionId + " AND B.BranchID=" + branchId + " AND B.ShiftID=" + shiftId + " AND B.ClassId=" + ClassId + "  AND B.SectionId=" + sessionId + " ";
            }
            else if (Wise == 6)
            {
                Where += "  AND  B.SessionId=" + sessionId + " AND B.BranchID=" + branchId + " AND B.ShiftID=" + shiftId + " AND B.ClassId=" + ClassId + "  ";
            }
            else if (Wise == 5)
            {
                Where += "  AND  B.SessionId=" + sessionId + " AND B.BranchID=" + branchId + " AND B.ShiftID=" + shiftId + " AND B.ClassId=" + ClassId + " ";
            }
            else if (Wise == 4)
            {
                Where += "  AND  B.SessionId=" + sessionId + " AND B.BranchID=" + branchId + " AND B.ShiftID=" + shiftId + " ";
            }
            else if (Wise == 3)
            {
                Where += "  AND  B.SessionId=" + sessionId + " AND B.BranchID=" + branchId + " ";
            }
            else if (Wise == 2)
            {
                Where += "  AND  B.SessionId=" + sessionId + " ";
            }
            else if (Wise == 1)
            {
                Where += " ";
            }
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendanceDynamicByType", new object[] { Where, Type, fd, td });
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptAttendenceReportKawservai.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", branchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();

            return File(GetPdf(rptViewer), "application/pdf");
        }
        #endregion Attendance Report
             
        #region Users
        [Authorize(Roles = "Super")]
        public FileResult UserList()
        {
            ReportViewer rptViewer = new ReportViewer();
            DataTable dt = new DataTable();

            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllUserInfo", new object[] { 2 });

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Users/rptUsersList.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");

        }
        #endregion

        #region Attendance Setup Report
        public FileResult PeriodassignReport(int SessionId, int BranchId, int? ShiftId, int? ClassId, int? SectionId)
        {
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("getPeriodTeacher", new object[] { 2, SessionId, BranchId, ShiftId, ClassId, SectionId });
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptClassWiseAssignPeriod.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));
            List<ReportParameter> parameter = new List<ReportParameter>();
            parameter.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            string shiftName = "";

            if (ShiftId != null)
                shiftName = dtResult.Rows[0]["ShiftName"].ToString();

            parameter.Add(new ReportParameter("ShiftName", shiftName));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();



            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult LIEOSetupReport(int SessionId, int BranchId, int? ShiftId, int? ClassId, int? SectionId)
        {
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("Attendence", new object[] { 2, ShiftId, ClassId, SectionId, DBNull.Value, SessionId, BranchId, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value });
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptLIEOSetupReport.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();



            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult CalenderSetupSummeryReport(int YearId)
        {
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptCalenderSummeryYearly", new object[] { YearId });
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptCalendearSetupSummary.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();



            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult EmpCalenderSetupSummeryReport(int YearId, int Month, int CalendarId)
        {
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptEmpCalenderSummeryYearly", new object[] { YearId, Month, CalendarId });
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptEmpCalendearSetupSummary.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();



            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult EmpRosterRegularSummeryReport(int BranchId, int CalendarId)
        {
            DataTable result = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetEmployeeRegularRosterList", new object[] { BranchId, CalendarId });
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptEmpRosterRegularSummary.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", result));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();



            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult EmpRosterTemSummeryReport(int EmpId)
        {
            DataTable result = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetEmployeeTemRosterList", new object[] { EmpId });
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptEmpRosterTempSummary.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", result));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();



            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult LeaveListReport(int SessionID, int BranchId, int ShiftId, int? ClassId, int? SectionId, string Status, DateTime Fromdate, DateTime Todate)
        {
            if (Status == "")
                Status = null;
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("Attendence", new object[] { 4, ShiftId, ClassId, SectionId, DBNull.Value, SessionID, BranchId, Status, Fromdate, Todate, DBNull.Value });
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptLeaveListReport.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchId));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();



            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult EmployeeAttendanceReward(int BranchId, string FromDate, string ToDate)
        {
            //DateTime From = Convert.ToDateTime(FromDate);
            // DateTime To = Convert.ToDateTime(ToDate);// DateTime Date = new DateTime(y, m, d);
            List<SqlParameter> param = new List<SqlParameter>();


            param.Add(new SqlParameter("@BranchId", BranchId));
            param.Add(new SqlParameter("@FromDate", FromDate));
            param.Add(new SqlParameter("@ToDate", ToDate));

            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("FullAttendanceAward", param.ToArray());
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmployeeAttendanceReward.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        #endregion        

        #region Generate Payrol Report
        public FileResult ReportGeneratePayrol(int SalaryPeriodId, string EmpId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            DataSet dt = new DataSet();

            dt = DataAccess.Instance.CommonServices.getDatasetResponseBySp("SP_RPTEmpSalarySlip", new object[] { SalaryPeriodId, EmpId.Trim(',') }).results;

            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmpSalarySlipAll.rdlc");

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt.Tables[0]));
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchID));
            //rptViewer.LocalReport.SetParameters(parameter);

            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
            //return File(bytes, "application/vnd.ms-excel", "Report.xls");
            //return File(bytes, "application/vnd.ms-word", "Report.doc");
        }
        public FileResult ReportGenerateSalaryHold(string EmpId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            DataSet dt = new DataSet();

            dt = DataAccess.Instance.CommonServices.getDatasetResponseBySp("SP_RPTGetSalaryHold", new object[] { EmpId.Trim(',') }).results;

            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmpSalaryHold.rdlc");

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt.Tables[0]));
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchID));
            //rptViewer.LocalReport.SetParameters(parameter);

            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");

        }
        public FileResult ReportSalaryHoldRefundIndividual(int EmpId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            DataSet dt = new DataSet();

            dt = DataAccess.Instance.CommonServices.getDatasetResponseBySp("rptSalaryHoldRefundInndividual", new object[] { EmpId }).results;

            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmpSalaryHoldrefund.rdlc");

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt.Tables[0]));
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchID));
            //rptViewer.LocalReport.SetParameters(parameter);

            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");

        }
        public FileResult ReportSalaryHoldRefund(int BranchId, int ReportType)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();

            System.Data.DataSet dt = new System.Data.DataSet();
            List<ReportParameter> parameters = new List<ReportParameter>();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            if (ReportType == 2)
            {
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptSalaryHoldRefund", new object[] { BranchId });
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt.Tables[0]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptSalaryHoldRefundCombind.rdlc");

            }
            else if (ReportType == 3)
            {
                parameters.Add(new ReportParameter("CurrentDate", DateTime.Now.ToString("dd/MM/yyyy")));
                dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptSalaryHoldRefund", new object[] { BranchId });
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt.Tables[0]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptSalaryHoldDue.rdlc");
            }



            rptViewer.LocalReport.EnableExternalImages = true;
            //parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));


            //rptViewer.LocalReport.SetParameters(parameters);          
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
        }
        public FileResult SalarySheetChequePayment(int PeriodId, int BranchID, int MonthId, int SalaryYearId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            //var param = new object[] { PeriodId, Month, DepartmentID,DBNull.Value };
            var Date = DateTime.Now;
            var param = new object[] { PeriodId, "Cheque", BranchID, Date, MonthId, SalaryYearId };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTGetSalarySheetByPaymentMode", param);


            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmployeeChequePaymentSalary.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult SalarySheetAdvice(int PeriodId, int BranchID, string SelectDate, int MonthId, int SalaryYearId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            DateTime date = Convert.ToDateTime(SelectDate);
            //var param = new object[] { PeriodId, Month, DepartmentID,DBNull.Value }; 
            var param = new object[] { PeriodId, "BankAccount", BranchID, date, MonthId, SalaryYearId };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTGetSalarySheetByPaymentMode", param);


            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptEmpSalaryAdvise.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        #endregion

        #region Inventory 
        public FileResult ReportAssestTagging(int ProductId, int Quantity)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            DataTable dt = new DataTable();
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetProductList", new object[] { ProductId });
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Inventory/AssetTaging.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            ReportParameter parameter = new ReportParameter("Quantity", Quantity.ToString());
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
            //return File(bytes, "application/vnd.ms-excel", "Report.xls");
            //return File(bytes, "application/vnd.ms-word", "Report.doc");
        }
        public FileResult ReportInventory(DateTime FromDate, DateTime ToDate, int Type)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            DataTable dt = new DataTable();

            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetAllProducList", new object[] { FromDate, ToDate, Type });

            if (Type == 1 || Type == 2 || Type == 3)
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Inventory/rptProductList.rdlc");
            }
            else if (Type == 4)
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Inventory/rptStockProductList.rdlc");
            }

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);

            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
            //return File(bytes, "application/vnd.ms-excel", "Report.xls");
            //return File(bytes, "application/vnd.ms-word", "Report.doc");
        }

        #endregion

        #region Employee Roster

        public FileResult GetRosterSetupReport(int BranchId, int CategoryId, int CalendarId)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@Block", 5));
            param.Add(new SqlParameter("@BranchId", BranchId));
            param.Add(new SqlParameter("@CategoryId", CategoryId));
            param.Add(new SqlParameter("@CalendarId", CalendarId));
            param.Add(new SqlParameter("@Year", DBNull.Value));
            param.Add(new SqlParameter("@MonthId", DBNull.Value));

            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRosterList", param.ToArray());

            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Attendance/rptGetRosterSetupReport.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));

            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
        }
        #endregion
                

        #region Invoice
        public FileResult ReportForBillingHeadConfig(int? ClientId, int? InvoiceServiceId, int? BillingHeadId, string BillingHeadType, int? BillingMethodId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            DataTable dt = new DataTable();
            int Block = 1;
            if(BillingHeadType == "undefined")
            {
                BillingHeadType = null;
            }

            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetAllBillingHeadConfig", new object[] { ClientId, InvoiceServiceId, BillingHeadId, BillingHeadType, BillingMethodId,DBNull.Value,DBNull.Value, Block });
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/BillingHeadConfigPanel.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
           // ReportParameter parameter = new ReportParameter("Quantity", Quantity.ToString());
            //rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();


            return File(GetPdf(rptViewer), "application/pdf");
            //return File(bytes, "application/vnd.ms-excel", "Report.xls");
            //return File(bytes, "application/vnd.ms-word", "Report.doc");
        }
        #endregion    
        
        public FileResult DatabaseConfig(string ClientName, string DataType, string FromDate, string ToDate)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;
         
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            if (DataType == "SMSData")
            {
                var param = new object[] { ClientName, FromDate, ToDate };
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetDB_SMSData", param);
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptSMSData.rdlc");
            }
            else if (DataType == "StudentData")
            {
                var param = new object[] { ClientName};
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetDB_StudentData", param);
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptStudentData.rdlc");

            }
            rptViewer.LocalReport.EnableExternalImages = true;
            
            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult InvoiceSearchReport(int? YearID, int? MonthId, int? ClientId, string InvoiceNo, string InvoiceId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { YearID, MonthId, ClientId, InvoiceNo, DBNull.Value, DBNull.Value, InvoiceId, 0, 17 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptInvoiceGenerate.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult InvoiceGenerate(int? YearID, int? MonthId, int? ClientId, string InvoiceNo, string InvoiceId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { YearID, MonthId, ClientId, InvoiceNo,DBNull.Value,DBNull.Value, InvoiceId,0, 7 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptInvoiceGenerate.rdlc");

            
            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult MoneyReceiptGenerate( string InvoiceNo)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { DBNull.Value, DBNull.Value, DBNull.Value, InvoiceNo, DBNull.Value, DBNull.Value, DBNull.Value, 0,12 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptMoneyReceiptGenerate.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult InvoiceExcelReport(int? YearID, int? MonthId, int? ClientId, string InvoiceNo, string InvoiceId)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { YearID, MonthId, ClientId, InvoiceNo, DBNull.Value, DBNull.Value, InvoiceId,0, 7 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptInvoiceGenerate.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("Excel", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/vnd.ms-excel");
            //return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult Collection(int? ClientId, int? YearID, int? MonthId, string FromDate, string ToDate)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { YearID, MonthId, ClientId,DBNull.Value, FromDate, ToDate, DBNull.Value,0,8 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptCollection.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult Due(int? ClientId, int? YearID, int? MonthId, string FromDate, string ToDate)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { YearID, MonthId, ClientId, DBNull.Value, FromDate, ToDate, DBNull.Value,0, 9 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptDueAmount.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }

        public FileResult CollectionSummary(int? ClientId, int? InvoiceServiceId, int? BillingHeadId, string FromDate, string ToDate)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] {DBNull.Value,DBNull.Value, ClientId, FromDate, ToDate, InvoiceServiceId, BillingHeadId, DBNull.Value, 0, 1 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptCollectionSummary.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult CollectionDetailsMonthly(int? ClientId, string FromDate, string ToDate)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { DBNull.Value, DBNull.Value, ClientId, FromDate, ToDate, DBNull.Value, DBNull.Value, DBNull.Value, 0, 2 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptCollectionDetailsMonthly.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf"); 
        }
        public FileResult CollectionDetailsYearly(int? ClientId, int? Year)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { Year, DBNull.Value, ClientId, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, 0,3 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptCollectionDetailsYearly.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult DueDetailsMonthly(int? ClientId, string FromDate, string ToDate, int? FilterType)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { DBNull.Value, DBNull.Value, ClientId, FromDate, ToDate, DBNull.Value, DBNull.Value, DBNull.Value, FilterType, 4 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptDueDetailsMonthly.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult DueDetailsYearly(int? ClientId, int? Year, int? FilterType)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { Year, DBNull.Value, ClientId, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, FilterType, 5 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptDueDetailsYearly.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult MonthlyStatus(int? ClientId, int? Year, int? MonthId, string Status, int? FilterType)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { Year, MonthId, ClientId, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, Status, FilterType, 6 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptMonthlyStatus.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult ManagementViewMonthly(int? Year, int? MonthId, int? FilterType)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataSet dt = new System.Data.DataSet();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { Year, MonthId,DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, FilterType, 7 };
            //dt = DataAccess.Instance.CommonServices.GetDatasetBySp("rptGetBalanceSheetForCC");
            //rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPliabilitis", dt.Tables[0]));
            //rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPAsset", dt.Tables[1]));
            dt = DataAccess.Instance.CommonServices.GetDatasetBySp("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPTotalResults", dt.Tables[0]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPMonthResults", dt.Tables[1]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPDueResults", dt.Tables[2]));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptManagementViewMonthly.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult ManagementViewYearly(int? Year, int? FilterType)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { Year, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, FilterType, 8 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptManagementViewYearly.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        public FileResult AdjustmentExtraincome(int? ClientId, string FromDate, string ToDate)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();

            var Date = DateTime.Now;

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            var param = new object[] { DBNull.Value, DBNull.Value, ClientId, FromDate, ToDate, DBNull.Value, DBNull.Value, DBNull.Value, 0, 9 };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_RPTInvoiceReport", param);
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Invoice/rptAdjustmentExtraincome.rdlc");


            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            return File(GetPdf(rptViewer), "application/pdf");
        }
        #region Issue
        public FileResult TaskReport(IssueReportVM issueReport)
        {
            ReportViewer rptViewer = new ReportViewer();
            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@Block", issueReport.ReportTypeId));
            param.Add(new SqlParameter("@DepartmentId", issueReport.DepartmentId));
            param.Add(new SqlParameter("@ProjectId", issueReport.ProjectId));
            param.Add(new SqlParameter("@ClientId", issueReport.ClientId));
            param.Add(new SqlParameter("@SprintId", issueReport.SprintId));
            param.Add(new SqlParameter("@IssueTypeId", issueReport.IssueTypeId));
            param.Add(new SqlParameter("@FromDate", issueReport.FromDate));
            param.Add(new SqlParameter("@ToDate", issueReport.ToDate));
            DataSet dtResult = new DataSet();
            DataTable dt = new DataTable();
            if (issueReport.ReportTypeId == 4)
            {
                List<SqlParameter> param1 = new List<SqlParameter>();
                param1.Add(new SqlParameter("@Priority", DBNull.Value));
                param1.Add(new SqlParameter("@IssueTypeId", issueReport.IssueTypeId));
                param1.Add(new SqlParameter("@ProjectId", issueReport.ProjectId));
                param1.Add(new SqlParameter("@ClientId", issueReport.ClientId));
                param1.Add(new SqlParameter("@ReporteId", DBNull.Value)); 
                param1.Add(new SqlParameter("@SprintId", issueReport.SprintId));
                param1.Add(new SqlParameter("@StatusId", DBNull.Value));
                param1.Add(new SqlParameter("@AssigneeId", DBNull.Value)); 
                param1.Add(new SqlParameter("@AddBy", DBNull.Value)); 
                param1.Add(new SqlParameter("@UserId", DBNull.Value));
                param1.Add(new SqlParameter("@Date", issueReport.FromDate));

                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptIndividualIssueList", param1.ToArray());
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/TaskManagement/rptIndivisualIssueList.rdlc");
            }
            else
            {
                dtResult = DataAccess.Instance.CommonServices.GetDatasetBySp("rptIssueList", param.ToArray());
            }


            if (issueReport.ReportTypeId == 1) // Task Details
            {
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult.Tables[0]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/TaskManagement/rptIssueList.rdlc");
            }
            else if (issueReport.ReportTypeId == 2) // Daily Schedule
            {
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult.Tables[0]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/TaskManagement/rptDailySchedule.rdlc");
            }
            else if (issueReport.ReportTypeId == 3) // Sprint Wise Report
            {
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult.Tables[0]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("EmpWiseDetails", dtResult.Tables[1]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("DeptWiseDetails", dtResult.Tables[2]));
                rptViewer.LocalReport.DataSources.Add(new ReportDataSource("IssueLineChart", dtResult.Tables[3]));
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/TaskManagement/rptSprintWiseReport.rdlc");
            }

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.EnableExternalImages = true;

       

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();

            return File(GetPdf(rptViewer), "application/pdf");
        }


        public FileResult TaskDetails(int issueId) 
        {
            ReportViewer rptViewer = new ReportViewer();
            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@Block", 2));
            param.Add(new SqlParameter("@IssueId", issueId));

            DataSet dtResult = DataAccess.Instance.CommonServices.GetDatasetBySp("GetIssueList", param.ToArray());

            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/TaskManagement/rptIssueDetails.rdlc");

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.EnableExternalImages = true;

            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("IssueBasicInfo", dtResult.Tables[0]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SubTasks", dtResult.Tables[1]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("Comments", dtResult.Tables[2]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("Attachments", dtResult.Tables[3]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("WebLinks", dtResult.Tables[4]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("History", dtResult.Tables[5]));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();

            MailMessage email = new MailMessage();
            //email.To.Add(new MailAddress(model.PhoneNumber)); ///Here It's Email But doesn't Give Email.
            email.To.Add(new MailAddress("kawsar@addiesoft.com"));

            email.Subject = "Issue Report";
            email.Body = "Daily Report";
            email.IsBodyHtml = true;

            MemoryStream s = new MemoryStream(GetPdf(rptViewer));
            s.Seek(0, SeekOrigin.Begin);

            email.Attachments.Add(new Attachment(s, "Report.pdf"));

            SmtpClient client = new SmtpClient();
            client.Send(email);

            return File(GetPdf(rptViewer), "application/pdf");
        }
        #endregion

        public FileResult LeaveApplicationForm(int LeaveId)
        {
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            //System.Data.DataTable dt = new System.Data.DataTable();
            List<SqlParameter> param = new List<SqlParameter>();

            param.Add(new SqlParameter("@LeaveId", LeaveId));

            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetDataForEmpLeaveApplicationForm", param.ToArray());

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Employee/rptLeaveApplicationForm.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();

            return File(GetPdf(rptViewer), "application/pdf");
        }
    }
}



