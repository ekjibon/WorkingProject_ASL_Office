using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Portal
{
    public class PaymentSuccess
    {
        public string TransactionId { get; set; }
        public string PaymentId { get; set; }
        public decimal Amount { get; set; }
        public string InvoiceNumber { get; set; }
        public string Reference { get; set; }
        public string StatusCode { get; set; }
        public string Message { get; set; }
        public string SuccessUrl { get; set; }
        public string Key { get; set; }
        public string Currency { get; set; }
        public string PaymentMethod { get; set; }

    }
}
