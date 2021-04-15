using Microsoft.AspNet.Identity;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Constant;
using OEMS.Models.Model;
using OEMS.Models.Model.Attendance;
using OEMS.Models.Model.Employee;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Models.Model.Student;
using OEMS.Models.Model.TaskManagement;
using OEMS.Models.ViewModel;
using OEMS.Models.ViewModel.Attendance;
using OEMS.Models.ViewModel.Employee;
using OEMS.Models.ViewModel.MobileApps;
using OEMS.Models.ViewModel.TaskManagement;
using OEMS.Repository.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Http;
using UI.Admin.Models.Task;
using static OEMS.Models.Constant.Enums;

namespace MobileApps.Api.Controllers
{
    [Authorize]
    [RoutePrefix("api/Employee")]
    public class EmployeeController : ApiController
    {

        #region EmpBasicInfo

        [Route("dashboard")]
        [HttpGet]
        public IHttpActionResult GetUserInfo()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpDashboardApps dashboard = new EmpDashboardApps();
                var dt = DataAccess.Instance.CommonServices.GetDatasetBySp("SPM_GetDashBoard", User.Identity.GetUserId());
                if (dt.Tables[0].Rows.Count > 0)
                {
                    dashboard = APIUitility.ConvertDataTable<EmpDashboardApps>(dt.Tables[0]).FirstOrDefault();
                    dashboard.DashboardTask = APIUitility.ConvertDataTable<DashboardTask>(dt.Tables[1]).ToList();
                }                
                cr.results = dashboard;
                return Json(dashboard);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message.ToString());
            }
        }
        [Route("EmployeeDepartment")]
        [HttpGet]
        public IHttpActionResult GetEmployeeDepartment()
        {
            var res = DataAccess.Instance.EmpDepartmentService.Filter(e => e.IsDeleted == false , orderBy: e => e.OrderBy(x => x.DisOrder))
                .Select(e => new { e.DepartmentID, e.DepartmentName, e.DisOrder }).ToList();

           return Json(res);
        }
        [Route("EmployeeDirectory/{departmentId}")]
        [HttpGet]
        public IHttpActionResult GetEmployeeDirectory(int departmentId)
        {
            //var res = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.IsDeleted == false && e.Status == "A",orderBy:e=>e.OrderBy(x => x.DisOrder))
            //    .Select(e=> new {e.ShortName,e.FullName,e.MobileNo,e.Email,e.DepartmentName,e.DesignationName }).ToList();
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmpProfileInfo", departmentId);

            var res = APIUitility.ConvertDataTable<EmpBasicInfo>(dt).Select(e => new { e.EmpBasicInfoID, e.ShortName, e.FullName, e.MobileNo, e.Email, e.DepartmentName, e.DesignationName, e.EmpID });
            return Json(res);
        }

        [Route("EmployeeImage")]
        [HttpGet]
        public IHttpActionResult EmployeeImage()
        {
            var res = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.IsDeleted == false && e.Status == "A", orderBy: e => e.OrderBy(x => x.DisOrder))
               .Select(e => new { e.EmpID, e.FullName, e.Image }).ToList();

            return Json(res);
        }
        [Route("ImageByEmpId/{empId}")]
        [HttpGet]
        public IHttpActionResult ImageByEmpId(int empId)
        {
            var url = "output.jpg";
            var res = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.IsDeleted == false && e.Status == "A" && e.EmpBasicInfoID == empId).FirstOrDefault().Image;

            using (Image image = Image.FromStream(new MemoryStream(res)))
            {
                image.Save("output.jpg", ImageFormat.Jpeg);  // Or Png
            }
            return Json(url);
        }
        [Route("GetEmpDetailsByEmpId/{EmpBasicInfoID}")]
        [HttpGet]
        public IHttpActionResult GetEmpDetailsByEmpId(int EmpBasicInfoID)
        {
            CommonRepository commonRepository = new CommonRepository();
            EmployeeVM EmpVM = new EmployeeVM();
            //var userid = User.Identity.GetUserId();
            //var EmpId = DataAccess.Instance.Users.Filter(e => e.Id == userid).FirstOrDefault().EmpId;
            DataSet dt = commonRepository.getDatasetResponseBySp("GetEmpInfoDetailID", new object[] { EmpBasicInfoID }).results;
            if (dt != null)
            {
                EmpVM.EmpBasicInfo = CommonRepository.ConvertDataTable<EmpBasicInfo>(dt.Tables[0]).FirstOrDefault();
                EmpVM.EmpImage = CommonRepository.ConvertDataTable<EmpImage>(dt.Tables[1]).FirstOrDefault();
                EmpVM.EmpJobHistory = CommonRepository.ConvertDataTable<EmpJobHistory>(dt.Tables[2]);
                EmpVM.EmployeeEducationalInfo = CommonRepository.ConvertDataTable<EmployeeEducationalInfo>(dt.Tables[3]);
                EmpVM.EmpNominee = CommonRepository.ConvertDataTable<EmpNominee>(dt.Tables[4]);
                EmpVM.EmpTraining = CommonRepository.ConvertDataTable<EmpTraining>(dt.Tables[5]);
            }
            return Json(EmpVM);
        }

        [Route("UpdateProfileImg")]
        [HttpPost]
        public IHttpActionResult UpdateProfileImg()
        {
            var img = HttpContext.Current.Request.Files.Count > 0 ?
            HttpContext.Current.Request.Files[0] : null;
            CommonResponse cr = new CommonResponse();
            var userName = User.Identity.GetUserName();
            var user = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == userName).FirstOrDefault();
            if (img != null)
            {
                MemoryStream target = new MemoryStream();
                img.InputStream.CopyTo(target);
                user.Image = target.ToArray();
            }
            var result = DataAccess.Instance.EmpBasicInfoService.Update(user);
            cr.message = result ? Constant.SUCCESS : Constant.UPDATED_ERROR;
            return Json(cr);
        }
        [Route("UpdateProfileImgByte")]
        [HttpPost]
        public IHttpActionResult UpdateProfileImgByte(EmployeeImageVM empimage)
        {
            //var img = HttpContext.Current.Request.Files.Count > 0 ?
            //HttpContext.Current.Request.Files[0] : null;
            var img = empimage.Photo;
            CommonResponse cr = new CommonResponse();
            var userName = User.Identity.GetUserName();
            var user = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == userName).FirstOrDefault();
            if (img != null)
            {
                //MemoryStream target = new MemoryStream();
                //img.InputStream.CopyTo(target);
                user.Image = img; //target.ToArray();
            }
            var result = DataAccess.Instance.EmpBasicInfoService.Update(user);
            cr.message = result ? Constant.SUCCESS : Constant.UPDATED_ERROR;
            return Json(cr);
        }


        #endregion

        #region Attendance

        [Route("Attendance/{empId}")]
        [HttpGet]
        public IHttpActionResult GetAttendance(int empId)
        {
            var fromDate = DataAccess.Instance.EmpAttendanceService.Filter(e => e.IsDeleted == false && e.EmpId == empId).FirstOrDefault().InTime;
            var toDate = DateTime.Now;

            List<SqlParameter> param = new List<SqlParameter>();

            param.Add(new SqlParameter("@EmpId", empId));
            param.Add(new SqlParameter("@FromDate", fromDate));
            param.Add(new SqlParameter("@ToDate", toDate));

            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SPM_GetEmpAttendance", param.ToArray());

            var res = APIUitility.ConvertDataTable<EmpAttendancevm>(dt);

            return Json(res);
        }
        [Route("MonthlyAttendance/{EmpId}/{Month}/{Year}")]
        [HttpGet]
        public IHttpActionResult GetMonthlyAttendance(int EmpId, int Month, int Year)
        {
            //Month = 1;
            List<EmpAttendancevm> attList = new List<EmpAttendancevm>();
            var FromDate = new DateTime(Year, Month, 1);
            var ToDate = FromDate.AddMonths(1).AddDays(-1);
            var month = DateTime.Now.Month;
            var year = DateTime.Now.Year;

            if (month == Month && year == Year)
            {
                ToDate = DateTime.Now;
            }
            if(Month > month && Year >= year) ///Future data not show
            {
                return Json(attList);
            }
            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@EmpId", EmpId));
            param.Add(new SqlParameter("@FromDate", FromDate));
            param.Add(new SqlParameter("@ToDate", ToDate));        
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SPM_GetEmpAttendance", param.ToArray());
            attList = APIUitility.ConvertDataTable<EmpAttendancevm>(dt);
            return Json(attList);
        }

        [HttpGet]
        [Route("GetEmpLeaveBalance")]
        public IHttpActionResult GetEmpLeaveBalance()
        {
            CommonResponse cr = new CommonResponse();
            int EmpBasicInfoId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);

            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@Block", 4));
            param.Add(new SqlParameter("@EmpBasicInfoId", EmpBasicInfoId));
            param.Add(new SqlParameter("@LeaveCategoryId", 0));
            param.Add(new SqlParameter("@LeaveId", 0));
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_EmpLeaveForMobile", param.ToArray());
            cr.results = dt;
            return Json(cr);
        }
        [HttpGet]
        [Route("GetEmpLeaveBalanceByCatagory/{LeaveCategoryId}")]
        public IHttpActionResult GetEmpLeaveBalanceByCatagory(int LeaveCategoryId)
        {
            CommonResponse cr = new CommonResponse();
            int EmpBasicInfoId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);

            List<SqlParameter> param = new List<SqlParameter>();
            param.Add(new SqlParameter("@Block", 1));
            param.Add(new SqlParameter("@EmpBasicInfoId", EmpBasicInfoId));
            param.Add(new SqlParameter("@LeaveCategoryId", LeaveCategoryId));
            param.Add(new SqlParameter("@LeaveId", 0));
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_EmpLeaveForMobile", param.ToArray());
            cr.results = dt;
            return Json(cr);
        }

        [Route("LeaveRequestStatus/{LeaveId}")]
        [HttpGet]
        public IHttpActionResult LeaveRequestStatus(int LeaveId)
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 3));
                param.Add(new SqlParameter("@EmpBasicInfoId", 0));
                param.Add(new SqlParameter("@LeaveCategoryId", 0));
                param.Add(new SqlParameter("@LeaveId", LeaveId));

                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_EmpLeaveForMobile", param.ToArray());
                cmr.results = dt;
                cmr.message = dt.Rows.Count > 0 ? dt.Rows.Count + " Data Found." : Constant.NOT_FOUND;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cmr);
        }

        [Route("ModifyEmpAttendance")]
        [HttpPost]
        public IHttpActionResult ModifyEmpAttendance(EmpRosterVM empRoster)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                if (empRoster.EmpRequestId > 0 && empRoster.AttendId > 0)
                {
                    EmpAttendance empAttendance = DataAccess.Instance.EmpAttendanceService.Filter(e => e.IsDeleted == false && e.AttendId == empRoster.AttendId).FirstOrDefault();
                    if (empAttendance != null)
                    {
                        empAttendance.EmpRequestId = empRoster.EmpRequestId;
                        empAttendance.Reason = empRoster.Reason;
                        empAttendance.IsChangedStatus = false;
                    }
                    var res = DataAccess.Instance.EmpAttendanceService.Update(empAttendance);
                    cr.message = res ? Constant.UPDATED : Constant.FAILED;
                }

            }
            catch (Exception ex)
            {
                return Json(ex.Message.ToString());
            }
            return Json(cr);
        }

        #endregion


        #region Request

        [Route("AddLeaveRequest")]
        [HttpPost]
        public IHttpActionResult AddRequest(EmpRequest empRequest)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                string CC = string.Empty;
                var EmpId = DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId;
                var EmpInfo = DataAccess.Instance.EmpBasicInfoService.Get(Convert.ToInt64( EmpId));
                var isLeaveQuataExists = DataAccess.Instance.CommonServices.IsExist("HR_EmpLeaveQuota", $" EmpId = {EmpId} AND IsDeleted = 0 AND RoutingId <> 0");
                if (!isLeaveQuataExists)
                {
                    throw new Exception("Your Leave Quota is not Set, Please Contact with HR/Administrator");
                }
                if (empRequest.RequestType == 5)
                {
                    if (empRequest.LeaveTypeCategory == "FD")
                    {
                        empRequest.FromDate = Convert.ToDateTime(empRequest.From);
                        empRequest.ToDate = Convert.ToDateTime(empRequest.To);
                    }
                    else
                    {
                        empRequest.FromDate = Convert.ToDateTime(empRequest.HalfDayDate);
                        empRequest.ToDate = Convert.ToDateTime(empRequest.HalfDayDate);
                    }
                    var dates = new List<DateTime>();

                    for (var dt = empRequest.FromDate; dt <= empRequest.ToDate; dt = dt.AddDays(1))
                    {
                        dates.Add(dt);
                    }                  
                }             
                if (empRequest != null)
                {                    
                    empRequest.Date = DateTime.Now;
                    empRequest.EmpId = Convert.ToInt32(EmpId);
                    empRequest.UpdateBy = User.Identity.Name;
                    empRequest.UpdateDate = DateTime.Now;
                    empRequest.IsDeleted = false;
                    empRequest.Status = LeaveStatus.Pending.ToString();
                    empRequest.SetDate();
                    empRequest.AddBy = User.Identity.Name;
                    empRequest.AddDate = DateTime.Now;
                    var res = DataAccess.Instance.EmpRequestService.Add(empRequest);
                    var id = empRequest.Id;

                    if (empRequest.Id > 0)
                    {                       
                        List<SqlParameter> param = new List<SqlParameter>();
                        param.Add(new SqlParameter("@LeaveId", empRequest.Id));
                        param.Add(new SqlParameter("@AddBy", User.Identity.Name));
                        param.Add(new SqlParameter("@IP", empRequest.IP));
                        param.Add(new SqlParameter("@MacAddress", empRequest.MacAddress));

                        var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_LeaveRoutingHistory", param.ToArray());
                        CC = dt.Rows[0][0].ToString();
                    }

                    if (res)
                    {
                        int hour = DateTime.Now.Hour;
                        CommunicationService.SendEmail(Enums.EMAILTYPE.LEAVEAPPLY.ToString(), CC: CC, Prams: new string[] { EmpInfo.FullName, hour < 12 ? "Morning" : "Afternoon" });
                        cr.message = Constant.SAVED;
                    }
                    else {
                        cr.message = Constant.SAVED_ERROR;
                    }
               
                }
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
                return Json(cr);
            }
            return Json(cr);
        }

        [HttpGet]
        [Route("GetAllRequestList/")]
        public IHttpActionResult GetAllRequestList()
        {

            try
            {
                int EmpId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRequestList", new object[] { EmpId, 9 });
                List<EmpRequestVM> list = CommonRepository.ConvertDataTable<EmpRequestVM>(dt);
                return Json(list);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }


        }
        [HttpGet]
        [Route("GetLeaveRequestList/")]
        public IHttpActionResult GetLeaveRequestList()
        {

            try
            {
                int EmpId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);
                DataTable dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetEmployeeRequestList", new object[] { EmpId, 5 });
                List<EmpRequestVM> list = CommonRepository.ConvertDataTable<EmpRequestVM>(dt);
                return Json(list);
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message.ToString());
            }
        }

        [Route("EmpLeaveDetails/{empId}")]
        [HttpGet]
        public IHttpActionResult EmpLeaveDetails(int empId)
        {

            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("EmpLeaveDetails", empId);
            var res = APIUitility.ConvertDataTable<EmpLeaveDetailsVM>(dt)[0];
            return Json(res);
        }

        [Route("EmpRequestAttachment/{reqId}")]
        [HttpGet]
        public IHttpActionResult EmpRequestAttachment(int reqId)
        {
            CommonResponse cr = new CommonResponse();
            var file = DataAccess.Instance.EmpRequestService.Filter(e => e.Id == reqId && e.IsDeleted == false).FirstOrDefault().File;
            if (file == null)
            {
                return BadRequest();
            }
            cr.results = file;             
            return Json(cr);
        }


        [HttpDelete]
        [Route("DeleteRequest/{Id}")]
        public IHttpActionResult DeleteRequest(int Id)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var dt = DataAccess.Instance.CommonServices.ExecuteSQLQUERY(@"SELECT LH.* FROM  HR_LeaveRoutingHistory LH INNER JOIN HR_LeaveRoutingConfigDetails RD ON RD.DetailsId = LH.RoutingId 
                                                                        WHERE  LH.LeaveId = " + Id +" AND RD.IsMandatory = 1 AND(LH.IsApprove = 1 OR LH.IsReject = 1)");
                if(dt.Rows.Count > 0)
                {
                    throw new Exception("Your Leave Application Already Received. ");
                }
                var res = DataAccess.Instance.EmpRequestService.Remove(Id);
                cr.message = res ? Constant.DELETED : Constant.DELETE_ERROR;
            }
            catch (Exception ex)
            {
                 cr.message = ex.Message;
            }
            return Json(cr);
        }
        #endregion

        #region Dashboard

        [Route("GetNoticDocumentList/")]
        [HttpGet]
        public IHttpActionResult GetNoticDocumentList()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                //var userName = User.Identity.GetUserName();
                //int branchid = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID == userName).FirstOrDefault().BranchID;
                var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetNoticDocumentList", new object[] { 1, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value });
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);

        }

        [Route("AddEmpGPS")]
        [HttpPost]
        public IHttpActionResult AddEmpGPS(EmpGPS empGPS)
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                EmpGPS empgps = new EmpGPS();
                empgps.GPSId = Guid.NewGuid();
                empgps.GPSDate = Convert.ToDateTime(empGPS.GPSDate);
                empgps.EmpId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);
                empgps.UserId = User.Identity.GetUserId();
                empgps.Addressline = empGPS.Addressline;
                empgps.Coordinate = empGPS.Coordinate;
                empgps.CountryCode = empGPS.CountryCode;
                empgps.CountryName = empGPS.CountryName;
                empgps.FeatureName = empGPS.FeatureName;
                empgps.Locality = empGPS.Locality;
                empgps.PostalCode = empGPS.PostalCode;
                empgps.AdminArea = empGPS.AdminArea;
                empgps.SubadminArea = empGPS.SubadminArea;
                empgps.SubLocality = empGPS.SubLocality;
                empgps.Throughfare = empGPS.Throughfare;
                empgps.SubThroughfare = empGPS.SubThroughfare;
                empgps.SetDate();
                empgps.IsDeleted = false;
                empgps.AddBy = User.Identity.Name;
                empgps.AddDate = DateTime.Now;

                bool res = DataAccess.Instance.EmpGPSService.Add(empgps);
                cr.message = res ? Constant.SAVED : Constant.SAVED_ERROR;
            }
            catch (Exception ex)
            {
                return Json(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("GetEmpGPS")]
        [HttpGet]
        public IHttpActionResult GetEmpGPS()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var empId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);
                var dt = DataAccess.Instance.CommonServices.ExecuteSQLQUERY(@"SELECT EB.FullName, EG.* FROM Emp_GPS EG LEFT JOIN Emp_BasicInfo EB ON  EB.EmpBasicInfoID = EG.EmpId WHERE EG.EmpId =" + empId + " ORDER BY EG.AddDate DESC");
                cr.results = dt;
                cr.httpStatusCode = HttpStatusCode.OK;
                cr.message = dt.Rows.Count > 0 ? $"{dt.Rows.Count} Data Found" : "Data Not Found";
                return Json(cr);
            }
            catch (Exception ex)
            {
                cr.httpStatusCode = HttpStatusCode.BadRequest;
                cr.message = ex.Message.ToString();
            }
            return Json(cr);

        }


        [Route("GetEmpLeaveModify")]
        [HttpGet]
        public IHttpActionResult GetEmpLeaveModify()
        {
            CommonResponse cr = new CommonResponse();
            try
            {
                var res = DataAccess.Instance.EmpLeaveModifyService.Filter(e => e.IsDeleted == false && e.IsEmployee == true).Select(i => new { i.Id, i.Title }).ToList();
                cr.results = res;
                cr.message = res.Count > 0 ? Constant.SUCCESS : Constant.FAILED;
            }
            catch (Exception ex)
            {
                return Json(ex.Message.ToString());
            }
            return Json(cr);
        }

        [Route("GetAllLeaveCategory")]
        [HttpGet]
        public IHttpActionResult GetAllLeaveCategory()
        {
            CommonResponse cmr = new CommonResponse();
            try
            {
                cmr.results = DataAccess.Instance.LeaveCategoryService.Filter(e => e.IsDeleted == false, o => o.OrderByDescending(e => e.Id)).ToList();
                return Json(cmr);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Route("GetEmpCalendarList")]
        [HttpGet]
        public IHttpActionResult GetEmpCalendarList()
        {

            CommonResponse cr = new CommonResponse();
            try
            {
                int EmpBasicInfoId = Convert.ToInt32(DataAccess.Instance.Users.Filter(e => e.UserName == User.Identity.Name).FirstOrDefault().EmpId);

                List<SqlParameter> param = new List<SqlParameter>();
                param.Add(new SqlParameter("@Block", 2));
                param.Add(new SqlParameter("@EmpBasicInfoId", 0));
                param.Add(new SqlParameter("@LeaveCategoryId", 0));
                param.Add(new SqlParameter("@LeaveId", 0));
                DataTable results = DataAccess.Instance.CommonServices.GetBySpWithParam("SP_EmpLeaveForMobile", param.ToArray());
                cr.results = results;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            return Json(cr);
        }
        #endregion




    }
}