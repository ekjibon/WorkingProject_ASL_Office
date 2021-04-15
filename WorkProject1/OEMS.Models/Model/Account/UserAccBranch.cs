using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Account
{
    [Table("Acc_UserAccBranch")]
    [ClassName("User Acc Branch")]
    public class UserAccBranch:Entity
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string UserId { get; set; }
        [Required]
        public int AccBranchId { get; set; }
    }
}
