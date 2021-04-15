using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model.Invoice;
using OEMS.Service.Services.Invoice;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace OEMS.Api.Controllers
{
    public class InvoiceController : ApiController
    {
        #region Invoice Service
        [Route("Invoice/GetAllInvoiceService/")]
        [HttpGet]
        public IHttpActionResult GetAllInvoiceService()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.InvoiceService.Filter(c => c.IsDeleted == false).OrderByDescending(i=>i.Id).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Invoice/AddInvoiceService")]
        [HttpPost]
        public IHttpActionResult AddInvoiceService(InvoiceService invoiceService)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (invoiceService != null)
                {
                    List<InvoiceService> invoiceServicelist = DataAccess.Instance.InvoiceService.Filter(a => a.ServiceName == invoiceService.ServiceName && a.IsDeleted == false && a.Status == "A").ToList();

                    if (invoiceServicelist.Count > 0)
                    {
                        throw new Exception("Invoice Service Already Exist.");
                    }

                    invoiceService.Status = "A";
                    invoiceService.IsDeleted = false;
                    invoiceService.AddBy = User.Identity.Name;
                    invoiceService.AddDate = DateTime.Now;
                    invoiceService.UpdateBy = User.Identity.Name;
                    invoiceService.UpdateDate = DateTime.Now;
                    invoiceService.SetDate();
                    var res = DataAccess.Instance.InvoiceService.Add(invoiceService);
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
        [Route("Invoice/changeActivityStatus/")]
        [HttpPut]
        public IHttpActionResult changeActivityStatus(InvoiceService invoiceService)
        {
            CommonResponse cmr = new CommonResponse();

            try
            {
                var invoiceServicelist = DataAccess.Instance.InvoiceService.Filter(e => e.IsDeleted == false && e.Id == invoiceService.Id).FirstOrDefault();

                if (invoiceService.Status == "A")
                {
                    invoiceServicelist.Status = "I";
                }
                if (invoiceService.Status == "I")
                {
                    invoiceServicelist.Status = "A";
                }

                invoiceServicelist.UpdateBy = User.Identity.Name;
                invoiceServicelist.SetDate();

                var res = DataAccess.Instance.InvoiceService.Update(invoiceServicelist);
                cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = res ? "Status changed successfully" : Constant.UPDATED_ERROR;
                //cmr.message = "Status changed successfully";

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }
        [Route("Invoice/UpdateInvoiceService")]
        [HttpPut]
        public IHttpActionResult UpdateInvoiceService(InvoiceService invoiceService)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (invoiceService != null)
                {
                    List<InvoiceService> invoiceServiceList = DataAccess.Instance.InvoiceService.Filter(a => a.ServiceName == invoiceService.ServiceName && a.Id != invoiceService.Id && a.IsDeleted == false && a.Status == "A").ToList();

                    if (invoiceServiceList.Count > 0)
                    {
                        throw new Exception("Invoice Service Already Exist.");
                    }
                    InvoiceService data = DataAccess.Instance.InvoiceService.Filter(p => p.Id == invoiceService.Id).FirstOrDefault();
                    data.ServiceName = invoiceService.ServiceName;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.InvoiceService.Update(data);
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
        [Route("Invoice/DeleteInvoiceService/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteInvoiceService(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                InvoiceService invoiceService = new InvoiceService();
                invoiceService = DataAccess.Instance.InvoiceService.Get(id);
                var invService = DataAccess.Instance.BillingHeadConfigService.Filter(p => p.InvoiceServiceId == invoiceService.Id).FirstOrDefault();
                if (invService != null)
                {
                    throw new Exception("Service Already Used.");
                }
                invoiceService.UpdateBy = User.Identity.Name;
                invoiceService.IsDeleted = true;
                invoiceService.SetDate();

                var resp = DataAccess.Instance.InvoiceService.Update(invoiceService);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        #endregion

        #region Invoice BillingHead

        [Route("Invoice/GetAllInvoiceBillingHead")]
        [HttpGet]
        public IHttpActionResult GetAllInvoiceBillingHead()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.InvoiceBillingHead.Filter(c => c.IsDeleted == false).ToList();
                dt.Reverse();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Invoice/GetAllActiveInvoiceBillingHead")]
        [HttpGet]
        public IHttpActionResult GetAllActiveInvoiceBillingHead()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.InvoiceBillingHead.Filter(c => c.IsDeleted == false && c.Status == "A" && c.IsDiscount != true).ToList();
                dt.Reverse();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Invoice/GetAllActiveInvoiceDiscountBillingHead")]
        [HttpGet]
        public IHttpActionResult GetAllActiveInvoiceDiscountBillingHead()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.InvoiceBillingHead.Filter(c => c.IsDeleted == false && c.Status == "A" && c.IsDiscount == true).ToList();
                dt.Reverse();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Invoice/AddInvoiceBillingHead")]
        [HttpPost]
        public IHttpActionResult AddInvoiceBillingHead(InvoiceBillingHead invoiceBillingHead)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (invoiceBillingHead != null)
                {
                    List<InvoiceBillingHead> invoiceBillingHeadlist = DataAccess.Instance.InvoiceBillingHead.Filter(a => a.BillingHeadName == invoiceBillingHead.BillingHeadName && a.BillingHeadType == invoiceBillingHead.BillingHeadType && a.IsDeleted == false ).ToList();

                    if (invoiceBillingHeadlist.Count > 0)
                    { 
                        throw new Exception("Invoice Billing Head Already Exist.");
                    }

                   
                    invoiceBillingHead.IsDeleted = false;
                    invoiceBillingHead.AddBy = User.Identity.Name;
                    invoiceBillingHead.AddDate = DateTime.Now;
                    invoiceBillingHead.UpdateBy = User.Identity.Name;
                    invoiceBillingHead.UpdateDate = DateTime.Now;
                    invoiceBillingHead.SetDate();
                    var res = DataAccess.Instance.InvoiceBillingHead.Add(invoiceBillingHead);
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
        [Route("Invoice/UpdateInvoiceBillingHead")]
        [HttpPut]
        public IHttpActionResult UpdateInvoiceBillingHead(InvoiceBillingHead invoiceBillingHead)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (invoiceBillingHead != null)
                {
                    List<InvoiceBillingHead> invoiceBillingHeadlist = DataAccess.Instance.InvoiceBillingHead.Filter(a => a.BillingHeadName == invoiceBillingHead.BillingHeadName && a.Id != invoiceBillingHead.Id && a.IsDeleted == false && a.Status == "A").ToList();


                    if (invoiceBillingHeadlist.Count > 0)
                    {
                        throw new Exception("Invoice Billing Head Already Exist.");
                    }
                    InvoiceBillingHead data = DataAccess.Instance.InvoiceBillingHead.Filter(p => p.Id == invoiceBillingHead.Id).FirstOrDefault();
                    data.BillingHeadName = invoiceBillingHead.BillingHeadName;
                    data.BillingHeadType = invoiceBillingHead.BillingHeadType;
                    data.LedgerId = invoiceBillingHead.LedgerId;
                    data.IsDiscount = invoiceBillingHead.IsDiscount;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.InvoiceBillingHead.Update(data);
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


       


        [Route("Invoice/DeleteInvoiceBillingHead/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteInvoiceBillingHead(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                InvoiceBillingHead invoiceBillingHead = new InvoiceBillingHead();
                invoiceBillingHead = DataAccess.Instance.InvoiceBillingHead.Get(id);

                var billingHeadConfig = DataAccess.Instance.BillingHeadConfigService.Filter(p => p.BillingHeadId == invoiceBillingHead.Id).FirstOrDefault();
                if (billingHeadConfig != null)
                {
                    throw new Exception("Billing Head Already Used.");
                }
                invoiceBillingHead.UpdateBy = User.Identity.Name;
                invoiceBillingHead.IsDeleted = true;
                invoiceBillingHead.SetDate();

                var resp = DataAccess.Instance.InvoiceBillingHead.Update(invoiceBillingHead);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("Invoice/ChangeStatus/")]
        [HttpPut]
        public IHttpActionResult ChangeStatus(InvoiceBillingHead invoiceBillingHead)
        {
            CommonResponse cmr = new CommonResponse();

            try
            {
                var invoiceBillingHeadlist = DataAccess.Instance.InvoiceBillingHead.Filter(e => e.IsDeleted == false && e.Id == invoiceBillingHead.Id).FirstOrDefault();

                if (invoiceBillingHead.Status == "A")
                {
                    invoiceBillingHeadlist.Status = "I";
                }
                if (invoiceBillingHead.Status == "I")
                {
                    invoiceBillingHeadlist.Status = "A";
                }

                invoiceBillingHeadlist.UpdateBy = User.Identity.Name;
                invoiceBillingHeadlist.SetDate();

                var res = DataAccess.Instance.InvoiceBillingHead.Update(invoiceBillingHeadlist);
                cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = res ? "Status changed successfully" : Constant.UPDATED_ERROR;
                //cmr.message = "Status changed successfully";

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }



        #endregion

        #region Invoice Billing Method

        [Route("Invoice/GetAllInvoiceBillingMethod")]
        [HttpGet]
        public IHttpActionResult GetAllInvoiceBillingMethod()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.InvoiceBillingMethod.Filter(c => c.IsDeleted == false).ToList();
                dt.Reverse();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Invoice/AddInvoiceBillingMethod")]
        [HttpPost]
        public IHttpActionResult AddInvoiceBillingMethod(InvoiceBillingMethod invoiceBillingMethod)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (invoiceBillingMethod != null)
                {
                    List<InvoiceBillingMethod> invoiceBillingMethodlist = DataAccess.Instance.InvoiceBillingMethod.Filter(a => a.BillingMethodName == invoiceBillingMethod.BillingMethodName && a.IsDeleted == false).ToList();

                    if (invoiceBillingMethodlist.Count > 0)
                    {
                        throw new Exception("Invoice Billing Head Already Exist.");
                    }


                    invoiceBillingMethod.IsDeleted = false;
                    invoiceBillingMethod.AddBy = User.Identity.Name;
                    invoiceBillingMethod.AddDate = DateTime.Now;
                    invoiceBillingMethod.UpdateBy = User.Identity.Name;
                    invoiceBillingMethod.UpdateDate = DateTime.Now;
                    invoiceBillingMethod.SetDate();
                    var res = DataAccess.Instance.InvoiceBillingMethod.Add(invoiceBillingMethod);
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
        [Route("Invoice/UpdateInvoiceBillingMethod")]
        [HttpPut]
        public IHttpActionResult UpdateInvoiceBillingMethod(InvoiceBillingMethod invoiceBillingMethod)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (invoiceBillingMethod != null)
                {
                    List<InvoiceBillingMethod> invoiceBillingMethodlist = DataAccess.Instance.InvoiceBillingMethod.Filter(a => a.BillingMethodName == invoiceBillingMethod.BillingMethodName && a.Id != invoiceBillingMethod.Id && a.IsDeleted == false && a.Status == "A").ToList();



                    if (invoiceBillingMethodlist.Count > 0)
                    {
                        throw new Exception("Invoice Billing Head Already Exist.");
                    }
                    InvoiceBillingMethod data = DataAccess.Instance.InvoiceBillingMethod.Filter(p => p.Id == invoiceBillingMethod.Id).FirstOrDefault();
                    data.BillingMethodName = invoiceBillingMethod.BillingMethodName;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.InvoiceBillingMethod.Update(data);
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

        [Route("Invoice/DeleteInvoiceBillingMethod/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteInvoiceBillingMethod(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                InvoiceBillingMethod invoiceBillingMethod = new InvoiceBillingMethod();
                invoiceBillingMethod = DataAccess.Instance.InvoiceBillingMethod.Get(id);
                var billingMethodConfig = DataAccess.Instance.BillingHeadConfigService.Filter(p => p.BillingMethodId == invoiceBillingMethod.Id).FirstOrDefault();
                if (billingMethodConfig != null)
                {
                    throw new Exception("Billing Method Already Used.");
                }
                invoiceBillingMethod.UpdateBy = User.Identity.Name;
                invoiceBillingMethod.IsDeleted = true;
                invoiceBillingMethod.SetDate();

                var resp = DataAccess.Instance.InvoiceBillingMethod.Update(invoiceBillingMethod);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        #endregion

        #region Billing Head Configure

        [Route("Invoice/GetAllBillingHeadConfig/")]
        [HttpPost]
        public IHttpActionResult GetAllBillingHeadConfig(BillingHeadConfig billingHeadConfig) 
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            int Block = 1;
            var param = new object[] {billingHeadConfig.ClientId, billingHeadConfig.InvoiceServiceId,
                billingHeadConfig.BillingHeadId, billingHeadConfig.BillingHeadType, billingHeadConfig.BillingMethodId ,DBNull.Value, DBNull.Value, Block};
            dt = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetAllBillingHeadConfig", param);
            if (dt.Rows.Count == 0)
            {
                cr.message = "No Data Found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            else
            {
                cr.results = dt;
                cr.message = dt.Rows.Count + " Data found";
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("Invoice/GetAllSelectedMonthByBillingHeadConfigId/{BillingId}")]
        [HttpGet]

        public IHttpActionResult GetSelectedMothById(int BillingId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //var dt = DataAccess.Instance.SpecialAllowanceService.Filter(s=>s.EmpId== EmpId && s.YearId == YearId && s.IsDeleted == false).ToList();
                var dt = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetAllSelectedMonthByBillingHeadConfigId", new object[] { BillingId });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Invoice/AddBillingHeadConfig")]
        [HttpPost]
        public IHttpActionResult AddBillingHeadConfig(BillingHeadConfig billingHeadConfig)
        {
            CommonResponse cmr = new CommonResponse();

            try
            {
                bool response = false;

                if (billingHeadConfig != null)
                {
                    List<BillingHeadConfig> billingHeadConfiglist = DataAccess.Instance.BillingHeadConfigService.Filter(a =>((a.ClientId == billingHeadConfig.ClientId && a.BillingHeadId == billingHeadConfig.BillingHeadId && a.Year == billingHeadConfig.Year) ||( a.Id == billingHeadConfig.Id)) && a.IsDeleted == false && a.Status == "A").ToList();

                    if (billingHeadConfiglist.Count > 0)
                    {
                        throw new Exception("Same Client,Year and Billing Head Configure Already Exist.");
                    }

                    billingHeadConfig.Status = "A";
                    billingHeadConfig.IsDeleted = false;
                    billingHeadConfig.AddBy = User.Identity.Name;
                    billingHeadConfig.AddDate = DateTime.Now;
                    billingHeadConfig.UpdateBy = User.Identity.Name;
                    billingHeadConfig.UpdateDate = DateTime.Now;
                    billingHeadConfig.SetDate();
                    var res = DataAccess.Instance.BillingHeadConfigService.Add(billingHeadConfig);

                    if (res == true && billingHeadConfig.Month.Count > 0)
                    {
                        foreach (var bill in billingHeadConfig.Month)
                        {
                            BillingHeadConfigDetails allow = new BillingHeadConfigDetails();
                            allow.BillingHeadConfigId = billingHeadConfig.Id;
                            allow.Year = billingHeadConfig.Year;
                            allow.MonthId = bill.Value;
                            allow.MonthName = bill.Text;
                            // allow.Amount = specAllow.Amount;
                            allow.Status = "A";
                            allow.IsDeleted = false;
                            allow.AddBy = User.Identity.Name;
                            allow.AddDate = DateTime.Now;
                            allow.UpdateBy = User.Identity.Name;
                            allow.UpdateDate = DateTime.Now;
                            allow.SetDate();
                            response = DataAccess.Instance.BillingHeadConfigDetailsService.Add(allow);

                        }
                    }
                }
                cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = response ? Constant.SAVED : Constant.FAILED;


            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
           
        }
        [Route("Invoice/UpdateBillingHeadConfig")]
        [HttpPut]
        public IHttpActionResult UpdateBillingHeadConfig(BillingHeadConfig billingHeadConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (billingHeadConfig != null)
                {
                    //List<InvoiceGenerate> invoiceGenerate = new List<InvoiceGenerate>();
                    //for (var i=0; i< billingHeadConfig.Month.Count; i++)
                    //{
                    //    int mnthId = (int)billingHeadConfig.Month[i].Value;
                    //    string mnthProcess = billingHeadConfig.Month[i].IsProcess;
                    //    var aa = DataAccess.Instance.InvoiceGenerateService.Filter(a => a.ClientId == billingHeadConfig.ClientId && a.BillingHeadId == billingHeadConfig.BillingHeadId && a.MonthId == mnthId && mnthProcess == "1" && a.IsDeleted == false).FirstOrDefault();
                    //    if (aa!=null)
                    //    {
                    //        invoiceGenerate.Add(aa);
                    //    }
                    //}

                    //if (invoiceGenerate.Count() >0)
                    //{
                    //    throw new Exception("Invoice Already Generated.");
                    //}
                    BillingHeadConfig data = DataAccess.Instance.BillingHeadConfigService.Filter(p => p.Id == billingHeadConfig.Id).FirstOrDefault();
                    data.BillingHeadType = billingHeadConfig.BillingHeadType;
                    data.ClientId = billingHeadConfig.ClientId;
                    data.InvoiceServiceId = billingHeadConfig.InvoiceServiceId;
                    data.BillingHeadId = billingHeadConfig.BillingHeadId;
                    data.BillingMethodId = billingHeadConfig.BillingMethodId;
                    data.Rate = billingHeadConfig.Rate;
                    data.MinAmount = billingHeadConfig.MinAmount;
                    data.MaxAmount = billingHeadConfig.MaxAmount;
                    data.MaskAmount = billingHeadConfig.MaskAmount;
                    data.NoMaskAmount = billingHeadConfig.NoMaskAmount;
                    data.Year = billingHeadConfig.Year;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.BillingHeadConfigService.Update(data);


                    int delte = DataAccess.Instance.CommonServices.ExecuteSQL($"DELETE FROM dbo.Invoice_BillingHeadConfigDetails WHERE BillingHeadConfigId = {billingHeadConfig.Id}");
                    bool response = false;
                    if (res == true && billingHeadConfig.Month.Count > 0)
                    {
                        foreach (var bill in billingHeadConfig.Month)
                        {
                            BillingHeadConfigDetails allow = new BillingHeadConfigDetails();

                            allow.BillingHeadConfigId = billingHeadConfig.Id; 
                            allow.Year = billingHeadConfig.Year;
                            allow.MonthId = bill.Value;
                            allow.MonthName = bill.Text;
                            // allow.Amount = specAllow.Amount;
                            allow.Status = "A";
                            allow.IsDeleted = false;
                            allow.AddBy = User.Identity.Name;
                            allow.AddDate = DateTime.Now;
                            allow.UpdateBy = User.Identity.Name;
                            allow.UpdateDate = DateTime.Now;
                            allow.SetDate();
                            response = DataAccess.Instance.BillingHeadConfigDetailsService.Add(allow);
                        }
                    }

                    cr.results = response;
                    cr.message = response ? Constant.UPDATED : Constant.UPDATED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Invoice/DeleteBillingHeadConfig/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteBillingHeadConfig(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                BillingHeadConfig billingHeadConfig = new BillingHeadConfig();
                billingHeadConfig = DataAccess.Instance.BillingHeadConfigService.Get(id);

                var billingHeadDetailsConf = DataAccess.Instance.BillingHeadConfigDetailsService.Filter(a => a.BillingHeadConfigId == billingHeadConfig.Id && a.Year == billingHeadConfig.Year && a.IsDeleted == false).FirstOrDefault();
                var invoiceGenerate = DataAccess.Instance.InvoiceGenerateService.Filter(a => a.ClientId == billingHeadConfig.ClientId && a.BillingHeadId == billingHeadConfig.BillingHeadId && a.Year == billingHeadConfig.Year && a.MonthId == billingHeadDetailsConf.MonthId && a.IsDeleted == false).FirstOrDefault();
                if (invoiceGenerate != null)
                {
                     throw new Exception("Invoice Already Generated.");
                }

                billingHeadConfig.UpdateBy = User.Identity.Name;
                billingHeadConfig.IsDeleted = true;
                billingHeadConfig.SetDate();
                var resp = DataAccess.Instance.BillingHeadConfigService.Update(billingHeadConfig);
                int delte = DataAccess.Instance.CommonServices.ExecuteSQL($"UPDATE dbo.Invoice_BillingHeadConfigDetails SET IsDeleted = 1 WHERE BillingHeadConfigId = {billingHeadConfig.Id}");
                
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        #endregion


        #region Billing Head Configure Details

        [Route("Invoice/GetAllBillingHeadConfigDetails/")]
        [HttpGet]
        public IHttpActionResult GetAllBillingHeadConfigDetails()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.BillingHeadConfigDetailsService.Filter(c => c.IsDeleted == false).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Invoice/AddBillingHeadConfigDetails")]
        [HttpPost]
        public IHttpActionResult AddbillingHeadConfigDetailsDetails(BillingHeadConfigDetails billingHeadConfigDetails)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (billingHeadConfigDetails != null)
                {
                    List<BillingHeadConfigDetails> billingHeadConfigDetailslist = DataAccess.Instance.BillingHeadConfigDetailsService.Filter(a => a.Id == billingHeadConfigDetails.Id && a.IsDeleted == false && a.Status == "A").ToList();

                    if (billingHeadConfigDetailslist.Count > 0)
                    {
                        throw new Exception("Billing Head Configure Details Already Exist.");
                    }

                    billingHeadConfigDetails.Status = "A";
                    billingHeadConfigDetails.IsDeleted = false;
                    billingHeadConfigDetails.AddBy = User.Identity.Name;
                    billingHeadConfigDetails.AddDate = DateTime.Now;
                    billingHeadConfigDetails.UpdateBy = User.Identity.Name;
                    billingHeadConfigDetails.UpdateDate = DateTime.Now;
                    billingHeadConfigDetails.SetDate();
                    var res = DataAccess.Instance.BillingHeadConfigDetailsService.Add(billingHeadConfigDetails);
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
        [Route("Invoice/UpdateBillingHeadConfigDetails")]
        [HttpPut]
        public IHttpActionResult UpdateBillingHeadConfigDetails(BillingHeadConfigDetails billingHeadConfigDetails)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (billingHeadConfigDetails != null)
                {
                    List<BillingHeadConfigDetails> billingHeadConfigDetailsList = DataAccess.Instance.BillingHeadConfigDetailsService.Filter(a => a.Id != billingHeadConfigDetails.Id && a.IsDeleted == false && a.Status == "A").ToList();

                    if (billingHeadConfigDetailsList.Count > 0)
                    {
                        throw new Exception("Billing Head Configure Details Already Exist.");
                    }
                    BillingHeadConfigDetails data = DataAccess.Instance.BillingHeadConfigDetailsService.Filter(p => p.Id == billingHeadConfigDetails.Id).FirstOrDefault();
                    data.MonthName = billingHeadConfigDetails.MonthName;
                    data.Year = billingHeadConfigDetails.Year;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.BillingHeadConfigDetailsService.Update(data);
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

        [Route("Invoice/DeleteBillingHeadConfigDetails")]
        [HttpPost]
        public IHttpActionResult DeleteBillingHeadConfigDetails(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                BillingHeadConfigDetails billingHeadConfigDetails = new BillingHeadConfigDetails();
                billingHeadConfigDetails = DataAccess.Instance.BillingHeadConfigDetailsService.Get(id);
                billingHeadConfigDetails.UpdateBy = User.Identity.Name;
                billingHeadConfigDetails.IsDeleted = true;
                billingHeadConfigDetails.SetDate();

                var resp = DataAccess.Instance.BillingHeadConfigDetailsService.Update(billingHeadConfigDetails);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        #endregion

        #region Billing Process Configure

        [Route("Invoice/GetAllBillingProcessPanel/")]
        [HttpPost]
        public IHttpActionResult GetAllBillingProcessPanel(BillingHeadConfig billingHeadConfig)
        {
             CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dt = new DataTable();
                List<BillingHeadConfig> _list = new List<BillingHeadConfig>();
                int Block = 2;
                var param = new object[] {billingHeadConfig.ClientId, billingHeadConfig.InvoiceServiceId,
                            billingHeadConfig.BillingHeadId, billingHeadConfig.BillingHeadType, billingHeadConfig.BillingMethodId ,billingHeadConfig.Year ,billingHeadConfig.MonthId, Block};
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetAllBillingHeadConfig", param);
               // dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetRequisitionList", param.ToArray());

                List<BillingHeadConfig> requiList = APIUitility.ConvertDataTable<BillingHeadConfig>(dt).ToList();
                foreach (var item in requiList)
                {
                    DataTable dtli = new DataTable();
                    BillingHeadConfig _requi = new BillingHeadConfig();
                    List<BillingHeadConfigVM> requiProList = new List<BillingHeadConfigVM>();
                   dtli = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetAllBillingHeadConfig", new object[] { item.ClientId, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, item.Year, item.MonthId, 3 });
                     requiProList =  APIUitility.ConvertDataTable<BillingHeadConfigVM>(dtli).ToList();
                    
                    item.RequList = requiProList;
                }

                cr.results = requiList;

                if (requiList.Count > 0)
                {
                    cr.message = $"{requiList.Count} Data Found.";
                }
                else
                {
                    cr.message = Constant.NOT_FOUND;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
       
        [Route("Invoice/AddBillingProcessPanel")]
        [HttpPost]
       
        public IHttpActionResult AddBillingProcessPanel(List<BillingHeadConfigVM> billingHeadConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (billingHeadConfig != null)
                {
                    
                    bool res = false;
                    foreach (var bill in billingHeadConfig)
                    {
                        List<BillingProcess> billingServicelist = DataAccess.Instance.BillingProcessService.Filter(a =>a.ClientId == bill.ClientId && a.BillingHeadId == bill.BillingHeadId && a.Year == bill.Year && a.MonthId == bill.MonthId && a.IsDeleted == false && a.Status == "A").ToList();

                        if (billingServicelist.Count > 0)
                        {
                            BillingProcess allow = DataAccess.Instance.BillingProcessService.Filter(a => a.ClientId == bill.ClientId && a.BillingHeadId == bill.BillingHeadId && a.Year == bill.Year && a.MonthId == bill.MonthId && a.IsDeleted == false && a.Status == "A").FirstOrDefault();
                            allow.ClientId = bill.ClientId;
                            allow.Year = bill.Year;
                            allow.MonthId = bill.MonthId;
                            allow.BillingHeadId = bill.BillingHeadId;
                            allow.Quantity = bill.Quantity;
                            allow.Rate = bill.Rate;
                            allow.TotalAmount = bill.TotalAmount;
                            allow.Status = "A";
                            allow.IsDeleted = false;
                            allow.AddBy = User.Identity.Name;
                            allow.AddDate = DateTime.Now;
                            allow.UpdateBy = User.Identity.Name;
                            allow.UpdateDate = DateTime.Now;
                            allow.SetDate();
                            res = DataAccess.Instance.BillingProcessService.Update(allow);
                            cr.results = res;
                            cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                        }
                        else
                        { 
                            if (bill.Quantity > 0 && bill.TotalAmount>0)
                            {
                                BillingProcess allow = new BillingProcess();
                                allow.ClientId = bill.ClientId;
                                allow.Year = bill.Year;
                                allow.MonthId = bill.MonthId;
                                allow.BillingHeadId = bill.BillingHeadId;
                                allow.Quantity = bill.Quantity;
                                allow.Rate = bill.Rate;
                                allow.TotalAmount = bill.TotalAmount;
                                allow.Status = "A";
                                allow.IsDeleted = false;
                                allow.AddBy = User.Identity.Name;
                                allow.AddDate = DateTime.Now;
                                allow.UpdateBy = User.Identity.Name;
                                allow.UpdateDate = DateTime.Now;
                                allow.SetDate();
                                res = DataAccess.Instance.BillingProcessService.Add(allow);
                            }
                        }

                    }
                    
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
        [Route("Invoice/AddInvoiceProcess")]
        [HttpPost]

        public IHttpActionResult AddInvoiceProcess(List<BillingHeadConfigVM> billingHeadConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (billingHeadConfig != null)
                {

                    bool res = false;
                    string InvNo = "";
                    string ShortName = "";
                    foreach (var bill in billingHeadConfig)
                    {
                        List<BillingProcess> billingProcess = DataAccess.Instance.BillingProcessService.Filter(a => a.ClientId == bill.ClientId && a.BillingHeadId == bill.BillingHeadId && a.Year == bill.Year && a.MonthId == bill.MonthId && a.Rate == bill.Rate && a.TotalAmount == bill.TotalAmount && a.IsDeleted == false).ToList();
                        if (billingProcess.Count < 1)
                        {
                            throw new Exception("Please Save at first.");
                        }

                        List<InvoiceGenerate> billingServicelist = DataAccess.Instance.InvoiceGenerateService.Filter(a => a.ClientId == bill.ClientId && a.BillingHeadId == bill.BillingHeadId && a.Year == bill.Year && a.MonthId == bill.MonthId && a.IsDeleted == false ).ToList();
                        if (billingServicelist.Count > 0)
                        {
                            //throw new Exception("Invoice Already Generated!.");
                            ShortName = bill.ShortName;
                            InvNo = billingServicelist[0].InvoiceNo;
                        }
                        else
                        {
                            if (bill.Quantity > 0 && bill.TotalAmount > 0)
                            {
                                InvoiceGenerate allow = new InvoiceGenerate();
                                //if (ShortName != bill.ShortName)
                                //{
                                //    ShortName = bill.ShortName;
                                //    InvNo = DataAccess.Instance.InvoiceGenerateService.InvoiceNo(bill.ShortName);
                                //}
                                allow.InvoiceNo = "";
                                allow.InvoiceAmount = bill.TotalAmount;
                                allow.ClientId = bill.ClientId;
                                allow.Year = bill.Year;
                                allow.MonthId = bill.MonthId;
                                allow.BillingHeadId = bill.BillingHeadId;
                                allow.Quantity = bill.Quantity;
                                allow.Rate = bill.Rate;
                                allow.TotalAmount = bill.TotalAmount;
                                allow.DueAmount = bill.TotalAmount;
                                allow.IssueDate = DateTime.Now;
                                allow.DueDate = DateTime.Now.AddDays(15);
                                allow.BillingPeriodStart = new DateTime(allow.IssueDate.Year, allow.IssueDate.Month, 1);
                                allow.BillingPeriodEnd = allow.BillingPeriodStart.AddMonths(1).AddDays(-1);
                                allow.Status = "Draft"; 
                                allow.IsDeleted = false;
                                allow.AddBy = User.Identity.Name; 
                                allow.AddDate = DateTime.Now;
                                allow.UpdateBy = User.Identity.Name;
                                allow.UpdateDate = DateTime.Now;
                                allow.SetDate();
                                res = DataAccess.Instance.InvoiceGenerateService.Add(allow);
                            }
                        }
                    }

                    cr.results = res;
                    cr.message = res ? "Process Successfully" : Constant.SAVED_ERROR;

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }



        [Route("Invoice/UpdateBillingProcessPanel")]
        [HttpPut]
        public IHttpActionResult UpdateBillingProcessPanel(BillingHeadConfig billingHeadConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (billingHeadConfig != null)
                {
                    List<BillingHeadConfig> billingHeadConfigList = DataAccess.Instance.BillingHeadConfigService.Filter(a => a.Id != billingHeadConfig.Id && a.IsDeleted == false && a.Status == "A").ToList();

                    if (billingHeadConfigList.Count > 0)
                    {
                        throw new Exception("Billing Head Configure Already Exist.");
                    }
                    BillingHeadConfig data = DataAccess.Instance.BillingHeadConfigService.Filter(p => p.Id == billingHeadConfig.Id).FirstOrDefault();
                    data.BillingHeadType = billingHeadConfig.BillingHeadType;
                    data.Rate = billingHeadConfig.Rate;
                    data.MinAmount = billingHeadConfig.MinAmount;
                    data.MaxAmount = billingHeadConfig.MaxAmount;
                    data.MaskAmount = billingHeadConfig.MaskAmount;
                    data.NoMaskAmount = billingHeadConfig.NoMaskAmount;
                    data.Year = billingHeadConfig.Year;
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.BillingHeadConfigService.Update(data);
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
        [Route("Invoice/ClearProcess")]
        [HttpPost]
        public IHttpActionResult ClearProcess(BillingProcess billingProcess)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                int delte2=0;
                int delte1=0;
                var invoiceProcess = DataAccess.Instance.InvoiceGenerateService.Filter(a => a.ClientId == billingProcess.ClientId && a.BillingHeadId == billingProcess.BillingHeadId && a.Year == billingProcess.Year && a.MonthId == billingProcess.MonthId && a.DueAmount != a.TotalAmount && a.IsDeleted == false).FirstOrDefault();
                if (invoiceProcess != null)
                {
                    throw new Exception("Payment Already Start.");
                }
                if (billingProcess.IsPublish == 0)
                {
                    delte2 = DataAccess.Instance.CommonServices.ExecuteSQL($"DELETE FROM dbo.Invoice_InvoiceGenerate WHERE ClientId = {billingProcess.ClientId} AND BillingHeadId={billingProcess.BillingHeadId} AND Year={billingProcess.Year} AND MonthId ={billingProcess.MonthId}");
                    delte1 = DataAccess.Instance.CommonServices.ExecuteSQL($"DELETE FROM dbo.Invoice_BillingProcess WHERE ClientId = {billingProcess.ClientId} AND BillingHeadId={billingProcess.BillingHeadId} AND Year={billingProcess.Year}AND MonthId ={billingProcess.MonthId}");

                    cmr.httpStatusCode = delte1 > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = delte1 > 0 ? "Process Clear" : Constant.FAILED;
                    return Json(cmr);
                }
                else
                {
                   
                    var param = new object[] { 2, billingProcess.Year, billingProcess.MonthId, billingProcess.ClientId, billingProcess.BillingHeadId, User.Identity.Name };
                    var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("TransactionInsert_Invoice", param);

                    cmr.httpStatusCode = dt.Rows.Count > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = dt.Rows.Count > 0 ? "Process Clear" : Constant.FAILED;
                    return Json(cmr);
                }                                
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [Route("Invoice/PublishProcess")]
        [HttpPost]
        public IHttpActionResult PublishProcess(BillingProcess billingProcess)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var client = DataAccess.Instance.ClientService.Filter(e => e.Id == billingProcess.ClientId).FirstOrDefault();
                if(client.LedgerId == null || client.LedgerId < 1)
                {
                    throw new Exception("Please setup client ledger first.");
                }
                var billingHead = DataAccess.Instance.InvoiceBillingHead.Filter(e => e.Id == billingProcess.BillingHeadId).FirstOrDefault();
                if (billingHead.LedgerId == null || billingHead.LedgerId < 1)
                {
                    throw new Exception("Please setup Billing Head ledger first.");
                }
                var param = new object[] { 1, billingProcess.Year, billingProcess.MonthId, billingProcess.ClientId, billingProcess.BillingHeadId, User.Identity.Name };                            
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("TransactionInsert_Invoice", param);
                cmr.httpStatusCode = dt.Rows.Count > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = dt.Rows.Count > 0 ? "Published" : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        #endregion

        #region Invoice Generate Panel
        [Route("Invoice/GetInvoiceGeneratePanel/{YearID}/{MonthId}/{ClintId}")]
        [HttpGet]

        public IHttpActionResult GetInvoiceGeneratePanel(int? YearID , int? MonthId , int? ClintId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //var dt = DataAccess.Instance.SpecialAllowanceService.Filter(s=>s.EmpId== EmpId && s.YearId == YearId && s.IsDeleted == false).ToList();
                var dt = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { YearID, MonthId , ClintId,DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, 0, 2 });
                List<InvoiceGenerate> requiList = APIUitility.ConvertDataTable<InvoiceGenerate>(dt).ToList();

                foreach (var item in requiList)
                {
                    DataTable dtli = new DataTable();
                    InvoiceGenerate _requi = new InvoiceGenerate();
                    List<InvoiceGenerate> requiProList = new List<InvoiceGenerate>();
                    dtli = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { YearID, MonthId, item.ClientId, item.InvoiceNo, DBNull.Value, DBNull.Value, DBNull.Value, 0, 3 });
                    requiProList = APIUitility.ConvertDataTable<InvoiceGenerate>(dtli).ToList();

                    item.RequList = requiProList;
                }
                cr.results = requiList;

                if (requiList.Count > 0)
                {
                    cr.message = $"{requiList.Count} Data Found.";
                }
                else
                {
                    cr.message = Constant.NOT_FOUND;
                }

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        #endregion

        #region Money Receipt Generate Panel
        [Route("Invoice/GetMoneyReceiptGenerate/{FromDate}/{ToDate}/{ClientId}")]
        [HttpGet]

        public IHttpActionResult GetMoneyReceiptGenerate(string FromDate, string ToDate, int? ClientId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                
                var dt = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { DBNull.Value, DBNull.Value, ClientId, DBNull.Value, FromDate, ToDate, DBNull.Value, 0, 11 });
                 cr.results = dt;

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }


        [Route("Invoice/RollbackCollection")]
        [HttpPost]
        public IHttpActionResult RollbackCollection(InvoiceCollectionDetails rollback)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                var param = new object[] { rollback.MasterID, User.Identity.Name };
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("TransactionRollback_Invoice", param);

                cmr.httpStatusCode = dt.Rows.Count > 0 ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                //cmr.message = dt.Rows.Count > 0 ? "Rollback successfully!" : Constant.FAILED;
                cmr.message ="Rollback successfully!" ;
                return Json(cmr);
                
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        #endregion

        #region Invoice Search Panel
        [Route("Invoice/GetInvoiceSearch/{FromDate}/{ToDate}/{ClientId}/{InvoiceNo}")]
        [HttpGet]

        public IHttpActionResult GetInvoiceSearch(string FromDate, string ToDate, int? ClientId, string InvoiceNo)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                string fromDate = FromDate == "[object Object]" ? "" : FromDate;
                string toDate = FromDate == "[object Object]" ? "" : ToDate;
                string invoiceNo = InvoiceNo == "undefined" ? "" : InvoiceNo;
                var dt = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { DBNull.Value, DBNull.Value, ClientId, invoiceNo, fromDate, toDate, DBNull.Value, 0, 16 });
                cr.results = dt;

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        #endregion
        #region Delete Invoice
        //Update Subject
        [Route("Invoice/UpdateInvoicePrint/")]
        [HttpPut]
        public IHttpActionResult UpdateInvoicePrint(InvoicePrintMaster invoice)  //  invoice
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //  var InvoiceInfo = DataAccess.Instance.InvoicePrintMasterService.Filter(e => e.IsDeleted == false && e.Id != invoice.Id);

                invoice.UpdateBy = User.Identity.Name;
                invoice.SetDate();
                var res = DataAccess.Instance.InvoicePrintMasterService.Update(invoice);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cr);
        }
        [Route("Invoice/InvoiceDelete/{Id}")]
        [HttpDelete]
        public IHttpActionResult InvoiceDelete(int Id) 
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var CheckPaid = DataAccess.Instance.InvoicePrintMasterService.Filter(t => t.Id == Id && t.PaymentStatus== "Paid");
                if (CheckPaid.Any())
                {
                    throw new Exception("Invoice Aleardy Paid!");
                }
                InvoicePrintMaster Adep = new InvoicePrintMaster();
            Adep = DataAccess.Instance.InvoicePrintMasterService.Get(Id);
            Adep.UpdateBy = User.Identity.Name;
            Adep.IsDeleted = true;
            Adep.SetDate();
            var res = DataAccess.Instance.InvoicePrintMasterService.Update(Adep);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
          
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion

        #region Invoice Modification
        [Route("Invoice/GetAllInvoiceModification/")]
        [HttpPost]
        public IHttpActionResult GetAllInvoiceModification(InvoiceGenerate invoiceGenerate)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dt = new DataTable();
                List<InvoiceGenerate> _list = new List<InvoiceGenerate>();
                int Block = 2;
                var param = new object[] {invoiceGenerate.Year ,invoiceGenerate.MonthId,invoiceGenerate.ClientId,DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, 0, Block };
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", param);
                // dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetRequisitionList", param.ToArray());

                List<InvoiceGenerate> requiList = APIUitility.ConvertDataTable<InvoiceGenerate>(dt).ToList();
                foreach (var item in requiList)
                {
                    DataTable dtli = new DataTable();
                    InvoiceGenerate _requi = new InvoiceGenerate();
                    List<InvoiceGenerate> requiProList = new List<InvoiceGenerate>();
                    dtli = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { invoiceGenerate.Year, invoiceGenerate.MonthId, item.ClientId, item.InvoiceNo, DBNull.Value, DBNull.Value, DBNull.Value, 0, 3 });
                    requiProList = APIUitility.ConvertDataTable<InvoiceGenerate>(dtli).ToList();

                    item.RequList = requiProList;
                }

                cr.results = requiList;

                if (requiList.Count > 0)
                {
                    cr.message = $"{requiList.Count} Data Found.";
                }
                else
                {
                    cr.message = Constant.NOT_FOUND;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Invoice/UpdateInvoiceGenerate")]
        [HttpPut]

        public IHttpActionResult UpdateInvoiceGenerate(InvoiceGenerate invoiceGenerate)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (invoiceGenerate != null)
                {

                    bool res = false;
                    // foreach (var bill in invoiceGenerate)
                    //{
                       
                            if (invoiceGenerate.Quantity > 0 && invoiceGenerate.TotalAmount > 0)
                            {
                                InvoiceGenerate allow = DataAccess.Instance.InvoiceGenerateService.Filter(p => p.Id == invoiceGenerate.Id).FirstOrDefault();
                                allow.InvoiceNo = invoiceGenerate.InvoiceNo;
                                allow.InvoiceAmount = invoiceGenerate.TotalAmount;
                                allow.ClientId = invoiceGenerate.ClientId;
                                allow.Year = invoiceGenerate.Year;
                                allow.MonthId = invoiceGenerate.MonthId;
                                allow.BillingHeadId = invoiceGenerate.BillingHeadId;
                                allow.Quantity = invoiceGenerate.Quantity;
                                allow.Rate = invoiceGenerate.Rate;
                                allow.TotalAmount = invoiceGenerate.TotalAmount;
                                allow.IssueDate = invoiceGenerate.IssueDate;
                                allow.DueDate = invoiceGenerate.DueDate;
                                allow.BillingPeriodStart = invoiceGenerate.BillingPeriodStart;
                                allow.BillingPeriodEnd = invoiceGenerate.BillingPeriodEnd;
                                allow.Status = "Draft";
                                allow.IsDeleted = false;
                                allow.AddBy = User.Identity.Name;
                                allow.AddDate = DateTime.Now;
                                allow.UpdateBy = User.Identity.Name;
                                allow.UpdateDate = DateTime.Now;
                                allow.SetDate();
                                res = DataAccess.Instance.InvoiceGenerateService.Update(allow);
                                cr.results = res;
                                cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                            }
                          
                   // }

                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

            return Json(cr);
        }
        [Route("Invoice/SearchInvoiceNo/{SrchText}")]
        [HttpGet]
        public IHttpActionResult SearchInvoiceNo(string SrchText)
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.InvoiceGenerateService.SearchInvoiceNo(SrchText);
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        #endregion
        #region Invoice Payment
        [Route("Invoice/GetAllInvoicePayment/")]
        [HttpPost]
        public IHttpActionResult GetAllInvoicePayment(InvoiceGenerate invoiceGenerate)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dt = new DataTable();
                List<InvoiceGenerate> _list = new List<InvoiceGenerate>();
                int Block = 4;
                var param = new object[] { DBNull.Value, DBNull.Value, invoiceGenerate.ClientId, invoiceGenerate.InvoiceNo, DBNull.Value, DBNull.Value, DBNull.Value,0, Block };
                dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", param);
                // dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetRequisitionList", param.ToArray());

                List<InvoiceGenerate> requiList = APIUitility.ConvertDataTable<InvoiceGenerate>(dt).ToList();
                foreach (var item in requiList)
                {
                    DataTable dtli = new DataTable();
                    InvoiceGenerate _requi = new InvoiceGenerate();
                    List<InvoiceGenerate> requiProList = new List<InvoiceGenerate>();
                    dtli = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { DBNull.Value, DBNull.Value, item.ClientId,item.InvoiceNo , DBNull.Value, DBNull.Value, DBNull.Value,0, 5 });
                    requiProList = APIUitility.ConvertDataTable<InvoiceGenerate>(dtli).ToList();

                    item.RequList = requiProList;
                }

                cr.results = requiList;

                if (requiList.Count > 0)
                {
                    cr.message = $"{requiList.Count} Data Found.";
                }
                else
                {
                    cr.message = Constant.NOT_FOUND;
                }
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
            return Json(cr);
        }
        [Route("Invoice/EditInvoicePaymentByClientId/{ClintId}/{InvoiceNo}")]
        [HttpGet]

        public IHttpActionResult EditInvoicePaymentByClientId(int ClintId, string InvoiceNo)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { DBNull.Value, DBNull.Value, ClintId, InvoiceNo, DBNull.Value, DBNull.Value, DBNull.Value,0, 6 });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Invoice/GetForCollection/")]
        [HttpPost]

        public IHttpActionResult GetForCollection(InvoiceGenerate invoiceGenerate)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { DBNull.Value, DBNull.Value, 0, invoiceGenerate.InvoiceNo, DBNull.Value, DBNull.Value, DBNull.Value, 0, 6 });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Invoice/SaveInvoicePayment/")]
        [HttpPost]

        public IHttpActionResult SaveInvoicePayment(List<InvoiceGenerate> invoiceGenerate)
        {
            CommonResponse cr = new CommonResponse();
            var res = true;
            try
            {
                if (invoiceGenerate != null)
                {
                    List<SqlParameter> param = new List<SqlParameter>();


                    param.Add(new SqlParameter("ClientId ", invoiceGenerate[0].ClientId));
                    param.Add(new SqlParameter("Year", invoiceGenerate[0].Year));
                    param.Add(new SqlParameter("MonthId", invoiceGenerate[0].MonthId));
                    param.Add(new SqlParameter("InvoiceNo ", invoiceGenerate[0].InvoiceNo));
                    param.Add(new SqlParameter("AddBy", User.Identity.Name));
                    param.Add(new SqlParameter("DueDate ", invoiceGenerate[0].NextPaymentDate));
                    param.Add(new SqlParameter("CollectionDate ", invoiceGenerate[0].CollectionDate));

                    DataTable dtt = new DataTable();

                    dtt.Columns.Add("Id", typeof(int));
                    dtt.Columns.Add("Year", typeof(int));
                    dtt.Columns.Add("MonthId", typeof(int));
                    dtt.Columns.Add("BillingHeadId", typeof(int));
                    dtt.Columns.Add("Quantity", typeof(int));
                    dtt.Columns.Add("Rate", typeof(decimal));
                    dtt.Columns.Add("TotalAmount", typeof(decimal)); 
                    dtt.Columns.Add("DueAmount", typeof(decimal)); 
                    dtt.Columns.Add("CollectionAmount", typeof(decimal));
                    dtt.Columns.Add("PaymentMethod", typeof(string));
                    dtt.Columns.Add("ChequeNo", typeof(string));
                    dtt.Columns.Add("AdjustmentAmount", typeof(decimal));
                    dtt.Columns.Add("CollectionNarration", typeof(string)); 
                    dtt.Columns.Add("DiscountAmount", typeof(decimal));
                    dtt.Columns.Add("ExtraCollectionAmount", typeof(decimal));

                    foreach (var item in invoiceGenerate)
                    {if(item.CollectionAmount>0)
                        {
                            dtt.Rows.Add(item.Id, item.Year, item.MonthId, item.BillingHeadId, item.Quantity, item.Rate, item.TotalAmount, item.DueAmount, item.CollectionAmount, item.PaymentMethod, item.ChequeNo, item.AdjustmentAmount, item.CollectionNarration, item.DiscountAmount, item.ExtraCollectionAmount);
                        }
                        
                    }

                    param.Add(Converter.ToSqlParameter("InvoicePayment", dtt, "dbo.UTT_InvoicePayment"));

                    var dt = DataAccess.Instance.CommonServices.GetBySpWithSQLParam("SP_InsertInvoicePayment", param.ToArray());
                    cr.results = dt;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;


                }
                else
                {
                    cr.message = "Data Not Found";
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion
        #region Phone call Maintain
        [Route("Invoice/GetAllPhoneCall/")]
        [HttpGet]
        public IHttpActionResult GetAllPhoneCall()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { 0, 0, 0, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value,0 ,13 });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }

        [Route("Invoice/AddPhoneCall")]
        [HttpPost]
        public IHttpActionResult AddPhoneCall(PhoneCallMaintain phoneCallMaintain)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (phoneCallMaintain != null)
                {
                    //PhoneCallMaintain phoneCallList = DataAccess.Instance.PhoneCallMaintainService.Filter(a => a.ClientId == phoneCallMaintain.ClientId && a.IsDeleted == false && a.Status == "A").FirstOrDefault();

                    //if (phoneCallList != null)
                    //{
                    //    throw new Exception("Invoice Service Already Exist.");
                    //}

                    phoneCallMaintain.Status = "A";
                    phoneCallMaintain.IsDeleted = false;
                    phoneCallMaintain.AddBy = User.Identity.Name;
                    phoneCallMaintain.AddDate = DateTime.Now;
                    phoneCallMaintain.UpdateBy = User.Identity.Name;
                    phoneCallMaintain.UpdateDate = DateTime.Now;
                    phoneCallMaintain.SetDate();
                    var res = DataAccess.Instance.PhoneCallMaintainService.Add(phoneCallMaintain);
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
        [Route("Invoice/UpdatePhoneCall")]
        [HttpPut]
        public IHttpActionResult UpdatePhoneCall(PhoneCallMaintain phoneCallMaintain)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (phoneCallMaintain != null)
                {
                    PhoneCallMaintain data = DataAccess.Instance.PhoneCallMaintainService.Filter(p => p.Id == phoneCallMaintain.Id).FirstOrDefault();
                    data.UpdateBy = User.Identity.Name;
                    data.UpdateDate = DateTime.Now;
                    data.SetDate();
                    var res = DataAccess.Instance.PhoneCallMaintainService.Update(data);
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
        [Route("Invoice/DeletPhoneCall/{id}")]
        [HttpDelete]
        public IHttpActionResult DeletPhoneCall(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                PhoneCallMaintain phoneCallMaintain = new PhoneCallMaintain();
                phoneCallMaintain = DataAccess.Instance.PhoneCallMaintainService.Get(id);
                phoneCallMaintain.UpdateBy = User.Identity.Name;
                phoneCallMaintain.IsDeleted = true;
                phoneCallMaintain.SetDate();

                var resp = DataAccess.Instance.PhoneCallMaintainService.Update(phoneCallMaintain);
                cmr.httpStatusCode = resp ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = resp ? Constant.DELETED : Constant.FAILED;
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        #endregion
        #region Invoice Discount
        [Route("Invoice/GetInvoiceGenerateDisPanel/{YearID}/{MonthId}/{ClintId}/{FilterType}")]
        [HttpGet]

        public IHttpActionResult GetInvoiceGenerateDisPanel(int? YearID, int? MonthId, int? ClintId, int? FilterType)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                
                var dt = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { YearID, MonthId, ClintId, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, FilterType, 2 });
                List<InvoiceGenerate> requiList = APIUitility.ConvertDataTable<InvoiceGenerate>(dt).ToList();

                foreach (var item in requiList)
                {
                    DataTable dtli = new DataTable();
                    InvoiceGenerate _requi = new InvoiceGenerate();
                    List<InvoiceGenerate> requiProList = new List<InvoiceGenerate>();
                    dtli = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { YearID, MonthId, item.ClientId, item.InvoiceNo, DBNull.Value, DBNull.Value, DBNull.Value, FilterType, 15 });
                    requiProList = APIUitility.ConvertDataTable<InvoiceGenerate>(dtli).ToList();

                    item.RequList = requiProList;
                }
                cr.results = requiList;

                if (requiList.Count > 0)
                {
                    cr.message = $"{requiList.Count} Data Found.";
                }
                else
                {
                    cr.message = Constant.NOT_FOUND;
                }

            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Invoice/AddInvoiceDiscount")]
        [HttpPost]
        public IHttpActionResult AddInvoiceDiscount(List<InvoiceGenerate> invoiceDiscount)
        {
            CommonResponse cmr = new CommonResponse();

            try
            {
                bool response = false;
                bool data1 = true;
                foreach (var adata in invoiceDiscount)
                {
                    var data = DataAccess.Instance.InvoiceGenerateService.Filter(p => p.ClientId == adata.ClientId && p.Year==adata.Year && p.MonthId==adata.MonthId && p.InvoiceStatus== "Discount").FirstOrDefault();
                    if (data != null && data1)
                    {
                        int delte1 = DataAccess.Instance.CommonServices.ExecuteSQL($"DELETE FROM dbo.Invoice_InvoiceGenerate WHERE ClientId = {adata.ClientId} AND Year={adata.Year}AND MonthId ={adata.MonthId} AND InvoiceStatus='Discount'");
                        data1 = false;
                    }
                    InvoiceGenerate dataLinkBillingHead = new InvoiceGenerate();
                    dataLinkBillingHead = DataAccess.Instance.InvoiceGenerateService.Filter(p => p.ClientId == adata.ClientId && p.Year == adata.Year && p.MonthId == adata.MonthId && p.BillingHeadId == adata.DiscountlinkBillingHeadId).FirstOrDefault();
                    if (dataLinkBillingHead != null )
                    {
                        if(adata.TotalAmount>dataLinkBillingHead.TotalAmount)
                        {
                            throw new Exception("Discount cannot be greater than billing head amount!");
                        }
                    }
                    else
                    {
                        throw new Exception("Link Billing Head does not match with Billing Head!");
                    }
                    InvoiceGenerate allow = new InvoiceGenerate();
                    allow.ClientId = adata.ClientId;
                    allow.BillingHeadId = adata.BillingHeadId;
                    allow.Year = adata.Year;
                    allow.MonthId = adata.MonthId;
                    allow.Quantity = adata.Quantity;
                    allow.Rate = adata.Rate;
                    allow.DiscountPercentage = adata.DiscountPercentage;
                    allow.TotalAmount = adata.TotalAmount;
                    allow.Description = adata.Description;
                    allow.Status = "Draft";
                    allow.IsDeleted = false;
                    allow.InvoiceStatus = "Discount";
                    allow.AddBy = User.Identity.Name;
                    allow.IssueDate = adata.DueDate; 
                    allow.DueDate = adata.DueDate;
                    allow.BillingPeriodStart = new DateTime(adata.Year, adata.MonthId, 1);
                    allow.BillingPeriodEnd = allow.BillingPeriodStart.AddMonths(1).AddDays(-1);
                    allow.DiscountlinkBillingHeadId = adata.DiscountlinkBillingHeadId;
                    allow.AddDate = DateTime.Now;
                    allow.UpdateBy = User.Identity.Name;
                    allow.UpdateDate = DateTime.Now;
                    allow.SetDate();
                    response = DataAccess.Instance.InvoiceGenerateService.Add(allow);

                }
                cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cmr.message = response ? Constant.SAVED : Constant.FAILED;


            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);

        }
        [Route("Invoice/GetInvoiceDiscountList/{YearID}/{MonthId}/{ClintId}/{FilterType}")]
        [HttpGet]

        public IHttpActionResult GetInvoiceDiscountList(int? YearID, int? MonthId, int? ClintId, int? FilterType)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.BillingHeadConfigService.GetBySpWithParam("SP_GetInvoiceGenerate", new object[] { YearID, MonthId, ClintId, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, FilterType, 14 });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        [Route("Invoice/GetLinkBillingHeadInvoice/{YearID}/{MonthId}/{ClintId}/{BillingHeadId}")]
        [HttpGet]

        public IHttpActionResult GetLinkBillingHeadInvoice(int? YearID, int? MonthId, int? ClintId, int? BillingHeadId)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.InvoiceGenerateService.Filter(p => p.ClientId == ClintId && p.Year == YearID && p.MonthId == MonthId && p.BillingHeadId == BillingHeadId).ToList();
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Count > 0 ? $"{dt.Count} Data Found" : "Data Not Found";
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        #endregion

        #region Search Invoice
        [Route("Invoice/SearchInvoice/{SrchText}")]
        [HttpGet]
        public IHttpActionResult SearchInvoice(string SrchText)
      {

            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = DataAccess.Instance.InvoicePrintMasterService.SearchInvoice(SrchText);
                cr.httpStatusCode = HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);
        }
        #endregion
    }
}



