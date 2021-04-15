using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_EmployeeSalary")]
    [ClassName("Employee Salary")]
    public class EmployeeSalary:Entity
    {
        public int EmployeeSalaryId { get; set; }
        public int EmpId { get; set; }
        public int PeriodId { get; set; }
        public int HeadId { get; set; }
        public decimal Amount { get; set; }
        public DateTime? DisburseDate { get; set; }
        
    }
}
