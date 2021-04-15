using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_AdvanceSalaryPayment")]
    [ClassName("Advance Salary Payment")]
    public class AdvanceSalaryPayment : Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int? SalaryPeriodId { get; set; }
        public int? AdvanceSalaryId { get; set; }
        public decimal? PaymentAmount { get; set; }
        
    }
}
