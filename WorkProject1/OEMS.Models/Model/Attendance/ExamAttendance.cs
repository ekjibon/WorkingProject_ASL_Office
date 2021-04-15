using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Attendance
{

    [Table("Att_ExamAttendance")]
    [ClassName("Exam Attendance")]
    public class ExamAttendance : Entity
    {
        [Key]
        public long ExamAttId { get; set; }
        public long StudentId { get; set; }
        public int ExamId { get; set; }
        public bool IsGrand { get; set; }
        public int PresentDay { get; set; }
        public string TotalWorkingDays { get; set; }
        [NotMapped]
        public string FullName { get; set; }
        [NotMapped]
        public int Attendance { get; set; }
        [NotMapped]
        public int RollNo { get; set; }

        [NotMapped]
        public string StudentInsID { get; set; }
        [NotMapped]
        public int TotalStudent { get; set; }

    }

}
