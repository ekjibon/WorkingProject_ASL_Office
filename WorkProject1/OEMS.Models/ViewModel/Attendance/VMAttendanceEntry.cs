using System.Collections.Generic;

namespace OEMS.Models.ViewModel.Attendance
{
    public class VMAttendanceEntry
    {
        public VMAttendanceEntry()
        {
            this.DayStatus = new List<DayStatus>();
        }
        public long StudentIID { get; set; }
        public string StudentInsID { get; set; }
        public long AttendId { get; set; }
        public string AbscondingPeriod { get; set; }
        public int RollNo { get; set; }
        public string RegiNo { get; set; }
        public string FullName { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public List<DayStatus> DayStatus { get; set; }
        public DayStatus DayPresent { get; set; }
        public int TotalPresent { get; set; }
        public int TotalAbs { get; set; }

    }

    public class DayStatus
    {
        public int Day { get; set; }
        public bool IsDisable { get; set; }
        public bool IsPresent { get; set; }
        public bool IsLeave { get; set; }
        public bool IsDisableDate { get; set; }
        public bool IsAbsconding { get; set; }
        public string DayType { get; set; }
        public int TotalPresent { get; set; }
        public int TotalAbs { get; set; }
        public int TotalLeave { get; set; }
    }
   
    public class AttendenceVM
    {
        public long StudentIID { get; set; }
        public int Day { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public bool IsPresent { get; set; }
        public int PeriodId { get; set; }
       
    }
    public class VMAttendanceEntryWithPeriod
    {
        public VMAttendanceEntryWithPeriod()
        {
            this.PeriodStatus = new List<Period>();
        }
        public long StudentIID { get; set; }
        public string StudentInsID { get; set; }          
        public int RollNo { get; set; }         
        public string FullName { get; set; }
        public long AttendId { get; set; }
        public bool IsPresent { get; set; }
        public bool IsLeave { get; set; }            
        public int TotalStudent { get; set; }
        public int TotalPresent { get; set; }
        public List<Period> PeriodStatus { get; set; }

    }
    public class Period
    {
        public int PeriodId { get; set; }
        public string PeriodName { get; set; }       
        public bool IsAbsconding { get; set; }  
        public bool IsAllPresent { get; set; }
        public bool PeriodIsLeave { get; set; }
    }
}
