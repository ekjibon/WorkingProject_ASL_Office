using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_CollectionMaster")]
    [ClassName("Invoice CollectionMaster")]
    public class InvoiceCollectionMaster : Entity
    {
        [Key]
        public int Id { get; set; }
        public string InvoiceNo { get; set; }
        public decimal? InvoiceAmount { get; set; }
        public int? ClientId { get; set; }
        public int? Year { get; set; }
        public int? MonthId { get; set; }
        public DateTime? CollectionDate { get; set; }
        public decimal? CollectionAmount { get; set; }
        public string PaymentMethod { get; set; }  // Cash,Cheque,
        public string ChequeNo { get; set; }
        public decimal? AdjustmentAmount { get; set; }
        public decimal? DiscountAmount { get; set; }
        public decimal? ExtraCollectionAmount { get; set; }


    }
}
