using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryPeriod")]
    [ClassName("Salary Period")]
    public class SalaryPeriod:Entity
    {
        [Key]
        public int Id { get; set; }
        public int FiscalYearId { get; set; }
        public int CategoryID { get; set; }
        public string PeriodName { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public string MonthName { get; set; }
        public int? DaysWorking { get; set; }
        public DateTime? ProcessDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? PeriodStartDate { get; set; }
        public DateTime? PeriodEndDate { get; set; }
        public int? IsLock { get; set; }
        public int? SalaryYearId { get; set; }
        public int? SalaryTaxYearId { get; set; }
        public bool? IsDeductTax { get; set; }
        public bool? IsLongHoliday { get; set; }

        [NotMapped]
        public string startDate { get; set; }
        [NotMapped]
        public string endDate { get; set; }
        [NotMapped]
        public string periodstartDate { get; set; }
        [NotMapped]
        public string periodendDate { get; set; }

    }
}
