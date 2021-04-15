using Newtonsoft.Json;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Http;
using System.Drawing;
using System.IO;
using System.Drawing.Imaging;
using OEMS.Models.ViewModel;
using static OEMS.Models.Constant.Enums;
using System.Data;
using System.Transactions;
using System.Globalization;

using OEMS.Models.Model.Club;
using OEMS.Models.Model.Document;
using OEMS.Models.Model.Portal;
using OEMS.Repository.Repositories;

namespace OEMS.Api.Controllers
{
    public class SetupInstitutionController : ApiController
    {
      
        #region Branch
        [Route("SetupInstitution/AddBranch/")]
        [HttpPost]
        public IHttpActionResult AddBranch(Branch branch)
        {
            // Add Branch      
            CommonResponse cr = new CommonResponse();
            try
            {
                var Branch = DataAccess.Instance.Branch.Filter(e => e.IsDeleted == false);
                if (Branch.Where(e => e.BranchName == branch.BranchName && e.Code == branch.Code).Any())
                {
                    throw new Exception("Branch Aleardy Exit");
                }
                if (Branch.Where(e => e.BranchName == branch.BranchName).Any())
                {
                    throw new Exception("Branch Name Aleardy Exit");
                }
                if (Branch.Where(e => e.Code == branch.Code).Any())
                {
                    throw new Exception("Branch Code Aleardy Exit");
                }

                Branch oBranch = new Branch();
                oBranch.BranchName = branch.BranchName;
                oBranch.BranchNameBangla = branch.BranchNameBangla;
                oBranch.Code = branch.Code;
                oBranch.Address = branch.Address;
                oBranch.AddressBangla = branch.AddressBangla;
                oBranch.Branch_ContactNumber = branch.Branch_ContactNumber;
                oBranch.Email = branch.Email;
                oBranch.Fax = branch.Fax;
                oBranch.SS_Lang = branch.SS_Lang;
                oBranch.SS_Latu = branch.SS_Latu;
                oBranch.IsDeleted = false;
                oBranch.AddBy = User.Identity.Name;
                oBranch.SetDate();
                oBranch.Remarks = branch.Remarks;
                oBranch.Status = "A";
                var res = DataAccess.Instance.Branch.Add(oBranch);

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        private PortalDocumentVM PortalDocument()
        {
            string value = HttpContext.Current.Request.Form["documentAll"] ?? "";
            PortalDocumentVM document = JsonConvert.DeserializeObject<PortalDocumentVM>(value);
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["pdf"] : null;
            if (file != null)
            {
                document.FileName = file.FileName;
                document.File = APIUitility.ToByte(file);
            }
            return document;
        }
        [Route("SetupInstitution/DocumentUploadGeneralNotice/")]
        [HttpPost]
        public IHttpActionResult DocumentUploadGeneralNotice()
        {
            CommonResponse cr = new CommonResponse();
            string currFilePath = string.Empty;
            string currFileExtension = string.Empty;
            bool res = false;
            PortalDocumentVM document = PortalDocument();

            try
            {

                var list = DataAccess.Instance.PortalDocumentService.Filter(p => p.IsDeleted == false && p.Status == "A" && p.TypeId == 4).ToList();

                if (document.TypeId == 4)  ///General Notice 
                {
                    PortalDocument singleDoc;
                    if (document.DocType == 1)
                    {

                        List<int> ClassIdList = new List<int>(Array.ConvertAll(document.ClassId.Split(','), int.Parse));
                        List<int> ShiftIdList = new List<int>(Array.ConvertAll(document.ShiftId.Split(','), int.Parse));


                        if (ClassIdList.Count > 0 && ShiftIdList.Count > 0)
                        {


                            foreach (int ClassId in ClassIdList)
                            {
                                foreach (int ShiftId in ShiftIdList)
                                {
                                    //if (list.Any(e => e.DocType == 1  && e.Year == document.Year && e.Month == document.Month))
                                    //{
                                    //    throw new Exception("General Notice  Exist For Student!");
                                    //}
                                    singleDoc = new PortalDocument();
                                    singleDoc.AddBy = User.Identity.Name;
                                    singleDoc.AddDate = DateTime.Now;
                                    singleDoc.SetDate();
                                    singleDoc.IsDeleted = false;
                                    singleDoc.Status = "A";
                                    singleDoc.TypeId = document.TypeId;
                                    singleDoc.DocType = document.DocType;
                                    singleDoc.File = document.File;
                                    singleDoc.FileName = document.FileName;
                                    singleDoc.Remarks = document.Remarks;
                                    singleDoc.Title = document.Title;
                                    singleDoc.UpdateDate = DateTime.Now;
                                    singleDoc.Year = document.Year;
                                    singleDoc.Month = document.Month;

                                    singleDoc.BranchId = document.BranchId;
                                    singleDoc.ClassId = ClassId;
                                    singleDoc.ShiftId = ShiftId;
                                    singleDoc.SessionId = document.SessionId;
                                    res = DataAccess.Instance.PortalDocumentService.Add(singleDoc);
                                }
                            }
                        }

                    }
                    else
                    {
                        //if (list.Any(e => e.DocType == 2))
                        //{
                        //    throw new Exception("General Notice Exist For Employee!");
                        //}
                        singleDoc = new PortalDocument();
                        singleDoc.IsDeleted = false;
                        singleDoc.Status = "A";
                        singleDoc.AddBy = User.Identity.Name;
                        singleDoc.AddDate = DateTime.Now;
                        singleDoc.SetDate();
                        singleDoc.TypeId = document.TypeId;
                        singleDoc.DocType = document.DocType;
                        singleDoc.BranchId = document.BranchId;
                        singleDoc.SessionId = 0;
                        singleDoc.ClassId = 0;
                        singleDoc.ShiftId = 0;
                        singleDoc.Year = 0;
                        singleDoc.Month = "";
                        singleDoc.File = document.File;
                        singleDoc.FileName = document.FileName;
                        singleDoc.Title = document.Title;
                        res = DataAccess.Instance.PortalDocumentService.Add(singleDoc);

                    }

                }
                cr.results = res;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                return Json(cr);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message);
            }

        }
        [Route("SetupInstitution/GetBranchs/{pageno}/{pagesize}/{searchtxt}")]
        [HttpGet]
        public IHttpActionResult GetBranchs(int pageno, int pagesize, string searchtxt)
        {
            // Get Branch by pageno, pagesize, searchtxt
            CommonResponse res = new CommonResponse();
            if (!string.IsNullOrEmpty(searchtxt) && searchtxt != "null")
            {
                res = DataAccess.Instance.Branch.Filter(pageno, pagesize, e => e.BranchName.Contains(searchtxt) && e.IsDeleted == false, o => o.OrderByDescending(e => e.BranchId));
            }
            else
            {
                res = DataAccess.Instance.Branch.Filter(pageno, pagesize, e => e.IsDeleted == false, o => o.OrderByDescending(e => e.BranchId));
            }
            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("SetupInstitution/GetAllBranchs/")]
        [HttpGet]
        public IHttpActionResult GetAllBranchs()
        {
            // Get all Branch
            CommonResponse res = new CommonResponse();
            List<Branch> lstBranch = new List<Branch>();
            var result = DataAccess.Instance.Branch.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.BranchId)).ToList();

            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.INVAILD_DATA);
            }

        }

        [Route("SetupInstitution/UpdateBranch/")]
        [HttpPut]
        public IHttpActionResult UpdateBranch(Branch branch)
        {
            // Update branch
            CommonResponse cr = new CommonResponse();
            try
            {
                var Branch = DataAccess.Instance.Branch.Filter(e => e.IsDeleted == false && e.BranchId != branch.BranchId);
                if (Branch.Where(e => e.BranchName == branch.BranchName && e.Code == branch.Code).Any())
                {
                    throw new Exception("Branch  Aleardy Exit");
                }
                if (Branch.Where(e => e.BranchName == branch.BranchName).Any())
                {
                    throw new Exception("Branch Name " + branch.BranchName + " Aleardy Exit");
                }
                if (Branch.Where(e => e.Code == branch.Code).Any())
                {
                    throw new Exception("Branch Code " + branch.Code + " Aleardy Exit");
                }

                branch.UpdateBy = User.Identity.Name;
                branch.SetDate();
                branch.SetDate();

                var res = DataAccess.Instance.Branch.Update(branch);

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("SetupInstitution/DeleteBranch/")]
        [HttpPost]
        public IHttpActionResult DeleteBranch(Branch branch)
        {
            // Delete Branch ID
            CommonResponse cr = new CommonResponse();
            try
            {
                //if (DataAccess.Instance.Shift.Filter(e => e.BranchId == branch.BranchId && e.IsDeleted == false).Any())
                //    throw new Exception("Branch Used in Shift");
                //if (DataAccess.Instance.CommonServices.IsExist("Student_BasicInfo", "BranchID", branch.BranchId))
                //    throw new Exception("Student Exist this Branch");
                bool res = DataAccess.Instance.Branch.Remove(branch.BranchId);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
                if (cr.httpStatusCode == HttpStatusCode.OK)
                    return Json(res);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("SetupInstitution/GetUserBranchDetailByUserId/")]
        [HttpGet]
        public IHttpActionResult GetUserBranchDetailByUserId()
        {
            // Get all Branch
            CommonResponse res = new CommonResponse();
            var empid = User.Identity.Name;
            DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetUserBranchDetailByUserId", new object[] { empid });
            List<Branch> lstBranch = APIUitility.ConvertDataTable<Branch>(dt);
            var result = lstBranch.FirstOrDefault();
            if (result != null)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.INVAILD_DATA);
            }

        }
        #endregion Branch
      


    }
}
