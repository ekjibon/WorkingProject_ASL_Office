using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class SalaryStructureVM
    {
        public int SalaryStructureId { get; set; }
        public int HeadId { get; set; }
        public int EmpId { get; set; }
        public int GradeId { get; set; }
        public int? TaxYearId { get; set; }
        public decimal Amount { get; set; }
    }
}
