using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryPayDetails")]
    [ClassName("Salary Pay Details")]
    public class SalaryPayDetails:Entity
    {
        public int Id { get; set; }
        public int CategoryID { get; set; }
        public int SalaryPeriodId { get; set; }
        public int EmpId { get; set; }
        public decimal GrossAmount { get; set; }
        public decimal NetAmount { get; set; }
        public decimal BankAmount { get; set; }
        public decimal CashAmount { get; set; }
        public bool? IsModified { get; set; }
        public string DesignationName { get; set; }
    }
}
