using OEMS.Api.Providers;
using OEMS.AppData;
using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Account;
using OEMS.Models.ViewModel;
using OEMS.Service.Services;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Microsoft.AspNet.Identity;
using System.Data;

namespace OEMS.Api.Controllers
{
   // [ApiAuth]
    public class UserController : ApiController
    {
        #region Roles
        [Route("user/AddRole/{RoleName}")]
        [HttpPost]
        public IHttpActionResult AddRole(string  RoleName)
        {
            CommonResponse cr = new CommonResponse();

            AspNetRole aspNetRole = new AspNetRole();
            aspNetRole.Name = RoleName;
            aspNetRole.Id = Guid.NewGuid().ToString(); /// Point 1 Set GUID as Role ID
            RoleService Role = new RoleService();
            var res = Role.Add(aspNetRole);
          
                cr.httpStatusCode = res? HttpStatusCode.OK:HttpStatusCode.BadRequest;
                cr.message = res? Constant.SAVED:Constant.FAILED;
           
            return Json(cr);
        }

        [Route("user/UpdateRole/{RoleName}/{id}")]
        [HttpPut]
        public IHttpActionResult UpdateRole(string RoleName,string id)
        {
            CommonResponse cr = new CommonResponse();

            AspNetRole aspNetRole = new AspNetRole();
            aspNetRole.Name = RoleName;
            aspNetRole.Id =id;
            RoleService Role = new RoleService();
            var res = Role.Update(aspNetRole); // Point  1 Update User Role

            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;



            return Json(cr);
        }

        [Route("user/Roles/{pageno}/{pagesize}/{searchtxt}")]
        [HttpGet]
        public IHttpActionResult Roles(int pageno,int pagesize,string searchtxt)
        {
            CommonResponse res = new CommonResponse();
            if (!string.IsNullOrEmpty(searchtxt)&&searchtxt!="null") // Point 1 Serach By text
            {
                res = DataAccess.Instance.Role.Filter(pageno, pagesize,e=>e.Name.Contains(searchtxt),o=>o.OrderByDescending(e=>e.Id));

            }
            else
            {
                res = DataAccess.Instance.Role.getPageResponse(pageno, pagesize); // Point 2 Serach By Pagination
            }

            

            if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);



            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("user/GetAllRoles/")]
        [HttpGet]
        public IHttpActionResult GetAllRoles()
        {
            CommonResponse res = new CommonResponse();
            res.results = DataAccess.Instance.Role.GetAll().ToList();

           //var res = DataAccess.Instance.PageRole
                return Json(res);
            
           
        }
        [Route("User/GetRolesByUserId/{UserId}")]
        [HttpGet]
        public IHttpActionResult GetRolesByUserId(string UserId)
        {
            CommonResponse res = new CommonResponse();
            // = DataAccess.Instance.Role.GetAll().ToList();
            res.results = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAssignRoleList", new object[] { UserId });
            return Json(res);
            
        }

        [Route("User/AddUserRole/")]
        [HttpPost]
        public IHttpActionResult AddUserRole(List<UserRoleVM> userRoles)
        {
            CommonResponse cr = new CommonResponse();
            DataTable dt = new DataTable();
          
            dt.Columns.Add("UserId", typeof(string));
            dt.Columns.Add("RoleId", typeof(string));

            List<SqlParameter> parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter("@UserId", userRoles[0].UserId));

            if (userRoles.Count>0)
            {
                foreach (var item in userRoles)
                {
                    dt.Rows.Add(item.UserId,item.RoleId);
                }

                parameters.Add(Converter.ToSqlParameter("@UserRoles", dt, "dbo.UTT_UserRoles"));
                DataTable dr = DataAccess.Instance.CommonServices.GetBySpWithSQLParam("InsertUserRole", parameters.ToArray());

                if (dr.Rows.Count>0)
                {
                    cr.message = Constant.SAVED;
                }
          
             
            }
         
            return Json(cr);

        }
        [Route("user/DeleteRoles/{roleid}")]
        [HttpDelete]
        public IHttpActionResult DeleteRoles(string roleid)
        {
            CommonResponse cr = new CommonResponse();
          var role=  DataAccess.Instance.Role.Filter(e => e.Id == roleid).FirstOrDefault();
            if (role.Name == "Super" || role.Name == "Admin") //  Point 1 Only Super & Admin Can delete
                return BadRequest("This Role Can not delete.");
             bool   res = DataAccess.Instance.Role.Remove(roleid);
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;
            
            if (cr.httpStatusCode == HttpStatusCode.OK)
                return Json(res);

            return BadRequest(Constant.INVAILD_DATA);
        }

        [Route("user/GetRolePermission/{roleid}")]
        [HttpGet]
        public IHttpActionResult GetRolePermission(string roleid)
        {
            // Point 1 Get All permisson by RoleId
            var roleperssion = DataAccess.Instance.PageRole.Filter(e => e.RoleId == roleid).ToList();

            var AspNetPages = DataAccess.Instance.AspNetPage.GetAll();
            List<TreeVM> menu = new List<TreeVM>();
            foreach (var node in AspNetPages.OrderBy(e => e.ModuleId)) // Point 2 Looping and Order by DisplayOrder
            {
                TreeVM obj = new TreeVM();
                State state = new State();
                obj.state = state;
                obj.id = node.PageID.ToString();
                if (node.IsModule == true && node.IsParent == true && node.ParentID == 0)
                {
                    obj.parent = "#";
                }
                else if (node.IsModule == false && node.IsParent == true && node.ParentID == 0)
                {
                    obj.parent = node.ModuleId.ToString();
                }
                else if (node.IsModule == false && node.IsParent == false && node.ParentID == 0)
                {
                    obj.parent = node.ModuleId.ToString();
                }
                else
                {
                    obj.parent = node.ParentID.ToString();
                }
                obj.text = node.NameOption_En;
                obj.state.selected = roleperssion.FirstOrDefault(e => e.PageId == node.PageID) != null ? true : false;
                obj.state.disabled = false;
                obj.state.opened = true;
                menu.Add(obj);
            }

            return Json(menu);
        }
        [Route("user/AddRolePermission/{roleid}")]
        [HttpPost]
        public IHttpActionResult AddRolePermission([FromBody] List<string> permissions, string roleid)
        {
            var r = Request.Content;
            string DeleteQuery = "DELETE AspNetPagesRoles WHERE RoleId = @roleid" ;
            SqlParameter[] commandParameters = new SqlParameter[1];
            commandParameters[0] = new SqlParameter("@roleid", roleid);
            var qres = DataAccess.Instance.CommonServices.ExecuteSQL(DeleteQuery, commandParameters); // Point 1 Delete Before Save by RoleId
            var lstPages = DataAccess.Instance.AspNetPage.GetAll().ToList();
            List<AspNetPagesRole> listPermssion = new List<AspNetPagesRole>();
            for (int i = 0; i < permissions.Count(); i++) // Point 2 Looping and Add in List Object For Save
            {
                AspNetPagesRole Obj = new AspNetPagesRole();
                Obj.RoleId = roleid;
                Obj.PageId = Convert.ToInt32(permissions[i]);
                Obj.CanAdd = true;
                Obj.CanApprove = true;
                Obj.CanDelete = true;
                Obj.CanEdit = true;
                Obj.CanView = true;
                listPermssion.Add(Obj);
            }
            bool res = DataAccess.Instance.PageRole.AddRange(listPermssion);
            return Json(res);
        }
        #endregion

        #region Users
        [Route("user/GetAlluser/")]
        [HttpGet]
        public IHttpActionResult GetAlluser()
        {
            CommonResponse res = new CommonResponse();

            //Point 1 Get All User Info using pagination
            // var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllUserInfo", new object[] { searchtext, pageno, pagesize });
            var dt = DataAccess.Instance.CommonServices.GetBySpWithParam("GetAllUserInfo", new object[] { 1 });
            res.results = APIUitility.ConvertDataTable<AspNetUser>(dt);

            //if (res.httpStatusCode == HttpStatusCode.OK)
                return Json(res);
        }
        [Route("User/UserList/")]    // As per kawsar requ.
        [HttpGet]
        public IHttpActionResult UserList() //point 1: This method will Search Employee by Employee ID , name etc Information  by Evan
        {
            CommonResponse cr = new CommonResponse();
            // cr.results = DataAccess.Instance.EmpBasicInfoService.Filter(e => e.EmpID.Contains(srhtext) || e.FullName.Contains(srhtext))
            //     .Select(e => new { Name = e.FullName + " (" + e.EmpID + ")", id = e.EmpBasicInfoID }).ToList();
            cr.results = DataAccess.Instance.CommonServices.ExecuteSQLQUERY("SELECT B.EmpBasicInfoID, U.FullName AS UserFullName FROM Emp_BasicInfo AS B INNER JOIN AspNetUsers AS U ON B.EmpBasicInfoID = U.EmpId");
            //cr.results = DataAccess.Instance.EmpBasicInfoService.Filter(e=>e.IsDeleted==false).ToList();
            return Json(cr);
        }
        #endregion

        #region AssignAccountBranch

        [Route("User/AssignAccountBranch/{UserId}")]
        [HttpPost]
        public IHttpActionResult AssignAccountBranch(List<AccountBranchs> Branchs, string UserId)
        {
            bool res=false;
            CommonResponse cr = new CommonResponse();
            UserAccBranch userAccountBranch = new UserAccBranch();

            string Sql = $"DELETE FROM Acc_UserAccBranch WHERE UserId='{UserId}'";
            DataAccess.Instance.CommonServices.ExecuteSQL(Sql);

            foreach (var item in Branchs.Where(e=>e.IsSelected))
            {
                userAccountBranch.UserId = UserId;
                userAccountBranch.AccBranchId = item.BranchId;
                res = DataAccess.Instance.UserAccBranch.Add(userAccountBranch);
            }
            
            
            cr.httpStatusCode = res ? HttpStatusCode.OK : HttpStatusCode.BadRequest;
            cr.message = res ? Constant.SAVED : Constant.FAILED;

            return Json(cr);
        }


        [Route("User/GetUserAccountBranch/{UserId}")]
        [HttpGet]
        public IHttpActionResult GetUserAccountBranch(string UserId)
        {
            
            CommonResponse res = new CommonResponse();
            var result = DataAccess.Instance.AccountBranchService.Filter(a => a.IsDeleted == false && a.Status =="A").ToList();
            if (result.Any())
            {
                var UserAccBranch = DataAccess.Instance.UserAccBranch.Filter(e => e.UserId == UserId).ToList();
                foreach (var item in result)
                {
                    if(UserAccBranch.FirstOrDefault(e=>e.AccBranchId==item.BranchId)!=null)
                    {
                        item.IsSelected = true;
                    }
                }


                res.results = result;
                res.httpStatusCode = HttpStatusCode.OK;
                return Json(res);
            }
            else
            {
                return BadRequest(Constant.NOT_FOUND);
            }
        }
        #endregion
    }
}
