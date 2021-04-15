using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetPurchaseOrderDetails")]
    [ClassName("Asset Purchase Order Details")]
    public class AssetPurchaseOrderDetails
    {
        [Key]
        public int PODetailsId { get; set; }
        public int POId { get; set; } 
        public int ProductId { get; set; }
        public decimal Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal TotalPrice { get; set; }
        public string Building { get; set; }
        public string Room { get; set; }
        public string Location { get; set; }
        public string AssetLifeTime { get; set; }
        public decimal Discount { get; set; }
        public decimal ReceiveQuantity { get; set; }
        [NotMapped]
        public string ProductName { get; set; }
        [NotMapped]
        public string Unit { get; set; }
    }
}
