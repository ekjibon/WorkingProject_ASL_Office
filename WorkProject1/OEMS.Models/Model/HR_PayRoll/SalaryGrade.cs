using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryGrade")]
    [ClassName("Salary Grade")]
    public class SalaryGrade : Entity
    {
        [Key]
        public int SalaryGradeId { get; set; }
        public int BranchId { get; set; }
        [StringLength(20, MinimumLength = 4, ErrorMessage = "Enter 4 to 20 characters!")]
        public string Code { get; set; }
        public string Name { get; set; }
        public decimal MinSalary { get; set; }
        public decimal MaxSalary { get; set; }
    }
}
