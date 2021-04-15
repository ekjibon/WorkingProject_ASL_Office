using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_InvoiceGenerate")]
    [ClassName("Invoice Generate")]
    public class InvoiceGenerate : Entity
    {
        [Key]
        public int Id { get; set; }
        public string InvoiceNo { get; set; }
        public decimal InvoiceAmount { get; set; }
        public int ClientId { get; set; }
        public int Year { get; set; }
        public int MonthId { get; set; }
        public int BillingHeadId { get; set; }
        public decimal? Quantity { get; set; }
        public decimal Rate { get; set; }
        public decimal TotalAmount { get; set; }
        [NotMapped]
        public decimal TotalTk { get; set; }
        [NotMapped]
        public decimal SubTotal { get; set; }
        public decimal? DueAmount { get; set; }
        public decimal? CollectionAmount { get; set; }
        public DateTime IssueDate { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime BillingPeriodStart { get; set; }
        public DateTime BillingPeriodEnd { get; set; }
        public string InvoiceStatus { get; set; }
        public bool IsPaid { get; set; }
        public string Description { get; set; }
        public decimal? AdjustmentAmount { get; set; }
        public string CollectionNarration { get; set; }
        public int? DiscountlinkBillingHeadId { get; set; }
        public decimal? DiscountAmount { get; set; }
        public bool? IsPublish { get; set; }
        public decimal? ExtraCollectionAmount { get; set; }
        public decimal? DiscountPercentage { get; set; }

        [NotMapped]
        public string FullName { get; set; }
        [NotMapped]
        public string BillingHeadName { get; set; }
        [NotMapped]
        public string Address { get; set; }
        [NotMapped]
        public string ShortName { get; set; }
        [NotMapped]
        public string Code { get; set; }
        [NotMapped]
        public string MonthNames { get; set; }
        [NotMapped]
        public decimal? PreviousDueAmount { get; set; }
        [NotMapped]
        public string PaymentMethod { get; set; }  // Cash,Cheque,
        [NotMapped]
        public string ChequeNo { get; set; }
        [NotMapped]
        public string NextPaymentDate { get; set; }
        [NotMapped]
        public string CollectionDate { get; set; }

        public List<InvoiceGenerate> RequList; 
    }
}
