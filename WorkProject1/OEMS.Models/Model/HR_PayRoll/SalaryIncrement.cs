using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryIncrement")]
    [ClassName("Salary Increment")]
    public  class SalaryIncrement:Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int? SalaryYearId { get; set; }
        public string Type { get; set; }
        public decimal? GrossSalary { get; set; }
        public decimal Amount { get; set; }
        public decimal? AmountAfterIncrement { get; set; }
        public decimal? IncrementPercentage { get; set; }
        public bool? IsPercentage { get; set; }
    }
}
