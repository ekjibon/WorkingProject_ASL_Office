using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_Status")]
    [ClassName("Emp Status")]
    public class EmpStatus:Entity
    {
        [Key]
        public int StatusID { get; set; }
        public string StatusName { get; set; }
       
    }
}
