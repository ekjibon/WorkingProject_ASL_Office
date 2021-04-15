using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryStructurePeriodModifylog")]
    [ClassName("Salary Structure Period Modify log")]
    public class SalaryStructurePeriodModifylog : Entity
    {
        [Key]
        public int Id { get; set; }
        public int PaydetailsId { get; set; }
        public decimal NetAmount { get; set; }
        public int SalaryStructurePeriodId { get; set; }
        public int CategoryID { get; set; }
        public int PeriodId { get; set; }
        public int HeadId { get; set; }
        public int EmpId { get; set; }
        public int? GradeId { get; set; }
        public int? TaxYearId { get; set; }
        public decimal Amount { get; set; }
        public DateTime ProccessDate { get; set; }
    }
}
