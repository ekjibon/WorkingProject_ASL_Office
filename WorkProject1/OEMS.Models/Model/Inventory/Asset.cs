using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_Asset")]
    [ClassName("Asset")]
    public class Asset : Entity
    {
        [Key]
        public int AssetId { get; set; }
        public string AssetName { get; set; }
        public string AssetCode { get; set; }       
        public int AssetSubCatId { get; set; }
        public int UnitId { get; set; }
      
        public int AssetTypeId { get; set; } // 1 = For Fixed Asset       
        public string Description { get; set; }
        public decimal Amount { get; set; } // Price Fixed 
        public decimal SellingPrice { get; set; }
        public string AccCode { get; set; }
        public int DeprcAmount { get; set; }
        public bool IsPercentage { get; set; }
        [NotMapped]
        public int CategoryId { get; set; }
    }
}
