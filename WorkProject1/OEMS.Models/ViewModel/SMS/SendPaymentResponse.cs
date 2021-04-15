using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.SMS
{
    public class SendPaymentResponse
    {
        public string paymentId { get; set; }
        public string currency { get; set; }
        public decimal amount { get; set; }
        public string invoiceNumber { get; set; }
        public string reference { get; set; }
        public string gatewayUrl { get; set; }

    }
}
