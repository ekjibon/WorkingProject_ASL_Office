using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_EmpLeaveModify")]
    [ClassName("Employee Leave Modify")]
    public class EmpLeaveModify : Entity
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public bool IsEmployee { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsLate { get; set; }
        public bool IsEarlyout { get; set; }
        public bool IsAbsent { get; set; }
        public bool IsLeave { get; set; }
        public bool IsNoAction { get; set; } // by default Is NoAction and true
    }
}
