using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Attendance
{
    public class EmpTempRosterVM
    {
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int EmpCategory { get; set; }
        public int BranchId { get; set; }
        public DateTime CalendarDate { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string Status { get; set; }
        public bool IsApproved { get; set; }

        public int CalendarId { get; set; }
        public int CalendarDetailId { get; set; }
        public string Title { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }

        public int Year { get; set; }
        public int Month { get; set; }
        public string Day { get; set; }
        public string DayType { get; set; }
        public string HolidayName { get; set; }
        public bool IsDateDisable { get; set; }

        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string Remarks { get; set; }

        public int EmpBasicInfoID { get; set; }

        public int RosterId { get; set; }
        public int AttendId { get; set; }
        public IList<DayListVM> DayList { get; set; }
       
    }
}
