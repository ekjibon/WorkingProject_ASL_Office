using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class ChartDataAttendanceVM
    {
        public string FullName { get; set; }
        public string StudentInsID { get; set; }
        public string AddDate { get; set; }
        public string Status { get; set; }
        public TimeSpan InTime { get; set; }
        public TimeSpan OutTime { get; set; }
    }
}
