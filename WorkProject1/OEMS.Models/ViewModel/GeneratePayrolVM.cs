using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class GeneratePayrolVM
    {
        public int CategoryID { get; set; }
      
        public int BranchID { get; set; }
        public int DepartmentID { get; set; }
        public int PeriodId { get; set; }
        public decimal TotalSalary { get; set; }
        //SalaryYearId
        public int SalaryYearId { get; set; }
        
        //paydetailsid
        public int Id { get; set; }

    }
}
