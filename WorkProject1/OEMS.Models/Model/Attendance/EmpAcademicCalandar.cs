using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Attendance
{
    [Table("Att_EmpAcademicCalendar")]
    [ClassName("Emp Academic Calandar")]
    public class EmpAcademicCalandar:Entity
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Title { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int EmpCategory { get; set; }
       
        // New Field Add
        public int EmpBranchId { get; set; }
        public int  Year { get; set; }
        public string  WeekendDay { get; set; } //  Friday,Sun,Starday
        public TimeSpan InTime { get; set; }
        public TimeSpan OutTime { get; set; }



        public int? DefaultLITime { get; set; }
        public int? DefaultEOTime { get; set; }

        [NotMapped]
        public string In { get; set; }
        [NotMapped]
        public string Out { get; set; }
        [NotMapped]
        public bool IsUpdateExisting { get; set; }

    }
}
