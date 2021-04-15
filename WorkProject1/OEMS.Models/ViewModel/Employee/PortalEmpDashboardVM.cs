using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Employee
{
    public class PortalEmpDashboardVM
    { 
        public PortalEmpDashboardVM()
        {
            CurrMonthAttendance = new List<MonthlyAttendance>();
            SMSList = new List<SMSList>();
            NoticeList = new List<NoticeBorad>();
            EmpNoticeList = new List<EmpNoticeBorad>();
            EmpAttendanceList = new List<EmployeeAttendance>(); 
             AttPreDay = new List<int>();
            AttAbsentDay = new List<int>();
            AttWorkingDay = new List<int>();
            Holliday = new List<int>(); 
             Attlabel = new List<string>();
            LateIN = new List<int>();
            EarlyOut = new List<int>();
        }
        public int TotalPresent { get; set; }
        public int TotalAbsent { get; set; }
        public decimal PeresentPercent { get; set; }
        public decimal AbsentPercent { get; set; }
        public string FeesMonth { get; set; }
        public List<MonthlyAttendance> CurrMonthAttendance { get; set; }
        public List<SMSList> SMSList { get; set; }
        public List<NoticeBorad> NoticeList { get; set; }
        public List<EmpNoticeBorad> EmpNoticeList { get; set; }
        public List<int> AttPreDay { get; set; }
        public List<int> AttAbsentDay { get; set; }
        public List<int> AttWorkingDay { get; set; }
        public List<string> Attlabel { get; set; }
        public List<int> Holliday { get; set; }
        public List<int> LateIN { get; set; }
        public List<int> EarlyOut { get; set; }
        public List<EmployeeAttendance> EmpAttendanceList { get; set; }
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
    public class EmpNoticeBorad
    {
        public int DocumentId { get; set; }
        public string Title { get; set; }
        public string FileName { get; set; }
        public int TypeId { get; set; }
        public string AddDate { get; set; }
        public byte[] File { get; set; }
    }

   
    public class EmployeeAttendance
    {

        public long AttendId { get; set; }
        public long EmpId { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public bool IsPresent { get; set; }
        public bool IsLeave { get; set; }
   
    }

}
