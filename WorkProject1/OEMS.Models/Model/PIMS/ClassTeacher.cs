using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model
{
    [Table("Emp_ClassTeacher")]
    [ClassName("Class Teacher")]
    public class ClassTeacher : Entity
    {
        [Key]
        public int ID { get; set; }
        public int SessionId { get; set; }
        public int BranchId { get; set; }
        public int ShiftId { get; set; }
        public int ClassId { get; set; }
        public int SectionId { get; set; }
        public int TeacherId { get; set; }
    }
}
