using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_EmpLeaveQuota")]
    [ClassName("Emp Leave Quota")]
    public class EmpLeaveQuota : Entity
    {
        [Key]
        public int EmpLeaveQuotaId { get; set; }
        public int EmpId { get; set; }
        public int BranchId { get; set; }
        public int EmpCategory { get; set; }
        public int AnnualLeaveDay { get; set; }
        public int SickLeaveDay { get; set; }
        public int AdvanceLeaveDay { get; set; }
        public int MaternityLeaveDay { get; set; }
        public int? CalenderId { get; set; }
        public int RoutingId { get; set; } // fk

    }
}
