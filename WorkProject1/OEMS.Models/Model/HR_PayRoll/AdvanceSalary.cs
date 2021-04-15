using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_AdvanceSalary")]
    [ClassName("Advance Salary")]
    public class AdvanceSalary : Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int? SalaryPeriodId { get; set; }
        public DateTime SanctionDate { get; set; }
        public int? HeadId { get; set; }
        public int? NoOfInstallment { get; set; }
        public decimal? AdvanceAmount { get; set; }
        public decimal? InstallmentAmount { get; set; }
        public int? Year { get; set; }
        public int? Month { get; set; }
        public string MonthName { get; set; }
        public int? InvoiceNumber { get; set; }


    }
}
