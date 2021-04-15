using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_QuotationDetails")]
    [ClassName("Quotation Details")]
    public class QuotationDetails : Entity
    {
        [Key]
        public int QuotationDetailsId { get; set; }
        public int QuotationId { get; set; }
        public int ProductId { get; set; }
        public decimal  Quantity { get; set; }
        public decimal  UnitPrice { get; set; }
        public decimal Discount { get; set; }
        [NotMapped]
        public string ProductName { get; set; }
        [NotMapped]
        public string Unit { get; set; }

    }
}
