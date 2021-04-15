using System;
using System.Collections.Generic;

namespace MobileApps.Api.Models
{
    // Models returned by AccountController actions.

    public class ExternalLoginViewModel
    {
        public string Name { get; set; }

        public string Url { get; set; }

        public string State { get; set; }
    }

    public class ManageInfoViewModel
    {
        public string LocalLoginProvider { get; set; }

        public string Email { get; set; }

        public IEnumerable<UserLoginInfoViewModel> Logins { get; set; }

        public IEnumerable<ExternalLoginViewModel> ExternalLoginProviders { get; set; }
    }

    public class UserInfoViewModel
    {
        public string Email { get; set; }

        public bool HasRegistered { get; set; }

        public string LoginProvider { get; set; }

        public string FullName { get; set; }
        public string MobileNo { get; set; }
        public byte[] Image { get; set; }
        public string Address { get; set; }
        public int? EmpId { get; set; }
        public string BloodGroup { get; set; }
        public DateTime? DOB { get; set; }
        public string Religion { get; set; }
        public string NID { get; set; }
        public string EmgName { get; set; }
        public string EmgRelation { get; set; }
        public string EmgMobile { get; set; }
        public string EmgAddress { get; set; }
        public string DesignationName { get; set; }
        public string DepartmentName { get; set; }
        public string EmployeeId { get; set;  }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public string Nationality { get; set; }
        public string Gender { get; set; }
        public string MaritalStatus { get; set; }
        public string PresentAddress { get; set; }
        public string PermanentAddress { get; set; }
    }

    public class UserLoginInfoViewModel
    {
        public string LoginProvider { get; set; }

        public string ProviderKey { get; set; }
    }
}
