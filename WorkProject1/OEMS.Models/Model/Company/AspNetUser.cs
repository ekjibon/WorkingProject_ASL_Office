namespace OEMS.Models.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [ClassName("AspNet User")]
    public partial class AspNetUser
    {
        
        public AspNetUser()
        {
            this.AspNetRoles = new HashSet<AspNetRole>();
        }
        [Key]
        public string Id { get; set; }
        public string FullName { get; set; }
        public string MobileNo { get; set; }
        public string Email { get; set; }
        public bool EmailConfirmed { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public string PhoneNumber { get; set; }
        public bool PhoneNumberConfirmed { get; set; }
        public bool TwoFactorEnabled { get; set; }
        public Nullable<System.DateTime> LockoutEndDateUtc { get; set; }
        public bool LockoutEnabled { get; set; }
        public int AccessFailedCount { get; set; }
        public string UserName { get; set; }
        public byte[] Image { get; set; }
        public string Address { get; set; }
        public int? EmpId { get; set; }
        [NotMapped]
        public string RoleName { get; set; }
        [NotMapped]
        public string BranchName { get; set; }
        [NotMapped]
        public string RoleId { get; set; }



        public virtual ICollection<AspNetRole> AspNetRoles { get; set; }
    }
}
