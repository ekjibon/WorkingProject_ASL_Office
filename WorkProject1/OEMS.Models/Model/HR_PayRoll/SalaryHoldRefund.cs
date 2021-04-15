using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryHoldRefund")]
    [ClassName("Salary Hold Refund")]
    public class SalaryHoldRefund : Entity
    {
        [Key]
        public int Id { get; set; }
        public int? EmpId { get; set; }
        public int? Installment { get; set; }
        public int? SalaryPeriodId { get; set; }
        public decimal? InstallmentAmount { get; set; }
        public decimal? HoldedAmount { get; set; }
        public int? SalaryYearId { get; set; }
    }
}
