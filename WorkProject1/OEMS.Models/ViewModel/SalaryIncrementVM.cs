using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
   public class SalaryIncrementVM
    {

       
        public int EmpId { get; set; }
        public int BranchId { get; set; }
        public int EmpCategory { get; set; }
        public int GrossSalary { get; set; }
        public int Amount { get; set; }
        public int AmountAfterIncrement { get; set; }
        public bool IsPercentage { get; set; }
        public string Remarks { get; set; }
        public int EmpBasicInfoID { get; set; }
        public int CategoryId { get; set; }



    }
}
