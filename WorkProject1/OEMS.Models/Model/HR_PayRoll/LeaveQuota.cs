using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_LeaveQuota")]
    [ClassName("Leave Quota")]
    public class LeaveQuota : Entity
    {
        [Key]
        public int LeaveQuotaId { get; set; }
        public int LeaveTypeId { get; set; }
        public int LeaveCatgoryId { get; set; }
        public int NoOfDay { get; set; }
        public bool? IsCarryForward { get; set; }
        //New Filed add
        public int RoutingId { get; set; } // fk
    }
}
