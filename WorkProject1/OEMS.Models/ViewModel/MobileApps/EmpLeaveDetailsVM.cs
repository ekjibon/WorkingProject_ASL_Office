using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.MobileApps
{
    public class EmpLeaveDetailsVM
    {
        public int EmpId { get; set; }
        public int TotalLeave { get; set; }
        public int ApplyedLeave { get; set; }
        public int DueLeave { get; set; }
    }
}
