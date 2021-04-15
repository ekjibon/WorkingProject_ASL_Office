using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.MobileApps
{
    public class EmpAttendancevm
    {
        public long AttendId { get; set; }
        public DateTime? InTime { get; set; }
        public DateTime? OutTime { get; set; }
        public bool IsPresent { get; set; }
        public bool IsLeave { get; set; }
        public int? LeaveId { get; set; }
        public bool IsLate { get; set; }
        public int? LateTime { get; set; }
        public bool IsEarlyOut { get; set; }
        public int? EarlyOutTime { get; set; }
        
        public string Device_SerialNo { get; set; }
     
        public string Device_UserID { get; set; }
       
        public string Device_CardNo { get; set; }
      
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

        public int EmpBasicInfoID { get; set; }
        public string FullName { get; set; }
        public string EmpID { get; set; }
        public DateTime? JoiningDate { get; set; }
        public DateTime? ConfirmationDate { get; set; }
        public DateTime? CalendarDate { get; set; }
        public string DayName { get; set; }
        public string DayType { get; set; }
        public int TotalDays { get; set; }
        public int Present { get; set; }
        public int Leave { get; set; }
        public int Halfday { get; set; }
        public int Late { get; set; }
        public int EarlyLeave { get; set; }
        public int Late_EarlyLeave { get; set; }
        public int Absent { get; set; }
        public int Holiday { get; set; }
        public int Weekend { get; set; }
        public int WithPaySickLeave { get; set; }
        public int WithOutPaySickLeave { get; set; }
        public int WithPayMeternityLeave { get; set; }
        public int WithOutPayMeternityLeave { get; set; }
        public int WithPayAnualLeave { get; set; }
        public int WithOutPayAnualLeave { get; set; }
        public int WithPayCasualLeave { get; set; }
        public int WithOutPayCasualLeave { get; set; }
        public string SoftwareResult { get; set; }
        public string OT { get; set; }
        public string ToTalOT { get; set; }
        public string WorkingHour { get; set; }
        public string TotalWorkingHour { get; set; }
        public string Remarks { get; set; }

        public DateTime? SignIntime { get; set; }
        public DateTime? SignOuttime { get; set; }

        public  decimal PercentPersent { get; set; }
        public decimal PercentHoliday { get; set; }
        public decimal PercentWeekend { get; set; }
        public decimal PercentAbsent { get; set; }
        public string Reason { get; set; }
        public string ApprovalStatus { get; set; }
        public string FinalStatus { get; set; }
        public string AdminStatus { get; set; }
    }
}
