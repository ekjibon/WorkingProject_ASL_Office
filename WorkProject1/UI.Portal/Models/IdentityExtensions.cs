using Microsoft.AspNet.Identity;
using OEMS.AppData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Web;

namespace UI.Portal.Models
{
    public static class IdentityExtensions
    {
        public static string GetUserStudentId(this IIdentity identity)
        {
            var claim = ((ClaimsIdentity)identity).FindFirst("StudentId");
            // Test for null to avoid issues during local testing
            return (claim != null) ? claim.Value : string.Empty;
        }
        public static string GetFullName(this IIdentity identity)
        {
            var claim = ((ClaimsIdentity)identity).FindFirst("FullName");
            // Test for null to avoid issues during local testing
            return (claim != null) ? claim.Value : string.Empty;
        }
        public static string GetInsId(this IIdentity identity)
        {
            var claim = ((ClaimsIdentity)identity).FindFirst("StudentInsId");
            // Test for null to avoid issues during local testing
            return (claim != null) ? claim.Value : string.Empty;
        }

    }
}