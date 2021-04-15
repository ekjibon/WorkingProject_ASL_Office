using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_Shift")]
    [ClassName("Emp Shift")]
    public class EmpShift : Entity
    {
       [Key]
       public int ShiftID { get; set; }

        public int ShiftBranchID { get; set; }
        public string ShiftName { get; set; }
        public string ShiftInTime { get; set; }
        public string ShiftOutTime { get; set; }
       
    
    }
}
