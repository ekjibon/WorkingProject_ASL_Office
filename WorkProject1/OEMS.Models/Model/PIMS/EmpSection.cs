using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_Section")]
    [ClassName("Emp Section")]
    public class EmpSection:Entity
    {
        [Key]
        public int SectionID { get; set; }
        public string SectionName { get; set; }
        
    }
}
