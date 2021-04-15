using Microsoft.AspNet.Identity;
using OEMS.Api.Providers;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Company;
using OEMS.Models.ViewModel;
using OEMS.Service.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace OEMS.Api.Controllers
{
    public class CommonController : ApiController
    {
        #region CommonDropdown

        [Route("Common/AddDropDown/")]
        [HttpPost]
        public IHttpActionResult AddDropDownConfig(DropDownConfig dropDownConfig)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var data = DataAccess.Instance.DropDownConfig.GetAll();
                //if (data.Where(e=>e.Text==dropDownConfig.Text && e.Type==dropDownConfig.Type).Any())
                //{
                //    throw new Exception("Text Already Exist");
                //}
                //if (data.Where(e => e.Text == dropDownConfig.Value && e.Type == dropDownConfig.Type).Any())
                //{
                //    throw new Exception("Value Already Exist");
                //}

                DropDownConfig oDropDownConfig = new DropDownConfig();
            oDropDownConfig.Text = dropDownConfig.Text;
            oDropDownConfig.Value = dropDownConfig.Value;
            oDropDownConfig.Type = dropDownConfig.Type;            
            var res = DataAccess.Instance.DropDownConfig.Add(oDropDownConfig);  
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            }
            catch (Exception ex)
            {
               return BadRequest(ex.Message);
            }
            return Json(cr);
        }


        [Route("Common/GetDropDown/")]
        [HttpGet]
        public IHttpActionResult GetDropDownConfig()
        {
            CommonResponse res = new CommonResponse();
          
            
            var result = DataAccess.Instance.DropDownConfig.GetAll();
            if (result.Any())
            {
                res.results = result;
                res.message = "Total "+ result.Count();
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Common/DeleteDropdown/")]
        [HttpPost]
        public IHttpActionResult DeleteDropdown(DropDownConfig dropDownConfig)
        {
            CommonResponse res = new CommonResponse();

            var result = DataAccess.Instance.DropDownConfig.Remove(dropDownConfig.Id);
            if (result)
            {
                res.results = result;
                res.httpStatusCode = result ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                res.message = result ? Constant.DELETED : Constant.FAILED;

                return Json(res);
            }
            return BadRequest(Constant.INVAILD_DATA);
        }
        [Route("Common/GetAcademicBranchListWithAll/")]
        [HttpGet]
        public IHttpActionResult GetAcademicBranchListWithAll()
        {

            CommonResponse res = new CommonResponse();
            try
            {

                var result = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAcademicBranchListWithAll", new object[] { });
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
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }

        }
        [Route("Common/UpdateDropDown/")]
        [HttpPost]
        public IHttpActionResult UpdateDropDown(DropDownConfig dropDownConfig)
        {
            CommonResponse res = new CommonResponse();
            try
            {
            var data = DataAccess.Instance.DropDownConfig.Filter(e=>e.Id != dropDownConfig.Id).ToList();
            if (data.Where(e => e.Text == dropDownConfig.Text && e.Type == dropDownConfig.Type).Any())
            {
                throw new Exception("Text Already Exist");
            }
            if (data.Where(e => e.Text == dropDownConfig.Value && e.Type == dropDownConfig.Type).Any())
            {
                throw new Exception("Value Already Exist");
            }
            var result = DataAccess.Instance.DropDownConfig.Update(dropDownConfig);
            if (result)
            {
                res.results = result;
                res.httpStatusCode = result ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                res.message = result ? Constant.UPDATED : Constant.FAILED;
            }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(res);
        }


        //[Route("Common/GetDropDown/{pageno}/{pagesize}/{searchtxt}")]
        //[HttpGet]
        //public IHttpActionResult GetDropDownConfig(int pageno, int pagesize, string searchtxt)
        //{
        //    CommonResponse res = new CommonResponse();
        //    if (!string.IsNullOrEmpty(searchtxt) && searchtxt != "null")
        //    {
        //        res = DataAccess.Instance.DropDownConfig.Filter(pageno, pagesize, e => e.Text.Contains(searchtxt), o => o.OrderByDescending(e => e.Id));

        //    }
        //    else
        //    {
        //        res = DataAccess.Instance.DropDownConfig.getPageResponse(pageno, pagesize);
        //    }

        //    if (res.httpStatusCode == HttpStatusCode.OK)
        //        return Json(res);
        //    return BadRequest(Constant.INVAILD_DATA);
        //}



        [Route("Common/GetTextByType/{pageno}/{pagesize}/{searchType}")]
        [HttpGet]
        public IHttpActionResult GetTextByType(int pageno, int pagesize, string searchType)
        {
            CommonResponse res = new CommonResponse();
            if (!string.IsNullOrEmpty(searchType) && searchType != "null")
            {
                res = DataAccess.Instance.DropDownConfig.Filter(pageno, pagesize, e => e.Type.Contains(searchType), o => o.OrderByDescending(e => e.Id));  
            }
            else
            {
                return BadRequest(Constant.INVAILD_DATA);
            }

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);

        }
        [Route("Common/GetCommonDDByType/{Type}")]
        [HttpGet]
        public IHttpActionResult GetCommonDDByType(string Type)
        {
            CommonResponse res = new CommonResponse();
            if (!string.IsNullOrEmpty(Type) && Type != "null")
            {
                var result = DataAccess.Instance.DropDownConfig.Filter(e => e.Type==Type, o => o.OrderByDescending(e => e.Id));
                if (result.Any())
                {
                    res.results = result;
                    res.httpStatusCode = HttpStatusCode.OK;
                    return Json(res);
                }
                else
                {
                    return BadRequest("Data not found");
                }
               
            }
            else
            {
                return BadRequest(Constant.INVAILD_DATA);
            }
            

        }
        [Route("Common/GetAllDropDown/")]
        [HttpGet]
        public IHttpActionResult GetAllDropDown()
        {
            CommonResponse res = new CommonResponse();          
            var results = DataAccess.Instance.DropDownConfig.GetAll().OrderBy(a=>a.Text);
            //results.OrderBy(a=>a.Text);
            if(results.Any())
            {
                res.results = results;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }                   
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Common/GetCommonItem/")]
        [HttpGet]
        public IHttpActionResult GetCommonItem()
        {
            CommonResponse res = new CommonResponse();
            res = DataAccess.Instance.DropDownConfig.getDataSetResponseBySp("sp_CommonItem"); 
            res.results.Tables[0].TableName = "Branch";
            //res.results.Tables[1].TableName = "ClassInfo";
            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Common/GetAllYear/")]
        [HttpGet]
        public IHttpActionResult GetAllYear()
        {
            CommonResponse res = new CommonResponse();
            res = DataAccess.Instance.DropDownConfig.getDataSetResponseBySp("sp_GetYear");

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Common/GetAllMonth/")]
        [HttpGet]
        public IHttpActionResult GetAllMonth()
        {
            CommonResponse res = new CommonResponse();
            res = DataAccess.Instance.DropDownConfig.getDataSetResponseBySp("sp_GetMonth");

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Common/GetCommonItemForFees/")]
        [HttpGet]
        public IHttpActionResult GetCommonItemForFees()
        {
            CommonResponse cr = new CommonResponse();
            var res = DataAccess.Instance.DropDownConfig.getDataSetResponseBySp("sp_CommonItem");              
            res.results.Tables[0].TableName = "Session";
            res.results.Tables[1].TableName = "ClassInfo";
            res.results.Tables[2].TableName = "Branch";
            res.results.Tables[3].TableName = "Shift";
            res.results.Tables[4].TableName = "Section";
            res.results.Tables[5].TableName = "StuType";
            res.results.Tables[6].TableName = "House";
            var SQL = $"SELECT ISNULL(E.[BranchID],0) AS [BranchID], B.BranchName  FROM [dbo].[Emp_BasicInfo] AS E INNER JOIN Ins_Branch AS B ON E.BranchID = B.BranchId WHERE E.EmpBasicInfoID = (SELECT TOP 1[EmpId] FROM[dbo].[AspNetUsers] WHERE Id = '{User.Identity.GetUserId()}')";
            var branch = DataAccess.Instance.CommonServices.ExecuteSQLQUERY(SQL);
            cr.results = new {CommonItem = res, branch = branch};
            //res.status = Convert.ToInt32(branchId.Rows[0][0]);               
            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(cr);
            return BadRequest(Constant.INVAILD_DATA);
        }
        // Add by azmal
        [Route("Common/GetClassInfoByBranchID/{BranchID}")]
        [HttpGet]
        public IHttpActionResult GetClassInfoByBranchID(int BranchID)
        {
            CommonResponse res = new CommonResponse();

            res.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetClassInfoByBranchID", new object[] { BranchID });

            return Json(res);

        }
        //Common Field for Employee

        [Route("Common/GetCommonItemEmp/")]
        [HttpGet]
        public IHttpActionResult GetCommonItemEmp()
        {
            CommonResponse res = new CommonResponse();
            res = DataAccess.Instance.DropDownConfig.getDataSetResponseBySp("GetCommonItemForEmp");
            res.results.Tables[0].TableName = "Designation";
            res.results.Tables[1].TableName = "Category";
            res.results.Tables[2].TableName = "Department";
            res.results.Tables[3].TableName = "Section";

            res.results.Tables[4].TableName = "Status";
            res.results.Tables[5].TableName = "Subject"; 
            res.results.Tables[6].TableName = "Branch";                 
            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
            return BadRequest(Constant.INVAILD_DATA);
        }






        [Route("SetupInstitution/UpdateDropDownConfig/")]
        [HttpPut]
        public IHttpActionResult UpdateDropDownConfig(DropDownConfig dropDownConfig)
        {
            CommonResponse cr = new CommonResponse();   
            var res = DataAccess.Instance.DropDownConfig.Update(dropDownConfig); 
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED; 
            return Json(cr);
        }



        [Route("SetupInstitution/DeleteDropDownConfig/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteDropDownConfig(int id)
        {
            CommonResponse cr = new CommonResponse();      
            bool res = DataAccess.Instance.DropDownConfig.Remove(id);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;      
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(res);       
            return BadRequest(Constant.INVAILD_DATA);
        }

        #endregion CommonDropdown

        #region District

        [Route("Common/GetDistrict/")]
        [HttpGet]
        public IHttpActionResult GetDistrict()
        {
            CommonResponse res = new CommonResponse();     
            var result = DataAccess.Instance.District.GetAll();     
            if (result.Any())
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }   
            return BadRequest(Constant.INVAILD_DATA);
        }

        #endregion District

        #region PoliceStation

        [Route("Common/GetPoliceStaion/")]
        [HttpGet]
        public IHttpActionResult GetPoliceStaion()
        {
            CommonResponse res = new CommonResponse();
             var result = DataAccess.Instance.PoliceStation.GetAll();
            if (result.Any() )
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }   
            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("Common/GetPoliceStaionByDId/{DistrictId}")]
        [HttpGet]
        public IHttpActionResult GetPoliceStaionByDId(int DistrictId)
        {            
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.PoliceStation.Filter(p=>p.DistrictId == DistrictId).ToList();
            if (result.Count()>0)
            {
                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
               
            return BadRequest(Constant.INVAILD_DATA);
        }

        #endregion PoliceStation

        #region AlertSetting
        [Route("AlertSetting/GetAllAlertSetting/")]
        [HttpGet]
        public IHttpActionResult GetAllAlertSeting()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.AlertSettingService.Filter(c => c.IsDeleted == false).ToList();
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

        [Route("AlertSetting/AddAlertSetting/")]
        [HttpPost]
        public IHttpActionResult AddAlertSetting(AlertSetting alertSetting)
        {
            CommonResponse cmr = new CommonResponse();
            int exist = 0;
            string message = "";

            try
            {
                if (alertSetting.Id == 0)
                {
                    exist = DataAccess.Instance.AlertSettingService.Filter(c => c.AlertType == alertSetting.AlertType && c.IsDeleted == false).Count();
                    message = "Alert Type already Exist..!";
                }

                if (exist <= 0)
                {
                    alertSetting.AddBy = User.Identity.Name;
                    alertSetting.IsDeleted = false;
                    alertSetting.SetDate();
                    var response = DataAccess.Instance.AlertSettingService.Add(alertSetting);
                    cmr.httpStatusCode = response ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = response ? Constant.SAVED : Constant.FAILED;
                }

                else
                {
                    throw new Exception(message);
                }
            }

            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        [Route("AlertSetting/UpdateAlertSetting/")]
        [HttpPut]
        public IHttpActionResult UpdateAlertSetting(AlertSetting alertSetting)
        {
            CommonResponse cmr = new CommonResponse();
            int exist = 0;
            string message = "";
            var alertSettingInfo = DataAccess.Instance.AlertSettingService.Filter(e => e.IsDeleted == false && e.Id == alertSetting.Id).FirstOrDefault();

            try
            {
                if (alertSetting.Id != 0)
                {
                    exist = DataAccess.Instance.AlertSettingService.Filter(c => c.AlertType == alertSetting.AlertType && c.AlertType != alertSettingInfo.AlertType && c.IsDeleted == false).Count();

                    message = "Alert Type already Exist..!";
                }

                if (exist <= 0)
                {
                    alertSettingInfo.UpdateBy = User.Identity.Name;
                    alertSettingInfo.AlertType = alertSetting.AlertType;
                    alertSettingInfo.FromAddress = alertSetting.FromAddress;
                    alertSettingInfo.ToAddress = alertSetting.ToAddress;
                    alertSettingInfo.CCAddress = alertSetting.CCAddress;
                    alertSettingInfo.BCCAddress = alertSetting.BCCAddress;
                    alertSettingInfo.Subject = alertSetting.Subject;
                    alertSettingInfo.DestinationMobileNo = alertSetting.DestinationMobileNo;
                    alertSettingInfo.Body = alertSetting.Body;

                    alertSettingInfo.SetDate();

                    var res = DataAccess.Instance.AlertSettingService.Update(alertSettingInfo);
                    cmr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
                    cmr.message = res ? Constant.UPDATED : Constant.UPDATED_ERROR;
                }

                else
                {
                    throw new Exception(message);
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

            return Json(cmr);
        }

        [Route("AlertSetting/DeleteAlertSetting/{id}")]
        [HttpDelete]
        public IHttpActionResult DeleteAlertSetting(int id)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                AlertSetting alertSetting = new AlertSetting();

                alertSetting = DataAccess.Instance.AlertSettingService.Get(id);
                alertSetting.UpdateBy = User.Identity.Name;
                alertSetting.IsDeleted = true;
                alertSetting.SetDate();

                var resp = DataAccess.Instance.AlertSettingService.Update(alertSetting);
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


        [Route("Common/GetMonth")]
        [HttpGet]
        public IHttpActionResult GetMonth()
        {
            CommonResponse cr = new CommonResponse();
            List<DropDownConfig> months = new List<DropDownConfig>();
            months.Add(new DropDownConfig { Text = "January", Value = "1" });
            months.Add(new DropDownConfig { Text = "February", Value = "2" });
            months.Add(new DropDownConfig { Text = "March", Value = "3" });
            months.Add(new DropDownConfig { Text = "April", Value = "4" });
            months.Add(new DropDownConfig { Text = "May", Value = "5" });
            months.Add(new DropDownConfig { Text = "June", Value = "6" });
            months.Add(new DropDownConfig { Text = "July", Value = "7" });
            months.Add(new DropDownConfig { Text = "August", Value = "8" });
            months.Add(new DropDownConfig { Text = "September", Value = "9" });
            months.Add(new DropDownConfig { Text = "October", Value = "10" });
            months.Add(new DropDownConfig { Text = "November", Value = "11" });
            months.Add(new DropDownConfig { Text = "December", Value = "12" });
            cr.results = months;
            
            cr.httpStatusCode = HttpStatusCode.OK;
            cr.message = Constant.SUCCESS;

            return Json(cr);
        }
    }
}
