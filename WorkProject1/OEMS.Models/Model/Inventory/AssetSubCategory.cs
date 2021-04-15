using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("FA_AssetSubCategory")]
    [ClassName("Asset SubCategory")]
    public class AssetSubCategory:Entity
    {
        [Key]
        public int AssetSubCatId { get; set; }
        public int CategoryId { get; set; }
        public string SubCategoryName { get; set; }

        [NotMapped]
        public string CategoryName { get; set; }
    }
}
