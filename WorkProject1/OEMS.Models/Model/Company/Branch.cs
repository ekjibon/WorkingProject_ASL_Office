using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model
{
    [Table("Ins_Branch")]
    [ClassName("Branch")]
    public class Branch : Entity
    {
        [Key]
        public int BranchId { get; set; }
        [Required]
        public string BranchName { get; set; }
        public string BranchNameBangla { get; set; }
        public string Code { get; set; }
        public string Address { get; set; }
        public string AddressBangla { get; set; }
        public string Branch_ContactNumber { get; set; }
        public int DisOrder { get; set; }
        [EmailAddress]
        public string Email { get; set; }
        public string Fax { get; set; }
        [StringLength(100)]
        public string SS_Lang { get; set; }
        [StringLength(100)]
        public string SS_Latu { get; set; }

    }
}
