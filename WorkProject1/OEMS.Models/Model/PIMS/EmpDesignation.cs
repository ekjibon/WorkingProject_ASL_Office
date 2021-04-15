using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{

    [Table("Emp_Designation")]
    [ClassName("Emp Designation")]
   public class EmpDesignation:Entity
    {
        [Key]
        public int DesignationID{ get; set; }

        public string DesignationName{ get; set; }

        public string CategoryID { get; set; }
        public int DesignationOrder { get; set; }
        public string CategoryName { get; set; }
       
        
    }

}
