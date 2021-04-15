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
    [Table("Att_EmpAcademicCalendarDetails")]
    [ClassName("Emp Academic Calendar Details")]
    public class EmpAcademicCalendarDetails :Entity
    {
        [Key]
        public int Id { get; set; }
        public int CalendarId { get; set; } // fk
        public int Year { get; set; }
        public int Month { get; set; }
        public int Day { get; set; }
        
        public DateTime CalendarDate { get; set; }
        [MaxLength(20)]
        public string DayType { get; set; }
        [MaxLength(300)]
        public string HolidayName { get; set; }
        [NotMapped]
        public bool IsDateDisable { get; set; }
        [NotMapped]
        private string _ColorCode;
        [NotMapped]
        public string ColorCode
        {
            get {
                if (this.DayType == Enums.DayType.Holiday.ToString())
                    return "#8877A9";
                else if (this.DayType == Enums.DayType.Weekend.ToString())
                    return "#e35b5a";
                else return "#3faba4";
            }
            set { _ColorCode = value; }
        }

    }
}
