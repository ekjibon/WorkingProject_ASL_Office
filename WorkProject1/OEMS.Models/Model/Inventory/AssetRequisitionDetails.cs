using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetRequisitionDetails")]
    [ClassName("Asset Requisition Details")]
    public class AssetRequisitionDetails 
    {
        [Key]
        public int ReqDetailsId { get; set; }
        public int ReqId { get; set; } 
        public int ProductId { get; set; }
        public decimal Quantity { get; set; }
        public decimal Price { get; set; }
        [NotMapped]
        public string AssetName { get; set; }
        [NotMapped]
        public string Unit { get; set; }
    }
}
