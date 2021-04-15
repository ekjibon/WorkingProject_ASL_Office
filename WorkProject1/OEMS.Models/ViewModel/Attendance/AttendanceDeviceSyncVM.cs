using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Attendance
{
    public class AttendanceDeviceSyncVM
    {
        public int BranchId { get; set; }
        public int CategoryId { get; set; }
        public int DepartmentId { get; set; }
        public int DesignationId { get; set; }
        public int EmpId { get; set; }
        public string AttDeviceId { get; set; }
        public string Date { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
    }
}
