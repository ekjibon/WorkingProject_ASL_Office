using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_InvoicePrintMaster")]
    [ClassName("Invoice Print Master")]
    public class InvoicePrintMaster : Entity
    {
        [Key]
        public int Id { get; set; }
        public string InvoiceNo { get; set; }
        public decimal InvoiceAmount { get; set; }
        public int ClientId { get; set; }
        public string BillingMonth { get; set; }
        public DateTime InvoiceDate { get; set; } //PrintDate
        public DateTime DueDate { get; set; }
        public DateTime BillingPeriodStart { get; set; }
        public DateTime BillingPeriodEnd { get; set; }
        public string PaymentStatus { get; set; } //Paid,Draft

    }
}
