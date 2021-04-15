using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_ProductCategory")]
    [ClassName("Product Category")]
    public class ProductCategory:Entity
    {
        [Key]
        public int ProductCateId { get; set; }
        public string CategoryName { get; set; }
        public string CategoryCode { get; set; }
        
    }
}
