using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_Department")]
    [ClassName("Emp Department")]
 public class EmpDepartment : Entity
    {
        [Key]
        public int DepartmentID { get; set; }

        public string DepartmentName { get; set; }
        public int DisOrder { get; set; }


    }
}
