using Microsoft.AspNet.Identity;
using OEMS.Api.Providers;
using OEMS.AppData;
using OEMS.Models.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UI.WebClients.App_Start;
using static OEMS.Models.Constant.Enums;

namespace UI.WebClients.Controllers
{
    //[Authorize]
    //[AuthorizeUser]
    public class BaseController : Controller
    {
        public BaseController()
        {
            if ((System.Web.HttpContext.Current.Session["Pages"] as object) == null)
            {
                var aa = System.Web.HttpContext.Current.User.Identity.GetUserName();
                if (aa != null)
                {
                    var pages = DataAccess.Instance.PageRole.GetByUserId(System.Web.HttpContext.Current.User.Identity.GetUserId(), 0).ToList();
                    System.Web.HttpContext.Current.Session["Pages"] = pages;
                }
                else {
                    RedirectToAction("Login", "Account");
                }
            }
        }
    }
}