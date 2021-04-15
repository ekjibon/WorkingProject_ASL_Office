using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
   public class AdditionDeductionVM
    {
        public int SalaryStructurePeriodId { get; set; }
        public decimal Amount { get; set; }
        public string Remarks { get; set; }
    }
}
