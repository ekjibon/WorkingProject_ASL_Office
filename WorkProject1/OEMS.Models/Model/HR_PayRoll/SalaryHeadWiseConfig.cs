using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryHeadWiseConfig")]
    [ClassName("Salary Head Wise Config")]
    public class SalaryHeadWiseConfig:Entity
    {
        [Key]
        public int Id { get; set; }
        public int CategoryID { get; set; }
        public int HeadId { get; set; }
        public decimal Amount { get; set; }
        public bool? IsPercentage { get; set; }
        public decimal? MinAmount { get; set; }
        public decimal? MaxAmount { get; set; }
    }
}
