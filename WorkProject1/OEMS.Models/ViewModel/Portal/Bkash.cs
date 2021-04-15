using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Portal
{
    public class bKashTranscation
    {
        public Transaction transaction { get; set; }
    }

    public class Transaction
    {
        public string trxTimestamp { get; set; }
        public string trxStatus { get; set; }
        public decimal amount { get; set; }
        public string trxId { get; set; }
        public int? counter { get; set; }
        public string reference { get; set; }
        public string reversed { get; set; }
        public string sender { get; set; }
        public string service { get; set; }
        public string currency { get; set; }
        public string receiver { get; set; }


    }
}
