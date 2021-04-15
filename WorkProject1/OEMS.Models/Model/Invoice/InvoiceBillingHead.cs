using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_BillingHead")]
    [ClassName("Invoice Billing Head")]
      public  class InvoiceBillingHead : Entity
    {
        [Key]
        public int Id { get; set; }
        public string BillingHeadName { get; set; }
        public string BillingHeadType { get; set; }
        public bool? IsDiscount { get; set; }
        public int? LedgerId { get; set; }
    }
}
