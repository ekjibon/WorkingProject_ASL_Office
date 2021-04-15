using Microsoft.AspNet.Identity;
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
using OEMS.Models.Model.SMS;
using System.Text;
using System.Text.RegularExpressions;
using OEMS.Models.Model.Employee;
using OfficeOpenXml;
using OEMS.Models.ViewModel.SMS;

namespace OEMS.Api.Controllers
{
    public class SMSController : ApiController
    {
        [Route("SMS/FirstSave/")]
        [HttpPost]
        public IHttpActionResult FirstSave()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var data = DataAccess.Instance.SMSSettingsService.GetAll().FirstOrDefault();
                if (data == null)
                {
                    SMSSettings setting = new SMSSettings();
                    setting.NoSMSPart = 0;
                    setting.AllowUnicode = false;
                    setting.ForStudent = false;
                    setting.ForEmployee = false;
                    setting.IsSMSNumber = false;
                    setting.IsFatherNumber = false;
                    setting.IsMotherNumber = false;
                    DataAccess.Instance.SMSSettingsService.Add(setting);
                }
                cr.results = DataAccess.Instance.SMSSettingsService.GetAll().FirstOrDefault();
                cr.httpStatusCode = cr.results != null ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = cr.results != null ? Constant.SUCCESS : Constant.FAILED;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Json(cr);
        }
        [HttpPut]
        [Route("SMS/UpdateSmsPart")]
        public IHttpActionResult UpdateSmsPart(SMSSettings Sms)
        {
            CommonResponse cr = new CommonResponse();
            var result = DataAccess.Instance.SMSSettingsService.Update(Sms);
            cr.results = result;
            if (result)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.SAVED;
            }
            else
                return BadRequest("Something Wrong");
            return Json(cr);

        }
        [Route("SMS/SaveTemplate/")]
        [HttpPost]
        public IHttpActionResult SaveTemplate(SMSTemplate SmsTemplate)
        {
            CommonResponse cr = new CommonResponse();
            //Check Exist Report Config
            if (DataAccess.Instance.SMSTemplateService.GetAll().ToList().Where(e => e.Title == SmsTemplate.Title).Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.DUPLICATE;
                return Json(cr);
            }
            // Add Report Config
            bool results = DataAccess.Instance.SMSTemplateService.Add(SmsTemplate);
            if (results)
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.SAVED;
            }
            else
                return BadRequest();
            return Json(cr);
        }
        [Route("SMS/GetTemplateByCategory/{CategoryID}")]
        [HttpGet]
        public IHttpActionResult GetTemplateByCategory(int CategoryID)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.SMSTemplateService.Filter(e => e.BodyType == 2 && e.CategoryId == CategoryID && e.IsDeleted == false).ToList();
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = res.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("SMS/GetAllSettings/")]
        [HttpGet]
        public IHttpActionResult GetAllSettings()
        {
            CommonResponse res = new CommonResponse();
            var results = DataAccess.Instance.SMSSettingsService.GetAll();
            if (results.Any())
            {
                res.results = results;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("SMS/GetSMSBalance/")]
        [HttpGet]
        public IHttpActionResult GetSMSBalance()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = CommunicationService.GetCustomerInfo();
                cr.results = res;
                return Json(cr);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("SMS/SMSRecharge/{NoOfSMS}")]
        [HttpPost]
        public IHttpActionResult SMSRecharge(string NoOfSMS)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                cr.results = CommunicationService.SMSRecharge(NoOfSMS);
                cr.httpStatusCode = HttpStatusCode.OK;
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("SMS/GetAllTempTag/")]
        [HttpGet]
        public IHttpActionResult GetAllTempTag()
        {
            CommonResponse res = new CommonResponse();
            var results = DataAccess.Instance.SMSTempTagService.GetAll();
            if (results.Any())
            {
                res.results = results.ToList();
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("SMS/GetAllGroupNumbers/{groupId}")]
        [HttpGet]
        public IHttpActionResult GetAllGroupNumbers( int groupId)
        {
            CommonResponse res = new CommonResponse();
            var results = DataAccess.Instance.SMSExtNumbersService.GetAll().Where(e=>e.GroupId==groupId).ToList();
            if (results.Any())
            {
                res.results = results;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("SMS/GetAllSMSTemplates/")]
        [HttpGet]
        public IHttpActionResult GetAllSMSTemplates()
        {
            // Get all Templates
            CommonResponse res = new CommonResponse();
            List<SMSTemplate> lstTemplate = new List<SMSTemplate>();
            var result = DataAccess.Instance.SMSTemplateService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.TemplateId)).ToList();
            // var result2 = DataAccess.Instance.DropDownConfig.Filter(e=>e.Type=="SMSCategory").ToList();
            // var result = (from s in result1 join p in result2 on s.CategoryId equals Int32.Parse(p.Value) select new { s.Title,s.TempType,s.BodyType,s.CategoryId,s.SMSPart,s.SMSLen,s.SMSBody,p.Text,s.isUnicode}).ToList();
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

        [Route("SMS/UpdateTemplate/")]
        [HttpPut]
        public IHttpActionResult UpdateTemplate(SMSTemplate template)
        {
            // Update Template
            CommonResponse cr = new CommonResponse();
            try
            {
                var Template = DataAccess.Instance.SMSTemplateService.Filter(e => e.IsDeleted == false && e.TemplateId != template.TemplateId);

                if (Template.Where(e => e.Title == template.Title).Any())
                {
                    throw new Exception("Template Name " + template.Title + " Aleardy Exit");
                }
                template.UpdateBy = User.Identity.Name;
                template.SetDate();
                var res = DataAccess.Instance.SMSTemplateService.Update(template);
                cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("SMS/DeleteTemplate/")]
        [HttpPost]
        public IHttpActionResult DeleteTemplate(SMSTemplate template)
        {
            // Delete Branch ID
            CommonResponse cr = new CommonResponse();
            try
            {
                bool res = DataAccess.Instance.SMSTemplateService.Remove(template.TemplateId);
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
        [Route("SMS/GetStaticTemplate/")]
        [HttpGet]
        public IHttpActionResult GetStaticTemplate()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.SMSTemplateService.Filter(e => e.BodyType == 1 && e.IsDeleted == false).ToList();
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = res.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("SMS/GetSMSCategorySeed/")]
        [HttpGet]
        public IHttpActionResult GetSMSCategorySeed()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                IDictionary<int, string> dict = new Dictionary<int, string>();
                dict.Add(1, "STUDENT");
                dict.Add(2, "EMPLOYEE");
                dict.Add(3, "Absent SMS");
                dict.Add(4, "Period Wise Absent");
                dict.Add(5, "FEES DUE");
                dict.Add(6, "FEES COLLECTION");
                dict.Add(7, "MAIN EXAM");
                dict.Add(9, "Absconding SMS");
                cr.results = dict.ToList();
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dict.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("SMS/GetStudentListForSms/")]
        [HttpPost]
        public IHttpActionResult GetStudentListForSms(StudentFilterForSms Sfs)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dtResult = new DataTable();
                List<StudentForDynamicSms> sms = new List<StudentForDynamicSms>();

                #region WHERE
                StringBuilder whereClause = new StringBuilder();
                whereClause.Append(" SMSNotificationNo IS NOT NULL AND SB.IsDeleted = 0 AND SB.Status = 'A' ");
                if (Sfs.StudentIID > 0)
                {
                    whereClause.Append(" AND  SB.StudentIID  = " + Sfs.StudentIID + " ");
                }
                else
                {
                   
                    if (!string.IsNullOrWhiteSpace(Sfs.Session.Trim(',')))
                    {
                        whereClause.Append("  AND  SB.SessionId  IN (" + Sfs.Session.Trim(',') + ") ");
                    }
                    if (!string.IsNullOrWhiteSpace(Sfs.Branch))
                    {
                        if (!string.IsNullOrWhiteSpace(Sfs.Branch.Trim(',')))
                        {
                            whereClause.Append("  AND  SB.BranchID  IN (" + Sfs.Branch.Trim(',') + ")  ");
                        }
                    }
                    if (!string.IsNullOrWhiteSpace(Sfs.Shift))
                    {

                        if (!string.IsNullOrWhiteSpace(Sfs.Shift.Trim(',')))
                    {
                        whereClause.Append("  AND  SB.ShiftID  IN (" + Sfs.Shift.Trim(',') + ")  ");
                    }
                    }
                    if (!string.IsNullOrWhiteSpace(Sfs.Class))
                        {
                            if (!string.IsNullOrWhiteSpace(Sfs.Class.Trim(',')))
                    {
                        whereClause.Append("  AND  SB.ClassId  IN (" + Sfs.Class.Trim(',') + ")  ");
                    }
                    }
                            if (!string.IsNullOrWhiteSpace(Sfs.Section))
                                {
                                    if (!string.IsNullOrWhiteSpace(Sfs.Section.Trim(',')))
                    {
                        whereClause.Append("  AND  SB.SectionId  IN (" + Sfs.Section.Trim(',') + ")  ");
                    }
                            }
                            if (!string.IsNullOrWhiteSpace(Sfs.StuType))
                                    {
                                        if (!string.IsNullOrWhiteSpace(Sfs.StuType.Trim()))
                    {
                        whereClause.Append("  AND  SB.StudentTypeID  IN (" + Sfs.StuType.Trim(',') + ")  ");
                    }
                            }
                            if (!string.IsNullOrWhiteSpace(Sfs.House))
                                        {
                                            if (!string.IsNullOrWhiteSpace(Sfs.House.Trim()))
                    {
                        whereClause.Append("  AND  SB.HouseID  IN (" + Sfs.House.Trim(',') + ")  ");
                    }
                            }
                        }

                #endregion WHERE

                if (Sfs.FunctionType == 1)
                {
                    object[] Param = new object[] { 1, whereClause.ToString(), Sfs.SMSBody, null, null, null, null };
                    dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForDynamicSMS", Param);
                    sms = Api.APIUitility.ConvertDataTable<StudentForDynamicSms>(dtResult);
                    cr.results = sms;
                }
                else if (Sfs.FunctionType == 3)    //Absent SMS
                {
                    if (!string.IsNullOrWhiteSpace(Sfs.StartDate.Trim()) && !string.IsNullOrWhiteSpace(Sfs.EndDate.Trim()))
                    {
                        object[] Param = new object[] { 3, whereClause.ToString(), Sfs.SMSBody, Sfs.StartDate.Trim(), Sfs.EndDate.Trim(), null, null };
                        dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForDynamicSMS", Param);
                        sms = Api.APIUitility.ConvertDataTable<StudentForDynamicSms>(dtResult);
                        cr.results = sms;
                    }
                    else
                    {
                        return BadRequest("Start or End Date Can not left blank");
                    }

                }
                else if (Sfs.FunctionType == 4)     //Absent Period SMS
                {
                    if (!string.IsNullOrWhiteSpace(Sfs.StartDate.Trim()) && !string.IsNullOrWhiteSpace(Sfs.EndDate.Trim()))
                    {
                        object[] Param = new object[] { 4, whereClause.ToString(), Sfs.SMSBody, Sfs.StartDate.Trim(), Sfs.EndDate.Trim(), null, null };
                        dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForDynamicSMS", Param);
                        sms = Api.APIUitility.ConvertDataTable<StudentForDynamicSms>(dtResult);
                        cr.results = sms;
                    }
                    else
                    {
                        return BadRequest("Start or End Date Can not left blank");
                    }
                }
                else if (Sfs.FunctionType == 5)    //Fees Due
                {
                    if (Sfs.FeesHead > 0 || Sfs.TotalDue == true)
                    {
                        StringBuilder fsy = new StringBuilder();
                        fsy.Append("FS.IsDeleted = 0 ");
                        if (!string.IsNullOrWhiteSpace(Sfs.Month.Trim(',')))
                        {
                            fsy.Append("  AND  FS.MonthId  IN (" + Sfs.Month.Trim(',') + ")  ");
                        }
                        if (!string.IsNullOrWhiteSpace(Sfs.Session.Trim(',')))
                        {
                            fsy.Append("  AND  FS.SessionId  IN (" + Sfs.Session.Trim(',') + ")  ");
                        }
                        StringBuilder fsy2 = new StringBuilder();
                        if (!string.IsNullOrWhiteSpace(Sfs.Month.Trim(',')))
                        {
                            fsy2.Append(" 0=0 AND FS.FeesMonthId  IN (" + Sfs.Month.Trim(',') + ")  ");
                        }
                        object[] Param = new object[] { 5, whereClause.ToString(), Sfs.SMSBody, fsy2.ToString(), fsy.ToString(), Sfs.FeesHead, Sfs.TotalDue };
                        dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForFeesDynamicSMS", Param);
                        sms = Api.APIUitility.ConvertDataTable<StudentForDynamicSms>(dtResult);
                        cr.results = sms;
                    }
                    else
                    {
                        return BadRequest("Fees Head or Total Due Can not left blank");
                    }
                }
                else if (Sfs.FunctionType == 6)   //Fees Collection
                {
                    if (Sfs.FeesHead > 0 || Sfs.TotalCollection == true)
                    {
                        StringBuilder fsy = new StringBuilder();
                        fsy.Append("FS.IsDeleted = 0 ");
                        if (!string.IsNullOrWhiteSpace(Sfs.Month.Trim(',')))
                        {
                            fsy.Append("  AND  FS.MonthId  IN (" + Sfs.Month.Trim(',') + ")  ");
                        }
                        if (!string.IsNullOrWhiteSpace(Sfs.Session.Trim(',')))
                        {
                            fsy.Append("  AND  FS.SessionId  IN (" + Sfs.Session.Trim(',') + ")  ");
                        }
                        StringBuilder fsy2 = new StringBuilder();
                        if (!string.IsNullOrWhiteSpace(Sfs.Month.Trim(',')))
                        {
                            fsy2.Append(" 0=0 AND FS.FeesMonthId  IN (" + Sfs.Month.Trim(',') + ")  ");
                        }
                        object[] Param = new object[] { 6, whereClause.ToString(), Sfs.SMSBody, fsy2.ToString(), fsy.ToString(), Sfs.FeesHead, Sfs.TotalCollection };
                        dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForFeesDynamicSMS", Param);
                        sms = Api.APIUitility.ConvertDataTable<StudentForDynamicSms>(dtResult);
                        cr.results = sms;
                    }
                    else
                    {
                        return BadRequest("Fees Head or Total Collection Can not left blank");
                    }
                }
                else if (Sfs.FunctionType == 7)   //Main Exam Result
                {
                    if (Sfs.MainExamId > 0 && Sfs.OverAllResult > 0)
                    {
                        object[] Param = new object[] { 7, whereClause.ToString(), Sfs.SMSBody, null, null, Sfs.MainExamId, Sfs.OverAllResult };
                        dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForDynamicSMS", Param);
                        sms = Api.APIUitility.ConvertDataTable<StudentForDynamicSms>(dtResult);
                        cr.results = sms;
                    }
                    else
                    {
                        return BadRequest("Main Exam or Over All Result can not left blank");
                    }
                }
                else if (Sfs.FunctionType == 8)   //Main Exam Result
                {
                    if (Sfs.GrandExamId > 0 && Sfs.OverAllResult > 0)
                    {
                        object[] Param = new object[] { 8, whereClause.ToString(), Sfs.SMSBody, null, null, Sfs.GrandExamId, Sfs.OverAllResult };
                        dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForDynamicSMS", Param);
                        sms = Api.APIUitility.ConvertDataTable<StudentForDynamicSms>(dtResult);
                        cr.results = sms;
                    }
                    else
                    {
                        return BadRequest("Grand Exam or Over All Result can not left blank");
                    }
                }
                else if (Sfs.FunctionType == 9)    //Abosconding SMS
                {
                    if (!string.IsNullOrWhiteSpace(Sfs.StartDate.Trim()) && !string.IsNullOrWhiteSpace(Sfs.EndDate.Trim()))
                    {
                        object[] Param = new object[] { 9, whereClause.ToString(), Sfs.SMSBody, Sfs.StartDate.Trim(), Sfs.EndDate.Trim(), null, null };
                        dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForDynamicSMS", Param);
                        sms = Api.APIUitility.ConvertDataTable<StudentForDynamicSms>(dtResult);
                        cr.results = sms;
                    }
                    else
                    {
                        return BadRequest("Start or End Date Can not left blank");
                    }

                }
                cr.httpStatusCode = sms.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = sms.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("SMS/GetEmployeeListForSms/")]
        [HttpPost]
        public IHttpActionResult GetEmployeeListForSms(StudentFilterForSms Sfs)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                DataTable dtResult = new DataTable();
                List<EmployeeForDynamicSms> sms = new List<EmployeeForDynamicSms>();
                #region WHERE
                StringBuilder whereClause = new StringBuilder();
                whereClause.Append("EB.IsDeleted=0 AND EB.Status='A' ");
                if (!string.IsNullOrWhiteSpace(Sfs.EmpID))
                {
                    whereClause.Append(" AND  EB.EmpID  = '" + Sfs.EmpID + "' ");
                }
                else
                {
                    if (Sfs.BranchID > 0)
                    {
                        whereClause.Append(" AND  EB.BranchID  = " + Sfs.BranchID + " ");
                    }
                    if (Sfs.EmpDesignation > 0)
                    {
                        whereClause.Append(" AND  EB.DesignationID  = " + Sfs.EmpDesignation + " ");
                    }
                    if (Sfs.EmpCategory > 0)
                    {
                        whereClause.Append(" AND  EB.CategoryID  = " + Sfs.EmpCategory + " ");
                    }
                }
                #endregion WHERE

                if (Sfs.FunctionType == 2)
                {
                    object[] Param = new object[] { 2, whereClause.ToString(), Sfs.SMSBody, null, null, null, null };
                    dtResult = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForDynamicSMS", Param);
                    sms = Api.APIUitility.ConvertDataTable<EmployeeForDynamicSms>(dtResult);
                    cr.results = sms;
                }
                cr.httpStatusCode = sms.Any() ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                cr.message = sms.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [HttpPost]
        [Route("SMS/SendStudentDynamicSMS/{CategoryId}/{TemplateId}")]
        public IHttpActionResult SendStudentDynamicSMS(List<StudentForDynamicSms> BulkSMS, int CategoryId, int TemplateId)
        {
            CommonResponse cr = new CommonResponse();
            bool res = false;
            //var sms = DataAccess.Instance.SMSTemplateService.GetAll().Where(e => e.TemplateId == TemplateId).FirstOrDefault();
            var smsSettings = DataAccess.Instance.SMSSettingsService.GetAll().FirstOrDefault();
            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    List<SMSSendHistroy> smsHistory = new List<SMSSendHistroy>();
                    if (smsSettings.IsSMSNumber == true)
                    {
                        BulkSMS = BulkSMS.Where(e => e.IsSms == true).ToList();
                        foreach (var item in BulkSMS)
                        {
                            SMSSendHistroy SMSSendHistroy = new SMSSendHistroy();

                            SMSSendHistroy.StudentIId = item.StudentIID;
                            SMSSendHistroy.ReceiveNumber = item.DestinationNumber;
                            SMSSendHistroy.TemplateId = TemplateId;
                            SMSSendHistroy.CategoryId = CategoryId;
                            SMSSendHistroy.SMSBody = item.SmsBody;
                            SMSSendHistroy.SMSPart = item.NoOfSms;
                            SMSSendHistroy.SMSLength = item.SmsLength;
                            SMSSendHistroy.SMSTypeId = 2;
                            SMSSendHistroy.AddBy = User.Identity.Name;
                            SMSSendHistroy.SendDateTime = DateTime.Now;
                            SMSSendHistroy.Status = "A";
                            SMSSendHistroy.SendStatus = 2;
                            SMSSendHistroy.SetDate();
                            var sendSMS = CommunicationService.SendSMSTosmstant(item.DestinationNumber, item.SmsBody);
                            if (sendSMS.FirstOrDefault().StatusCode == 1)
                            {
                                SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                                res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                                if (!res) throw new Exception("SMS History Not Save");
                            }
                        }
                    }
                    scope.Complete();
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Successfully Send";
                }
            }
            catch (TransactionAbortedException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (ApplicationException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [HttpPost]
        [Route("SMS/SendEmployeeDynamicSMS/{CategoryId}/{TemplateId}")]
        public IHttpActionResult SendEmployeeDynamicSMS(List<EmployeeForDynamicSms> BulkSMS, int CategoryId, int TemplateId)
        {
            CommonResponse cr = new CommonResponse();
            bool res = false;
            //var sms = DataAccess.Instance.SMSTemplateService.GetAll().Where(e => e.TemplateId == TemplateId).FirstOrDefault();
            var smsSettings = DataAccess.Instance.SMSSettingsService.GetAll().FirstOrDefault();
            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    List<SMSSendHistroy> smsHistory = new List<SMSSendHistroy>();
                    if (smsSettings.IsSMSNumber == true)
                    {
                        BulkSMS = BulkSMS.Where(e => e.IsSms == true).ToList();
                        foreach (var item in BulkSMS)
                        {
                            SMSSendHistroy SMSSendHistroy = new SMSSendHistroy();

                            SMSSendHistroy.StudentIId = item.EmpBasicInfoID;
                            SMSSendHistroy.ReceiveNumber = item.DestinationNumber;
                            SMSSendHistroy.TemplateId = TemplateId;
                            SMSSendHistroy.CategoryId = CategoryId;
                            SMSSendHistroy.SMSBody = item.SmsBody;
                            SMSSendHistroy.SMSPart = item.NoOfSms;
                            SMSSendHistroy.SMSLength = item.SmsLength;
                            SMSSendHistroy.SMSTypeId = 2;
                            SMSSendHistroy.AddBy = User.Identity.Name;
                            SMSSendHistroy.AddDate = DateTime.Now;
                            SMSSendHistroy.SendDateTime = DateTime.Now;
                            SMSSendHistroy.Status = "A";
                            SMSSendHistroy.SendStatus = 2;
                            SMSSendHistroy.SetDate();
                            var sendSMS = CommunicationService.SendSMSTosmstant(item.DestinationNumber, item.SmsBody);
                            if (sendSMS.FirstOrDefault().StatusCode == 1)
                            {
                                SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                                res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                                if (!res) throw new Exception("SMS History Not Save");
                            }
                        }
                    }
                    scope.Complete();
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Successfully Send";
                }
            }
            catch (TransactionAbortedException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (ApplicationException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            return Json(cr);

        }

        [Route("SMS/SearchStudent/")]
        [HttpPost]
        public IHttpActionResult SearchStudenForStaticSMS(StudentFilter f)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            /// Create SQL Parameter for query , field value  will be 0 if no need to query on this
            var param = new object[] { f.SessionId, f.BranchID, f.ShiftID, f.ClassId, f.SectionId, null };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetStudentInfoForStaticSMS", param);
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
        [Route("SMS/StudentSMSHistory/")]
        [HttpPost]
        public IHttpActionResult StudentSMSHistory(StudentSMSHistory f)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            DateTime _startDate = Converter.ToDateTime(f.StartDate, "101");
            DateTime _endDate = Converter.ToDateTime(f.EndDate, "101");
       
            var param = new object[] { _startDate, _endDate, f.BodyType,f.CategoryID, f.SessionId, f.BranchID, f.ShiftID, f.ClassId,f.StudentIID };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetStudentSMSHistory", param);
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
        [Route("SMS/EmployeeSMSHistory/")]
        [HttpPost]
        public IHttpActionResult EmployeeSMSHistory(EmployeeSMSHistory f)
        {
            CommonResponse cr = new CommonResponse();
            System.Data.DataTable dt = new System.Data.DataTable();
            DateTime _startDate = Converter.ToDateTime(f.StartDate, "101");
            DateTime _endDate = Converter.ToDateTime(f.EndDate, "101");
            var param = new object[] { _startDate, _endDate, f.BodyType, f.CategoryID, f.BranchID };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetEmployeeSMSHistory", param);
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
        [Route("SMS/GetStudentByID/{id}/{startDate}/{endDate}")]
        [HttpGet]
        public IHttpActionResult GetStudentByID(int id,string startDate, string endDate)
        {
            CommonResponse cr = new CommonResponse();
            DateTime _startDate = Converter.ToDateTime(startDate, "101");
            DateTime _endDate = Converter.ToDateTime(endDate, "101");
            StudentBasicInfo studentBasicInfo = new StudentBasicInfo();
            studentBasicInfo = DataAccess.Instance.StudentBasicInfo.Filter(e => e.StudentIID == id && e.IsDeleted == false).FirstOrDefault();
            System.Data.DataTable dt = new System.Data.DataTable();
            
            var param = new object[] { _startDate, _endDate, 0,0,  studentBasicInfo.SessionId, studentBasicInfo.BranchID, studentBasicInfo.ShiftID, studentBasicInfo.ClassId,studentBasicInfo.StudentIID };
            dt = DataAccess.Instance.CommonServices.GetBySpWithParam("rptGetStudentSMSHistory", param);
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
        [HttpPost]
        [Route("SMS/SendBulkSMS/")]
        public IHttpActionResult SendBulkSMS(SendBulkSMSVM vm)
        {
            CommonResponse cr = new CommonResponse();
            SMSTemplate SMSTemplate = new SMSTemplate();
            bool res = false;
            if (vm.TemplateId == 0)
            {
                SMSTemplate.Title = "Draft_" + DateTime.Now;
                SMSTemplate.SMSPart = vm.SMSPart;
                SMSTemplate.TempType = "1";
                SMSTemplate.SMSLen = vm.length;
                SMSTemplate.SMSBody = vm.SMSBody;
                SMSTemplate.BodyType = 1;
                SMSTemplate.IsDeleted = false;
                DataAccess.Instance.SMSTemplateService.Add(SMSTemplate);
                vm.TemplateId = DataAccess.Instance.SMSTemplateService.Filter(e => e.IsDeleted == false).Last().TemplateId;
            }
            var sms = DataAccess.Instance.SMSTemplateService.GetAll().Where(e => e.TemplateId == vm.TemplateId).FirstOrDefault();
            var smsSettings = DataAccess.Instance.SMSSettingsService.GetAll().FirstOrDefault();
            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    List<SMSSendHistroy> smsHistory = new List<SMSSendHistroy>();
                    if (smsSettings.IsSMSNumber == true)
                    {
                        foreach (var item in vm.BulkSMS)
                        {
                            SMSSendHistroy SMSSendHistroy = new SMSSendHistroy();
                            SMSSendHistroy.StudentIId = item.StudentIID;
                            SMSSendHistroy.ReceiveNumber = item.SMSNotificationNo;
                            SMSSendHistroy.TemplateId = sms.TemplateId;
                            SMSSendHistroy.CategoryId = DataAccess.Instance.SMSTemplateService.Filter(e => e.TemplateId == sms.TemplateId).FirstOrDefault().CategoryId;
                            SMSSendHistroy.SMSBody = sms.SMSBody;
                            SMSSendHistroy.SMSPart = sms.SMSPart;
                            SMSSendHistroy.SMSLength = sms.SMSLen;
                            SMSSendHistroy.SMSTypeId = sms.BodyType;
                            SMSSendHistroy.AddBy = User.Identity.Name;
                            SMSSendHistroy.AddDate = DateTime.Now;
                            SMSSendHistroy.SendDateTime = DateTime.Now;
                            SMSSendHistroy.Status = "A";
                            SMSSendHistroy.SendStatus = 2;
                            SMSSendHistroy.SetDate();
                            var sendSMS = CommunicationService.SendSMSTosmstant(item.SMSNotificationNo, sms.SMSBody);
                            if (sendSMS.FirstOrDefault().StatusCode == 1)
                            {
                                SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                                res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                                if (!res) throw new Exception("SMS History Not Save");
                            }
                        }
                    }
                    if (smsSettings.IsFatherNumber == true)
                    {
                        foreach (var item in vm.BulkSMS)
                        {
                            SMSSendHistroy SMSSendHistroy = new SMSSendHistroy();

                            SMSSendHistroy.StudentIId = item.StudentIID;
                            SMSSendHistroy.ReceiveNumber = item.F_Mobile;
                            SMSSendHistroy.TemplateId = sms.TemplateId;
                            SMSSendHistroy.CategoryId = sms.CategoryId;
                            SMSSendHistroy.SMSBody = sms.SMSBody;
                            SMSSendHistroy.SMSPart = sms.SMSPart;
                            SMSSendHistroy.SMSLength = sms.SMSLen;
                            SMSSendHistroy.SMSTypeId = sms.BodyType;
                            SMSSendHistroy.AddBy = User.Identity.Name;
                            SMSSendHistroy.AddDate = DateTime.Now;
                            SMSSendHistroy.SendDateTime = DateTime.Now;
                            SMSSendHistroy.Status = "A";
                            SMSSendHistroy.SendStatus = 2;
                            SMSSendHistroy.SetDate();
                            var sendSMS = CommunicationService.SendSMSTosmstant(item.F_Mobile, sms.SMSBody);
                            if (sendSMS.FirstOrDefault().StatusCode == 1)
                            {
                                SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                                res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                                if (!res) throw new Exception("SMS History Not Save");
                            }
                        }
                    }
                    if (smsSettings.IsMotherNumber == true)
                    {
                        foreach (var item in vm.BulkSMS)
                        {
                            SMSSendHistroy SMSSendHistroy = new SMSSendHistroy();
                            SMSSendHistroy.StudentIId = item.StudentIID;
                            SMSSendHistroy.ReceiveNumber = item.M_Mobile;
                            SMSSendHistroy.TemplateId = sms.TemplateId;
                            SMSSendHistroy.CategoryId = sms.CategoryId;
                            SMSSendHistroy.SMSBody = sms.SMSBody;
                            SMSSendHistroy.SMSPart = sms.SMSPart;
                            SMSSendHistroy.SMSLength = sms.SMSLen;
                            SMSSendHistroy.SMSTypeId = sms.BodyType;
                            SMSSendHistroy.AddBy = User.Identity.Name;
                            SMSSendHistroy.AddDate = DateTime.Now;
                            SMSSendHistroy.SendDateTime = DateTime.Now;
                            SMSSendHistroy.Status = "A";
                            SMSSendHistroy.SendStatus = 2;
                            SMSSendHistroy.SetDate();
                            var sendSMS = CommunicationService.SendSMSTosmstant(item.M_Mobile, sms.SMSBody);
                            if (sendSMS.FirstOrDefault().StatusCode == 1)
                            {
                                SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                                res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                                if (!res) throw new Exception("SMS History Not Save");
                            }
                        }
                    }
                    scope.Complete();
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Successfully Send";
                }
            }
            catch (TransactionAbortedException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (ApplicationException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [HttpPost]
        [Route("SMS/SendBulkSMSExcel/{TemplateId}/{SmsLength}/{SmsPart}/{Body}")]
        public IHttpActionResult SendBulkSMSExcel(List<StudentFilterForStaticSms> BulkSMS, int TemplateId, int SmsLength, int SmsPart, string Body)
        {
            CommonResponse cr = new CommonResponse();
            SMSTemplate SMSTemplate = new SMSTemplate();
            bool res = false;
            if (TemplateId == 0)
            {
                SMSTemplate.Title = "Draft_" + DateTime.Now;
                SMSTemplate.SMSPart = SmsPart;
                SMSTemplate.TempType = "1";
                SMSTemplate.SMSLen = SmsLength;
                SMSTemplate.SMSBody = Body;
                SMSTemplate.BodyType = 1;
                SMSTemplate.IsDeleted = false;
                DataAccess.Instance.SMSTemplateService.Add(SMSTemplate);
                TemplateId = DataAccess.Instance.SMSTemplateService.Filter(e => e.IsDeleted == false).Last().TemplateId;
            }
            var sms = DataAccess.Instance.SMSTemplateService.GetAll().Where(e => e.TemplateId == TemplateId).FirstOrDefault();
            var smsSettings = DataAccess.Instance.SMSSettingsService.GetAll().FirstOrDefault();
            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    List<SMSSendHistroy> smsHistory = new List<SMSSendHistroy>();
                    foreach (var item in BulkSMS)
                    {
                        SMSSendHistroy SMSSendHistroy = new SMSSendHistroy();
                        SMSSendHistroy.ReceiveNumber = item.SMSNotificationNo;
                        SMSSendHistroy.TemplateId = sms.TemplateId;
                        SMSSendHistroy.CategoryId = sms.CategoryId;
                        SMSSendHistroy.SMSBody = sms.SMSBody;
                        SMSSendHistroy.SMSPart = sms.SMSPart;
                        SMSSendHistroy.SMSLength = sms.SMSLen;
                        SMSSendHistroy.SMSTypeId = sms.BodyType;
                        SMSSendHistroy.AddBy = User.Identity.Name;
                        SMSSendHistroy.AddDate = DateTime.Now;
                        SMSSendHistroy.SendDateTime = DateTime.Now;
                        SMSSendHistroy.Status = "A";
                        SMSSendHistroy.SendStatus = 2;
                        SMSSendHistroy.SetDate();
                        var sendSMS = CommunicationService.SendSMSTosmstant(item.SMSNotificationNo, sms.SMSBody);
                        if (sendSMS.FirstOrDefault().StatusCode == 1)
                        {
                            SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                            res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                            if (!res) throw new Exception("SMS History Not Save");
                        }
                    }

                    scope.Complete();
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Successfully Send";
                }
            }
            catch (TransactionAbortedException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (ApplicationException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            return Json(cr);

        }
        [HttpPost]
        [Route("SMS/SendBulkSMSEmp/")]
        public IHttpActionResult SendBulkSMSEmp(SendBulkSMSVM vm)
        {
            CommonResponse cr = new CommonResponse();
            SMSTemplate SMSTemplate = new SMSTemplate();
            bool res = false;
            if (vm.TemplateId == 0)
            {
                SMSTemplate.Title = "Draft_" + DateTime.Now;
                SMSTemplate.SMSPart = vm.SMSPart;
                SMSTemplate.TempType = "2";
                SMSTemplate.SMSLen = vm.length;
                SMSTemplate.SMSBody = vm.SMSBody;
                SMSTemplate.BodyType = 1;
                SMSTemplate.IsDeleted = false;
                DataAccess.Instance.SMSTemplateService.Add(SMSTemplate);
                vm.TemplateId = DataAccess.Instance.SMSTemplateService.Filter(e => e.IsDeleted == false).Last().TemplateId;
            }
            var sms = DataAccess.Instance.SMSTemplateService.GetAll().Where(e => e.TemplateId == vm.TemplateId).FirstOrDefault();
            var smsSettings = DataAccess.Instance.SMSSettingsService.GetAll().FirstOrDefault();
            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    foreach (var item in vm.EMPBulkSMS)
                    {
                        SMSSendHistroy SMSSendHistroy = new SMSSendHistroy();

                        SMSSendHistroy.EmpId = item.EmpBasicInfoID;
                        SMSSendHistroy.ReceiveNumber = item.SMSNotificationNo;
                        SMSSendHistroy.TemplateId = sms.TemplateId;
                        SMSSendHistroy.CategoryId = sms.CategoryId;
                        SMSSendHistroy.SMSBody = sms.SMSBody;
                        SMSSendHistroy.SMSPart = sms.SMSPart;
                        SMSSendHistroy.SMSLength = sms.SMSLen;
                        SMSSendHistroy.SMSTypeId = sms.BodyType;
                        SMSSendHistroy.AddBy = User.Identity.Name;
                        SMSSendHistroy.AddDate = DateTime.Now;
                        SMSSendHistroy.SendDateTime = DateTime.Now;
                        SMSSendHistroy.Status = "A";
                        SMSSendHistroy.SendStatus = 2;
                        SMSSendHistroy.SetDate();
                        var sendSMS = CommunicationService.SendSMSTosmstant(item.SMSNotificationNo, sms.SMSBody);
                        if (sendSMS.FirstOrDefault().StatusCode == 1)
                        {
                            SMSSendHistroy.JobId = sendSMS.FirstOrDefault().MsgId;
                            res = DataAccess.Instance.SMSSendHistroyService.Add(SMSSendHistroy);
                            if (!res) throw new Exception("SMS History Not Save");
                        }
                    }
                    scope.Complete();
                    cr.httpStatusCode = HttpStatusCode.OK;
                    cr.message = "Successfully Send";
                }
            }
            catch (TransactionAbortedException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (ApplicationException ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                cr.message = ex.Message.ToString();
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                return BadRequest(ex.Message);
            }
            return Json(cr);

        }
        [Route("SMS/StuBulkSMSExcel/")]
        [HttpPost]
        public IHttpActionResult StuBulkSMSExcel()
        {
            try
            {
                CommonResponse cr = new CommonResponse();
                int rCount = 0;
                string currFilePath = string.Empty;
                string currFileExtension = string.Empty;
                var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files["excel"] : null;

                string fileName = file.FileName;
                string tempPath = System.IO.Path.GetTempPath();    //Point 1 Get Temporary File Path
                fileName = System.IO.Path.GetFileName(fileName);  //Point 2 Get File Name (not including path)
                currFileExtension = System.IO.Path.GetExtension(fileName);   //Point 3 Get File Extension
                currFilePath = tempPath + fileName; // Get File Path after Uploading and Record to Former Declared Global Variable
                if (File.Exists(currFilePath))
                {
                    File.Delete(currFilePath);
                }
                file.SaveAs(currFilePath);  //Upload



                using (var package = new ExcelPackage(file.InputStream))
                {

                    var workSheet = package.Workbook.Worksheets["BulkStudentForID"];
                    var noOfRow = workSheet.Dimension.End.Row;
                    List<object> results = new List<object>();
                    for (int i = 2; i <= noOfRow; i++)
                    {
                        string Name = workSheet.Cells[i, 1].Value != null ? workSheet.Cells[i, 1].Value.ToString() : string.Empty;
                        string SMS = workSheet.Cells[i, 2].Value != null ? '0' + workSheet.Cells[i, 2].Value.ToString() : string.Empty;
                        results.Add(new { Name = Name, SMS = SMS });
                        rCount++;
                    }
                    cr.results = results;
                }
                cr.message = rCount + " Records Found.";
                return Json(cr);
            }
            catch (Exception ex)
            {
                throw ex;

            }
        }
        [Route("SMS/SaveSMSGroup/{SmsGroupName}")]
        [HttpPost]
        public IHttpActionResult SaveSMSGroup(List<ExternalNumbersFilter> Numbers, string SmsGroupName)
        {
            SMSExtGroup SMSExtGroup = new SMSExtGroup();
            SMSExtNumbers SMSExtNumbers = new SMSExtNumbers();
            CommonResponse cr = new CommonResponse();
            if (DataAccess.Instance.SMSExtGroupService.GetAll().ToList().Where(e => e.GroupName == SmsGroupName).Any())
            {
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = Constant.DUPLICATE;
                return Json(cr);
            }
            SMSExtGroup.GroupName = SmsGroupName;
            DataAccess.Instance.SMSExtGroupService.Add(SMSExtGroup);
            var GroupId = DataAccess.Instance.SMSExtGroupService.Filter(e => e.IsDeleted == false).Last().GroupId;
            foreach (var item in Numbers)
            {
                SMSExtNumbers.GroupId = GroupId;
                SMSExtNumbers.FullName = item.Name;
                SMSExtNumbers.ReceiveNumber = item.SMS;
                DataAccess.Instance.SMSExtNumbersService.Add(SMSExtNumbers);
            }
            cr.httpStatusCode = HttpStatusCode.OK;
            cr.message = Constant.SAVED;
            return Json(cr);
        }
        [Route("SMS/GetSMSGroup/")]
        [HttpGet]
        public IHttpActionResult GetSMSGroup()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.SMSExtGroupService.Filter(e=>e.IsDeleted == false).ToList();
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = res.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        #region
        [Route("SMS/AddUpdateScheduleSMSConfig/")]
        [HttpPost]
        public IHttpActionResult AddUpdateScheduleSMSConfig(ScheduleSMSConfig ScheduleSMSConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {

                if (ScheduleSMSConfig.ConfigId == 0)
                {
                    ScheduleSMSConfig.RunTime = ScheduleSMSConfig.Hours.ToString("00")+":"+ ScheduleSMSConfig.Min.ToString("00");
                    ScheduleSMSConfig.IsDeleted = false;
                    ScheduleSMSConfig.AddBy = User.Identity.Name;
                    ScheduleSMSConfig.Status = "A";
                    ScheduleSMSConfig.SetDate();
                    var res = DataAccess.Instance.ScheduleSMSConfigService.Add(ScheduleSMSConfig);
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
                }
                else
                {
                    var oScheduleSMSConfig = DataAccess.Instance.ScheduleSMSConfigService.Filter(e => e.IsDeleted == false && e.Status == "A" && e.ConfigId == ScheduleSMSConfig.ConfigId).FirstOrDefault();
                    oScheduleSMSConfig.CategoryId = ScheduleSMSConfig.CategoryId;
                    oScheduleSMSConfig.Body = ScheduleSMSConfig.Body;
                    oScheduleSMSConfig.Recipent = ScheduleSMSConfig.Recipent;
                    oScheduleSMSConfig.RunTime = ScheduleSMSConfig.RunTime;
                    oScheduleSMSConfig.IsDeleted = false;
                    oScheduleSMSConfig.UpdateBy = User.Identity.Name;
                    oScheduleSMSConfig.Status = "A";
                    oScheduleSMSConfig.SetDate();
                    var res = DataAccess.Instance.ScheduleSMSConfigService.Update(oScheduleSMSConfig);
                    cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        [Route("SMS/GetScheduleSMSConfig/")]
        [HttpGet]
        public IHttpActionResult GetScheduleSMSConfig()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.ScheduleSMSConfigService.Filter(e => e.IsDeleted == false && e.Type=="S" ).ToList();
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = res.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("SMS/GetAutoSMSConfig/")]
        [HttpGet]
        public IHttpActionResult GetAutoSMSConfig()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.ScheduleSMSConfigService.Filter(e => e.IsDeleted == false && e.Type == "A").ToList();
                cr.results = res;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = res.Any() ? Constant.SUCCESS : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        #endregion 
    }
}
