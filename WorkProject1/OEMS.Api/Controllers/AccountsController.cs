using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.Account;
using OEMS.Models.ViewModel;
using OEMS.Models.ViewModel.Account;
using OEMS.Repository.Helpers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Transactions;
using System.Web;
using System.Web.Http;

namespace OEMS.Api.Controllers
{
    public class AccountsController : ApiController
    {
        public AccountsController()
        {
            //GetAllRootGroup();
        }

        #region Ledgers
        [Route("Accounts/GetAllLedgers/")]
        [HttpGet]
        public IHttpActionResult GetAllLedgers()
        {
            // Get All Tags
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.IsLedger == true).OrderByDescending(t => t.LedgerId).ToList();
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

        [Route("Accounts/GetAllLedgersForInvoice/")]
        [HttpGet]
        public IHttpActionResult GetAllLedgersForInvoice()
        {
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllLedgersForInvoice", new object[] { 1 });
            
            if (result != null)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }
        [Route("Accounts/GetAllLedgersForUpdateCollection/")]
        [HttpGet]
        public IHttpActionResult GetAllLedgersForUpdateCollection()
        {
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllLedgersForInvoice", new object[] { 2 });

            if (result != null)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Accounts/GetAllGroups/")]
        [HttpGet]
        public IHttpActionResult GetAllGroups()
        {
            //All Group
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySp("GetGroupWithParent");
            if (result != null)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Accounts/GetAllRootLedger/")]
        [HttpGet]
        public IHttpActionResult GetAllRootLedger()
        {
            // Get All Root Group
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.LedgersService.Filter(r => r.IsDeleted == false && r.ParentId == 0 && r.IsGroup == true).ToList();
            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Accounts/GetLedgersByRootGroup/{Id}")]
        [HttpGet]
        public IHttpActionResult GetLedgersByRootGroup(int Id)
        {
            // Get All Tags
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.ParentId == Id && e.IsLedger == true).ToList();
            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }




        [Route("Accounts/GetLedgersByLedgerId/{Id}")]
        [HttpGet]
        public IHttpActionResult GetLedgersByLedgerId(int Id)
        {
            // Get All Tags
            CommonResponse res = new CommonResponse();
            //var result = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.IsLedger == true).ToList();
            var result = DataAccess.Instance.LedgersService.Filter(e => e.ParentId == Id && e.IsDeleted == false && e.IsGroup == true).ToList();
            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }
        [Route("Accounts/GetLedgersByLedgerIdEdit/{Id}")]
        [HttpGet]
        public IHttpActionResult GetLedgersByLedgerIdEdit(int Id)
        {
            // Get All Tags
            CommonResponse res = new CommonResponse();
            //var result = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.IsLedger == true).ToList();
            var result = DataAccess.Instance.LedgersService.Filter(e => e.LedgerId == Id && e.IsDeleted == false).ToList();
            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }


        [Route("Accounts/AddLedgers/")]
        [HttpPost]
        public IHttpActionResult AddLedgers(Ledgers Ledgers)
        {
            // Add Ledgers 
            CommonResponse cr = new CommonResponse();
            Ledgers oLedgers = new Ledgers();
            try
            {

                var Ledgersinfos = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.IsGroup == true);
                var Ledgersinfo = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.IsGroup == false);
                if (Ledgersinfo.Where(e => e.Name == Ledgers.Name).Any())
                {
                    return BadRequest("Name  Aleardy Exists");
                }
                if(Ledgersinfos.Where(e => e.Name == Ledgers.Name).Any())
                {
                    return BadRequest("Name Aleardy Exists in Groups");
                }

                oLedgers.RootGroupId = Ledgers.RootGroupId;
                oLedgers.Name = Ledgers.Name;
                oLedgers.Code = GenCode(Ledgers);
                oLedgers.RootGroupId = Ledgers.RootGroupId;
                oLedgers.OpenningBalance = Ledgers.OpenningBalance;
                if (Ledgers.RootGroupId == 1 || Ledgers.RootGroupId == 4)
                {
                    oLedgers.CurrentBalanceDc = 1;
                    oLedgers.OpenningBalanceDc = 1;
                }
                else
                {
                    oLedgers.CurrentBalanceDc = 2;
                    oLedgers.OpenningBalanceDc = 2;
                }

                oLedgers.Remarks = Ledgers.Remarks;
                oLedgers.CurrentBalance = Ledgers.OpenningBalance;
                oLedgers.ParentId = Ledgers.ParentId;
                oLedgers.IsGroup = Ledgers.IsGroup;
                oLedgers.IsLedger = Ledgers.IsLedger;
                oLedgers.CashFlowType = Ledgers.CashFlowType;

                oLedgers.IsDeleted = false;
                oLedgers.IsDisplay = true;
                oLedgers.Status = "A";
                oLedgers.AddBy = User.Identity.Name;
                oLedgers.SetDate();
                var res = DataAccess.Instance.LedgersService.Add(oLedgers);
                if (res)
                {
                    string Sql = $"UPDATE ACC_Ledgers SET Code = ISNULL(dbo.GetAccCodeById({oLedgers.LedgerId}, {oLedgers.RootGroupId}), Name) WHERE LedgerId= {oLedgers.LedgerId}";

                   // DataAccess.Instance.CommonServices.ExecuteSQLQUERY(Sql);
                }

                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Accounts/GetLedgers/{pageno}/{pagesize}/{searchtxt}")]
        [HttpGet]
        public IHttpActionResult GetLedgers(int pageno, int pagesize, string searchtxt)
        {
            // Get Shifts by pageno, pagesize, searchtxt
            CommonResponse res = new CommonResponse();
            if (!string.IsNullOrEmpty(searchtxt) && searchtxt != "null")
            {
                res = DataAccess.Instance.LedgersService.Filter(pageno, pagesize, e => e.Name.Contains(searchtxt), o => o.OrderByDescending(e => e.LedgerId));
            }
            else
            {
                res = DataAccess.Instance.LedgersService.getPageResponse(pageno, pagesize);
            }
            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("Accounts/UpdateLedgers/")]
        [HttpPut]
        public IHttpActionResult UpdateLedgers(Ledgers Ledgers)
        {
            // Update Shift
            CommonResponse cr = new CommonResponse();
            try
            {
                var CheckTrans = DataAccess.Instance.TransactionDetailService.Filter(t => t.LedgerId == Ledgers.LedgerId);
                if (CheckTrans.Any())
                {
                    throw new Exception("Ledgers Aleardy Exists In Transection");
                }
                var Ledgersinfos = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.LedgerId != Ledgers.LedgerId && e.IsGroup == true);
                if (Ledgersinfos.Where(e => e.Name == Ledgers.Name).Any())
                {
                    return BadRequest("Group Aleardy Exists");
                }
                var Ledgersinfo = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.LedgerId != Ledgers.LedgerId);
                if (Ledgersinfo.Where(e => e.Name == Ledgers.Name).Any())
                {
                    throw new Exception("Ledgers Aleardy Exists");
                }
                var vers = DataAccess.Instance.LedgersService.Filter(e => e.LedgerId == Ledgers.LedgerId).FirstOrDefault();
                if (vers.IsEdit)
                {
                    vers.RootGroupId = Ledgers.RootGroupId;
                    vers.Name = Ledgers.Name;
                    vers.Code = Ledgers.Code;
                    vers.RootGroupId = Ledgers.RootGroupId;
                    vers.Remarks = Ledgers.Remarks;
                    vers.ParentId = Ledgers.ParentId;

                    vers.IsDeleted = Ledgers.IsDeleted;
                    vers.Status = Ledgers.Status;
                    vers.CashFlowType = Ledgers.CashFlowType;

                    vers.UpdateBy = User.Identity.Name;
                    vers.SetDate();
                    var res = DataAccess.Instance.LedgersService.Update(vers);
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.UPDATED : Constant.FAILED;
                }
                else
                {
                    return BadRequest("This is not editable ledger");
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        

        [Route("Accounts/UpdateGroupLedgers/{GroupName}/{Id}/")]
        [HttpPut]
        public IHttpActionResult UpdateGroupLedgers(string GroupName, int Id)
        {
            // Update Shift Group
            CommonResponse cr = new CommonResponse();
            try
            {

                var Ledgersinfo = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.LedgerId != Id && e.IsGroup == true);
                if (Ledgersinfo.Where(e => e.Name == GroupName).Any())
                {
                    return BadRequest("Ledgers Aleardy Exists");
                }
                var vers = DataAccess.Instance.LedgersService.Filter(e => e.LedgerId == Id).FirstOrDefault();
                vers.Name = GroupName;
                //if (vers.IsEdit)
                //{
                //vers.RootGroupId = Ledgers.RootGroupId;
                //vers.Name = Ledgers.Name;
                ////vers.Code = Ledgers.Code;

                ////vers.Remarks = Ledgers.Remarks;
                //vers.ParentId = Ledgers.ParentId;

                //vers.IsDeleted = Ledgers.IsDeleted;
                //vers.Status = Ledgers.Status;

                vers.UpdateBy = User.Identity.Name;
                vers.SetDate();
                var res = DataAccess.Instance.LedgersService.Update(vers);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
                //}
                //else
                //{
                //    return BadRequest("This is not editable ledger");
                //}





            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }


        [Route("Accounts/SearchGroup/{srhtext}/{ParentId}")]
        [HttpGet]
        public IHttpActionResult SearchGroup(string srhtext, int ParentId) //This method will Search Student by Student ID , name and sms notification no.
        {
            CommonResponse cr = new CommonResponse();

            var results = DataAccess.Instance.LedgersService.Filter(e => e.IsGroup == true && e.RootGroupId == ParentId && e.Name.Contains(srhtext)).ToList();

            cr.results = results.Select(e => new { Text = e.Name, Value = e.LedgerId }).ToList();
            return Json(cr);
        }

        [Route("Accounts/DeleteGroupLedgers/")]
        [HttpPut]
        public IHttpActionResult DeleteGroupLedgers(Ledgers Ledgers)
        {
            // Update Shift
            CommonResponse cr = new CommonResponse();
            try
            {
                if (Ledgers != null)
                {
                    var CheckTrans = DataAccess.Instance.TransactionDetailService.Filter(t => t.LedgerId == Ledgers.LedgerId);
                    if (CheckTrans.Any())
                    {
                        throw new Exception("Ledgers Aleardy Exists In Transection");
                    }
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.ACC_Ledgers", "ParentId=" + Ledgers.LedgerId + " AND IsDeleted=" + 0);
                    if (Exist)
                    {
                        return BadRequest("DATA EXISTS");
                    }
                    else
                    {
                        var res = DataAccess.Instance.LedgersService.Remove(Ledgers.LedgerId);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("Accounts/ActiveInactiveLedger/")]
        [HttpPut]
        public IHttpActionResult ActiveInactiveLedger(Ledgers Ledgers)
        {
            // Update Ledger
            CommonResponse cr = new CommonResponse();
            try
            {
                var vers = DataAccess.Instance.LedgersService.Filter(e => e.LedgerId == Ledgers.LedgerId).FirstOrDefault();
                vers.Status = Ledgers.Status;

                vers.UpdateBy = User.Identity.Name;
                vers.SetDate();
                var res = DataAccess.Instance.LedgersService.Update(vers);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Accounts/UpdateDisplay/")]
        [HttpPut]
        public IHttpActionResult UpdateDisplay(Ledgers Ledgers)
        {
            // Update Display
            CommonResponse cr = new CommonResponse();
            try
            {
                var CheckTrans = DataAccess.Instance.TransactionDetailService.Filter(t => t.LedgerId == Ledgers.LedgerId);
                if (CheckTrans.Any())
                {
                    throw new Exception("Ledgers Aleardy Exists In Transection");
                }
                bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.ACC_Ledgers", "ParentId=" + Ledgers.LedgerId + " AND IsDeleted=" + 0);
                if (Exist)
                {
                    return BadRequest("This Group has childs");
                }
                var Ledgersinfo = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.LedgerId != Ledgers.LedgerId);
                if (Ledgersinfo.Where(e => e.Name == Ledgers.Name).Any())
                {
                    throw new Exception("Ledgers Aleardy Exists");
                }
                var vers = DataAccess.Instance.LedgersService.Filter(e => e.LedgerId == Ledgers.LedgerId).FirstOrDefault();
                vers.IsDisplay = Ledgers.IsDisplay;
                if (Ledgers.IsDisplay == false)
                    vers.DisplayOrder = 0;
                vers.UpdateBy = User.Identity.Name;
                vers.SetDate();
                var res = DataAccess.Instance.LedgersService.Update(vers);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Accounts/UpdateDisplayOrder/")]
        [HttpPut]
        public IHttpActionResult UpdateDisplayOrder(Ledgers Ledgers)
        {
            // Update Display Order
            CommonResponse cr = new CommonResponse();
            try
            {
                var Ledgersinfo = DataAccess.Instance.LedgersService.Filter(e => e.IsDeleted == false && e.LedgerId != Ledgers.LedgerId);
                if (Ledgersinfo.Where(e => e.Name == Ledgers.Name).Any())
                {
                    throw new Exception("Ledgers Aleardy Exists");
                }
                if (Ledgersinfo.Where(le => le.DisplayOrder == Ledgers.DisplayOrder && le.DisplayOrder > 0).Any())
                {
                    throw new Exception("Order Aleardy Exists");
                }
                var vers = DataAccess.Instance.LedgersService.Filter(e => e.LedgerId == Ledgers.LedgerId).FirstOrDefault();

                vers.DisplayOrder = Ledgers.DisplayOrder;
                vers.UpdateBy = User.Identity.Name;
                vers.SetDate();
                var res = DataAccess.Instance.LedgersService.Update(vers);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Accounts/DeleteLedgers/")]
        [HttpPost]
        public IHttpActionResult DeleteLedgers(Ledgers Ledgers)
        {
            // Delete Ledgers by LedgersID
            CommonResponse cr = new CommonResponse();
            var res = false;
            try
            {
                res = DataAccess.Instance.LedgersService.Remove(Ledgers.LedgerId);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Accounts/SearchLedger/{srhtext}/{type}/{accType}/{paymode}")]
        [HttpGet]
        public IHttpActionResult SearchLedger(string srhtext, int type, string accType, int paymode) //This method will Search Ledger by Name.
        {
            CommonResponse cr = new CommonResponse();
            //var results = DataAccess.Instance.LedgersService.SearchLedger(srhtext).Where(l => !LedgerIds.Contains(l.Id)).ToList();
            //if (results.Count > 0)
            //    cr.results = results;
            cr.results = DataAccess.Instance.LedgersService.SearchLedger(srhtext, type, accType, paymode).ToList();

            return Json(cr);
        }
        #endregion Ledgers        

        #region FiscalYear CRUD
        [Route("Accounts/GetAllFiscalYear/")]
        [HttpGet]
        public IHttpActionResult GetAllFiscalYear()
        {
            // Get All Fiscal Year
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false).ToList();
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
        [Route("Accounts/GetActiveFiscalYear/")]
        [HttpGet]
        public IHttpActionResult GetActiveFiscalYear()
        {
            // Get All Fiscal Year
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").ToList();
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
        [Route("Accounts/AddFiscal/")]
        [HttpPost]
        public IHttpActionResult AddFiscalYear(FiscalYear FiscalYear)
        {
            // Add Fiscal Year 
            CommonResponse cr = new CommonResponse();
            try
            {

                var FiscalYearinfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false);

                if (FiscalYearinfo.Where(f => f.Status == "A").Any())
                {
                    throw new Exception("Already active a FiscalYear, Please inactive then add new one");
                }

                if (FiscalYearinfo.Where(f => f.Name == FiscalYear.Name).Any())
                {
                    throw new Exception("Fiscal Year Name Aleardy Exist");
                }
                if (FiscalYearinfo.Where(f =>(f.StartDate<= Convert.ToDateTime(FiscalYear.StartDate) && f.EndDate >= Convert.ToDateTime(FiscalYear.StartDate)) || (f.StartDate <= Convert.ToDateTime(FiscalYear.EndDate) && f.EndDate >= Convert.ToDateTime(FiscalYear.EndDate))).Any())
                {
                    throw new Exception("Year Range Already Taken");
                }

                FiscalYear.StartDate = Convert.ToDateTime(FiscalYear.StartDate);
                FiscalYear.EndDate = Convert.ToDateTime(FiscalYear.EndDate);
                FiscalYear.IsDeleted = false;
                FiscalYear.Status = "A";
                FiscalYear.AddBy = User.Identity.Name;
                FiscalYear.SetDate();
                var res = DataAccess.Instance.FiscalYearService.Add(FiscalYear);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Accounts/UpdateFiscalYear/")]
        [HttpPut]
        public IHttpActionResult UpdateFiscalYear(FiscalYear fiscalYear)
        {
            // Update Fiscal Year
            CommonResponse cr = new CommonResponse();
            try
            {
                var chaekTrans = DataAccess.Instance.TransactionService.Filter(t => t.FiscalYearId == fiscalYear.Id);
                if (chaekTrans.Any())
                {
                    throw new Exception("FiscalYear Already Used In Transection !!");
                }
                var FiscalYearinfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Id != fiscalYear.Id);
                if (FiscalYearinfo.Where(f => f.Name == fiscalYear.Name).Any())
                {
                    throw new Exception("Fiscal Year Aleardy Exist");
                }
                if (FiscalYearinfo.Where(f => (f.StartDate <= Convert.ToDateTime(fiscalYear.StartDate) && f.EndDate >= Convert.ToDateTime(fiscalYear.StartDate)) || (f.StartDate <= Convert.ToDateTime(fiscalYear.EndDate) && f.EndDate >= Convert.ToDateTime(fiscalYear.EndDate))).Any())
                {
                    throw new Exception("Year Range Already Taken");
                }

                var vers = DataAccess.Instance.FiscalYearService.Filter(f => f.Id == fiscalYear.Id).FirstOrDefault();
                vers.Name = fiscalYear.Name;
                vers.Status = fiscalYear.Status;
                vers.StartDate = Convert.ToDateTime(fiscalYear.StartDate);
                vers.EndDate = Convert.ToDateTime(fiscalYear.EndDate);
                vers.UpdateBy = User.Identity.Name;
                vers.IsDeleted = fiscalYear.IsDeleted;
                vers.SetDate();
                var res = DataAccess.Instance.FiscalYearService.Update(vers);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Accounts/ActiveInactiveFY/")]
        [HttpPut]
        public IHttpActionResult ActiveInactiveFY(FiscalYear fiscalYear)
        {
            // Update Fiscal Year
            CommonResponse cr = new CommonResponse();
            try
            {

                var FiscalYearinfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false);

                if (FiscalYearinfo.Where(f => f.Status == "A" && fiscalYear.Status == "A").Any())
                {
                    throw new Exception("Already active a FiscalYear, Please inactive active one then active the other one");
                }

                var yearInfo = DataAccess.Instance.FiscalYearService.Filter(f => f.Id == fiscalYear.Id).FirstOrDefault();
                yearInfo.Status = fiscalYear.Status;
                yearInfo.UpdateBy = User.Identity.Name;
                yearInfo.SetDate();
                var res = DataAccess.Instance.FiscalYearService.Update(yearInfo);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Accounts/CheckFiscalYear/")]
        [HttpPost]
        public IHttpActionResult CheckFiscalYear(FiscalYear fiscalYear)
        {
            // Update Fiscal Year
            CommonResponse cr = new CommonResponse();
            bool res = true;
            try
            {
                var FiscalYearinfo = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false);
                if (FiscalYearinfo.Where(f => f.Name == fiscalYear.Name).Any())
                {
                    throw new Exception("Fiscal Year Aleardy Exist");
                }
                cr.results = true;
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Accounts/DeleteFiscal/")]
        [HttpPost]
        public IHttpActionResult DeleteFiscal(FiscalYear FisYear)
        {
            // Delete Fiscal Year
            CommonResponse cr = new CommonResponse();
            var chaekTrans = DataAccess.Instance.TransactionService.Filter(t => t.FiscalYearId == FisYear.Id);
            if (chaekTrans.Any())
            {
                throw new Exception("FiscalYear Already Used In Transection !!");
            }
            var TrasactionLst = DataAccess.Instance.TransactionService.Filter(t => t.IsDeleted ==false);
            if (TrasactionLst.Where(t => t.FiscalYearId == FisYear.Id).Any())
            {
                throw new Exception("Fiscal Year Setup Exists!");
            }
            var res = false;
            try
            {
                res = DataAccess.Instance.FiscalYearService.Remove(FisYear.Id);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion FiscalYear

        #region Account Branch
        [Route("Accounts/GetAllAccountBranch/")]
        [HttpGet]
        public IHttpActionResult GetAllAccountBranch()
        {

            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.AccountBranchService.Filter(a => a.IsDeleted == false).ToList();
            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }
        [Route("Accounts/GetAllAssignedAccountBranch/")]
        [HttpGet]
        public IHttpActionResult GetAllAssignedAccountBranch()
        {

            CommonResponse res = new CommonResponse();
            try
            {
                var userid = User.Identity.GetUserId();
                if (userid != null)
                {
                    var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAssignedACCBranch", new object[] { userid });
                    if (result.Rows.Count > 0)
                    {
                        res.results = result;
                        res.httpStatusCode = HttpStatusCode.OK;
                        return Json(res);
                    }
                    else
                    {
                        return BadRequest(Constant.NOT_FOUND);
                    }
                }
                else
                {
                    return NotFound();
                }

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

        }
        [Route("Accounts/AddAcBranch/")]
        [HttpPost]
        public IHttpActionResult AddAcBranch(AccountBranchs AccountBranchs)
        {
            // Add Account Branch 
            CommonResponse cr = new CommonResponse();
            try
            {
                var AcBranchinfo = DataAccess.Instance.AccountBranchService.Filter(a => a.IsDeleted == false);

                if (AcBranchinfo.Where(a => a.Name == AccountBranchs.Name).Any())
                {
                    throw new Exception("Branch Aleardy Exist");
                }

                AccountBranchs.IsDeleted = false;
                AccountBranchs.Status = "A";
                AccountBranchs.AddBy = User.Identity.Name;
                AccountBranchs.SetDate();
                var res = DataAccess.Instance.AccountBranchService.Add(AccountBranchs);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("Accounts/UpdateAcBranch/")]
        [HttpPut]
        public IHttpActionResult UpdateAcBranch(AccountBranchs accountBranchs)
        {
            // Update Account Branch
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllUserInfoWithAsignBranch", new object[] { accountBranchs.BranchId });
                if (dt.Rows.Count > 0 && accountBranchs.Status == "I")
                {
                    throw new Exception("Branch Aleardy Assign");
                }
                var CheckTrans = DataAccess.Instance.TransactionService.Filter(t => t.AccBranchId == accountBranchs.BranchId);
                if (CheckTrans.Any())
                {
                    throw new Exception("Branch Aleardy Used In Transection");
                }
                var AcBranchinfo = DataAccess.Instance.AccountBranchService.Filter(a => a.IsDeleted == false && a.BranchId != accountBranchs.BranchId);

                if (AcBranchinfo.Where(a => a.Name == accountBranchs.Name).Any())
                {
                    throw new Exception("Branch Aleardy Exist");
                }

                var acbr = DataAccess.Instance.AccountBranchService.Filter(a => a.BranchId == accountBranchs.BranchId).FirstOrDefault();
                acbr.Name = accountBranchs.Name;
                acbr.Code = accountBranchs.Code;
                acbr.Status = accountBranchs.Status;
                acbr.UpdateBy = User.Identity.Name;
                acbr.IsDeleted = accountBranchs.IsDeleted;
                acbr.SetDate();
                var res = DataAccess.Instance.AccountBranchService.Update(acbr);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion

        #region RootGroup
        //public void GetAllRootGroup()
        //{
        //    List<RootGroup> rootGroups = new List<RootGroup>();
        //    RootGroup rootGroup = new RootGroup();
        //    CommonResponse res = new CommonResponse();
        //    var data = DataAccess.Instance.RootGroupService.GetAll().ToList();
        //    if (data.Count == 0)
        //    {
        //        rootGroup = new RootGroup(){ Name="Assest" };
        //        rootGroups.Add(rootGroup);
        //        rootGroup = new RootGroup() { Name = "Liabilities" };
        //        rootGroups.Add(rootGroup);
        //        rootGroup = new RootGroup() { Name = "Income" };
        //        rootGroups.Add(rootGroup);
        //        rootGroup = new RootGroup() { Name = "Expense" };
        //        rootGroups.Add(rootGroup);
        //        DataAccess.Instance.RootGroupService.AddRange(rootGroups);
        //    }
        //}
        [Route("Accounts/GetAllRtGroup/")]
        [HttpGet]
        public IHttpActionResult GetAllRtGroup()
        {
            // Get All Root Group
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.RootGroupService.Filter(r => r.IsDeleted == false).ToList();
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
        #endregion RootGroup

        #region COA

        [Route("Accounts/GetLedgerTree/")]
        [HttpGet]
        public IHttpActionResult GetLedgerTree()
        {

            var dt = DataAccess.Instance.CommonServices.GetBySp("GetCOATree");


            List<TreeVM> menu = new List<TreeVM>();
            foreach (DataRow node in dt.Rows) // Point 2 Looping and Order by DisplayOrder
            {
                TreeVM obj = new TreeVM();
                State state = new State();
                obj.state = state;
                obj.id = node["LedgerId"].ToString();
                obj.parent = Convert.ToInt32(node["ParentId"].ToString()) == 0 ? "#" : node["ParentId"].ToString();
                obj.text = node["Name"].ToString();
                obj.icon = Convert.ToBoolean(node["IsLedger"]) == true ? "fa fa-file-alt icon-lg" : "fa fa-folder icon-state-warning icon-lg";
                obj.state.selected = false; //Convert.ToBoolean( node["IsDisplay"]);
                obj.state.disabled = Convert.ToInt32(node["ParentId"].ToString()) == 0 ? true : false;
                obj.state.opened = false;
                menu.Add(obj);
            }

            return Json(menu);
        }

        [Route("Accounts/AddCOA/")]
        [HttpPost]
        public IHttpActionResult AddCOA()
        {
            CommonResponse res = new CommonResponse();
            bool save = false;
            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    string value = HttpContext.Current.Request.Form["FisYear"] ?? "";
                    if (string.IsNullOrEmpty(value))
                        throw new Exception("Incorrect Format.");
                    FiscalYear fiscalYear = JsonConvert.DeserializeObject<FiscalYear>(value);
                    fiscalYear.StartDate = Convert.ToDateTime(fiscalYear.StartDate);
                    fiscalYear.EndDate = Convert.ToDateTime(fiscalYear.EndDate);
                    string value1 = HttpContext.Current.Request.Form["AcLedgers"] ?? "";
                    if (string.IsNullOrEmpty(value1))
                        throw new Exception("Incorrect Format.");
                    List<Ledgers> ledgers = JsonConvert.DeserializeObject<List<Ledgers>>(value1);
                    if (DataAccess.Instance.FiscalYearService.Filter(e => e.Name == fiscalYear.Name && e.IsDeleted == false).Any())
                    {
                        throw new Exception("Fiscal Year Name Already Exist");
                    }
                    fiscalYear.Status = "A";
                    fiscalYear.AddBy = User.Identity.Name;
                    fiscalYear.SetDate();
                    save = DataAccess.Instance.FiscalYearService.Add(fiscalYear);
                    if (save == false)
                    {
                        throw new Exception("Fiscal Year Add Fail");
                    }
                    var ledgerall = DataAccess.Instance.LedgersService.GetAll();
                    foreach (var item in ledgers.OrderBy(e => e.DisplayOrder).ToList())
                    {
                        if (ledgerall.Where(e => e.Name == item.Name).Any())
                        {
                            throw new Exception("Ledger Name " + item.Name + " Already Exist");
                        }

                        if (item.IsEdit == true)
                        {
                            item.IsLedger = true;
                            //item.OpenningBalance = 100;
                        }
                        else { item.IsGroup = true; }
                        item.Code = GenCode(item);
                        if (item.RootGroupId == 1 || item.RootGroupId == 4 || item.Type.ToString().Contains("1,4"))
                        {
                            item.CurrentBalanceDc = 1;
                            item.OpenningBalanceDc = 1;
                        }
                        else
                        {
                            item.CurrentBalanceDc = 2;
                            item.OpenningBalanceDc = 2;
                        }
                        item.CurrentBalance = item.OpenningBalance;
                        item.Status = "A";
                        item.AddBy = User.Identity.Name;
                        item.SetDate();
                        save = DataAccess.Instance.LedgersService.Add(item);
                        if (save == false)
                        {
                            throw new Exception("Ledger Add Fail");
                        }
                    }
                    ledgerall = DataAccess.Instance.LedgersService.GetAll().ToList();
                    foreach (var item in ledgers.OrderByDescending(e => e.DisplayOrder).ToList())
                    {
                        var ledgerss = ledgerall.Where(e => e.ParentId == item.LedgerId);
                        var update = DataAccess.Instance.LedgersService.Filter(e => e.Name == item.Name).FirstOrDefault();
                        update.OpenningBalance = item.OpenningBalance != 0 ? item.OpenningBalance : ledgerall.Where(e => e.ParentId == item.LedgerId).Sum(e => e.OpenningBalance);
                        update.CurrentBalance = update.OpenningBalance;
                        update.DisplayOrder = 0;
                        save = DataAccess.Instance.LedgersService.Update(update);
                    }
                    res.message = save ? Constant.SAVED : Constant.SAVED_ERROR;
                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                res.message = ex.Message.ToString();
            }
            return Json(res);
        }

        [Route("Accounts/GetLedgerList/")]
        [HttpGet]
        public IHttpActionResult GetLedgerList()
        {
            // Point 1 Get All permisson by RoleId
            var data = DataAccess.Instance.CommonServices.GetDatatableBySQL("select * from dbo.ACC_Ledgers where IsDeleted=0");
            List<LedgersVM> LedgersVMs = new List<LedgersVM>();
            List<LedgersVM> LedgerList = new List<LedgersVM>();

            LedgerList = APIUitility.ConvertDataTable<LedgersVM>(data).ToList();

            foreach (var node in LedgerList.Where(e => e.IsGroup == true && e.ParentId == 0)) // Point 2 Looping and Order by DisplayOrder
            {

                foreach (var node1 in LedgerList.Where(e => e.ParentId == node.LedgerId && e.IsDisplay == true)) // Point 2 Looping and Order by DisplayOrder
                {

                    foreach (var node2 in LedgerList.Where(e => e.ParentId == node1.LedgerId && e.IsDisplay == true)) // Point 2 Looping and Order by DisplayOrder
                    {
                        node1.LedgersVMs.Add(node2);
                    }
                    node1.CurrentBalance = node1.LedgersVMs.Sum(e => e.CurrentBalance);
                    node.LedgersVMs.Add(node1);
                }
                node.CurrentBalance = node.LedgersVMs.Sum(e => e.CurrentBalance);
                LedgersVMs.Add(node);
            }
            return Json(LedgersVMs);
        }
        public LedgersVM ledgerConvert(Ledgers LedgerGroups)
        {
            LedgersVM lgvm = new LedgersVM();
            lgvm.Code = LedgerGroups.Code;
            lgvm.CurrentBalance = LedgerGroups.CurrentBalance;
            lgvm.CurrentBalanceDc = LedgerGroups.CurrentBalanceDc;
            lgvm.DisplayOrder = LedgerGroups.DisplayOrder;
            lgvm.IsDisplay = LedgerGroups.IsDisplay;
            lgvm.IsEdit = LedgerGroups.IsEdit;
            lgvm.IsGroup = LedgerGroups.IsGroup;
            lgvm.IsLedger = LedgerGroups.IsLedger;
            lgvm.LedgerId = LedgerGroups.LedgerId;
            lgvm.Name = LedgerGroups.Name;
            lgvm.OpenningBalance = LedgerGroups.OpenningBalance;
            lgvm.OpenningBalanceDc = LedgerGroups.OpenningBalanceDc;
            lgvm.ParentId = LedgerGroups.ParentId;
            lgvm.RootGroupId = LedgerGroups.RootGroupId;
            lgvm.Type = LedgerGroups.Code;
            return lgvm;
        }
        #endregion COA

        #region CodeSetup
        [Route("Accounts/GetAllRootGroup/")]
        [HttpGet]
        public IHttpActionResult GetAllRootGroup()
        {
            // Get All Root Group

            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.RootGroupService.getResponseBySp("GetRootGroupCodeSetup");
            if (result != null)
            {
                res.results = result.results;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }
        [Route("Accounts/UpdateRootGroup/")]
        [HttpPut]
        public IHttpActionResult UpdateRootGroup(RootGroup rootGroup)
        {
            // Update Root Grup Year
            CommonResponse cr = new CommonResponse();
            try
            {
                var vers = DataAccess.Instance.RootGroupService.Filter(f => f.Id == rootGroup.Id).FirstOrDefault();
                vers.Name = rootGroup.Name;
                vers.Length = rootGroup.Length;
                vers.Order = rootGroup.Order;
                vers.Prefix = rootGroup.Prefix;
                vers.Remarks = rootGroup.Remarks;
                vers.Surfix = rootGroup.Surfix;

                vers.AddBy = rootGroup.AddBy;
                vers.Status = rootGroup.Status;
                vers.Seperator = rootGroup.Seperator;
                vers.UpdateBy = User.Identity.Name;
                vers.IsDeleted = rootGroup.IsDeleted;
                vers.SetDate();
                var res = DataAccess.Instance.RootGroupService.Update(vers);
                if (res)
                {
                    SetCode(rootGroup);
                }
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.UPDATED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        public void SetCode(RootGroup rootGroup)
        {
            List<Ledgers> ledgerByRoot = DataAccess.Instance.LedgersService.Filter(l => l.ParentId == rootGroup.Id && l.IsDeleted == false).ToList();
            foreach (var ledger in ledgerByRoot)
            {
                var vers = DataAccess.Instance.LedgersService.Filter(f => f.LedgerId == ledger.LedgerId).FirstOrDefault();
                if (rootGroup.Surfix != null && rootGroup.Prefix != null && rootGroup.Seperator != null)
                    vers.Code = rootGroup.Prefix + ' ' + rootGroup.Seperator + ' ' + rootGroup.Surfix;

                CommonResponse cr = new CommonResponse();
                try
                {
                    vers.RootGroupId = ledger.RootGroupId;
                    vers.Name = ledger.Name;
                    vers.RootGroupId = ledger.RootGroupId;
                    vers.OpenningBalance = ledger.OpenningBalance;
                    vers.OpenningBalanceDc = ledger.OpenningBalanceDc;
                    vers.CurrentBalanceDc = ledger.OpenningBalanceDc;
                    vers.Remarks = ledger.Remarks;
                    vers.CurrentBalance = ledger.OpenningBalance;
                    vers.ParentId = ledger.ParentId;
                    vers.IsGroup = ledger.IsGroup;
                    vers.IsLedger = ledger.IsLedger;

                    vers.IsDeleted = ledger.IsDeleted;
                    vers.Status = ledger.Status;

                    vers.UpdateBy = User.Identity.Name;
                    vers.SetDate();
                    var res = DataAccess.Instance.LedgersService.Update(vers);
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.FAILED;
                }
                catch (Exception ex)
                {
                    BadRequest(ex.Message);
                }
            }
        }
        public string GenCode(Ledgers led)
        {
            string code = string.Empty;
            string ledname = string.Empty;
            string Prefix = string.Empty;
            string Surfix = string.Empty;
            try
            {
                List<int> Codelist = new List<int>();
                if (led.RootGroupId == 0)
                {
                    switch (led.Name)
                    {
                        case "Asset":
                            led.RootGroupId = 1;
                            break;
                        case "Liabilities":
                            led.RootGroupId = 2;
                            break;
                        case "Income":
                            led.RootGroupId = 3;
                            break;
                        case "Expense":
                            led.RootGroupId = 4;
                            break;
                        default:
                            led.RootGroupId = 0;
                            break;
                    }
                }
                var data = DataAccess.Instance.RootGroupService.Filter(e => e.Id == led.RootGroupId).FirstOrDefault() ?? new RootGroup();
                if (data == null)
                {
                    throw new Exception("Asset Code Set Up Not Found");
                }
                var ledgerdata = DataAccess.Instance.LedgersService.Filter(e => e.RootGroupId == led.RootGroupId).ToList();
                if (!string.IsNullOrEmpty(data.Prefix))
                {
                    if (data.Prefix.StartsWith("AA"))
                    {
                        if (!ledgerdata.Any())
                        {
                            Prefix = (1).ToString().PadLeft(data.Prefix.Length);
                        }
                        else
                        {
                            Prefix = (ledgerdata.Select(e => Convert.ToInt32(e.Code.Substring(0, data.Prefix.Length))).ToList().Max() + 1).ToString("0000");
                        }
                    }
                    else
                    {
                        Prefix = data.Prefix;
                    }
                }
                if (!string.IsNullOrEmpty(data.Surfix))
                {
                    if (data.Surfix.StartsWith("AA"))
                    {
                        if (!ledgerdata.Any())
                        {
                            Surfix = (1).ToString().PadLeft(data.Surfix.Length);
                        }
                        else
                        {
                            Surfix = (ledgerdata.Select(e => Convert.ToInt32(e.Code.Substring(e.Code.Length - data.Surfix.Length))).ToList().Max() + 1).ToString("0000");
                        }
                    }
                    else
                    {
                        Surfix = data.Surfix;
                    }
                }
                if (data.Length != 0)
                {
                    if (Convert.ToInt32(data.Length) >= led.Name.Length)
                    {
                        throw new Exception("Lenght Should Not Name");
                    }
                    ledname = led.Name.Substring(0, Convert.ToInt32(data.Length));
                }
                else
                {
                    ledname = ledname = led.Name;
                }
                code = Prefix + ledname + Surfix;
                if (!string.IsNullOrEmpty(data.Seperator) && !string.IsNullOrEmpty(data.Position))
                {
                    if (Convert.ToInt32(data.Position) > led.Name.Length)
                    {
                        throw new Exception("Position Should Not greater then  Name length");
                    }
                    if (((data.Surfix.StartsWith("AA")) || (data.Prefix.StartsWith("AA"))) && Convert.ToInt32(data.Position) < 4)
                    {
                        throw new Exception("Position less then Surfix or Prefix");
                    }
                    string first = code.Substring(0, Convert.ToInt32(data.Position));
                    string Last = code.Substring(code.Length - (Convert.ToInt32(data.Position) + 1));
                    code = first + data.Seperator + Last;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return code;
        }
        #endregion

        #region Transaction
        [Route("Accounts/GetAllTransaction/")]
        [HttpGet]
        public IHttpActionResult GetAllTransaction()
        {
            // Get All Transaction
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.CommonServices.GetBySp("GetAllTransaction");
            if (result.Rows.Count > 0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }

        [Route("Accounts/GetLastVoucher/")]
        [HttpGet]
        public IHttpActionResult GetLastVoucher()
        {
            // Get All Transaction
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.TransactionService.Filter(r => r.IsDeleted == false).ToList();

            if (result.Count > 0)
            {
                var lastVoucherNo = result.Last().TransNo;
                res.results = (DateTime.Now.Year).ToString().Substring(2, 2) + DateTime.Now.Month.ToString("00") + DateTime.Now.Day.ToString("00") + (Convert.ToInt32(lastVoucherNo.Substring(6, 4)) + 1).ToString("D4");
            }
            else
            {
                res.results = (DateTime.Now.Year).ToString().Substring(2, 2) + DateTime.Now.Month.ToString("00") + DateTime.Now.Day.ToString("00") + (1).ToString("D4");
            }
            return Json(res);
        }
        [Route("Accounts/AddTransaction/")]
        [HttpPost]
        public IHttpActionResult AddTransaction(TransactionVM vm)
        {
            //CommonResponse cr = new CommonResponse();
            CommonResponse cr = null;
            try
            {
                DateTime stratdate = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").FirstOrDefault().StartDate;
                DateTime enddate = DataAccess.Instance.FiscalYearService.Filter(f => f.IsDeleted == false && f.Status == "A").FirstOrDefault().EndDate;
                if (stratdate < Convert.ToDateTime(vm.Date) && Convert.ToDateTime(vm.Date) > enddate)
                {
                    throw new Exception("Invalid date, Please select the date with in the date range");
                }
                cr = InsertTransaction(vm);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }

        [Route("Accounts/ApproveTransaction/{TransactionId}")]
        [HttpPost]
        public IHttpActionResult ApproveTransaction(int TransactionId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (TransactionId > 0)
                {
                    var transaction = DataAccess.Instance.TransactionService.Filter(t => t.Id == TransactionId && t.IsDeleted == false && t.IsApproved == false && t.Status == "Pending").FirstOrDefault();
                    List<SqlParameter> param = new List<SqlParameter>();
                    param.Add(new SqlParameter("@TransactionId", transaction.Id));
                    param.Add(new SqlParameter("@ApproveBy", User.Identity.Name));
                    param.Add(new SqlParameter("@UpdateUserId", User.Identity.GetUserId()));
                    var res = DataAccess.Instance.CommonServices.GetBySpWithParam("UpdateTransaction", param.ToArray());
                    cr.message = res.Rows.Count > 0 ? Constant.UPDATED : Constant.UPDATED_ERROR;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }

        [Route("Accounts/RejectStatus/{Id}/{Status}")]
        [HttpPost]
        public IHttpActionResult RejectStatus(int Id, string Status)
        {
            CommonResponse cr = new CommonResponse();
            OEMS.Models.Model.Account.Transaction transaction = DataAccess.Instance.TransactionService.SingleOrDefault(x=>x.Id==Id);

            transaction.Status = Status;
            transaction.IsDeleted = false;
            transaction.UpdateBy = User.Identity.GetUserName();
            transaction.UpdateDate = DateTime.Now;
            transaction.IsReject = true;
            var results = DataAccess.Instance.TransactionService.Update(transaction);
            if (results)
            {
                
                cr.message = results ? Constant.UPDATED : Constant.UPDATED_ERROR;
            }
            
            return Json(cr);
        }

        public CommonResponse InsertTransaction(TransactionVM vm)
        {
            OEMS.Models.Model.Account.Transaction transaction = new OEMS.Models.Model.Account.Transaction();
            transaction.SetDate();
            CommonResponse cr = new CommonResponse();
            DataTable dt = new DataTable();
            dt.Columns.Add("RowNo");
            dt.Columns.Add("LedgerId", typeof(int));
            dt.Columns.Add("DrAmount", typeof(decimal));
            dt.Columns.Add("CrAmount", typeof(decimal));
            dt.Columns.Add("CurrentAmount", typeof(decimal));
            dt.Columns.Add("OpeningAmount", typeof(decimal));
            dt.Columns.Add("DC", typeof(int));

            List<SqlParameter> SqlParameters = new List<SqlParameter>();
            SqlParameters.Add(new SqlParameter("@FiscalYearId", vm.FiscalYearId));
            SqlParameters.Add(new SqlParameter("@AccBranchId", vm.AccBranchId));

            SqlParameters.Add(new SqlParameter("@TransType", vm.TransType));
            SqlParameters.Add(new SqlParameter("@Date", Convert.ToDateTime(vm.Date)));
            SqlParameters.Add(new SqlParameter("@DrTotal", vm.DrTotal));
            SqlParameters.Add(new SqlParameter("@CrTotal", vm.CrTotal));
            SqlParameters.Add(new SqlParameter("@AddBy", User.Identity.Name));
            SqlParameters.Add(new SqlParameter("@Description", vm.Remarks));
            SqlParameters.Add(new SqlParameter("@IP", transaction.IP));
            SqlParameters.Add(new SqlParameter("@MAC", transaction.MacAddress));

            SqlParameters.Add(new SqlParameter("@PayMode", vm.PayMode));
            SqlParameters.Add(new SqlParameter("@ChequeNo", vm.ChequeNo));
            if (string.IsNullOrEmpty(vm.ChequeDate))
            {
                SqlParameters.Add(new SqlParameter("@ChequeDate", vm.ChequeDate));
            }
            else
            {
                SqlParameters.Add(new SqlParameter("@ChequeDate", Convert.ToDateTime(vm.ChequeDate)));
            }

            SqlParameters.Add(new SqlParameter("@PayTo", vm.PayTo));
            SqlParameters.Add(new SqlParameter("@RecivedBy", vm.RecivedBy));
            SqlParameters.Add(new SqlParameter("@IsReject", vm.IsReject));

            int counter = 1;
            foreach (var item in vm.TransactionDetail.OrderBy(e => e.DC))
            {
                decimal currentamount = (item.CrAmount + item.DrAmount + DataAccess.Instance.LedgersService.Filter(e => e.LedgerId == item.LedgerId).FirstOrDefault().CurrentBalance);
                dt.Rows.Add(counter, item.LedgerId, item.DrAmount, item.CrAmount, currentamount, item.OpeningAmount, item.DC);
                counter++;
            }

            var res = false;
            try
            {
                SqlParameters.Add(Converter.ToSqlParameter("@TransactionDetail", dt, "dbo.UTT_TransactionDetail"));
                DataTable dr = DataAccess.Instance.CommonServices.GetBySpWithSQLParam("TransactionInsert", SqlParameters.ToArray());
                //  string con = ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
                //  var _dt = SqlHelper.ExecuteDataTable(con, CommandType.StoredProcedure, "TransactionDetailInsert", SqlParameters.ToArray());
                int TransactionId = Convert.ToInt32(dr.Rows[0]["TransactionId"]);
                int LedgerId = 0;
                foreach (var item1 in vm.TransactionDetail.Where(x=>x.DC==1))
                {
                    LedgerId = Convert.ToInt32(item1.LedgerId);
                    CostCenterDetails data = new CostCenterDetails();
                    if(item1.lsCostCenter!=null)
                    { 
                        foreach (var item in item1.lsCostCenter)
                        {
                            data.TransactionId = TransactionId;
                            data.LedgerId = LedgerId;
                            data.CostCenterId = item.CostCenterId;
                            data.Amount = item.Amount;
                            data.IsDeleted = false;
                            data.Status = "A";
                            data.AddBy = User.Identity.Name;
                            data.SetDate();
                            DataAccess.Instance.CostCenterDetailsService.Add(data);
                        }
                    }
                }
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = "Your Vouchar No is " + Convert.ToString(dr.Rows[0]["VoucharNo"]); /* + " " + Constant.SAVED;*/
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            return cr;
        }

        [Route("Accounts/DetailsTransaction/{Id}")]
        [HttpGet]
        public IHttpActionResult DetailsTransaction(int Id)
        {
            CommonResponse cr = new CommonResponse();
            //var res = DataAccess.Instance.TransactionService.Filter(x => x.Id == Id && x.IsDeleted == false).FirstOrDefault();
            //var results= DataAccess.Instance.TransactionDetailService.Filter(x => x.TransactionId == res.Id).ToList();

            DataTable results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetDetailsTransaction", new object[] { Id });
            if (results != null)
            {
                cr.results = results;
            }
            else
            {
                cr.results = 0;
            }

            return Json(cr);
        }
        [Route("Accounts/updateCollection")]
        [HttpPut]
        public IHttpActionResult UpdateChequeDate(OEMS.Models.Model.Account.Transaction transaction)
        {
            CommonResponse cr = new CommonResponse();
            var upData = DataAccess.Instance.TransactionService.Get(transaction.Id);
            transaction.UpdateBy = User.Identity.Name;
            transaction.UpdateDate = upData.UpdateDate;
            transaction.Date = transaction.Date;
            transaction.SetDate();
            var res = DataAccess.Instance.TransactionService.Update(transaction);

            TransactionDetail data = DataAccess.Instance.TransactionDetailService.Filter(c => c.TransactionId == transaction.Id && c.LedgerId == 5340).FirstOrDefault();
            if(data!=null)
            { 
            data.LedgerId = Convert.ToInt32(transaction.LedgerId);
            DataAccess.Instance.TransactionDetailService.Update(data);
            }

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.UPDATED : Constant.FAILED;
            return Json(cr);
        }
        #endregion Transaction

        #region CostCenter

        [Route("Accounts/AddCostCategory")]
        [HttpPost]
        public IHttpActionResult AddCostCategory(CostCategory costCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (costCategory != null)
                {
                    List<CostCategory> costCategoryList = DataAccess.Instance.CostCategoryService.Filter(c => c.IsDeleted == false && c.Status == "A").ToList();

                    if (costCategoryList.Any(c => c.CostCategoryName == costCategory.CostCategoryName ))
                    {
                        throw new Exception("Product Category Already Exist.");
                    }

                    costCategory.Status = "A";
                    costCategory.IsDeleted = false;
                    costCategory.AddBy = User.Identity.Name;
                    costCategory.AddDate = DateTime.Now;
                    costCategory.UpdateBy = User.Identity.Name;
                    costCategory.UpdateDate = DateTime.Now;
                    costCategory.SetDate();
                    var res = DataAccess.Instance.CostCategoryService.Add(costCategory);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Accounts/UpdateCostCategory")]
        [HttpPut]
        public IHttpActionResult UpdateCostCategory(CostCategory costCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (costCategory != null)
                {
                    List<CostCategory> costCategoryList = DataAccess.Instance.CostCategoryService.Filter(c => c.Id != costCategory.Id && c.IsDeleted == false && c.Status == "A").ToList();

                    if (costCategoryList.Any(c => c.CostCategoryName == costCategory.CostCategoryName ))
                    {
                        throw new Exception("Cost Category Already Exist.");
                    }
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.ACC_CostCenter", "CostCategoryId=" + costCategory.Id + " AND IsDeleted=" + 0);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    CostCategory data = DataAccess.Instance.CostCategoryService.Filter(c => c.Id == costCategory.Id).FirstOrDefault();
                    data.CostCategoryName = costCategory.CostCategoryName;                
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.CostCategoryService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Accounts/DeleteCostCategory")]
        [HttpPost]
        public IHttpActionResult DeleteCostCategory(CostCategory costCategory)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (costCategory != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.ACC_CostCenter", "CostCategoryId="+ costCategory.Id + " AND IsDeleted=" + 0);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.CostCategoryService.Remove(costCategory.Id);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Accounts/GetCostCategorys")]
        [HttpGet]
        public IHttpActionResult GetCostCategorys()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                List<CostCategory> costCategoryList = DataAccess.Instance.CostCategoryService.Filter(c => c.IsDeleted == false && c.Status == "A").ToList();
                if (costCategoryList.Count > 0)
                {
                    cr.results = costCategoryList;
                    cr.message = costCategoryList.Count + " Data Found.";
                }
                //Khaled
                else
                {
                    throw new Exception("No Data Found.");
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }


        [Route("Accounts/AddCostCenter")]
        [HttpPost]
        public IHttpActionResult AddCostCenter(CostCenter costCenter)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (costCenter != null)
                {
                    List<CostCenter> costCenterList = DataAccess.Instance.CostCenterService.Filter(c => c.IsDeleted == false && c.Status == "A").ToList();

                    if (costCenterList.Any(c => c.CostCenterName == costCenter.CostCenterName && c.CostCategoryId == costCenter.CostCategoryId && c.LedgerId == costCenter.LedgerId))
                    {
                        throw new Exception("cost Center Already Exist.");
                    }

                    costCenter.Status = "A";
                    costCenter.IsDeleted = false;
                    costCenter.AddBy = User.Identity.Name;
                    costCenter.AddDate = DateTime.Now;
                    costCenter.UpdateBy = User.Identity.Name;
                    costCenter.UpdateDate = DateTime.Now;
                    costCenter.SetDate();
                    var res = DataAccess.Instance.CostCenterService.Add(costCenter);
                    cr.results = res;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Accounts/UpdateCostCenter")]
        [HttpPut]
        public IHttpActionResult UpdateCostCenter(CostCenter costCenter)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (costCenter != null)
                {
                    List<CostCenter> costCenterList = DataAccess.Instance.CostCenterService.Filter(c=> c.Id != costCenter.Id && c.IsDeleted == false && c.Status == "A").ToList();

                    if (costCenterList.Any(c => c.CostCenterName == costCenter.CostCenterName && c.CostCategoryId == costCenter.CostCategoryId && c.LedgerId == costCenter.LedgerId))
                    {
                        throw new Exception("Cost Category Already Exist.");
                    }
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.ACC_CostCenterDetails", "CostCenterId="+ costCenter.Id + " AND IsDeleted=" + 0);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    CostCenter data = DataAccess.Instance.CostCenterService.Filter(c => c.Id == costCenter.Id).FirstOrDefault();
                    data.CostCenterName = costCenter.CostCenterName;
                    data.CostCategoryId = costCenter.CostCategoryId;
                    data.LedgerId = costCenter.LedgerId;
                    data.UpdateDate = DateTime.Now;
                    data.UpdateBy = User.Identity.Name;
                    data.SetDate();
                    var res = DataAccess.Instance.CostCenterService.Update(data);
                    cr.results = res;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Accounts/DeleteCostCenter")]
        [HttpPost]
        public IHttpActionResult DeleteProductSubCategory(CostCenter costCenter)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (costCenter != null)
                {
                    bool Exist = DataAccess.Instance.CommonServices.IsExist("dbo.ACC_CostCenterDetails", "CostCenterId=" + costCenter.Id  +" AND IsDeleted=" + 0);
                    if (Exist)
                    {
                        throw new Exception(Constant.DATA_EXISTS);
                    }
                    else
                    {
                        var res = DataAccess.Instance.CostCenterService.Remove(costCenter.Id);
                        cr.results = res;
                        cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
                    }


                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Accounts/GetCostCenters")]
        [HttpGet]
        public IHttpActionResult GetCostCenters()
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                var list = DataAccess.Instance.CommonServices.GetBySp("GetCostCenterList");
      
                 cr.results = list;
                 cr.message =" Data Found.";   

            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Accounts/GetCostCenterforTransaction/{srhtext}/{LedgerId}")]
        [HttpGet]
        public IHttpActionResult GetCostCenterforTransaction(string srhtext, int LedgerId) //This method will Search cost center by Name.
        {
            CommonResponse cr = new CommonResponse();
           
            cr.results = DataAccess.Instance.CostCenterService.GetCostCenterforTransaction(srhtext, LedgerId).ToList();

            return Json(cr);
        }
        #endregion

    }
}
