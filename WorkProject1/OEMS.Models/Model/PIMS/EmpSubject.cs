using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_Subject")]
    [ClassName("Emp Subject")]
   public class EmpSubject:Entity
    {
        [Key]
        public int SubjectID { get; set; }
        public string SubjectName { get; set; }
      
    }
}
