using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_PurchaseOrderDetails")]
    [ClassName("Purchase Order Details")]
    public class PurchaseOrderDetails
    {
        [Key]
        public int PODetailsId { get; set; }
        public int POId { get; set; } 
        public int ProductId { get; set; }
        public decimal Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal TotalPrice { get; set; }
        public decimal Discount { get; set; }
        public decimal ReceiveQuantity { get; set; }
        [NotMapped]
        public string ProductName { get; set; }
        [NotMapped]
        public string Unit { get; set; }
    }
}
