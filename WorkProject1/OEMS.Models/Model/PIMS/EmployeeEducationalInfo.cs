using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_EducationalInfo")]
    [ClassName("Employee Educational Info")]
    public class EmployeeEducationalInfo :Entity
    {
        [Key]
        public int EducationalInfo_ID { get; set; }
        public int EmployeeID { get; set; }
        [Required]
        [StringLength(50)]
        public string ExamBoard { get; set; }

        [Required]
        [StringLength(50)]
        public string ExamInstituteName { get; set; }

        public int ExamPasYear { get; set; }

        [Required]
        [StringLength(50)]
        public string ExamTotal { get; set; }
        public string ExamGroupName { get; set; }
        public string ExamName { get; set; }
    }
}
