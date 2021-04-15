using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetCategory")]
    [ClassName("Asset Category")]
    public class AssetCategory : Entity
    {
        [Key]
        public int AssetCateId { get; set; }
        public string CategoryName { get; set; }
        public string CategoryCode { get; set; }
        
    }
}
