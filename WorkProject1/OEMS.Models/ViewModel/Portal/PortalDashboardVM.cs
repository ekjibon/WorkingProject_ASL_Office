using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Portal
{
    public class PortalDashboardVM
    {
        public PortalDashboardVM()
        {
            CurrMonthAttendance = new List<MonthlyAttendance>();
            SMSList = new List<SMSList>();
            NoticeList = new List<NoticeBorad>();
            StdNoticeList = new List<StudentNoticeBorad>();
            ResultsList = new List<Results>();
            AssignmentList = new List<Assignment>();
            StudentAttendanceList = new List<StudentAttendance>(); 
             AttPreDay = new List<int>();
            AttAbsentDay = new List<int>();
            AttWorkingDay = new List<int>();
            Holliday = new List<int>(); 
             Attlabel = new List<string>();
            LateIN = new List<int>();
           EarlyOut = new List<int>();
          
        }
        public decimal TotalDue { get; set; }
        public decimal TotalPaid { get; set; }
        public int TotalPresent { get; set; }
        public int TotalAbsent { get; set; }
        public decimal PaidPercent { get; set; }
        public decimal DuePercent { get; set; }
        public decimal PeresentPercent { get; set; }
        public decimal AbsentPercent { get; set; }
        public string FeesMonth { get; set; }
        public string FeesYear { get; set; }
        public List<MonthlyAttendance> CurrMonthAttendance { get; set; }
        public List<SMSList> SMSList { get; set; }
        public List<NoticeBorad> NoticeList { get; set; }
        public List<StudentNoticeBorad> StdNoticeList { get; set; }
        public List<Results> ResultsList { get; set; }
        public List<Assignment> AssignmentList { get; set; }
        public List<int> AttPreDay { get; set; }
        public List<int> AttAbsentDay { get; set; }
        public List<int> AttWorkingDay { get; set; }
        public List<string> Attlabel { get; set; }
        public List<int> Holliday { get; set; }
        public List<int> LateIN { get; set; }
        public List<int> EarlyOut { get; set; }
        public List<StudentAttendance> StudentAttendanceList { get; set; }
    }

    public class MonthlyAttendance
    { 
        public string CalendarDate { get; set; }
        public string DayType { get; set; }
        public string HolidayName { get; set; }
        public string DayStaus { get; set; }
        public string ClassName { get; set; }
        public string LateIN { get; set; }
        public string EarlyOut { get; set; }

    }

    public class SMSList
    {
        public string SMSBody { get; set; }
        public string SendDateTime { get; set; }
    }

    public class NoticeBorad
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string PublishDate { get; set; }
        public string ColorCode { get; set; }
        public string Type { get; set; }
        public string Letter { get; set; }
    }
    public class StudentNoticeBorad
    {
        public int DocumentId { get; set; }
        public string Title { get; set; }
        public string FileName { get; set; }
        public int TypeId { get; set; }
        public string AddDate { get; set; }
        public byte[] File { get; set; }
    }
    public class Results
    {
        public string PreviousYear { get; set; }
        public string ClassName { get; set; }
        public string StdStatus { get; set; }
        public string Award { get; set; }
    }
    public class Assignment
    {
      
        public int Id { get; set; }    
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Deadline { get; set; }
        public string GivenBy { get; set; }
    }
    public class StudentAttendance
    {

        public long AttendId { get; set; }
        public long StudentId { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public bool IsPresent { get; set; }
        public bool IsLeave { get; set; }
   
    }

}
