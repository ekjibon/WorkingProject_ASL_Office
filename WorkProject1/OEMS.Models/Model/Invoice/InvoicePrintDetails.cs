using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_InvoicePrintDetails")]
    [ClassName("Invoice Print Details")]
    public class InvoicePrintDetails : Entity
    {
        [Key]
        public int Id { get; set; }
        public int MasterId { get; set; }
        public int ClientId { get; set; }
        public int Year { get; set; }
        public int MonthId { get; set; }
        public int BillingHeadId { get; set; }
        public decimal? Quantity { get; set; }
        public decimal? Rate { get; set; }
        public decimal SubTotalAmount { get; set; }
        public decimal? DiscountAmount { get; set; }
        public decimal NetTotalAmount { get; set; }
        public string DueStatus { get; set; } // Current, Previous
        public string BillingHeadName { get; set; }
        public string DiscountHeadName { get; set; }


    }
}
