using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_LeaveApplication")]
    [ClassName("Leave Application")]
    public class LeaveApplication:Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int LeaveTypeId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public decimal? TotalDays { get; set; }
        public decimal? TotalEffectDays { get; set; }
        public string Reason { get; set; }
        public byte[] Attachment { get; set; }
        public string ApproveBy { get; set; }
        public DateTime? ApproveDate { get; set; }
        public string ApproveComments { get; set; }
        public string RejectedBy { get; set; }
        public DateTime? RejectedDate { get; set; }
        public string RejectedComments { get; set; }
        public bool? IsReApplied { get; set; }
        public decimal BalanceLeave { get; set; }
    }
}
