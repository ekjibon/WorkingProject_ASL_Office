using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Repository.Repositories;
using System.Data;

namespace OEMS.Service.Services
{
    public  class AuthService 
    {
      
        public static bool IsAuthenticated(string UserName,string PageName)
        {
            string Sql = @"SELECT U.Id , P.Action
                            FROM AspNetUsers U 
                            INNER JOIN AspNetUserRoles R On R.UserId = U.Id
                            INNER JOIN AspNetPagesRoles PR On R.RoleId = PR.RoleId
                            INNER JOIN AspNetPages P On P.PageID = PR.PageId
                            WHERE U.UserName = '" + UserName + "' AND P.Action = '" + PageName + "'";
            CommonServices cmd = new Services.CommonServices();
            DataTable dt =   cmd.GetDatatableBySQL(Sql);
            if (dt.Rows.Count > 0)
                return true;
            else
                return false;
        }

        public static bool IsAuthenticated(string UserName, string ControllerName , string Route)
        {
            string Sql = @"SELECT U.Id , P.Action
                        FROM AspNetUsers U 
                        INNER JOIN AspNetUserRoles R On R.UserId = U.Id
                        INNER JOIN AspNetPagesRoles PR On R.RoleId = PR.RoleId
                        INNER JOIN AspNetPages P On P.PageID = PR.PageId
                        INNER JOIN AspNetPageApis PA ON PA.PageId = P.PageID
                        INNER JOIN AspNetApis AP ON AP.ApiId = PA.ApiId
                        WHERE U.UserName = '"+UserName.Trim()+"' AND Ap.Controller = '"+ControllerName.Trim()+"' AND Ap.Route = '"+Route+"'";
            CommonServices cmd = new Services.CommonServices();
            DataTable dt = cmd.GetDatatableBySQL(Sql);
            if (dt.Rows.Count > 0)
                return true;
            else
                return false;
        }

    }
}
