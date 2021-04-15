using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Invoice
{
    [Table("Invoice_BillingProcess")]
    [ClassName("Billing Process")]
    public class BillingProcess : Entity
    {
        [Key]
        public int Id { get; set; }
        public int? ClientId { get; set; }
        public int? Year { get; set; }
        public int? MonthId { get; set; }
        public int? BillingHeadId { get; set; }
        public decimal? Quantity { get; set; }
        public decimal? Rate { get; set; }
        public decimal? TotalAmount { get; set; }
        [NotMapped]
        public int IsPublish { get; set; }
    }
}
