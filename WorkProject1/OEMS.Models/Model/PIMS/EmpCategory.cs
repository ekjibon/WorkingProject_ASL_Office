using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_Category")]
    [ClassName("Emp Category")]
    public class EmpCategory:Entity
    {
        [Key]
        public int CategoryID { get; set; }

        public string CategoryName { get; set; }
        public bool CategoryIsTeacher { get; set; }

       

    }
}
