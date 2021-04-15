using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_AssetDisposal")]
    [ClassName("Asset Disposal")]
    public class AssetDisposal:Entity
    {
        [Key]
        public int DisposalId { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public string DisposalType { get; set; }
        public string AccountCode { get; set; }
        public decimal SellingPrice { get; set; }
    }
}
