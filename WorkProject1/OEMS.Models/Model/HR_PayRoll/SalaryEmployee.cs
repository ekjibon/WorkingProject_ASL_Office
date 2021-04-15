using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryEmployee")]
    [ClassName("Salary Employee")]
    public class SalaryEmployee:Entity
    {
        [Key]
        public int Id { get; set; }
        public int SalaryPeriodId { get; set; }
        public int HeadId { get; set; }
        public int EmpId { get; set; }
        public int GradeId { get; set; }
        public int? TaxYearId { get; set; }
        public int Amount { get; set; }
    }
}
