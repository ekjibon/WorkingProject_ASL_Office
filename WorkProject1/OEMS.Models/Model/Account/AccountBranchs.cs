using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Account
{
    [Table("ACC_Branchs")]
    [ClassName("Account Branch")]
    public class AccountBranchs : Entity
    {
        [Key]
        public int BranchId { get; set; }
        [MaxLength(50)]
        public string Name { get; set; }
        public string Code { get; set; }
        [NotMapped]
        public bool IsSelected { get; set; }
    }
}
