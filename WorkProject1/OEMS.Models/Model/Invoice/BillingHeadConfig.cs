using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_BillingHeadConfig")]
    [ClassName("BillingHeadConfig")]
    public class BillingHeadConfig : Entity
    {
        public BillingHeadConfig()
        {
            Month = new List<BillingHeadConfigDetails>();
        }
        [Key]
        public int Id { get; set; }
        public int ClientId { get; set; }
        public int InvoiceServiceId { get; set; }
        public int BillingHeadId { get; set; }
        public string BillingHeadType { get; set; }
        public int BillingMethodId { get; set; }
        public decimal Rate { get; set; }
        public decimal MinAmount { get; set; }
        public decimal MaxAmount { get; set; }
        public decimal MaskAmount { get; set; }
        public decimal NoMaskAmount { get; set; }
        public int Year { get; set; }
        public int Quantity { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal ProcessAmount { get; set; }
        public int TotalStudent { get; set; }
        public int TotalSMS { get; set; }
        public int TotalEmail { get; set; }
        [NotMapped]
        public string GenerateClientId { get; set; }
        [NotMapped]
        public string FullName { get; set; }
        [NotMapped]
        public int MonthId { get; set; }

        public List<BillingHeadConfigDetails> Month;
        public List<BillingHeadConfigVM> RequList = new List<BillingHeadConfigVM>();

    }

    public class BillingHeadConfigVM
    {
        public int Id { get; set; }
        public int ClientId { get; set; }
        public int BillingHeadId { get; set; }
        public int InvoiceServiceId { get; set; }
        public int BillingHeadConfigId { get; set; }
        public int BillingMethodId { get; set; }
        public string BillingHeadName { get; set; }
        public string BillingHeadType { get; set; }
        public string ShortName { get; set; }
        public string Status { get; set; }
        public decimal MinAmount { get; set; }
        public int Year { get; set; }
        public int MonthId { get; set; }
        public decimal Rate { get; set; }
        public decimal Quantity { get; set; }
        public decimal TotalAmount { get; set; }
        public int IsPublish { get; set; }
    }
}
