using OEMS.Models.Constant;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Attendance
{
    [Table("Att_AttendanceLog")]
    [ClassName("Attendance Log")]
    public class AttendanceLog : Entity
    {
        [Key]
        public int Id {get; set;}
        public string LogType { get; set; } //  Attendance Process
        public string LogStatus { get; set; } // Add, Update, Delete, Attendance Process
        public string Description { get; set; }
        public DateTime LogDate { get; set; }
        public string UserId { get; set; }// ASP Net User Id



    }
}
