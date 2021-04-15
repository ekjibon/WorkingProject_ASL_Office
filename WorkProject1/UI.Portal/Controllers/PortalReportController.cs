using Microsoft.Reporting.WebForms;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Attendance;
using OEMS.Models.Model.Document;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using UI.Portal.Models;

namespace UI.Portal.Controllers
{
    [Authorize]
    public class PortalReportController : Controller
    {
        public string ImgType { get; private set; }
        public int BranchId { get; private set; }

        // GET: PortalReport
        public FileResult LeaveApplication(long LeaveId)
        {
            int SIID = Convert.ToInt32(User.Identity.GetUserStudentId());
            DataSet ds = DataAccess.Instance.StudentBasicInfo.GetStudentDetailByIID(SIID.ToString());

            //DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { VersionId, SessionId, BranchId, ShiftId, ClassId, GroupId, SectionId, DBNull.Value, FromDate, ToDate, 8 });
            DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetLeaveDeatailsById",new object[] { SIID, LeaveId});
 
            string SchoolName = ConfigurationManager.AppSettings["SchoolName"].ToString();
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/rptLeave.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dtResult));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("StudentBasicInfo", ds.Tables[0]));

            ReportParameter parameter = new Microsoft.Reporting.WebForms.ReportParameter("SchoolName", SchoolName);
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();

            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

            return File(bytes, "application/pdf");
        }

        public FileResult MoneyReceiptReport(string FeesBookNo)
        {
            ReportViewer rptViewer = new ReportViewer();
            DataTable dt = new DataTable();
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("MoneyReceiptView", new object[] { 5, FeesBookNo, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value });

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Fees/rptMoneyReceiptStudentPortal.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            //ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            //rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

            return File(bytes, "application/pdf");
        }


        public FileResult MyProfile()
        {
            var StudentIID = Convert.ToInt32(User.Identity.GetUserStudentId());
            DataSet ds = DataAccess.Instance.StudentBasicInfo.GetStudentDetailByIID(StudentIID.ToString());
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/StudentBasic/rptMyProfile.rdlc");
           //D:\OEMS (New Solution)\UI.Portal\RDLC\StudentBasic\rptMyProfile.rdlc
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("SPResults", ds.Tables[0]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("GuardianInfo", ds.Tables[1]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("AcademicHistory", ds.Tables[2]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SiblingInfo", ds.Tables[4]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("OthersInfo", ds.Tables[5]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("Header", GetHeader()));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();

            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

            return File(bytes, "application/pdf");
        }
        public FileResult ReportCardTermWise(int TermId, int ClassId, int SessionId, string StuId, int BranchID)
        {

            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            DataSet dt = new DataSet();
            var termname = DataAccess.Instance.TermService.Filter(e => e.TermId == TermId).FirstOrDefault().Name;

            int MainExamId =  DataAccess.Instance.MainExamService.Filter(e => e.ClassId == ClassId && e.BranchID == BranchID && e.TermId == TermId).Select(e=> e.MainExamId).SingleOrDefault();

            if (BranchID == 8)
            {
                if (ClassId == 19 || ClassId == 20)
                {
                    dt = DataAccess.Instance.CommonServices.getDatasetResponseBySp("rptGetTermWiseResult", new object[] { 3, TermId, ClassId, SessionId, StuId.Trim(','), MainExamId }).results;
                    if (termname == "Summer")
                    {
                        rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Result/rptTermWiseReportCardPGToKGSummer.rdlc");
                    }
                    else
                    {
                        rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Result/rptTermWiseReportCardPGToKG.rdlc");
                    }
                }
                else
                {
                    dt = DataAccess.Instance.CommonServices.getDatasetResponseBySp("rptGetTermWiseResult", new object[] { 4, TermId, ClassId, SessionId, StuId.Trim(','), MainExamId }).results;
                    if (termname == "Summer")
                    {
                        rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Result/rptTermWiseReportCardKGto6PSummer.rdlc");
                    }
                    else
                    {
                        rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Result/rptTermWiseReportCardKGto6P.rdlc");
                    }
                }
            }
            else
            {
                dt = DataAccess.Instance.CommonServices.getDatasetResponseBySp("rptGetTermWiseResult", new object[] { 4, TermId, ClassId, SessionId, StuId.Trim(','), MainExamId }).results;
                if (termname == "Summer" || termname == "Summer(Secondary)")
                {
                    rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Result/rptTermWiseReportCardSummer.rdlc");
                }
                else
                {
                    rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Result/rptTermWiseReportCard.rdlc");
                }
            }


            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt.Tables[0]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("ClassTecherReport", dt.Tables[1]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("TermReport", dt.Tables[2]));

            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);

            rptViewer.LocalReport.Refresh();


            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

            return File(bytes, "application/pdf");
        }
        public FileResult ResultSheet(int ExamId)
        {
            int StudentId = Convert.ToInt32(User.Identity.GetUserStudentId());
            DataSet ds = DataAccess.Instance.StudentBasicInfo.GetStudentDetailByIID(StudentId.ToString());
            StudentId = 77;
            //DataTable dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("rptAttendance", new object[] { VersionId, SessionId, BranchId, ShiftId, ClassId, GroupId, SectionId, DBNull.Value, FromDate, ToDate, 8 });
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetPortalResultDetails", new object[] { StudentId, ExamId });
            ReportViewer rptViewer = new ReportViewer();

            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Result/rptResultSheet.rdlc");
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("StudentBasicInfo", ds.Tables[0]));
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("A4Landscape"));
            rptViewer.LocalReport.SetParameters(parameter);
            rptViewer.LocalReport.Refresh();

            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

            return File(bytes, "application/pdf");
        }

        public List<SchoolSetup> GetHeader()
        {
            List<SchoolSetup> schoolSetup = new List<SchoolSetup>();
            schoolSetup.Add(DataAccess.Instance.SchoolSetupService.GetAll().FirstOrDefault());
            return schoolSetup;
        }
     

        public FileResult CollectionReportCard()
        {
            var StudentIID = Convert.ToInt32(User.Identity.GetUserStudentId());
            StudentBasicInfo sb = DataAccess.Instance.StudentBasicInfo.Filter(s => s.StudentIID == StudentIID).FirstOrDefault();
            ReportViewer rptViewer = new ReportViewer();
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();


            var SessionId = sb.SessionId;
            var BranchID = sb.BranchID;
            var ShiftID = sb.ShiftID;
            var ClassId = sb.ClassId;
            var SectionId = sb.SectionId;
            int StudentId = StudentIID;
            var TypeId = 14; //1=All Student ,2=GN ,3=AT,4=with TC,5=Given TC,6=Testmonial,7=AdmissionSummary,8=TOTList


            string FromDate = null;
            string ToDate = null;

            var param = new object[] { SessionId, BranchID, ShiftID, ClassId, SectionId, TypeId, FromDate, ToDate, StudentId };
            var ReportName = "Student Collection Card";
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("AccdemicUseVairousType", param);
            //if (dt.Rows.Count > 0) {
            //    dt.Columns.Add(new DataColumn("ReportName", typeof(string)));

            //}
            //dt.Rows[0]["ReportName"] = ReportName[TypeId - 1].ToString();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            if (TypeId == 14)
            {
                rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/StudentBasic/rptStudentCollectionCard.rdlc");

            }

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            List<ReportParameter> parameters = new List<ReportParameter>();
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            parameters.Add(new ReportParameter("ReportName", ReportName.ToString()));

            rptViewer.LocalReport.SetParameters(parameters);

            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf");
            //return File(bytes, "application/vnd.ms-excel", "Report.xls");
            //return File(bytes, "application/vnd.ms-word", "Report.doc");
        }
        private string GetHeader(string ImgType, int? BranchId = 8)
        {
            ReportHeader Header = DataAccess.Instance.RepHeaderImgService.Filter(e => e.IsDeleted == false).ToList().FirstOrDefault();
            if (Header != null)
            {
                if (ImgType == "LegalLandscape")
                {
                    if (BranchId == 8 || BranchId == 0)
                        return Convert.ToBase64String(Header.LegalLandscape);
                    if (BranchId == 9)
                        return Convert.ToBase64String(Header.LegalPortrait);
                }
                else if (ImgType == "LegalPortrait")
                {
                    if (BranchId == 8 || BranchId == 0)
                        return Convert.ToBase64String(Header.LegalLandscape);
                    if (BranchId == 9)
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
        public FileResult SubjectWiseResult(int TermId, int SubjectId, int BranchID)
        {
            var StudentIID = Convert.ToInt32(User.Identity.GetUserStudentId());

            var stuDetail = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == StudentIID).FirstOrDefault();
            var MainExam = DataAccess.Instance.MainExamService.Filter(e => e.SessionId == stuDetail.SessionId && e.ClassId == stuDetail.ClassId && e.TermId == TermId && e.IsDeleted == false && e.BranchID == BranchID);
            if (!MainExam.Any())
            {
                throw new Exception("MainExam Not Setup");
            }
            var MainExamId = MainExam.FirstOrDefault().MainExamId;
            ReportViewer rptViewer = new ReportViewer();
            DataSet dt = new DataSet();
            dt = DataAccess.Instance.CommonServices.getDatasetResponseBySp("rptGetSubjectWiseResult", new object[] { MainExamId, SubjectId, StudentIID ,stuDetail.BranchID,stuDetail.SectionId}).results;


            DataTable gdt = new DataTable();
            //var xx = ;
            //gdt.Columns.AddRange((new List<DataColumn>() { new DataColumn("ID", typeof(Int32)), new DataColumn("VersionID", typeof(Int32))
            //    , new DataColumn("SessionID", typeof(Int32)), new DataColumn("ClassID", typeof(Int32)), new DataColumn("Marks_From", typeof(Decimal))
            //    , new DataColumn("Marks_To", typeof(Decimal)), new DataColumn("GL", typeof(String)), new DataColumn("GP", typeof(Decimal))
            //    , new DataColumn("IsFailGrade", typeof(Boolean))}).ToArray());
            //gdt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetGrades", new object[] {SessionId, ClassId });
            int termId = DataAccess.Instance.MainExamService.Filter(e => e.MainExamId == MainExamId).FirstOrDefault().TermId;
            var termname = DataAccess.Instance.TermService.Filter(e => e.TermId == termId).FirstOrDefault().Name;
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            int ClassId = DataAccess.Instance.TermService.Filter(e => e.TermId == termId).FirstOrDefault().ClassId;
            if ((termname == "Summer" && (ClassId == 30 && (SubjectId == 94 || SubjectId == 96 || SubjectId == 106))) || (termname == "Summer" && (ClassId == 31)))
            {
                rptViewer.LocalReport.ReportPath = Path.Combine("RDLC/Result/rptSubjectWiseResultSummer9_10.rdlc");
            }
            else
            {
                switch (termname)
                {
                    case "Autumn":
                        rptViewer.LocalReport.ReportPath = Path.Combine("RDLC/Result/rptSubjectWiseResult.rdlc");
                        break;
                    case "Winter":
                        rptViewer.LocalReport.ReportPath = Path.Combine("RDLC/Result/rptSubjectWiseResultWinter.rdlc");
                        break;
                    case "Winter(Secondary)":
                        rptViewer.LocalReport.ReportPath = Path.Combine("RDLC/Result/rptSubjectWiseResultWinter.rdlc");
                        break;
                    case "Summer":
                        rptViewer.LocalReport.ReportPath = Path.Combine("RDLC/Result/rptSubjectWiseResultSummer.rdlc");
                        break;
                    case "Summer(Secondary)":
                        rptViewer.LocalReport.ReportPath = Path.Combine("RDLC/Result/rptSubjectWiseResultSummer.rdlc");
                        break;
                    default:
                        rptViewer.LocalReport.ReportPath = Path.Combine("RDLC/Result/rptSubjectWiseResult.rdlc");
                        break;
                }
            }
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt.Tables[0]));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPAssesment", dt.Tables[1]));
            //rptViewer.LocalReport.DataSources.Add(new ReportDataSource("GradeResults", gdt));
            //rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SigResults", Signiture));


            // string imagePath = new Uri(Server.MapPath("~/RDLC/Header/LegalLandscape.png")).AbsoluteUri;
            ReportParameter parameter = new ReportParameter("HeaderImg", GetHeader("LegalLandscape"));
            rptViewer.LocalReport.SetParameters(parameter);
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




        public FileContentResult GetStudentCSHeader()
        {
            int SId = Convert.ToInt32(User.Identity.GetUserStudentId());
            StudentBasicInfo st = DataAccess.Instance.StudentBasicInfo.Filter(d => d.StudentIID == SId).FirstOrDefault();
            PortalDocument doc = DataAccess.Instance.PortalDocumentService.Filter(d => d.ClassId == st.ClassId && d.BranchId == st.BranchID && d.SessionId == st.SessionId && d.ShiftId == st.ShiftID && d.TypeId == 6 && d.DocType == 1).LastOrDefault();
            return File(doc.File, "application/pdf");
            //return File(doc.File, System.Net.Mime.MediaTypeNames.Application.Octet, doc.FileName);
        }
        public FileContentResult GetStudentRotinHeader()
        {
            int SId = Convert.ToInt32(User.Identity.GetUserStudentId());
            StudentBasicInfo st = DataAccess.Instance.StudentBasicInfo.Filter(d => d.StudentIID == SId).FirstOrDefault();
            PortalDocument doc = DataAccess.Instance.PortalDocumentService.Filter(d => d.ClassId == st.ClassId && d.BranchId == st.BranchID && d.SessionId == st.SessionId && d.ShiftId == st.ShiftID && d.TypeId == 7 && d.DocType == 1).LastOrDefault();
            return File(doc.File, "application/pdf");
            //return File(doc.File, System.Net.Mime.MediaTypeNames.Application.Octet, doc.FileName);
        }
        #region feesbook

        public FileResult FeesBook(int FeesSessionYear,int PayMode, string ChequeNo)

        {
            string pmode;
            var IID = Convert.ToInt32(User.Identity.GetUserStudentId());
            var SIID = Convert.ToInt64(User.Identity.GetUserStudentId());
            int BranchID = DataAccess.Instance.StudentBasicInfo.Filter(b => b.StudentIID == SIID).FirstOrDefault().BranchID;
            ReportViewer rptViewer = new ReportViewer();

            // string schoolName = ConfigurationManager.AppSettings["SchoolShortName"];

            DataTable dt = new DataTable();
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("FeesDuePayment", new object[] { IID, FeesSessionYear });

            var setting = DataAccess.Instance.FeesSettingService.GetAll();
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            switch (setting.FirstOrDefault().FeesBookPart)
            {
                case 2:
                    rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Fees/rptFeesBookNew2.rdlc");
                    break;
                case 3:
                    rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Fees/rptFeesBookNew2.rdlc");
                    break;
                case 4:
                    rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Fees/rptFeesBookNew2.rdlc");
                    break;
            }

            if (PayMode == 1)
            {
                pmode = "Cash";
            }
            else if (PayMode == 2)
            {
                 pmode = "Cheque";
            }
            else
            {
                 pmode = "Online Transfer";
            }

            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("FessSetting", setting));
            List<ReportParameter> parameters = new List<ReportParameter>();
            parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape", BranchID)));
            parameters.Add(new ReportParameter("ReportName", "Deposit Slip"));
            parameters.Add(new ReportParameter("PayMode", pmode));
            parameters.Add(new ReportParameter("ChequeNo", ChequeNo));
            rptViewer.LocalReport.SetParameters(parameters);
            rptViewer.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;
            byte[] bytes = rptViewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            return File(bytes, "application/pdf", "DepositSlip.PDF");
           // return File(bytes, "application/pdf");
        }


        public FileResult PaymentHistory(int Id)
        {
            var IID = Convert.ToInt32(User.Identity.GetUserStudentId());
            ReportViewer rptViewer = new ReportViewer();

            //  string schoolName = ConfigurationManager.AppSettings["SchoolShortName"];
            DataTable dt = new DataTable();
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("MoneyReceipt", new object[] { 1, Id });

            if (dt.Rows.Count > 0)
                dt.Columns.Add(new DataColumn("BarCode", typeof(byte[])));
            var setting = DataAccess.Instance.FeesSettingService.GetAll();
            foreach (DataRow dr in dt.Rows)
            {
                string Value = String.Empty;

                Value = dr["StudentInsID"].ToString();
                //dr["BarCode"] = GetBarCode(Value);
            }
            rptViewer.ProcessingMode = ProcessingMode.Local;
            rptViewer.Width = Unit.Percentage(100);
            rptViewer.LocalReport.ReportPath = Server.MapPath("~/RDLC/Fees/rptMoneyReceiptStudentPortal.rdlc");

            foreach (DataRow dr in dt.Rows)
            {
                string Value = String.Empty;

                Value = dr["StudentInsID"].ToString();
                //dr["BarCode"] = GetBarCode(Value);
            }
            rptViewer.LocalReport.EnableExternalImages = true;
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("SPResults", dt));
            rptViewer.LocalReport.DataSources.Add(new ReportDataSource("FessSetting", setting));
            List<ReportParameter> parameters = new List<ReportParameter>();
            //parameters.Add(new ReportParameter("HeaderImg", GetHeader("LegalLandscape")));
            //parameters.Add(new ReportParameter("ReportName", "Fees Book"));
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

        #endregion feesbook

    }
}