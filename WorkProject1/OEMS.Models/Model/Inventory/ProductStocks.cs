using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Inventory
{
    [Table("Inv_ProductStocks")]
    [ClassName("Product Stocks")]
    public class ProductStocks:Entity
    {
        [Key]
        public int StockId { get; set; }
        public int ProductId { get; set; }
        public decimal Quantity { get; set; }
    }
}
