using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
 
namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_LeaveRequestDetails")]
    [ClassName("Leave Request Details")]
    public class LeaveRequestDetails:Entity
    {
       
        [Key]
        public int Id { get; set; }
        public int LeaveId { get; set; } // fk
        public int EmpId { get; set; } // fk
        public int LeaveCategoryId { get; set; } // fk 
        public decimal EligibleLeave { get; set; }
        public decimal LeaveAvailable { get; set; }
        public decimal LeaveInHand { get; set; }
        public decimal AdjustLeave { get; set; }
        public decimal WithPayLeave { get; set; }
        public decimal WithoutPayLeave { get; set; }
  
    }
}
