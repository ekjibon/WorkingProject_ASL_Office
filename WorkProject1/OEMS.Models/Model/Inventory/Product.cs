using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_Product")]
    [ClassName("Product")]
    public class Product:Entity
    {
        [Key]
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string ProductCode { get; set; }       
        public int ProductSubCateId { get; set; }
        public int UnitId { get; set; }
        public int ReOrderLevel { get; set; }
        public int ProductTypeId { get; set; } // 1 = For Sale , 2 = For Distribute , 3 = For Fixed Asset, 4 = For Fixed Asset       
        public string Description { get; set; }
        public decimal OpeningBalance { get; set; } /// when balance greater than 0 then update stock
        public decimal Amount { get; set; } // Price Fixed 
        public decimal SellingPrice { get; set; }
        public string AccCode { get; set; }
        [NotMapped]
        public int CategoryId { get; set; }
    }
}
