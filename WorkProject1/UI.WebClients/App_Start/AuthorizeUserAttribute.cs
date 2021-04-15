using OEMS.Service.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;

namespace UI.WebClients.App_Start
{
    public class AuthorizeUserAttribute: AuthorizeAttribute
    {
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            var isAuthorized = base.AuthorizeCore(httpContext);
            if (!isAuthorized)
            {
                return false;
            }

            IPrincipal user = httpContext.User;//.ControllerContext.RequestContext.Principal;
            if (user == null || user.Identity == null || !user.Identity.IsAuthenticated)
            {
                return false;
            }

            var rd = httpContext.Request.RequestContext.RouteData;
            string ActionName = rd.GetRequiredString("action");
            string controllerName = rd.GetRequiredString("controller");
          
            return AuthService.IsAuthenticated(user.Identity.Name, ActionName);
        }
    }
}