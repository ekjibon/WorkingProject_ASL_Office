using OEMS.Models.Constant;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Attendance
{
    [Table("Att_EmpRoster")]
    [ClassName("Emp Roster")]
    public class EmpRoster : Entity
    {
        [Key]
        public int Id {get; set;}
        public int? EmpId {get; set;}
        public int? EmpCategory {get; set;}
        public int? BranchId {get; set;}
        public DateTime CalendarDate {get; set;}
        public string Day { get; set; }
        [MaxLength(20)]
        public string DayType { get; set; }
        [NotMapped]
        public string FromDate {get; set;}
        [NotMapped]
        public string ToDate {get; set;}
        public TimeSpan InTime { get; set; }       
        public TimeSpan OutTime { get; set; }

        public TimeSpan? TempInTime { get; set; }
        public TimeSpan? TempOutTime { get; set; }

        public bool IsApproved { get; set; }
        public bool IsRejected { get; set; }

        public bool IsTempApproved { get; set; }
        public bool IsTempRejected { get; set; }
        public bool IsTemporary { get; set; }
        public int? CalendarId { get; set; }
        


[NotMapped]
        public bool IsDateDisable { get; set; }
        


    }
}
