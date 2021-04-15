using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Attendance
{
    public class EmpAcademicCalendarConfigDetailsVM
    {
        public int EmpId { get; set; }
        public int CalendarId { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public int AttendId { get; set; }
        public string AttDayType { get; set; }
        public string OfficeInTime { get; set; }
        public string OfficeOutTime { get; set; }

        //Bulk Update
        public string In { get; set; }
        public string Out { get; set; }
        public int EmpBranchId { get; set; }

    }
}
