using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Attendance
{

    [Table("Emp_Attendance")]
    [ClassName("Emp Attendance")]
    public class EmpAttendance : Entity
    {
        [Key]
        public long AttendId { get; set; }
        public long EmpId { get; set; }
        public DateTime? InTime { get; set; }
        public DateTime? OutTime { get; set; }
        public bool IsPresent { get; set; }
        public bool IsLeave { get; set; }
        public int? LeaveId { get; set; }
        public bool? IsLate { get; set; }
        public int? LateTime { get; set; }
        public bool? IsEarlyOut { get; set; }
        public int? EarlyOutTime { get; set; }
        [MaxLength(25)]
        public string Device_SerialNo { get; set; }
        [MaxLength(25)]
        public string Device_UserID { get; set; }
        [MaxLength(25)]
        public string Device_CardNo { get; set; }
        [MaxLength(2)]
        public string EntryType { get; set; } // M = Manual, D = From Device, P = Period Wise Proccess 
        public string UpdatedStatus { get; set; }
        public bool IsPriApproved { get; set; }
        public bool IsFinalApproved { get; set; }
        public bool IsChangedStatus { get; set; }
        public bool IsApproved { get; set; }
        public bool IsRejected { get; set; }
        public bool? IsWithPay { get; set; }
        public bool? IsWithOutPay { get; set; }
        public bool? IsHalfDay { get; set; }
        public bool? IsAbsetLongHoliday { get; set; }
        public bool? IsDutyOff { get; set; }
        public bool? IsECAabsent { get; set; }
        public bool? IsEarlyOut5Years { get; set; }
        public bool? IsPresentInHoliday { get; set; }
        public bool? IsPriReject { get; set; }

        // New Field Add
        public int CalanderDetailsId { get; set; } // fk
        
        public string DayType { get; set; }

        public TimeSpan OfficeInTime { get; set; }
        public TimeSpan OfficeOutTime { get; set; }



        public int? DefaultLITime { get; set; }
        public int? DefaultEOTime { get; set; }

        public string AttStatusType { get; set; }  // Pending ='P',Active ='A' , InActive = 'I'

        public string AdminStatus { get; set; }
        public string ApproveBy { get; set; }
        public string ApproveNarration { get; set; }
        public string FinalStatus { get; set; }
        public string FinalNarration { get; set; }
        public int? RequestId { get; set; } // fk 
        public string Reason { get; set; } // From Employee
        public int? EmpRequestId { get; set; }
        //New Field
        public string SoftwareResult { get; set; }

    }
}
