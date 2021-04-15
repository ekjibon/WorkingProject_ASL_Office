using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class SalaryModifyVM
    {
        public int Id { get; set; }
        public int CategoryID { get; set; }
        public int SalaryPeriodId { get; set; }
        public int EmpId { get; set; }
        public decimal GrossAmount { get; set; }
        public decimal NetAmount { get; set; }

        public IList<AdditionDeductionVM> AdditionDeductionVm { get; set; }
        
    }
}
