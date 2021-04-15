using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
   public class SalaryHoldRefundVM
    {
        public SalaryHoldRefundVM()
        {
            PeriodList = new List<SalaryPeriodVM>();
        }
        public int Id { get; set; }
        public int? EmpId { get; set; }
        public int? Installment { get; set; }
        public int? SalaryYearId { get; set; }
        public decimal? InstallmentAmount { get; set; }
        public decimal? HoldedAmount { get; set; }
        public bool IsChecked { get; set; }

        public List<SalaryPeriodVM> PeriodList;
    }

}
