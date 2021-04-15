using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Portal
{
    public class FeesPaymentVM
    {
        public FeesPaymentVM()
        {

        }
        public string HeadName { get; set; }
        public string DueMonth { get; set; }
        public long FeesStudentId { get; set; }
        public int Year { get; set; }
        public int HeadId { get; set; }
        public long StudentIID { get; set; }
        public int MonthId { get; set; }
        public decimal DueAmount { get; set; }
        public decimal InvoiceAmount { get; set; }
        public decimal TotalAmount { get; set; }

    }
    public class OnlineDueList
    {
        public long FeesStudentId { get; set; }
        public string DueMonth { get; set; }
        public string HeadName { get; set; }
        public int Year { get; set; }
        public int HeadId { get; set; }
        public int MonthId { get; set; }
        public string MonthName { get; set; }

        public long StudentIID { get; set; }
        public decimal InvoiceAmount { get; set; }
        public decimal DueAmount { get; set; }

    }
}

