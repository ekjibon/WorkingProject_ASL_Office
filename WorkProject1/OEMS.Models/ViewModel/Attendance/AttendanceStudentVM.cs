using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OEMS.Models.ViewModel.Attendance
{
   public class AttendanceStudentVM
    {
        public int TotalAttendence { get; set; }
        public int TotalLeave { get; set; }
        public int TotalAbsconding { get; set; }
        public int TotalWorkingDays  { get; set; }
        public int TotalAbsent { get; set; }
    }
}
