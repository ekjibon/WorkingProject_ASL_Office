using Microsoft.AspNet.Identity;
using OEMS.AppData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Web;

namespace UI.WebClients.Models
{
    public static class IdentityExtensions
    {
        public static string GetUserFullname(this IIdentity identity)
        {
            var claim = ((ClaimsIdentity)identity).FindFirst("Fullname");
            // Test for null to avoid issues during local testing
            return (claim != null) ? claim.Value : string.Empty;
        }
        public static string GetRoleName(this IIdentity identity)
        {
            var claim = ((ClaimsIdentity)identity).FindFirst("Roleid");
            // Test for null to avoid issues during local testing
            return (claim != null) ? claim.Value : string.Empty;
        }
        //public static string GetRoleId(this IIdentity identity)
        //{
        //    var claim = ((ClaimsIdentity)identity).FindFirst("Roleid");
        //    if (claim.Value == null)
        //        return string.Empty;
        //    string val = DataAccess.Instance.Role.GetRolId(claim.Value);
        //    return (claim != null) ? val : string.Empty;
        //}
        public static string GetUserImage(this IIdentity identity)
        {
            var claim = ((ClaimsIdentity)identity).FindFirst("Image");
            

           byte[] toBytes = Encoding.ASCII.GetBytes(claim.Value);
            return (claim != null) ? claim.Value : string.Empty;
        }

    }
}