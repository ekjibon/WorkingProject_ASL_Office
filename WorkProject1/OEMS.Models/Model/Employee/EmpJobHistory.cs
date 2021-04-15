using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_JobHistory")]
    [ClassName("Emp Job History")]
    public class EmpJobHistory : Entity
    {
        [Key]
        public int EmpJobId { get; set; }
        public int EmpId { get; set; }
        public string Companyname { get; set; }
        public string Designation { get; set; }
        public string AreaOfExperiance { get; set; }
        public string From { get; set; }
        public string To { get; set; }
        public string YearOfExperiance { get; set; }
    }
}
