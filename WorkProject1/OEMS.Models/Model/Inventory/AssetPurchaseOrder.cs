using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetPurchaseOrder")]
    [ClassName("Asset Purchase Order")]
    public class AssetPurchaseOrder : Entity
    {
        public AssetPurchaseOrder()
        {
            OrderDetails = new List<AssetPurchaseOrderDetails>();
            PurchaseOrderList = new List<AssetPurchaseOrder>();
        }
        [Key]
        public int POId { get; set; }
        public string POCode { get; set; } // Automatice Generate 
        public int SupplierId { get; set; }
        public DateTime DueDate { get; set; }
        public string Description { get; set; }
        public decimal TotalPrice { get; set; }
        public bool IsReceived { get; set; }
        public string ReceivedBy { get; set; }
        public string ReceiverComments { get; set; }
        [NotMapped]
        public string Date { get; set; }
        [NotMapped]
        public string SupplierName { get; set; }
        [NotMapped]
        public string AccountCode { get; set; }

        [NotMapped]
        public IList<AssetPurchaseOrderDetails> OrderDetails { get; set; }

        [NotMapped]
        public IList<AssetPurchaseOrder> PurchaseOrderList { get; set; }

    }
}
