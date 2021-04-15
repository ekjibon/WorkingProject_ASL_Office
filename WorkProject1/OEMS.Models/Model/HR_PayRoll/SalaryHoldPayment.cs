using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryHoldPayment")]
    [ClassName("SalaryHoldPayment")]
    public class SalaryHoldPayment : Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int? SalaryPeriodId { get; set; }
        public int? SalaryHoldId { get; set; }
        public decimal? PaymentAmount { get; set; }
        public decimal? ToptalPaymentAmount { get; set; }

    }
}
