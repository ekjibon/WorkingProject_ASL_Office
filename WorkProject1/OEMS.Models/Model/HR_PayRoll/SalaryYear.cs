using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.HR_PayRoll
{
    [Table("HR_SalaryYear")]
    [ClassName("Salary Year")]
    public class SalaryYear : Entity
    {
        [Key]
        public int Id { get; set; }
        public string YearName { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        [NotMapped]
        public string fromDate { get; set; }
        [NotMapped]
        public string toDate { get; set; }
    }
}
