using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryHead")]
    [ClassName("Salary Head")]
    public class SalaryHead:Entity
    {
        [Key]
        public int Id { get; set; }
        public int AccHeadId { get; set; }
        public string HeadName { get; set; }
        public string HeadCode { get; set; }
        public int Category { get; set; }
        public bool? IsBasic { get; set; }
        public int? DisplayOrder { get; set; }
        public bool? IsAccLedger { get; set; }
        public bool? IsEdit { get; set; }
        
    }
}
