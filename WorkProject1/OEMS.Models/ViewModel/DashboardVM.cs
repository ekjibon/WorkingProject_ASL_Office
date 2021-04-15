using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
    public class DashboardVM
    {
        public DashboardVM()
        {
            CurrMonthTrans = new List<MonthTrans>();
            ClasswisePresent = new List<ClassAtten>();
        }
        public int TotalStudent { get; set; }
        public int TotalPresent { get; set; }
        public decimal TotalCollection { get; set; }
        public int TotalSentSMS { get; set; }

        public List<MonthTrans> CurrMonthTrans { get; set; }
        public List<ClassAtten> ClasswisePresent { get; set; }
    }

   public class MonthTrans
    {
        public string PaymentDate { get; set; }
        public decimal Amount { get; set; }
    }

    public class ClassAtten
    {
        public string ClassName { get; set; }
        public int PresentStudent { get; set; }
    }
}
