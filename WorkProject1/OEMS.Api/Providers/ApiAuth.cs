using OEMS.AppData;
using OEMS.Service.Services;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Principal;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace OEMS.Api.Providers
{
    public class ApiAuthAttribute : AuthorizeAttribute
    {
        private static readonly string[] _emptyArray = new string[0];
        private string _roles;
        private string[] _rolesSplit = _emptyArray;
        public string Roles
        {
            get { return _roles ?? String.Empty; }
            set
            {
                _roles = value;
                _rolesSplit = SplitString(value);
            }
        }
        protected override bool IsAuthorized(HttpActionContext actionContext)
        {
            if (actionContext == null)
            {
                return false;
            }

            IPrincipal user = actionContext.ControllerContext.RequestContext.Principal;
            if (user == null || user.Identity == null || !user.Identity.IsAuthenticated)
            {
                return false;
            }


            //if (_usersSplit.Length > 0 && !_usersSplit.Contains(user.Identity.Name, StringComparer.OrdinalIgnoreCase))
            //{
            //    return false;
            //}

            //if (_rolesSplit.Length > 0 && !_rolesSplit.Any(user.IsInRole))
            //{
            //    return false;
            //}
           // return true;
            string controllerName =  actionContext.ControllerContext.ControllerDescriptor.ControllerName;
        
            string route = actionContext.ControllerContext.RouteData.Route.RouteTemplate;

            return AuthService.IsAuthenticated(user.Identity.Name, controllerName, route);


          

        }

        public override void OnAuthorization(HttpActionContext actionContext)
        {
            if (actionContext == null)
            {
                throw new ArgumentNullException("actionContext");
            }

            if (SkipAuthorization(actionContext))
            {
                return;
            }

            if (!IsAuthorized(actionContext))
            {
                HandleUnauthorizedRequest(actionContext);
            }
        }

        /// <summary>
        /// Processes requests that fail authorization. This default implementation creates a new response with the
        /// Unauthorized status code. Override this method to provide your own handling for unauthorized requests.
        /// </summary>
        /// <param name="actionContext">The context.</param>
        protected virtual void HandleUnauthorizedRequest(HttpActionContext actionContext)
        {
            if (actionContext == null)
            {
                throw new  ArgumentNullException("actionContext");
            }

            // actionContext.Response = new System.Net.Http.HttpResponseMessage(HttpStatusCode.Unauthorized);/// actionContext.ControllerContext.Request.Content(HttpStatusCode.Unauthorized, SRResources.RequestNotAuthorized);
            actionContext.Response = new HttpResponseMessage
            {
                StatusCode = HttpStatusCode.Forbidden,
                Content = new StringContent("You are unauthorized to access this resource")
            };
        }

        private static bool SkipAuthorization(HttpActionContext actionContext)
        {
            Contract.Assert(actionContext != null);

            return actionContext.ActionDescriptor.GetCustomAttributes<AllowAnonymousAttribute>().Any()
                   || actionContext.ControllerContext.ControllerDescriptor.GetCustomAttributes<AllowAnonymousAttribute>().Any();
        }
        internal static string[] SplitString(string original)
        {
            if (String.IsNullOrEmpty(original))
            {
                return _emptyArray;
            }

            var split = from piece in original.Split(',')
                        let trimmed = piece.Trim()
                        where !String.IsNullOrEmpty(trimmed)
                        select trimmed;
            return split.ToArray();
        }


    }

}