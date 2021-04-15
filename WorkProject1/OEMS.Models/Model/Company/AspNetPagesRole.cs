
namespace OEMS.Models.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [ClassName("AspNet Pages Role")]
    public partial class AspNetPagesRole
    {
        [Key]
        public int PageRoleId { get; set; }
        [ForeignKey("AspNetPage")]
        public int PageId { get; set; }
        [ForeignKey("AspNetRole")]
        public string RoleId { get; set; }
        public bool CanAdd { get; set; }
        public bool CanEdit { get; set; }
        public bool CanView { get; set; }
        public bool CanDelete { get; set; }
        public bool CanApprove { get; set; }
    
        public  AspNetPage AspNetPage { get; set; }
        public  AspNetRole AspNetRole { get; set; }
    }
}
