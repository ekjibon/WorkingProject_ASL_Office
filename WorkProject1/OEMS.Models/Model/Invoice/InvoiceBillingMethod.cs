using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{

    [Table("Invoice_BillingMethod")]
    [ClassName("Invoice Billing Method")]
     public class InvoiceBillingMethod : Entity
    {
        [Key]
        public int Id { get; set; }
        public string BillingMethodName { get; set; }
    }
}
