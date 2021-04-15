using OEMS.Models.Constant;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Student
{
    [Table("Emp_Request")]
    [ClassName("Emp Request")]
    public class EmpRequest : Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; } // Log In StudentId
        public int  RequestType { get; set; } //for member,for NOC ,Foc TC
        public int ? CategoryId { get; set; }
        public int ? DesignationId { get; set; }
        public DateTime? Date { get; set; }
        public string  Reason { get; set; }
        public DateTime? Time { get; set; }
        public string Description { get; set; }
        public string MeetingIssue { get; set; }
        //NOC start
        public int NOCType { get; set; } // Travelling NOC, NON Travelling
        public string TravelDesination { get; set; }
        public DateTime? TravelTo { get; set; }
        public DateTime? TravelFrom { get; set; }
        // NOC END
        //TC Start
        public DateTime? LeaveDate { get; set; }

        //TC END

        //For Leave
        public int? LeaveCategoryId { get; set; }
        public DateTime FromDate { get; set; }
       
        public DateTime ToDate { get; set; }
        
        public decimal? Duration { get; set; }
        public DateTime? RequestOn { get; set; }
        public byte[] File { get; set; }
        public int? AdjustableDay { get; set; }
        public int? UnadjustedDay { get; set; }
        public int? Withpay { get; set; }
        public int? WithOutpay { get; set; }
        public int? MaternityLeaveType { get; set; }

        public string LeaveTypeCategory { get; set; }
        [NotMapped]
        public string HalfDayDate { get; set; }
        
        [NotMapped]
        public string date { get; set; }
        [NotMapped]
        public string LeaveType { get; set; }
        [NotMapped]
        public string From { get; set; }
        [NotMapped]
        public string To { get; set; }
        [NotMapped]
        public string Request { get; set; }
        [NotMapped]
        private string _ColorCode;
        [NotMapped]
        public string ColorCode
        {
            get
            {
                if (this.Status == Enums.LeaveStatus.Pending.ToString())
                    return "Yellow";
                else if (this.Status == Enums.LeaveStatus.Cancel.ToString())
                    return "Red";
                else return "Green";
            }
            set { _ColorCode = value; }
        }

        //Leave End
        [NotMapped]
        public DateTime GetTime { get; set; }
    }
}
