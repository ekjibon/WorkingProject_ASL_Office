using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryHold")]
    [ClassName("SalaryHold")]
    public class SalaryHold : Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; }
        public decimal? GrossSalary { get; set; }
        public decimal? HoldPerMonthAmount { get; set; }
        public int? SalaryPeriodId { get; set; }
        public DateTime? HoldDate { get; set; }
        public int? HeadId { get; set; }
        public int? NoOfInstallment { get; set; }
        public int? Year { get; set; }
        public int? Month { get; set; }
        public string MonthName { get; set; }


    }
}
