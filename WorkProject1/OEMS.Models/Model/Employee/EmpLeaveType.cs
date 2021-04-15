using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_LeaveType")]
    [ClassName("Emp Leave Type")]
    public class EmpLeaveType: Entity
    {
        [Key]
        public int EmpLeaveTypeId { get; set; }
        public string TypeName { get; set; }
        public string Code { get; set; }
    }
}
