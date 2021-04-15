using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetDetails")]
    [ClassName("Asset Details")]
    public class AssetDetails : Entity
    {
        [Key]
        public int DetailId { get; set; }
        public int AssetIId { get; set; }
        public string AssetID { get; set; }
        public decimal PurchseValue { get; set; }
        public decimal CurrentValue { get; set; }
        public string Brand { get; set; }
        public string BranchID { get; set; }
        public string Building { get; set; }
        public string Room { get; set; }
        public string Location { get; set; }
        public string AssetLifeTime { get; set; }
        public decimal SalvageValue { get; set; }
        public int Quantity { get; set; }
        public int SerialNo { get; set; }
        public string DisposedBy { get; set; }
        public bool IsDispose { get; set; }
        public bool IsExisting { get; set; }
        public string DisposComment { get; set; }
        public string warrentyPeriod { get; set; }
    }
}
