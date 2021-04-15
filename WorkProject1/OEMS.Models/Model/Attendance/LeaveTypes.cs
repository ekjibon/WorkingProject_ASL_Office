using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Attendance
{
    [Table("Att_LeaveTypes")]
    [ClassName("Leave Types")]
    public class LeaveTypes:Entity
    {
        [Key]
        public int LeaveId { get; set; }
        public string TypeName { get; set; }
        public string Type { get; set; } // S = Student, E = Empolyee
    }
}
