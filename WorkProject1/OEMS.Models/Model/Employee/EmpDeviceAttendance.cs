using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_DeviceAttendance")]
    [ClassName("Emp Device Attendance")]
    public  class EmpDeviceAttendance : Entity
    {
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int DeviceUSERID { get; set; } // Device User Id
        public DateTime CHECKTIME { get; set; }

        public string CHECKTYPE { get; set; }
        public int VERIFYCODE { get; set; }
        public string SENSORID { get; set; }
        public string Memoinfo { get; set; }
        public string WorkCode { get; set; }
        public string sn { get; set; }
        public int UserExtFmt { get; set; }
        public bool IsSync { get; set; }
    }
}
