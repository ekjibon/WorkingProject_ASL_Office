using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_LeaveRoutingHistory")]
    [ClassName("Leave Routing History")]
    public class LeaveRoutingHistory : Entity
    {
        [Key]
        public int LeaveHistoryId { get; set; }
        public int RoutingId { get; set; } // fk
        public int LeaveId { get; set; } // fk
        public string Comments { get; set; }
        public bool IsApprove { get; set; }
        public bool IsReject { get; set; }
        public string RejectedBy { get; set; }


    }
}
