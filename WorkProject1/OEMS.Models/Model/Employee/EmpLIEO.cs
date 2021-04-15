using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Attendance
{
    [Table("Emp_LIEO")]
    [ClassName("Emp LIEO")]
    public class EmpLIEO :Entity
    {
        [Key]
        public int LIEOId { get; set; }
        public int? EmpId { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan LateInTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public TimeSpan EarlyOutTime { get; set; }
        [NotMapped]
        public string Start { get; set; }
        [NotMapped]
        public string LateIn { get; set; }
        [NotMapped]
        public string End{ get; set; }
        [NotMapped]
        public string EarlyOut { get; set; }
        [NotMapped]
        public string ShiftName { get; set; }
        [NotMapped]
        public string ClassName { get; set; }
        [NotMapped]
        public string SectionName { get; set; }
        //[NotMapped]
        //public int StarEndHourt { get; set; }
        //[NotMapped]
        //public int EndMinutes { get; set; }
    }
}
