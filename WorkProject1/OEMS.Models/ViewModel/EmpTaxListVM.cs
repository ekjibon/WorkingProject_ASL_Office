using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
   public class EmpTaxListVM
    {
        public int Id { get; set; }
        public int EmpBasicInfoID { get; set; }
        public int EmpId { get; set; }
        public string CurrentSalary { get; set; }
        public decimal TaxAmount { get; set; }
        public int TaxYearId { get; set; }
        public int CategoryID { get; set; }
        public int BranchID { get; set; }

    }
}
