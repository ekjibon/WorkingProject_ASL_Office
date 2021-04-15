namespace OEMS.Models.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    [ClassName("AspNet Role")]
    public partial class AspNetRole
    {
     
        public AspNetRole()
        {
            this.AspNetPagesRoles = new HashSet<AspNetPagesRole>();
            this.AspNetUsers = new HashSet<AspNetUser>();
        }
        [Key]
        public string Id { get; set; }
        public string Name { get; set; }
    
       
        public  ICollection<AspNetPagesRole> AspNetPagesRoles { get; set; }
       
        public  ICollection<AspNetUser> AspNetUsers { get; set; }
       
    }
}
