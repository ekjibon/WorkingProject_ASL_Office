using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    
    [Table("HR_EmployeeTaxSetup")]
    [ClassName("Employee Tax Setup")]
    public class EmployeeTaxSetup:Entity
    {
        [Key]
        public int Id { get; set; }
        public int EmpId { get; set; }
        public string CurrentSalary { get; set; }
        public decimal TaxAmount { get; set; }
        public int TaxYearId { get; set; }
        public int CategoryID { get; set; }
        
    }
}
