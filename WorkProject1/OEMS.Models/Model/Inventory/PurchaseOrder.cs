using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_PurchaseOrder")]
    [ClassName("Purchase Order")]
    public class PurchaseOrder : Entity
    {
        public PurchaseOrder()
        {
            OrderDetails = new List<PurchaseOrderDetails>();
            PurchaseOrderList = new List<PurchaseOrder>();
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
        public IList<PurchaseOrderDetails> OrderDetails { get; set; }

        [NotMapped]
        public IList<PurchaseOrder> PurchaseOrderList { get; set; }

    }
}
