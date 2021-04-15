using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_CollectionDetails")]
    [ClassName("Invoice CollectionDetails")]
    public class InvoiceCollectionDetails : Entity
    {
        [Key]
        public int Id { get; set; }
        public int MasterID { get; set; }
        public int? Year { get; set; }
        public int? MonthId { get; set; }
        public int? BillingHeadId { get; set; }
        public decimal? Quantity { get; set; }
        public decimal? Rate { get; set; }
        public decimal? TotalAmount { get; set; }
        public decimal? DueAmount { get; set; }
        public decimal? CollectionAmount { get; set; }
        public decimal? AdjustmentAmount { get; set; }
        public string CollectionNarration { get; set; }
        public decimal? DiscountAmount { get; set; }
        public decimal? ExtraCollectionAmount { get; set; }

    }
}
